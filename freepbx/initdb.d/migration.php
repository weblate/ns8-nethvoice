<?php
#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

include_once '/etc/freepbx_db.conf';

# TODO check if migration is needed. Exit 0 if not

# Add srtp column to rest_devices_phones
$db->query("ALTER TABLE `asterisk`.`rest_devices_phones` ADD COLUMN `srtp` BOOLEAN DEFAULT NULL AFTER `type`");



/* Convert existing srtp extensions to be used with proxy */

# get all NethVoice extensions with srtp enabled
$sql = "SELECT extension
		FROM `asterisk`.`rest_devices_phones` 
		JOIN `asterisk`.`sip` 
		ON `asterisk`.`rest_devices_phones`.`extension` = `asterisk`.`sip`.`id` 
		WHERE `type` = 'physical' 
		AND	`srtp` IS NULL 
		AND `keyword`='media_encryption' 
		AND `data`='sdes'";

$stmt = $db->prepare($sql);
$stmt->execute();
$res = $stmt->fetchAll(\PDO::FETCH_ASSOC);
$extensions = array_column($res, 'extension');

# set media_encryption to no in freepbx sip table
$sql = "UPDATE `asterisk`.`sip` SET `data` = 'no' WHERE `keyword` = 'media_encryption' AND `id` IN ('".str_repeat('?, ', count($extensions) - 1) . '?'."')";
$stmt = $db->prepare($sql);
$stmt->execute($extensions);

# set srtp to true in rest_devices_phones table
$sql = "UPDATE `asterisk`.`rest_devices_phones` SET `srtp` = 1 WHERE `extension` IN ('".str_repeat('?, ', count($extensions) - 1) . '?'."')";
$stmt = $db->prepare($sql);
$stmt->execute($extensions);

# configure proxy on all FreePBX extensions
$proxy_host = $_ENV['PUBLIC_IP'];
$proxy_port = 5060;

$sql = "UPDATE `asterisk`.`sip` SET `data` = ? WHERE `keyword` = 'outbound_proxy' AND `id` IN ('".str_repeat('?, ', count($extensions) - 1) . '?'."')";
$stmt = $db->prepare($sql);
$stmt->execute(array_merge(['sip:'.$proxy_host.':'.$proxy_port], $extensions));

# set rtp_symmetric to no in freepbx sip table
$sql = "UPDATE `asterisk`.`sip` SET `data` = 'no' WHERE `keyword` = 'rtp_symmetric' WHERE `id` IN ('".str_repeat('?, ', count($extensions) - 1) . '?'."')";
$stmt = $db->prepare($sql);
$stmt->execute($extensions);

# set rewrite_contact to no in freepbx sip table
$sql = "UPDATE `asterisk`.`sip` SET `data` = 'no' WHERE `keyword` = 'rewrite_contact' WHERE `id` IN ('".str_repeat('?, ', count($extensions) - 1) . '?'."')";
$db->query($sql);
$stmt = $db->prepare($sql);
$stmt->execute($extensions);