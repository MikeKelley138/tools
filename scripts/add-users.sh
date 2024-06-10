#!/bin/bash

CSV_FILE="./users.csv"
OUTPUT_LOG="command_output.log"

# Clean the CSV file
tr -cd '\11\12\15\40-\176' < "$CSV_FILE" > "${CSV_FILE}.clean"
echo >> "${CSV_FILE}.clean"
mv "${CSV_FILE}.clean" "$CSV_FILE"

# Convert CSV file to Unix format to handle any line-ending issues
dos2unix "$CSV_FILE"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "CSV file not found"
  exit 1
fi

# Process the CSV file using awk
awk -F',' 'NR > 1 { 
    role = $1; 
    email = $4; 
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", role); 
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", email); 
    if (role == "" || email == "") {
        print "Missing role or email on line " NR ". Skipping...";
        next;
    }
    username = substr(email, 1, index(email, "@") - 1); 
    command = "vip @386.develop -- wp user create \"" username "\" \"" email "\" --role=\"" role "\" >> \"" output_log "\" 2>&1"; 
    print "Running command:", command; 
    system(command); 
}' output_log="$OUTPUT_LOG" "$CSV_FILE"
