#!/bin/bash

current_time=$(date +"%Y%m%d_%H%M%S")    
archive_name="archive_${current_time}.zip"

find . -type f -mmin +3 -exec zip -r "${archive_name}" {} +

if [ -e "latest_archive.zip" ]; then
    rm -f "latest_archive.zip"
fi
    
ln -s "${archive_name}" "latest_archive.zip"

