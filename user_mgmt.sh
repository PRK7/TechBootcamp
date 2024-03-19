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
	if sudo useradd -m -e 2025-01-01 -s /bin/bash $username #Added Expirydate and shell as bash
	then
		echo "User $username added successfully!"
	else
		echo "Failed to add user $username. Details: $?"
	fi
}

changeUserPassword() {
	echo "---------------------------------------------"
    	read -p "Enter username: " username
    	if sudo passwd $username
		then
    		echo "Password for $username changed successfully."
		else
			echo "Failed to change password for $username."
		fi
}

removeUser() {
	echo "---------------------------------------------"
	read -p "Enter username to remove: " username
	if sudo userdel -r $username 2>/dev/null
	then
		echo "User $username deleted successfully!"
	else
		echo "Failed to delete user $username."
	fi
}

listUsers() {
	echo "---------------------------------------------"
	echo "List of all users:"
	if grep -E 100[0-9] /etc/passwd | cut -d: -f1
	then
		return 0
	else
		echo "Failed to list users."
		return 1
	fi
}

downloadUserListCSV() {
    	echo "---------------------------------------------"
    	echo "Downloading list of users in CSV..."
    	if sudo cp /etc/passwd /tmp/passwd && \
   			echo "Username,User ID,Home Directory" > /home/$USER/listofusers.csv && \
    		sed 's/:/,/g' /tmp/passwd | grep -E 100[0-9] | cut -d, -f1,3,6 >> /home/$USER/listofusers.csv
    	then
			echo "User list downloaded to listofusers.csv"
		else
			echo "Failed to download user list."
		fi
}

modifyUserPermissions() {
	echo "---------------------------------------------"
	read -p "Enter username to modify permissions: " username
	read -p "Enter permission mode (e.g., 755, 700, 777): " permission_mode
	if sudo chmod -R $permission_mode /home/$username
	then
		echo "Permissions modified successfully for user $username."
	else
		echo "Failed to modify permissions for user $username."
	fi
}

addGroup() {
	echo "---------------------------------------------"
	read -p "Enter group name to add: " groupname
	if sudo groupadd $groupname
	then
		echo "Group $groupname added successfully!"
	else
		echo "Failed to add group $groupname."
	fi
}

removeGroup() {
	echo "---------------------------------------------"
	read -p "Enter group name to remove: " groupname
	if sudo groupdel $groupname
	then
		echo "Group $groupname deleted successfully!"
	else
		echo "Failed to delete group $groupname."
	fi
}

listGroups() {
	echo "---------------------------------------------"
	echo "List of all groups:"
	if grep -E 100[0-9] /etc/group | cut -d: -f1
	then
		return 0
	else
		echo "Failed to list groups."
		return 1
	fi
}

modifyGroupPermissions() {
	echo "---------------------------------------------"
	read -p "Enter group name to modify permissions: " groupname
	read -p "Enter permission mode (e.g., 755, 700, 777): " permission_mode
	if sudo chmod $permission_mode /home/$groupname
	then
		echo "Permissions modified successfully for group $groupname."
	else
		echo "Failed to modify permissions for group $groupname."
	fi
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
	if sudo deluser $username $groupname
	then
		echo "User $username removed from group $groupname successfully."
	else
		echo "Failed to remove $username from group $groupname."
	fi
}

checkUserGroups() {
	echo "---------------------------------------------"
	read -p "Enter username: " username
	echo "Groups for user $username:"
	if groups $username | cut -d: -f2
	then
		return 0
	else
		echo "Failed to retrieve groups for user $username."
		return 1
	fi
}

checkGroupUsers() {
	echo "---------------------------------------------"
	read -p "Enter group name: " groupname
	echo "Users in group $groupname:"
	if getent group $groupname | cut -d: -f4
	then
		return 0
	else
		echo "Failed to retrieve users in group $groupname."
		return 1
	fi
}

main
