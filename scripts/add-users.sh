#!/bin/bash

CSV_FILE="users.csv"
LOG_FILE="user_creation.log"
BATCH_SIZE=5
DELAY_BETWEEN_BATCHES=5 # seconds

# Initialize the log file
echo "Starting user creation process..." > "$LOG_FILE"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found" | tee -a "$LOG_FILE"
  exit 1
fi

# Read the CSV file and process users in batches
batch=()
header_skipped=false # Flag to track if the header line has been skipped
line_count=0
while IFS=, read -r role first_name last_name email; do
  ((line_count++))

  # Skip the header line
  if ! $header_skipped; then
    header_skipped=true
    echo "Skipping header line" | tee -a "$LOG_FILE"
    continue
  fi

  # Log the user details being processed
  echo "Reading user: $role, $first_name, $last_name, $email" | tee -a "$LOG_FILE"
  
  # Skip empty lines
  if [[ -z "$role" || -z "$first_name" || -z "$last_name" || -z "$email" ]]; then
    echo "Skipping empty or invalid line" | tee -a "$LOG_FILE"
    continue
  fi

  batch+=("$role,$first_name,$last_name,$email")
  if [[ ${#batch[@]} -ge $BATCH_SIZE ]]; then
    # Process the batch
    for user_info in "${batch[@]}"; do
      process_user "$user_info"
    done

    # Clear the batch
    batch=()

    echo "Batch completed. Sleeping for $DELAY_BETWEEN_BATCHES seconds..." | tee -a "$LOG_FILE"
    sleep $DELAY_BETWEEN_BATCHES
  fi
done < "$CSV_FILE"

# Process any remaining users
if [[ ${#batch[@]} -gt 0 ]]; then
  echo "Processing remaining users" | tee -a "$LOG_FILE"
  for user_info in "${batch[@]}"; do
    process_user "$user_info"
  done
fi

echo "User creation process completed." | tee -a "$LOG_FILE"

# Function to process a single user
process_user() {
  local user_info=$1
  IFS=, read -r role first_name last_name email <<< "$user_info"
  # Extract username from email (remove everything after '@' including '@')
  username="${email%%@*}"

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
