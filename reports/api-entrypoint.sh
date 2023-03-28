#!/usr/bin/env sh

set -e

# if command is provided, execute it
if [ -n "$1" ]; then
  exec "$@"
else
  # Wait for redis to be ready
  redis_addr=$(jq '.redis_host' /opt/nethvoice-report/api/conf.json)
  wait-for "${redis_addr}" -t 30 -- echo "Redis is up"

  # Wait for cdr database to be ready
  cdr_database_host=$(jq '.cdr_database.host' /opt/nethvoice-report/api/conf.json)
  cdr_database_port=$(jq '.cdr_database.port' /opt/nethvoice-report/api/conf.json)
  wait-for "${cdr_database_host}:${cdr_database_port}" -t 30 -- echo "Cdr database is up"

  # Migrate cdr database
  # Check if REPORTS_INTERNATIONAL_PREFIX is set, otherwise exit
  if [ -z "${REPORTS_INTERNATIONAL_PREFIX}" ]; then
    echo "REPORTS_INTERNATIONAL_PREFIX is not set"
    exit 1
  fi
  # Fetch credentials from conf.json
  cdr_database_user=$(jq '.cdr_database.user' /opt/nethvoice-report/api/conf.json)
  cdr_database_password=$(jq '.cdr_database.password' /opt/nethvoice-report/api/conf.json)
  cdr_database_name=$(jq '.cdr_database.name' /opt/nethvoice-report/api/conf.json)
  # Replace $international_prefix with REPORTS_INTERNATIONAL_PREFIX
  sed \
    -e 's/@international_prefix/'"${REPORTS_INTERNATIONAL_PREFIX}"'/g' \
    -e 's/@database_name/'"${cdr_database_name}"'/g' \
    /opt/nethvoice-report/api/migration.sql.tmpl | mysql -u"${cdr_database_user}" -p"${cdr_database_password}" -h"${cdr_database_host}" -P"${cdr_database_port}"

  # Wait for phonebook database to be ready
  phonebook_database_host=$(jq '.phonebook_database.host' /opt/nethvoice-report/api/conf.json)
  phonebook_database_port=$(jq '.phonebook_database.port' /opt/nethvoice-report/api/conf.json)
  wait-for "${phonebook_database_host}:${phonebook_database_port}" -t 30 -- echo "Phonebook database is up"

  # Wait for freepbx database to be ready
  freepbx_database_host=$(jq '.freepbx_database.host' /opt/nethvoice-report/api/conf.json)
  freepbx_database_port=$(jq '.freepbx_database.port' /opt/nethvoice-report/api/conf.json)
  wait-for "${freepbx_database_host}:${freepbx_database_port}" -t 30 -- echo "Freepbx database is up"

  # Start api service
  exec api
fi
