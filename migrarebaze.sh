#!/bin/bash

# Prompt user to modify MySQL connection details
read -p "Enter MySQL host (default is localhost): " mysql_host
mysql_host=${mysql_host:-localhost}  # Set default host to localhost if user didn't input anything

read -p "Enter MySQL user: " mysql_user

echo "Enter MySQL password:"
echo "Hint: Parola poate fi găsită accesând: /etc/webmin/mysql/config | grep pass"
read -s mysql_password
echo

# Main folder path to store SQL files
output_folder='/root/bazededate'

# Check if the output folder exists, if not, create it
if [ ! -d "$output_folder" ]; then
    mkdir -p "$output_folder"
    echo "Folder $output_folder created."
fi

# Get a list of all databases
databases=$(mysql -h "$mysql_host" -u "$mysql_user" -p"$mysql_password" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# Loop through each database and export it to a SQL file
for db in $databases; do
    mysqldump -h "$mysql_host" -u "$mysql_user" -p"$mysql_password" "$db" > "$output_folder/$db.sql"
    echo "Exported $db to $output_folder/$db.sql"
done

echo "All databases exported to $output_folder"
