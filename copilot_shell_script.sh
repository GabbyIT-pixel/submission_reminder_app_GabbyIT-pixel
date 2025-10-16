#!/bin/bash

# Ask the user for the new assignment name to replace the old one
echo -n "Enter the new assignment name: "
read new_assignment

main_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the path to the config file
config_file="$(find "$main_dir" -type f -path "*/config/config.env" | head -n 1)"
# Locate path to startup.sh
startup_file="$(find "$main_dir" -type f -name "startup.sh" | head -n 1)"

# Checking if config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Config file not found at $config_file"
    exit 1
fi

# Update the ASSIGNMENT value in config.env
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"

echo "Assignment updated to '$new_assignment' in config.env."

# rerun the application
echo "Running the startup script."
bash "$startup_file" 