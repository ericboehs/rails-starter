#!/bin/bash
eval "$(mise activate bash 2>/dev/null)" 2>/dev/null

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' '{"decision": "block", "reason": "Required dependency jq is not installed; ERB lint hook cannot determine the file to lint."}'
  exit 0
fi

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ ! "$file_path" =~ \.erb$ ]]; then exit 0; fi
if [[ ! -f "$file_path" ]]; then exit 0; fi

erb_out=$(bundle exec erb_lint "$file_path" 2>&1)
if [[ $? -ne 0 ]]; then
  reason=$'ERB Lint issues:\n'"$erb_out"
  jq -n --arg reason "$reason" '{"decision": "block", "reason": $reason}'
fi
