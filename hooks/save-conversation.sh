#!/bin/bash

# Read the SessionEnd hook input from stdin
input=$(cat)

# Extract info from hook input
transcript_path=$(echo "$input" | jq -r '.transcript_path')
session_id=$(echo "$input" | jq -r '.session_id')

# Output directory
output_dir="$HOME/.claude/saved-conversations"
mkdir -p "$output_dir"

# Copy transcript to saved conversations directory
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  timestamp=$(date +%Y%m%d_%H%M%S)
  output_file="$output_dir/conversation_${timestamp}_${session_id}.jsonl"
  cp "$transcript_path" "$output_file"
fi

exit 0
