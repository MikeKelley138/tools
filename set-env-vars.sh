#!/bin/bash

APP_FILE="apps.txt"

ENV_VAR_NAME="ACF_PRO_KEY"

VAR_VALUE="b3JkZXJfaWQ9MTgxMjAyfHR5cGU9ZGV2ZWxvcGVyfGRhdGU9MjAxOS0xMi0yMCAxOTowMDo0NQ=="

ENVIRONMENTS=("staging")

while IFS= read -r APP_KEY; do
  [[ -z "$APP_KEY" ]] && continue

  echo "Setting $VAR_NAME for @APP_KEY.$ENV ..."

  expect <<EOF
    spawn vip @$APP_KEY.staging config envvar set $ENV_VAR_NAME
    expect "? Enter the value for ACF_PRO_KEY:"
    send "$VAR_VALUE\r"
    expect "? Please confirm the input value above (y/N)"
    send "y\r"
    expect oef
EOF

done < "apps.txt"
