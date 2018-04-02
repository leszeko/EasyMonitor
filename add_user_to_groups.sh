#!/bin/bash
# add_user_to_groups.sh script for Easy Monitor. Run with user LOGIN as parameter: su -c "bash add_user_to_groups.sh $you_user_login" ; OR ; sudo /bin/bash add_user_to_groups.sh $you_user_login

################# Variables for color terminal
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/Color_terminal_variables.sh"
Color_terminal_variables
#################

if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This script must be run with root privileges.$Reset$Nline"; exit 1; fi

you_user_login="$1"

if [ -z "$you_user_login" ]
then :
	echo "$Nline$Orange No parameter. Your have to give your user login sa parameter$Reset$Nline"; exit 1
else :
	echo -n "$Nline$Green Add$Magenta $you_user_login$Green to:$Cyan sudo,users,wheel - groups$Reset"
fi

user_mod=$(whereis -b usermod|awk '{print $2}')
add_user=$(whereis -b adduser|awk '{print $2}')

if [[ -x $user_mod ]]
then :	# If usermod command: usermod -a -G sudo,users,wheel $you_user_login
	echo "$Green by $user_mod command$Reset$Nline"
	$user_mod -a -G sudo $you_user_login; $user_mod -a -G users $you_user_login; $user_mod -a -G wheel $you_user_login
	echo "$Green Now your user$Magenta $you_user_login$Green belong to group:$Cyan $(groups $you_user_login)$Reset"
	
elif [[ -x $add_user ]]
then :	# If adduser command: adduser $you_user_login sudo,users,wheel
	echo "$Green by $add_user command$Reset$Nline"
	$add_user $you_user_login sudo; $add_user $you_user_login users; $add_user $you_user_login wheel
	echo "$Green Now your user$Magenta $you_user_login$Green belong to group:$Cyan $(groups $you_user_login)$Reset"
	
else :
	echo "$Red Can't find suitable command for add user $you_user_login to: sudo,users,wheel groups. Try do it manually$Reset$Nline"; exit 1
fi
echo "$Nline$Yellow* If your user $Magenta$you_user_login$Yellow has now been added$Cyan to any group$Yellow - Logout from desktop environments and$Orange$Blink login again$Reset$Nline"; exit 0