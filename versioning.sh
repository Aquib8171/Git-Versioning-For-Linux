GNU nano 5.8                                                                                                                                                                           versioning.sh
#!/bin/bash

# Define directories
SSH_DIR="/etc/ssh"
LOG_DIR="$SSH_DIR/scripts/logs"
mkdir -p "$LOG_DIR"  # Ensure log directory exists

cd "$SSH_DIR" || { echo "Failed to change directory to $SSH_DIR"; exit 1; }

# Ensure Git is initialized in the SSH directory
if [ ! -d "$SSH_DIR/.git" ]; then
    echo "Initializing Git repository in $SSH_DIR"
    git init
fi

# Exclude logs directory from Git tracking
git rm -r --cached "$LOG_DIR" 2>/dev/null  # Remove from cache if already tracked
echo "/scripts/logs/" >> "$SSH_DIR/.gitignore"  # Add to .gitignore

# Add all changes except logs
git add --all ":!scripts/logs/"

# Check if there are changes to commit
if ! git diff --cached --quiet; then
    COMMIT_MSG="Auto-commit SSH config on $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$COMMIT_MSG"

    # Get changed files excluding logs
    CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD | grep -v "^scripts/logs/")

    for FILE in $CHANGED_FILES; do
        # Exclude any file inside /scripts directory
        if [[ "$FILE" != scripts/* ]]; then
            LOG_FILE="$LOG_DIR/${FILE//\//_}.log"

            {
                echo "===================================================="
                echo "$COMMIT_MSG"
                echo "----------------------------------------------------"
                git log -1 --pretty=format:"%h | %an | %ad | %s" --date=local
                echo "----------------------------------------------------"
                echo "Modified File: $FILE"
                echo "----------------------------------------------------"
                git diff HEAD~1 -- "$FILE"  # Show changes
                echo ""
            } >> "$LOG_FILE"

            echo "Log created for $FILE: $LOG_FILE"
        fi
    done
else
    echo "No changes detected. Skipping commit."
fi

# Clean up logs older than 3 days
find "$LOG_DIR" -type f -name "*.log" -mtime +3 -exec rm -f {} \;

echo "Versioning script execution completed."
