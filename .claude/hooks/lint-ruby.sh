#!/bin/bash
eval "$(mise activate bash 2>/dev/null)" 2>/dev/null

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' '{"decision": "block", "reason": "Required dependency jq is not installed; Ruby lint hook cannot determine the file to lint."}'
  exit 0
fi

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ ! "$file_path" =~ \.rb$ ]]; then exit 0; fi
if [[ ! -f "$file_path" ]]; then exit 0; fi

# Skip paths excluded from Reek (mirrors .reek.yml exclude_paths)
if [[ "$file_path" =~ db/migrate/ ]] || [[ "$file_path" =~ \.git-hooks/ ]] || [[ "$file_path" =~ /bin/ ]] || [[ "$file_path" =~ /test/ ]]; then
  reek_skip=true
fi

output=""

rubocop_out=$(bundle exec rubocop --format simple --force-exclusion "$file_path" 2>&1)
if [[ $? -ne 0 ]]; then
  output+="RuboCop issues:"
  output+=$'\n'"$rubocop_out"$'\n\n'
fi

if [[ -z "$reek_skip" ]]; then
  reek_out=$(bundle exec reek "$file_path" 2>&1)
  if [[ $? -ne 0 ]]; then
    output+="Reek issues:"
    output+=$'\n'"$reek_out"$'\n\n'
  fi
fi

if [[ -n "$output" ]]; then
  jq -n --arg reason "$output" '{"decision": "block", "reason": $reason}'
fi
