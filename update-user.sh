#!/bin/zsh

INPUT_FILE="posts.txt"
NEW_USER_ID=270
COMMAND="vip @1351.preprod -- wp post update"

while IFS= read -r post_id; do
  [[ -z "$post_id" ]] && continue

  echo "updating post ID $post_id..."
  $COMMAND "$post_id" --post_author="$NEW_USER_ID"
done < $INPUT_FILE
