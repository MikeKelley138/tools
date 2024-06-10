while IFS=, read -r role first_name last_name email; do
  # Skip the header line
  if [[ "$role" == "role" ]]; then
    continue
  fi

  # Extract username from email (remove everything after '@' including '@')
  username="${email%%@*}"

  # Create array for the WP CLI command
  create_command=("vip" "@385.develop" "--" "wp" "user" "create" "$username" "$email" "--role=$role" "--first_name=$first_name" "--last_name=$last_name")

  # Debugging: Print the command before running it
  echo "Running command: ${create_command[@]}"

  # Run the WP CLI command
  echo "preparing command execution"
  "${create_command[@]}"
  echo "command execution complete"
done < "$CSV_FILE"
