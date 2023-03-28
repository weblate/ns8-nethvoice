#!/usr/bin/env sh

set -e

# if command is provided, execute it
if [ -n "$1" ]; then
  exec "$@"
else
  # check if UI_HOST and UI_PORT are set
  if [ -z "${UI_HOST}" ] || [ -z "${UI_PORT}" ]; then
    echo "UI_HOST and UI_PORT must be set"
    exit 1
  fi
  wait-for "${UI_HOST}:${UI_PORT}" -t 30 -- echo "UI is up"

  exec /docker-entrypoint.sh "$@"
fi
