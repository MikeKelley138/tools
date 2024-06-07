#!/bin/bash

CSV_FILE="users.csv"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found"
  exit 1
fi

# Function to remove non-printing characters from a string
remove_non_printable_chars() {
  local string="$1"
  echo "$string" | tr -cd '[:print:]'
}

# Read the CSV file line by line
while IFS=, read -r role first_name last_name email; do
  # Skip the header line
  if [[ "$role" == "role" ]]; then
    continue
  fi

  # Extract username from email (remove everything after '@' including '@')
  username="${email%%@*}"

  # Create variables for different parts of the command
  create_command="wp user create \"$username\" \"$email\""
  additional_args="--role=\"$role\" --first_name=\"$first_name\" --last_name=\"$last_name\""

  # Remove non-printing characters from create_command
  create_command_clean="$(remove_non_printable_chars "$create_command")"

  # Concatenate the variables to form the WP CLI command
  wp_command="$create_command_clean $additional_args"

  # Run the WP CLI command
  echo "Running command: $wp_command"
  eval "$wp_command"

done < "$CSV_FILE"
