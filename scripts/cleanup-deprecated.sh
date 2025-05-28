#!/bin/bash
# Cleanup script for removing deprecated run scripts
# Created: May 28, 2025

echo "This script will remove deprecated run scripts that have been replaced by the unified run.sh script."
echo "The following files will be removed:"
echo "- scripts/run-prod-local.sh"
echo "- scripts/run-prod-local-unified.sh"
echo

read -p "Are you sure you want to proceed? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Make backup directory
    mkdir -p scripts/deprecated_backup
    
    # Copy files to backup
    cp scripts/run-prod-local.sh scripts/deprecated_backup/
    cp scripts/run-prod-local-unified.sh scripts/deprecated_backup/
    
    # Remove the files
    rm scripts/run-prod-local.sh
    rm scripts/run-prod-local-unified.sh
    
    echo "Deprecated files have been removed."
    echo "Backups of these files are stored in scripts/deprecated_backup/ directory."
    echo "Note: scripts/run-migrations.sh has been kept as it's used for database migrations."
else
    echo "Operation cancelled. No files were removed."
fi
