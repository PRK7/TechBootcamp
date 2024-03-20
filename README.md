# User Management script for Linux

<p align="center">
      <img src="https://github.com/PRK7/TechBootcamp/assets/35907619/31201f0c-baf5-4b62-b9f8-f3baaa2b9d8d" />
</p>

## Steps for Implementation: 

1. If you have a fresh installation of linux, it is necessary to add password for root account as we will be removing default sudo access for every user . Using the following commands, you can set the root password.

      ```
     su -
      ```
   
      ```
      passwd root
      ```
    **Note - Don't share the root password with anyone.**
   
2. Create a folder using root account in the following path, if not exists, create a one:

      ```
      mkdir /usr/share/scripts
      ```
   
3. Clone the repository using the following command:
    
      ```
      git clone https://github.com/PRK7/TechBootcamp.git
      ```
   
4.  Make sure to modify the permissions once cloned:

      ```
      chmod -R 755 /usr/share/scripts
      ```
      <p align="center">
        <img src="https://github.com/PRK7/TechBootcamp/assets/35907619/18d20ffa-f0f2-4419-a188-fdc821635242" />
      </p>


6. Now open the sudoers file(make sure you are still logged in root account) using the following command:

      ```
      visudo
      ```

7. Comment the sudo line and add specific permissions for our groups:

      ```
      #%sudo  ALL=(ALL) NOPASSWD:ALL
      ```

      ```
      %hrg ALL=(ALL) NOPASSWD: /usr/sbin/useradd, /bin/cp, /usr/sbin/deluser, /usr/sbin/usermod, /bin/chmod, /etc/passwd,
      /usr/sbin/userdel, /usr/sbin/chpasswd, /usr/bin/passwd, /usr/sbin/groupadd, /usr/sbin/groupdel
      ```
   

      ```
       %opsg ALL=(ALL) NOPASSWD: /bin/sh, /etc/passwd, /bin/cp
      ```

8. Save the file.
   
9. Create a user/superuser and HR group using root account and add the user to the HR group.
      ```
       useradd -m -e 2025-01-01 -s /bin/bash theboss
      ```
      ```
       usermod -aG hrg theboss
      ```

10. Now login as HR user and implement user management hierarchy. 



