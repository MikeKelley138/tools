#!/bin/bash
set -x

CSV_FILE="./users.csv"
OUTPUT_LOG="command_output.log"

# Convert CSV file to Unix format to handle any line-ending issues
dos2unix "$CSV_FILE"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found"
  exit 1
fi

# Read the CSV file line by line
while IFS=',' read -r role first_name last_name email; do
  echo "Original line: role=$role, first_name=$first_name, last_name=$last_name, email=$email"

  # Skip the header line
  if [[ "$role" == "role" ]]; then
    echo "Skipping header line"
    continue
  fi

  # Trim leading and trailing spaces from fields and remove potential carriage return characters
  role=$(echo "$role" | tr -d '[:space:]' | tr -d '\r')
  first_name=$(echo "$first_name" | tr -d '[:space:]' | tr -d '\r')
  last_name=$(echo "$last_name" | tr -d '[:space:]' | tr -d '\r')
  email=$(echo "$email" | tr -d '[:space:]' | tr -d '\r')

  echo "Trimmed line: role=$role, first_name=$first_name, last_name=$last_name, email=$email"

  # Extract username from email (remove everything after '@' including '@')
  username="${email%%@*}"

  # Create command with output redirection
  create_command="vip @385.develop -- wp user create \"$username\" \"$email\" --role=\"$role\" >> $OUTPUT_LOG 2>&1"

  # Run the WP CLI command
  echo "Running command: $create_command"
  bash -c "$create_command"

done < "$CSV_FILE"

# Disable debug mode at the end of the script
set +x
