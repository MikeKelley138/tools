#!/bin/bash

set -e

FILES_DIR="./test"
OUTPUT_FILE="output.txt"
NEW_PRIMARY_SECTION="22441"
VIP_CMD="vip @5867.preprod -- wp"

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Add header to the output CSV
echo "ID,Post Title,Action" >> "$OUTPUT_FILE"

# Loop through each file
for FILE in "$FILES_DIR"/page*.txt; do
  echo "Processing $FILE"

  # Read each post ID from the file
  while IFS= read -r POST_ID; do
    echo "Checking post ID: $POST_ID"

    # Check if the post has a primary section meta value
    PRIMARY_SECTION=$($VIP_CMD post meta get "$POST_ID" primary_section | xargs)

    if [ "$PRIMARY_SECTION" == '1' ]; then
      # Update the primary section to the new value
      if $VIP_CMD post meta update "$POST_ID" primary_section "$NEW_PRIMARY_SECTION"; then
        echo "Primary section updated for post ID $POST_ID"

        # Get post title
        POST_TITLE=$($VIP_CMD post get "$POST_ID" --field=post_title)

        # Append the post ID and title to the output file indicating the primary section was updated
        echo "$POST_ID,\"$POST_TITLE\",Primary section updated to $NEW_PRIMARY_SECTION" >> "$OUTPUT_FILE"
      else
        echo "Failed to update primary section for post ID $POST_ID" >> "$OUTPUT_FILE"
      fi
    else
      echo "Post ID $POST_ID primary section is not '1', it's $PRIMARY_SECTION"
    fi
  done < "$FILE"
done

echo "Processing complete. Results listed in $OUTPUT_FILE"
