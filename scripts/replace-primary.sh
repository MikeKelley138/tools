#!/bin/bash

# Directory containing the files (change this to your actual directory)
FILES_DIR="/path/to/your/files"
OUTPUT_FILE="/path/to/output/missing_primary_section_posts.csv"
NEW_PRIMARY_SECTION="new_value" # Set the new value for the primary section

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Add header to the output CSV
echo "ID,Post Title,Action" >> "$OUTPUT_FILE"

# Loop through each file
for FILE in "$FILES_DIR"/page*.txt; do
  echo "Processing $FILE"
  
  # Read each post ID from the file
  while IFS= read -r POST_ID; do
    # Check if the post has a primary section meta value
    PRIMARY_SECTION=$(wp post meta get "$POST_ID" primary_section)

    if [ -z "$PRIMARY_SECTION" ]; then
      # Get post title
      POST_TITLE=$(wp post get "$POST_ID" --field=post_title)
      
      # Append the post ID and title to the output file indicating no primary section
      echo "$POST_ID,\"$POST_TITLE\",No primary section" >> "$OUTPUT_FILE"
    elif [ "$PRIMARY_SECTION" -eq 1 ]; then
      # Update the primary section to the new value
      wp post meta update "$POST_ID" primary_section "$NEW_PRIMARY_SECTION"
      
      # Get post title
      POST_TITLE=$(wp post get "$POST_ID" --field=post_title)
      
      # Append the post ID and title to the output file indicating the primary section was updated
      echo "$POST_ID,\"$POST_TITLE\",Primary section updated to $NEW_PRIMARY_SECTION" >> "$OUTPUT_FILE"
    fi
  done < "$FILE"
done

echo "Processing complete. Results listed in $OUTPUT_FILE"
