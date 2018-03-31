#!/bin/bash
# add_user_to_groups.sh script for Easy Monitor. Run with user LOGIN as parameter: su -c "bash add_user_to_groups.sh $you_user_login" ; OR ; sudo /bin/bash add_user_to_groups.sh $you_user_login

################## Variables for color terminal
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[00;34m'"" Magenta=""$'\033[00;35m'""
GREEN=""$'\033[01;32m'"" RED=""$'\033[01;31m'"" WHITE=""$'\033[01;37m'"" YELLOW=""$'\033[01;33m'"" CYAN=""$'\033[01;36m'"" BLUE=""$'\033[01;34m'"" MAGENTA=""$'\033[01;35m'""
n=""$'\n'"" Blink=""$'\033[5m'"" Back=""$'\b'"" Reset=""$'\033[0;0m'""; if [[ $TERM != *xterm* ]]; then SMOOTHBLUE=$BLUE;Orange=$Yellow;ORANGE=$YELLOW;Cream=$Magenta;CREAM=$MAGENTA;else
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[00;38;5;5344m'"";Orange=""$'\033[00;38;5;714m'""
SMOOTHBLUE=""$'\033[01;38;5;111m'"";CREAM=""$'\033[01;38;5;5344m'"";ORANGE=""$'\033[01;38;5;714m'"";fi
#################

if ! [ $(id -u) = 0 ]; then echo "$n$Orange This script must be run with root privileges.$Reset$n"; exit 1; fi

you_user_login="$1"

if [ -z "$you_user_login" ]
then :
	echo "$n$Orange No parameter. Your have to give your user login sa parameter$Reset$n"; exit 1
else :
	echo -n "$n$Green Add$Magenta $you_user_login$Green to:$Cyan sudo,users,wheel - groups$Reset"
fi

user_mod=$(whereis -b usermod|awk '{print $2}')
add_user=$(whereis -b adduser|awk '{print $2}')

if [[ -x $user_mod ]]
then :	# If usermod command: usermod -a -G sudo,users,wheel $you_user_login
	echo "$Green by $user_mod command$Reset$n"
	$user_mod -a -G sudo $you_user_login; $user_mod -a -G users $you_user_login; $user_mod -a -G wheel $you_user_login
	echo "$Green Now your user$Magenta $you_user_login$Green belong to group:$Cyan $(groups $you_user_login)$Reset"
	
elif [[ -x $add_user ]]
then :	# If adduser command: adduser $you_user_login sudo,users,wheel
	echo "$Green by $add_user command$Reset$n"
	$add_user $you_user_login sudo; $add_user $you_user_login users; $add_user $you_user_login wheel
	echo "$Green Now your user$Magenta $you_user_login$Green belong to group:$Cyan $(groups $you_user_login)$Reset"
	
else :
	echo "$Red Can't find suitable command for add user $you_user_login to: sudo,users,wheel groups. Try do it manually$Reset$n"; exit 1
fi
echo "$n$YELLOW* If your user $Magenta$you_user_login$YELLOW has now been added$Cyan to any group$YELLOW - Logout from desktop environments and$Orange$Blink login again$Reset$n"; exit 0