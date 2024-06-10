#!/bin/bash

CSV_FILE="users.csv"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found"
  exit 1
fi
# Trim leading and trailing spaces from fields
role=$(echo "$role" | tr -d '[:space:]')
first_name=$(echo "$first_name" | tr -d '[:space:]')
last_name=$(echo "$last_name" | tr -d '[:space:]')
email=$(echo "$email" | tr -d '[:space:]')

# Read the CSV file line by line
while IFS=',' read -r role first_name last_name email 
do
  # Skip the header line
  if [[ "$role" == "role" ]]; then
    continue
  fi

  # Extract username from email (remove everything after '@' including '@')
  username="${email%%@*}"

  # Create variables for different parts of the command
  create_command="vip @385.develop -- wp user create \"$username\" \"$email\" --role=\"$role\" --first_name=\"$first_name\" --last_name=\"$last_name\" "

  # Run the WP CLI command
  echo "Running command: $create_command"
  echo "preparing eval"
  eval "$create_command"
  echo "eval complete"

done < "$CSV_FILE"

