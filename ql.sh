config_dir="$HOME/.config/quicklog"
config_file="$config_dir/config.yaml"

initialize_config() {
  mkdir -p "$config_dir"
  echo "The configuration file does not exist or is incomplete."
  echo "Please specify the logbook directory."
  read -e -p "Directory: " -i "$HOME/" user_dir

  user_dir="${user_dir%/}"

  if [ -d "$user_dir" ]; then
    echo "Directory set to: $user_dir"
  else
    echo "$user_dir is an invalid directory. Exiting."
    exit 1
  fi

  logbook_path="$user_dir/logbook.txt"
  if [ -f "$logbook_path" ]; then
    echo "Synchronized the previously existing logbook successfully: $logbook_path"
  fi

  echo "logbook_path: $logbook_path" > "$config_file"
  echo "Configuration saved to $config_file"
}

load_config() {
  if [ ! -f "$config_file" ]; then
    initialize_config
  fi
  logbook_path=$(awk '/logbook_path:/ {print $2}' "$config_file")
}

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

load_config

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