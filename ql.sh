#!/bin/bash

desktop_path="$HOME/Desktop"
logbook_path="$desktop_path/logbook.txt"

if [ ! -d "$desktop_path" ]; then
  echo "Error: Desktop path not found: $desktop_path"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage: ql {text}"
  exit 1
fi

text="$*"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

if [ ! -f "$logbook_path" ]; then
  echo "$timestamp" > "$logbook_path"
  echo "$text" >> "$logbook_path"
else
  echo -e "\n$timestamp" >> "$logbook_path"
  echo -e "$text" >> "$logbook_path"
fi

echo "Text added to $logbook_path"

