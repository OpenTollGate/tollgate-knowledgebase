#!/usr/bin/env bash
# Print a concatenated overview of incident files, newest first.
# Usage: overview.sh [N]   # optional: limit to N most recent

set -euo pipefail

LIMIT="${1:-0}"

# Find the incidents dir: prefer ./incidents, else walk up.
find_incidents_dir() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/incidents" ]]; then
      echo "$dir/incidents"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

INCIDENTS_DIR="$(find_incidents_dir)" || {
  echo "error: no incidents/ directory found from $PWD upward" >&2
  exit 1
}

shopt -s nullglob
files=("$INCIDENTS_DIR"/*.md)
if (( ${#files[@]} == 0 )); then
  echo "error: no incident files in $INCIDENTS_DIR" >&2
  exit 1
fi

# Build "sortkey<TAB>path" lines. Sortkey is YYYYMMDD parsed from date: field.
# date format in frontmatter is DD-MM-YYYY.
rows=()
for f in "${files[@]}"; do
  date_line="$(awk '/^date:/ {print $2; exit}' "$f" || true)"
  if [[ "$date_line" =~ ^([0-9]{2})-([0-9]{2})-([0-9]{4})$ ]]; then
    sortkey="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
  else
    sortkey="00000000"
  fi
  rows+=("$sortkey	$f")
done

# Sort newest first.
IFS=$'\n' sorted=($(printf '%s\n' "${rows[@]}" | sort -r))
unset IFS

if (( LIMIT > 0 )); then
  sorted=("${sorted[@]:0:LIMIT}")
fi

cat <<EOF
# Incident overview

Source: $INCIDENTS_DIR
Count: ${#sorted[@]}$( (( LIMIT > 0 )) && echo " (limited to $LIMIT most recent)")

EOF

for row in "${sorted[@]}"; do
  f="${row#*	}"
  name="$(awk -F': ' '/^name:/ {sub(/^name: */,""); print; exit}' "$f")"
  date="$(awk '/^date:/ {print $2; exit}' "$f")"
  tags="$(awk -F': ' '/^tags:/ {sub(/^tags: */,""); print; exit}' "$f")"
  echo "---"
  echo "## ${name:-$(basename "$f" .md)}"
  echo "- date: ${date:-unknown}"
  echo "- tags: ${tags:-}"
  echo "- file: ${f}"
  echo
  cat "$f"
  echo
done
