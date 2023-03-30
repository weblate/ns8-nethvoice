# FreePBX

FreePBX container for NethServer 8

## Environment variables

- `APACHE_RUN_USER` user Apache is run with (Asterisk)
- `APACHE_RUN_GROUP` group Apache is run with (Asterisk)
- `ASTMANAGERHOST` is the ip where AMI , Asterisk Manager Interface is exposed. 127.0.0.1 in network=host configuration
- `ASTMANAGERPORT` port of AMI, Asterisk Manager Interface
- `AMPMGRUSER` User automatically configured to access ti AMI
- `AMPMGRPASS` Password of AMI user
- `AMPDBUSER` FreePBX MariaDB database user (default: freepbxuser)
- `AMPDBPASS` FreePBX MariaDB database password
- `AMPDBHOST` FreePBX MariaDB database host (default: 127.0.0.1)
- `AMPDBNAME` FreePBX MariaDB database name (default: asterisk)
- `CDRDBUSER` CDR MariaDB database user (default: freepbxuser)
- `CDRDBPASS` CDR MariaDB database pass
- `NETHCTI*`
    - `NETHCTI_DB_USER` NethCTI MariaDB database user (default: nethcti3)
    - `NETHCTI_DB_PASSWORD` NethCTI MariaDB database password
    - `NETHCTI_AMI_PASSWORD` NethCTI AMI password 
- `APACHE_PORT` Port used for httpd
- `TANCREDIPORT` Port used bt Tancredi
- `BRAND_NAME` Name for branding (default: NethVoice)
- `BRAND_SITE` Site or branding (default: www.nethesis.it)
- `BRAND_DOCS` Site or documentation (default: ?)
- `SUBSCRIPTION_SYSTEMID` my.nethesis.it server SystemID
- `SUBSCRIPTION_SECRET` my.nethesis.it server secret