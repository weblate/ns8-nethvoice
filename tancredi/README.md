# Tancredi

Tancredi container for NethServer 8


Tancredi code repository are https://github.com/nethesis/tancredi and https://github.com/nethesis/nethserver-tancredi/

## Environment variables

- `AMPDBPASS` password of asterisk database
- `AMPDBUSER` user of asterisk database
- `NETHVOICE_HOST` hostname of NethVoice server devices will connect to
- `NETHVOICE_MARIADB_PORT` port of MariaDB
- `NETHVOICESECRETKEY` secret key used by NethVoice UI to authenticate with Tancredi
- `PROXY_IP` sip proxy ip address to be used in extensions. Default is own public IP
- `PROXY_PORT` sip proxy port. Default is 5060
- `TANCREDI_STATIC_TOKEN` static token used by NethCTI to authenticate with Tancredi