#!/bin/bash

CSV_FILE="users.csv"

# Function to check CSV file format
check_csv_format() {
    while IFS=',' read -r role first_name last_name email; do
        # Check if each line has the expected number of fields
        if [[ "$role" == "" || "$first_name" == "" || "$last_name" == "" || "$email" == "" ]]; then
            echo "Error: Invalid CSV format - Missing fields in line: $role,$first_name,$last_name,$email"
            exit 1
        fi
        # Add additional validation as needed
        # For example, check if email addresses are valid
    done < "$CSV_FILE"
}

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found"
  exit 1
fi

# Validate the CSV file format
check_csv_format

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

