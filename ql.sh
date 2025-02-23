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

ensure_decrypted_logbook() {
  if [ -f "$logbook_path.gpg" ]; then
    echo "⚠️ The logbook is encrypted. Please decrypt it first."
    read -s -p "Enter decryption password: " passphrase
    echo ""
    gpg --batch --yes --passphrase "$passphrase" --decrypt "$logbook_path.gpg" > "$logbook_path"
    if [ $? -eq 0 ]; then
      rm -f "$logbook_path.gpg"
      echo "✅ Logbook decrypted successfully."
    else
      echo "❌ Decryption failed. Exiting."
      exit 1
    fi
  fi
}

write_log() {
  ensure_decrypted_logbook
  if [ ! -f "$1" ]; then
    echo "🚫 No logbook found at $1"
    return 1
  fi

  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  text_with_timestamp="$timestamp\n$2"
  echo -e "\n\n$text_with_timestamp" >> "$1"
  echo "📝 Text added to $1"
}


read_logs() {
  if [ -f "$1" ]; then
    less "$1"
  else
    echo "🚫 No logbook found at $1"
  fi
}

last_log() {
  if [ -f "$1" ]; then
    awk -v RS= 'END {print $0}' "$1"
  else
    echo "🚫 No logbook found at $1"
  fi
}

encrypt_log() {
  if [ ! -f "$logbook_path" ]; then
    echo "🚫 No logbook found to encrypt."
    exit 1
  fi

  gpg --batch --yes --passphrase "$1" --symmetric --cipher-algo AES256 "$logbook_path"
  if [ $? -eq 0 ]; then
    rm -f "$logbook_path"
    echo "✅ Logbook encrypted successfully."
  else
    echo "❌ Encryption failed."
  fi
}

decrypt_log() {
  if [ ! -f "$logbook_path.gpg" ]; then
    echo "🚫 No encrypted logbook found."
    exit 1
  fi

  gpg --batch --yes --passphrase "$1" --decrypt "$logbook_path.gpg" > "$logbook_path"
  if [ $? -eq 0 ]; then
    rm -f "$logbook_path.gpg"
    echo " Logbook decrypted successfully."
  else
    echo "❌ Decryption failed."
  fi
}

load_config

if [ $# -eq 0 ]; then
  echo "Usage: ql {text}"
  echo "       ql -r         # To read the logbook"
  echo "       ql -l         # To show the last log entry"
  echo "       ql -e {key}   # To encrypt the logbook"
  echo "       ql -de {key}  # To decrypt the logbook"
  exit 1
fi

case "$1" in
  -r) read_logs "$logbook_path" ;;
  -l) last_log "$logbook_path" ;;
  -e) encrypt_log "$2" ;;
  -de) decrypt_log "$2" ;;
  *) write_log "$logbook_path" "$*" ;;
esac
