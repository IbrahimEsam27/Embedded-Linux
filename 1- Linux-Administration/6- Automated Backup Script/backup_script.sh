#!/bin/bash 

# Check if no directory is provided as argument
if [ "$#" -eq 0 ]; then
echo " you havenot entered directories as arguments"
exit 1 
fi

backup_dir="backups"
# Checks if there is backupdirectory called backups
if [ ! -d "$backup_dir" ]; then
mkdir "$backup_dir"
echo "Created backup directory: $backup_dir"
fi

for dir in "$@"; do
	# Check if directory exists
	if [ ! -d "$dir" ]; then
	echo "Error: Directory '$dir' does not exist."

	else
	# Extract directory name from path
        dir_name=$(basename "$dir")
        
	# Create backup filename with current date
        backup_file="backup_${dir_name}_$(date +%Y-%m-%d).tar.gz"
        
	# Perform backup
        tar -czf "$backup_dir/$backup_file" "$dir" && echo "Backup of '$dir' created: $backup_file" || echo "Error: Backup of '$dir' failed."
    fi
done
	 



 
