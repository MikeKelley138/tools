#!/bin/bash

CSV_FILE="users.csv"

if [[ ! -f "$CSV_FILE"]]; then
  echo "CSV file not found"
  exit 1
fi

while IFS=, read -r role first_name last_name email
do

  if[[ "$role" == "role"]]; then
    continue
  fi

  #generate username - same as email
  username=$email

  command="vip @385.develop -- wp user create $username $email --role=$role --first_name=$first_name --last_name=$last_name"

  echo "running command: $command"

  eval $command

done < "$CSV_FILE"