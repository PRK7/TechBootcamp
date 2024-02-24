#!/usr/bin/bash

PASSWORD="techBootcamp@1"

authenticate() {
	local attempt=0
	while [ $attempt -lt 3 ]
	do
		read -sp "Enter password: " inputPassword
		if [ $inputPassword = $PASSWORD ]
		then
			echo "Authentication Successful!"
			return 0
		else
			echo "Incorrect password. Please try again."
			((attempts++))
		fi
	done
	echo "Too many incorrect attempts. Exiting..."
	exit 1
}

addUser() {
	read -p "Enter username to add: " username
	sudo useradd -m $username
	echo "User $username added successfully!"
}

removeUser() {
	read -p "Enter username to remove: " username
	sudo userdel -r $username
	echo "User $username deleted successfully!"
}

addGroup() {
	read -p "Enter group name to add: " groupname
	sudo groupadd $groupname
	echo "Group $groupname added successfully!"
}

main() {
	clear
	echo "Welcome!"

	authenticate || exit 1

	while true
	do
		echo "Please select an option: "
		echo "1. Add user"
		echo "2. Remove user"
		echo "3. Add a group"
		echo "4. Exit"
		read -p "Enter your choice: " choice

		case $choice in
			1) addUser;;
			2) removeUser;;
			3) addGroup;;
			4) echo "Exiting..";
				exit;;
			*) echo "Invalid choice. Please try again.";;
		esac
	done
}

main
