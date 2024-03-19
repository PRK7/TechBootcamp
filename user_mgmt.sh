#!/usr/bin/bash
# Date: 25/02/2024
# This is script for user & group management in linux.
# Usage: bash user_mgmt.sh
# Author: Prateek Karkera & Bhikesh Khute


PASSWORD="jimjam"

main() {
	clear
	echo "Welcome!"

	#authenticate || exit 1

	while true
	do
		echo "---------------------------------------------"
		echo "Please select an option: "
		echo "1. Add user"
		echo "2. Change User Password"
		echo "3. Remove user"
		echo "4. List all users"
		echo "5. Download list of users in CSV"
		echo "6. Modify user permissions"
		echo "7. Add a group"
		echo "8. Remove a group"
		echo "9. List all groups"
		echo "10. Modify group permissions"
		echo "11. Add user to a group"
		echo "12. Remove user from group"
		echo "13. Check which groups a user is in"
		echo "14. Check which users are in a particular group"
		echo "15. Exit"
		read -p "Enter your choice: " choice

		case $choice in
			1) addUser;;
			2) changeUserPassword;;
			3) removeUser;;
			4) listUsers;;
			5) downloadUserListCSV;;
			6) modifyUserPermissions;;
			7) addGroup;;
			8) removeGroup;;
			9) listGroups;;
			10) modifyGroupPermissions;;
			11) addUsertoGroup;;
			12) removeUserfromGroup;;
			13) checkUserGroups;;
			14) checkGroupUsers;;
			15) echo "Exiting..";
				exit;;
			*) echo "Invalid choice. Please try again.";;
		esac
	done
}

authenticate() {
	local attempt=0
	while [ $attempt -lt 3 ]
	do
		read -sp "Enter password: " inputPassword
		if [[ "$inputPassword" == "$PASSWORD" ]]
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
	echo "---------------------------------------------"
	read -p "Enter username to add: " username
	sudo useradd -m -e 2025-01-01 -s /bin/bash $username #Added Expirydate and shell as bash
	echo "User $username added successfully!"
}

changeUserPassword() {
	echo "---------------------------------------------"
    	read -p "Enter username: " username
    	read -p "Enter new password for $username: " new_password
    	sudo passwd $username
    	echo "Password for $username changed successfully."
}

removeUser() {
	echo "---------------------------------------------"
	read -p "Enter username to remove: " username
	sudo userdel -r $username 2>/dev/null
	echo "User $username deleted successfully!"
}

listUsers() {
	echo "---------------------------------------------"
	echo "List of all users:"
	grep -E 100[0-9] /etc/passwd | cut -d: -f1
}

downloadUserListCSV() {
    	echo "---------------------------------------------"
    	echo "Downloading list of users in CSV..."
    	sudo cp /etc/passwd /tmp/passwd
   	echo "Username,User ID,Home Directory" > /home/$USER/listofusers.csv
    	sed 's/:/,/g' /tmp/passwd | grep -E 100[0-9] | cut -d, -f1,3,6 >> /home/$USER/listofusers.csv
    	echo "User list downloaded to listofusers.csv"
}

modifyUserPermissions() {
	echo "---------------------------------------------"
	read -p "Enter username to modify permissions: " username
	read -p "Enter permission mode (e.g., 755, 700, 777): " permission_mode
	sudo chmod -R $permission_mode /home/$username
	echo "Permissions modified successfully for user $username."
}

addGroup() {
	echo "---------------------------------------------"
	read -p "Enter group name to add: " groupname
	sudo groupadd $groupname
	echo "Group $groupname added successfully!"
}

removeGroup() {
	echo "---------------------------------------------"
	read -p "Enter group name to remove: " groupname
	sudo groupdel $groupname
	echo "Group $groupname deleted successfully!"
}

listGroups() {
	echo "---------------------------------------------"
	echo "List of all groups:"
	grep -E 100[0-9] /etc/group | cut -d: -f1
}

modifyGroupPermissions() {
	echo "---------------------------------------------"
	read -p "Enter group name to modify permissions: " groupname
	read -p "Enter permission mode (e.g., 755, 700, 777): " permission_mode
	sudo chmod $permission_mode /home/$groupname
	echo "Permissions modified successfully for group $groupname."
}

addUsertoGroup() {
	echo "---------------------------------------------"
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

removeUserfromGroup() {
	echo "---------------------------------------------"
	read -p "Enter username: " username
	read -p "Enter group name: " groupname
	sudo deluser $username $groupname
	echo "User $username removed from group $groupname successfully."
}

checkUserGroups() {
	echo "---------------------------------------------"
	read -p "Enter username: " username
	echo "Groups for user $username:"
	groups $username | cut -d: -f2
}

checkGroupUsers() {
	echo "---------------------------------------------"
	read -p "Enter group name: " groupname
	echo "Users in group $groupname:"
	getent group $groupname | cut -d: -f4
}

main
