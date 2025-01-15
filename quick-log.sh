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

if [ ! -f "$logbook_path" ]; then
  echo "$text" > "$logbook_path"
else
  echo -e "\n\n$text" >> "$logbook_path"
fi

echo "Log added to $logbook_path"

