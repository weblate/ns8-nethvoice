# Phonebook

Phonebook container for NethServer 8
This container connects to MariaDB phonebook database, read the phonebook and expose it using LDAPS


Phonebook code repository is https://github.com/nethesis/nethserver-phonebook-mysql/tree/ns8

## Environment variables

- `PHONEBOOK_DB_NAME` name of phonebook database
- `PHONEBOOK_DB_USER` user of phonebook database
- `PHONEBOOK_DB_PASS` password of phonebook database
- `PHONEBOOK_DB_HOST` host of phonebook database
- `NETHVOICE_MARIADB_PORT` port of MariaDB phonebook database
- `PHONEBOOK_LDAP_LIMIT` limit of LDAP results. Default is 500
- `PHONEBOOK_LDAP_PORT` port of LDAP server
- `PHONEBOOK_LDAP_USER` user of LDAP server
- `PHONEBOOK_LDAP_PASS` password of LDAP server
