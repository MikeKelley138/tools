#!/bin/bash

CSV_FILE="users.csv"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found"
  exit 1
fi

# Read the CSV file line by line
while IFS=, read -r role first_name last_name email; do
  # Skip the header line
  if [[ "$role" == "role" ]]; then
    continue
  fi

  # Generate username (same as email)
  username="$email"

  # Create the WP CLI command
  wp_command="wp user create $username $email --role=$role --first_name=$first_name --last_name=$last_name"

  # Run the WP CLI command
  echo "Running command: $wp_command"
  eval "$wp_command"

done < "$CSV_FILE"
