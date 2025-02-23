# QuickLog - Minimalist CLI Logbook

QuickLog is a simple command-line tool for quickly logging thoughts. It provides strong encryption and decryption for privacy.

## Installation
```bash
git clone https://github.com/andrechaumet/quick-log.git
cd quick-log
chmod +x ql.sh
sudo mv ql.sh /usr/local/bin/ql
```
- Run `ql` for the first time to set up your logbook.

## Usage

### Adding an Entry

```bash
ql Your log entry
```

- If this is your first time using QuickLog, it will ask you to configure the logbook directory.
- If the logbook is encrypted, it will prompt you to decrypt it before adding new entries.
- If your entry contains special characters, enclose it in double quotes, e.g., "Your log entry".

### Reading the Logbook

```bash
ql -r
```

- Opens the entire logbook in a pager.

### Viewing the Last Entry

```bash
ql -l
```

- Displays only the last log entry.

### Encrypting the Logbook

```bash
ql -e {key}
```

- Encrypts the logbook using AES256.
- Deletes the plaintext version after encryption.

### Decrypting the Logbook

```bash
ql -de {key}
```

- Decrypts the logbook and removes the encrypted version.

## Notes

- If the logbook is encrypted, you **must** decrypt it before adding new entries.
- The encryption uses GPG with AES256 for security.

---

🚀 QuickLog makes logging fast, simple, and private!

