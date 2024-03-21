# Prompt user for source paths
echo "Enter the source paths (press Enter after each path, type 'done' when finished):"
source_paths=()
while true; do
    read -p "> " path
    if [ "$path" == "done" ]; then
        break
    else
        source_paths+=("$path")
    fi
done

# Prompt user for remote server IP
read -p "Enter the remote server IP: " remote_server_ip

# Prompt user for remote server port
read -p "Enter the remote server port (default is 22): " remote_port
remote_port=${remote_port:-22}  # Set default port to 22 if user didn't input anything

# Define the base destination path
base_destination_path="/root/migrare/"

# Perform rsync for each source path
for source_path in "${source_paths[@]}"; do
    # Perform rsync with the --relative option to preserve paths
    rsync -a -g -o -p -t -v -P --numeric-ids --relative -e "ssh -p $remote_port" "$source_path" "root@$remote_server_ip:$base_destination_path"
done

echo "Backup and sync completed successfully."
