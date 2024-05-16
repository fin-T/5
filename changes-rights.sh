#!/bin/bash

specified_folder="$1"

# Function for recursively changing file and folder permissions
change_permissions() {
    local folder="$1"
    
    # Changing permissions for files in a folder
    find "$folder" -type f -exec chmod 660 {} \;

    # Changing permissions for folders in a folder
    find "$folder" -type d -exec chmod 770 {} \;
}

# Ignore self if script is inside the specified folder
ignore_self() {
    local folder="$1"
    local script_name=$(basename "$0")

    if [[ "$folder" == "$(dirname "$0")" ]]; then
        echo "Script is inside the specified folder. Ignoring self."
        return 1
    fi
}

# Check if script should ignore self
ignore_self "$specified_folder" && exit

# Infinite loop to periodically change permissions
while true; do
    change_permissions "$specified_folder"
    sleep 5 # Pause 5 seconds between iterations
done

