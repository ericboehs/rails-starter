#!/bin/bash
eval "$(mise activate bash 2>/dev/null)" 2>/dev/null

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ ! "$file_path" =~ \.erb$ ]]; then exit 0; fi
if [[ ! -f "$file_path" ]]; then exit 0; fi

erb_out=$(bundle exec erb_lint "$file_path" 2>&1)
if [[ $? -ne 0 ]]; then
  jq -n --arg reason "ERB Lint issues:\n$erb_out" '{"decision": "block", "reason": $reason}'
fi
