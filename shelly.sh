#!/bin/bash

get_configured_editor() {
    local configfile=$1
    configured_editor=$(grep '^EDITOR:' "$configfile" | cut -d ':' -f2 | xargs)
    if [ -z "$configured_editor" ]; then
        configured_editor=${VISUAL:-${EDITOR:-nano}}
    fi
    echo $configured_editor
}

USER_DATA_DIR="$HOME/.shelly"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
export PYTHONPATH="$DIR:$PYTHONPATH"

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage:"
    echo
    echo "> shelly \"command description in natural language\""
    echo "> shelly --config"
    echo "> shelly --version"
    exit 0
fi

# Check for --version argument
if [[ "$1" == "--version" ]]; then
    VERSION=$(cat version.txt)
    echo $VERSION
    exit 0
fi

# Define the config file path
configfile="$USER_DATA_DIR/config.yml"

if [[ "$1" == "--config" ]] || [ ! -f "$configfile" ]; then
    # Define the config file path
    configfile="$HOME/.shelly/config.yml"
    configdir="$HOME/.shelly"

    # Check if the config directory exists, if not, create it
    if [ ! -d "$configdir" ]; then
        mkdir -p "$configdir"
    fi

    # Check if the config file exists, if not, copy the default config file
    if [ ! -f "$configfile" ]; then
        cp "$DIR/default_config.yml" "$configfile"
    fi

    # Open the config file in the default editor for editing
    editor=$(get_configured_editor "$configfile")
    $editor "$configfile"

    # Exit after editing the config file
    exit 0
fi

# Run the Python script and capture the output
response=$(python3 $DIR/src/main.py "$@")

# Use jq to parse the JSON and extract fields.
error_message=$(echo "$response" | jq -r '.error')

if [ -n "$error_message" ] && [ "$error_message" != "null" ]; then
    echo "$error_message"
    exit 1
fi
input=$(echo "$response" | jq -r '.input')
output=$(echo "$response" | jq -r '.output')

# Get the device name
device_name=$(hostname)

# SQLite database file
dbfile="$USER_DATA_DIR/history.db"

# Check if the database file exists, if not, create it and initialize the table
if [ ! -f "$dbfile" ]; then
    sqlite3 "$dbfile" "CREATE TABLE history (timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, device_name TEXT, query TEXT, command TEXT);"
fi

# Create a temporary file
tempfile=$(mktemp)

# Ensure the temporary file is deleted on exit
trap "rm -f '$tempfile'" EXIT

# Write the command to the temporary file
echo "$output" >"$tempfile"

editor=$(get_configured_editor "$configfile")
$editor "$tempfile"

# Read the possibly edited command back from the temporary file
file_contents=$(cat "$tempfile")

# If the command is not empty, execute it and save it to the SQLite database
if [ -n "$file_contents" ]; then
    # Insert the executed command into the history table
    sqlite3 "$dbfile" "INSERT INTO history (device_name, query, command) VALUES ('$device_name', '$input', '$file_contents');"

    # Execute the command
    eval "$file_contents"

    # Delete commands older than 3 months
    sqlite3 "$dbfile" "DELETE FROM history WHERE timestamp < datetime('now', '-3 month');"
else
    echo "No command to execute."
fi
