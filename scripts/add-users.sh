#!/bin/bash

CSV_FILE="users.csv"
LOG_FILE="user_creation.log"
BATCH_SIZE=5

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found" | tee -a "$LOG_FILE"
  exit 1
fi

# Function to process a batch of users
process_batch() {
  local batch=("$@")
  for user in "${batch[@]}"; do
    IFS=, read -r role first_name last_name email <<< "$user"
    
    # Skip the header line
    if [[ "$role" == "role" ]]; then
      continue
    fi

    # Extract username from email (remove everything after '@' including '@')
    username="${email%%@*}"

    # Create the WP CLI command
    wp_command="vip @123.preprod -- wp user create \"$username\" \"$email\" --role=\"$role\" --first_name=\"$first_name\" --last_name=\"$last_name\" --allow-root"
    
    # Debugging: Echo the command before running it
    echo "Running command: $wp_command" | tee -a "$LOG_FILE"
    
    # Run the WP CLI command and log the output
    eval "$wp_command" 2>&1 | tee -a "$LOG_FILE"
  done
}

# Read the CSV file and process users in batches
batch=()
while IFS=, read -r role first_name last_name email; do
  batch+=("$role,$first_name,$last_name,$email")
  if [[ ${#batch[@]} -ge $BATCH_SIZE ]]; then
    process_batch "${batch[@]}"
    batch=()
  fi
done < "$CSV_FILE"

# Process any remaining users
if [[ ${#batch[@]} -gt 0 ]]; then
  process_batch "${batch[@]}"
fi

echo "User creation process completed." | tee -a "$LOG_FILE"
