# Git-Versioning-For-Linux
#To enable logs for the changes

Step 1: Install Git
	sudo yum install git –y
________________________________________
Step 2: Initialize a Git Repository in /etc/ssh
	cd /etc/ssh – Navigate to path /etc/ssh
	sudo git init – Initialize fit repository
________________________________________
Set up global user info (required by Git)
	sudo git config --global user.name "AutoGit"
	sudo git config --global user.email "autogit@localhost"

Is It Necessary?
🔹 Yes, if you plan to commit changes.
🔹 No, if you're only viewing or checking out files.
_______________________________________
Step 3: Add SSH Files to Version Control
1.	Add all SSH configuration files:
	sudo git add .
2.	Commit the initial version:
	sudo git commit -m "Initial SSH configuration backup"
________________________________________
Step 4: Automate Git Versioning with a Cron Job
Create a Git Auto-Commit Script
1.	Create a script to automatically track changes:
   nano versioning.sh
versioning.sh file is attached to this repo.
________________________________________

Step 5: Schedule the Script Using Cron (Optional)
To run the script every 30 minutes:
1.	Open the crontab editor:
	sudo crontab -e
2.	Add the following line at the bottom:
	*/30 * * * * /etc/ssh/script/versioning.sh
o	This will auto-commit changes every 30 minutes.


File change:
	sudo git log --follow --pretty=format:"%h | %an | %ad | %s" --date=local --name-status -- /etc/ssh
This will also include file status (A, M, D):
•	A → Added
•	M → Modified
•	D → Deleted
Note: Below command will work only at the directory where changes have been made.
To view versions of the file: 
	sudo git show 9315f09:sshd_config
1.	9315f09 is a Git commit hash (or a shortened version of it). Git uses SHA-1 hashes to identify commits uniquely.
2.	sshd_config is the file you are trying to view from that specific commit.
To restore previous version of the file: 
	sudo git checkout c9c07a5 -- sshd_config
To restore previous version for all:
	sudo git checkout c9c07a5 -- .



