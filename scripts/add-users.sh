#!/bin/bash

CSV_FILE="users.csv"
LOG_FILE="user_creation.log"
BATCH_SIZE=5
DELAY_BETWEEN_BATCHES=5 # seconds

# Initialize the log file
echo "Starting user creation process..." > "$LOG_FILE"

# Function to create a WP user
create_wp_user() {
  local username="$1"
  local email="$2"
  local role="$3"
  local first_name="$4"
  local last_name="$5"

  # Create the WP CLI command
  wp_command="vip @123.preprod -- wp user create \"$username\" \"$email\" --role=\"$role\" --first_name=\"$first_name\" --last_name=\"$last_name\" --allow-root"

  # Debugging: Echo the command before running it
  echo "Running command: $wp_command" | tee -a "$LOG_FILE"

  # Run the WP CLI command and log the output
  eval "$wp_command" 2>&1 | tee -a "$LOG_FILE"

  # Check the exit status of the last command
  if [[ $? -ne 0 ]]; then
    echo "Command failed: $wp_command" | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found" | tee -a "$LOG_FILE"
  exit 1
fi

# Read the CSV file and process users
while IFS=, read -r role first_name last_name email; do
  # Skip the header line
  if [[ "$role" == "role" ]]; then
    continue
  fi

  # Extract username from email (remove everything after '@' including '@')
  username="${email%%@*}"

  # Create the WP user
  create_wp_user "$username" "$email" "$role" "$first_name" "$last_name"

  # Delay between users
  echo "Sleeping for $DELAY_BETWEEN_BATCHES seconds..." | tee -a "$LOG_FILE"
  sleep $DELAY_BETWEEN_BATCHES
done < "$CSV_FILE"

echo "User creation process completed." | tee -a "$LOG_FILE"
