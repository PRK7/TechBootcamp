#!/usr/bin/bash
# Date: 24/02/2024
# This is script for user & group management in linux.
# Usage: bash user_mgmt.sh
# Author: Prateek Karkera & Bhikesh Khute

PASSWORD="jimjam"

authenticate() {
	local attempt=0
	while [ $attempt -lt 3 ]
	do
		read -sp "Enter password: " inputPassword
		if [ $inputPassword = $PASSWORD ]
		then 
			echo -e "\n---------------------------------------------"
			echo "Authentication Successful!"
			#echo "---------------------------------------------"
			return 0
		else
			echo "Incorrect password. Please try again."
			((attempt++))
		fi
	done
	echo "Too many incorrect attempts. Exiting..."
	exit 1
}

addUser() {
	read -p "Enter username to add: " username
	sudo useradd -m -e 2025-01-01 $username #Added Expiry date of account as well
	echo "User $username added successfully!"
	read -sp "Enter password for $username: " userpass
	echo $username:$userpass | sudo chpasswd
	echo "Password for $username added successfully!"
}

removeUser() {
	read -p "Enter username to remove: " username
	sudo userdel -r $username 2>/dev/null
	echo "User $username deleted successfully!"
}

addGroup() {
	read -p "Enter group name to add: " groupname
	sudo groupadd $groupname
	echo "Group $groupname added successfully!"
}

usertoGroup() {
	read -p "Enter the username: " username
	userexists=$(grep -w $username /etc/passwd)
	if [ -z "$userexists" ]
	then
		echo -e "User $username doesn't exist\nExiting ..."
		echo "---------------------------------------------"
	else
		echo "User $username exists"
		read -p "Enter the group in which $username needs to be added: " groupname
		sudo usermod -aG $groupname $username
		echo "$username successfully added to group $groupname"
	fi
}


main() {
	clear
	echo "Welcome!"

	authenticate || exit 1

	while true
	do
		echo "---------------------------------------------"
		echo "Please select an option: "
		echo "1. Add user"
		echo "2. Remove user"
		echo "3. Add a group"
		echo "4. Add user to a group"
		echo "5. Exit"
		read -p "Enter your choice: " choice

		case $choice in
			1) addUser;;
			2) removeUser;;
			3) addGroup;;
			4) usertoGroup;;
			5) echo "Exiting..";
				exit;;
			*) echo "Invalid choice. Please try again.";;
		esac
	done
}
main
