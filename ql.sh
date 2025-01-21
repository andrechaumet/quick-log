desktop_path="$HOME/Desktop"
logbook_path="$desktop_path/logbook.txt"

write_log() {
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  text_with_timestamp="$timestamp\n$2"
  if [ ! -f "$1" ]; then
    echo -e "$text_with_timestamp" > "$1"
  else
    echo -e "\n\n$text_with_timestamp" >> "$1"
  fi
  echo "Text added to $1"
}

read_logs() {
  if [ -f "$1" ]; then
    less "$1"
  else
    echo "No logbook found at $1"
  fi
}

last_log() {
  if [ -f "$1" ]; then
    awk -v RS= 'END {print $0}' "$1"
  else
    echo "No logbook found at $1"
  fi
}

if [ ! -d "$desktop_path" ]; then
  echo "Error: Desktop path not found: $desktop_path"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage: ql {text}"
  echo "       ql -r     # To read the logbook"
  echo "       ql -l     # To show the last log entry"
  exit 1
fi

if [ "$1" == "-r" ]; then
  read_logs "$logbook_path"
  exit 0
fi

if [ "$1" == "-l" ]; then
  last_log "$logbook_path"
  exit 0
fi

write_log "$logbook_path" "$*"

