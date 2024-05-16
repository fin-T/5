#!/bin/bash

set -x

rootUser=$1
ip=$2
newUserName=$3
publicKey=$4
linuxKeyPath="./key.pem"

ssh -i $linuxKeyPath -T $1@$2 <<-EOF

if id $newUserName >/dev/null 2>&1; then
	echo "User $newUserName already exists"
else
	sudo adduser $newUserName
    	sudo passwd -d $username
	echo "User '$username' has been created with password '$password'"
	sudo usermod -aG sudo $newUserName
	echo "Sudo rights have been added"

	sudo -u $newUserName bash <<-NESTED_EOF
		mkdir -p ~/.ssh
		chmod 700 ~/.ssh
		if [ -f ~/.ssh/authorized_keys ]; then
			echo "File 'authorized_keys' already exists"
		else
			touch ~/.ssh/authorized_keys
			chmod 600 ~/.ssh/authorized_keys
			echo "$publicKey" >> ~/.ssh/authorized_keys
			echo "New file 'authorized_keys' has been created"
		fi

		if grep -qF "$publicKey" ~/.ssh/authorized_keys; then
			echo "Public key already in file 'authorized_keys'"
		else
			echo "$publicKey" >> ~/.ssh/authorized_keys
			echo "Public key has been added to the file 'authorized_keys'"
		fi
	NESTED_EOF
	# Creates a sudoers configuration file for new_user in the /etc/sudoers.d directory.
	sudo bash -c "echo '$newUserName ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$newUserName"

	# Sets the correct file permissions.
	sudo chmod 440 /etc/sudoers.d/$newUserName
fi
EOF

echo "Connecting to the server with new user"
ssh -i $linuxKeyPath $newUserName@$ip
