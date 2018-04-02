#!/bin/bash
# new_create_boot_grub_disdk.image.sh V 1.5
# by Leszek Ostachowski® (©2017) @GPL V2

Begin () {
################# Variables for color terminal
Color_terminal_variables() {
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[01;34m'"" Magenta=""$'\033[00;35m'""
LGreen=""$'\033[01;32m'"" LRed=""$'\033[01;31m'"" LWhite=""$'\033[01;37m'"" LYellow=""$'\033[01;33m'"" LCyan=""$'\033[01;36m'"" LBlue=""$'\033[00;34m'"" LMagenta=""$'\033[01;35m'""
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[0;38;5;225m'"";Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[01;38;5;111m'"";LCream=""$'\033[1;38;5;225m'"";LOrange=""$'\033[1;38;5;202m'"";Blink=""$'\033[5m'""
if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
fi
Nline=""$'\n'"" Reset=""$'\033[0;0m'"" EraseR=""$'\033[K'"" Back=""$'\b'"" Creturn=""$'\033[\r'"" Ctabh=""$'\033[\t'"" Ctabv=""$'\033[\v'"" SaveP=""$'\033[s'"" RestoreP=""$'\033[u'""
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
}
Color_terminal_variables
#################

Get_Parameters
test_software
test_image_file
test_size
Create_file_for_disk
Setup_loop_device
Create_disk_and_partition
Create_filesystem
Mount_new_partiton
Copy_boot_folder
Install_Grub
End_message

}

Get_Parameters () {

disk_image="/mnt/disk.img"
system_device="/dev/loop1"
partition="p1"
Grub_map_device='(hd0)'
# ='(xxx)'; ='(hd0)'; or ='' for skipp create file /boot/grubdevice.map
comment=cat <<-EOF
# When you specify the option --device-map (see Basic usage),
the grub shell creates the device map file automatically unless it already exists.
The file name /boot/grub/device.map is preferred.
# https://www.gnu.org/software/grub/manual/legacy/Basic-usage.html#Basic-usage
# https://www.gnu.org/software/grub/manual/legacy/Device-map.html
# https://www.gnu.org/software/grub/manual/legacy/Device-syntax.html#Device-syntax
#
https://www.gnu.org/software/grub/manual/html_node/index.html#SEC_Contents
https://www.gnu.org/software/grub/manual/html_node/Installation.html#Installation
#
https://wiki.archlinux.org/index.php/GRUB_Legacy
EOF

max_part=10
mount_point="/mnt/test_partition"
file_system="ext4"
copy_boot_folder="ask"
#copy_boot_folder=""
# "ask" "yes" "no"
grub_version="ask"
#grub_version="no"
# "ask" "1" "2" "no"
size="AsK"
# size="Tsaa"
#size="200"
#size="200+1"
#size="+200"
# size="-200"
#size="200+0.5+0.5" # (MB)
# size="0.5+0.5+0.5" # (MB)
# size in MB or "ask"
MESSAGE=''

if ! [ $(id -u) = 0 ]
then :
	echo "$Nline$Orange This $Cyan$(basename "$0")$Orange script must be run with root privileges.$Reset$Nline"
	su -c "/bin/bash \"$0\" $*"
	/bin/bash
	exit $?
fi

echo "$Nline$Cyan This script can create a new {$size} MB hard disk image and install grub into this image,$Nline or setup the existing image for system in test purpose.$Reset"

}

 ### Program ###

veryfy_packages_list_names () { : ;}

function ping_gw () {
  COMMAND=$(command -v ping) && sudo $COMMAND -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2>&1 && return 0 || return 1
}

test_image_file () {

if [ -f "$disk_image" ]
then :
	echo -n "$Nline$Orange File:$SmoothBlue "$disk_image"$Orange exist,$LRed Delete and create new$Green or Mount it,"
	read -p "$Orange If you are SURE Please answer$LRed {D}$SmoothBlue or$Green {M} $Cream{*} exit$LRed$Blink ?:$Reset$Yellow *$MoveL" REPLY; echo -n "$Reset"
	if [ "$REPLY" = "D" ] || [ "$REPLY" = "d" ]
	then :
		echo "$Nline$Green ok, $LRed delete and create new"
		echo "$Nline$Green rm "$disk_image" $Reset"
		rm  "$disk_image"
		MESSAGE+="$Red $(( mn+=1 )). Delete "$disk_image" file $Reset"
		
	elif [ "$REPLY" = "M" ] || [ "$REPLY" = "m" ]
	then :
		size=$(ls -l "$disk_image" | awk '{print $5}')
		Setup_loop_device
		Mount_new_partiton
		End_message
		exit 0
	else :
		echo "$Nline$Orange ok, next time$Reset$Nline"
		/bin/bash; exit
	fi
fi

}

test_software () {

 ### Check software
IS_SOFTWARE=''
NO_SOFTWARE=''
ERROR_SOFTWARE=''

	if $(command -v grub2-install >/dev/null 2>&1) && $(command -v grub2-mkconfig >/dev/null 2>&1)
	then :
		command=$(command -v grub2-install 2>/dev/null)
		command_v=$($command --version 2>/dev/null)
		grub_boot_folder="/boot/grub2"                         #s=${x#*hello}; echo $s # =1hello2hello3
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $command:$Cyan ${command_v#*$command }, boot folder: $grub_boot_folder $Reset"
	elif $(command -v grub-install  >/dev/null 2>&1) && $(command -v grub-mkconfig >/dev/null 2>&1)
	then :
		command=$(command -v grub-install 2>/dev/null)
		command_v=$($command --version 2>/dev/null)
		grub_boot_folder="/boot/grub"
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $command:$Cyan ${command_v#*$command }, boot folder: $grub_boot_folder $Reset"
		
	else :
		
		NO_SOFTWARE+="$Nline$Red $(( cn+=1 )). no: can't find: grub, GRUB version at least 1.98 $Reset"
		packages_to_install+="grub-pc"" "
	fi
	
	command="grub"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		command_v=$($ok_command --version 2>/dev/null)
		grub_boot_folder="/boot/grub"
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan ${command_v#* }, boot folder: $grub_boot_folder $Reset"
		
	else :
		NO_SOFTWARE+="$Nline$Red $(( cn+=1 )). no: can't find: $command, GRUB version less than 1.98 $Reset"
		packages_to_install+="grub"" "
	fi
	
	command="bb"
	# BB is a high quality audio-visual demonstration for your text terminal. It is a portable demo, so you can run it on plenty of operating systems and DOS.
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		command_v=$($ok_command --version 2>/dev/null)
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan ${command_v#* }$Reset"
		
	else :
		NO_SOFTWARE+="$Nline$Red $(( cn+=1 )). no: can't find: $command $Reset"
		packages_to_install+="$command"" "
	fi
	
	command="qemu"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		NO_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command"" "
	fi
	
	command="dd"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command"" "
	fi
	
	command="losetup"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="fdisk"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="mkfs.${file_system}"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="awk"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="mount"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="df"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="df"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="$0"
	if ok_command=$(ls $command 2>/dev/null)
	then :
		IS_SOFTWARE+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Nline$Cyan
 by Leszek Ostachowski® (©2017) @GPL V2
 To jest wolne oprogramowanie: masz prawo je zmieniać i rozpowszechniać
 Autorzy nie dają ŻADNYCH GWARANCJI w granicach Nakazywanych jakimś prawem. $Reset"
	else :
		ERROR_SOFTWARE+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
	fi
	
	###
	if ! [ -z "$IS_SOFTWARE" ]
	then :
		echo "$Nline$LMagenta Checked software: program find the following commands: ${IS_SOFTWARE%%, }$Reset"
	fi
	
	if ! [ -z "$NO_SOFTWARE" ]
	then :
		echo "$Nline$LMagenta Missing software: can't find the following commands: ${NO_SOFTWARE%%, }$Reset"
		get_additinal_packages "${packages_to_install%% }"
		if ! [ $? = 0 ]
		then :
			echo "$LRed Error: install: ${pakages}. Try do it manually... $Reset"
		fi
	fi

	if ! [ -z "$ERROR_SOFTWARE" ]
	then :
			echo "$Nline$LMagenta Error - Missing software can't find the following commands: ${ERROR_SOFTWARE%%, }$Reset"
			echo "Exit"
			/bin/bash; exit
	fi
	###

}

get_additinal_packages () {
pakages=${1}
# Bash doesn't have dimensional/static/ arrays. But one dimension have mulit stage directions
# Z tablicami to jest tak, że zawsze czujesz się wywołany i trzeba się tłumaczyć

rn=0          manager=1          install=2               init=3                  comment=4 columns=5 distro=$columns c=$columns # space separator # row name rx colum name cx
managers=(
"AY$(( rcn=0 ))" "c$(( cn=1  ))"	 "c$(( cn+=1  ))"	 "c$(( cn+=1  ))"	 "c$(( cn+=1  ))"
"r$(( rn+=1 ))" "zypper"	 "zypper install -R"	 ""			 "# /usr/bin/zypper 	: su -c zypper install -R ... 			# OpenSuse"
"r$(( rn+=1 ))" "apt-get"	 "apt-get install -y"	 "apt-get update"	 "# /usr/bin/apt-get 	: su -c apt-get update; apt-get install ... 	# Ubuntu"
"r$(( rn+=1 ))" "urpmi"		 "urpmi"		 "urpmi --auto-select"	 "# /usr/sbin/urpmi 	: su -c urpmi --auto-select; urpmi ... 		# Mandriva"
"r$(( rn+=1 ))" "pacman"	 "pacman -Su --needed"	 "pacman -Syu"		 "# /usr/bin/pacman 	: su -c pacman -Syu; pacman -Su --needed ... 	# Arch"
"r$(( rn+=1 ))" "yum"		 "yum install"		 ""			 "# /usr/bin/yum 	: su -c yum install ... 			# Fedora"
"r$(( rn+=1 ))" "equo"		 "equo install --ask"	 "equo up" 		 "# /usr/bin/equo 	: su -c equo up; equo install --ask ... 	# Sabayon"
"r$(( rn+=1 ))" "eopkg"		 "eopkg install -g"	 "eopkg upgrade"	 "# /usr/bin/eopkg 	: su -c eopkg upgrade; eopkg install -g ... 	# Solus"
"r$(( rn+=1 ))" "netpkg"	 "netpkg"		 ""			 "# /usr/sbin/netpkg 	: su -c netpkg ... 				# Slakware"
"r$(( rn+=1 ))" "slackpkg"	 "slackpkg install"	 "slackpkg update"	 "# /usr/sbin/slackpkg 	: su -c slackpkg update; slackpkg install ... 	# Slakware"
"r$(( rn+=1 ))" "slapt-get"	 "slapt-get --install"	 "slapt-get -u"		 "# /usr/sbin/slapt-get : su -c slapt-get -u; slapt-get --install ... 	# Vector"
"r$(( rn+=1 ))" "xbps-install"	 "xbps-install"		 "xbps-install -S"	 "# /usr/bin/xbps-install : su -c xbps-install -S; xbps-install ... 	# VOID"
"r$(( rn+=1 ))" "wget"		 "wget -O"		 "check_arch_type"	 "# wget -O 		: su -c wget -O ...				# XXX"
"r$(( rn+=1 ))" "With tables"	 "it is so With tables"	 "that you always feel called up"		" # and have to explain ...			# aaa"
)


# let command_meneger_x=manager_x*distro+manager ; echo "${managers[command_meneger_x]}" ${managers[command_meneger_x+insyall]}
list_menagers () {
for (( manager_x=1; manager_x<=${rn};manager_x++ ))
do :
	if ! [[ -z "${managers[manager_x*distro+manager]}" ]]
	then :
		if ok_command=$(command -v "${managers[manager_x*distro+manager]}" 2>/dev/null)
		then :
		echo "$Nline$Green Program find package menager:$Red su -c \""$(dirname $ok_command)/${managers[manager_x*distro+install]} ${pakages}"\" $Reset"
		is_menager+=(
		"menager $(( ln+=1 ))" "$ok_command" "${managers[manager_x*distro+install]}" "${managers[manager_x*distro+init]}" "${managers[manager_x*distro+comment]}$Nline"
		)
		fi
	fi
done
}
list_menagers
	echo
	echo "fields = ${#is_menager[*]} records = $ln positions = $columns"
	echo ""
	echo " ${is_menager[@]}"
	echo

if [[ ($ln > 1) ]]
then : # select

	for (( list_x=0; list_x<=${#is_menager[*]};list_x+=$columns ))
	do :
		if ! [[ -z "${is_menager[$list_x]}" ]]
		then :
			options[$list_x]=${is_menager[$list_x+manager]}
		else :
			break
		fi
	done
	
	keys=("1""2""3""4") options=(${options[@]}) default=1 time_out=30
	ask_info="$Cyan You was found for you more than one coach, then now you have to choose Which one,$Reset"
		ask_select
	echo "$Nline$Green Selected = $Cyan$Selected$Reset$Nline"
	
	for (( list_x=0; list_x<=${#is_menager[*]};list_x+=$columns ))
	do :
		if ! [[ $Selected = ${is_menager[$list_x+manager]} ]]
		then :
			is_menager[$list_x+manager]=''
		fi
	done
	
else :
fi

ping_gw # && echo "Online" ||  echo "Offline"
	if [ $? -eq 0 ]
	then :
		echo "$Nline$Cyan Ok internet connection go On line$Reset"
	elif ! [ $? -eq 0 ]
	then :
		echo "$Nline$Red No internet connection go$Blink Off line$Reset"
	else :
		
	fi

for (( manager_x=0; manager_x<=${ln};manager_x++ ))
do :
	if ! [[ -z "${is_menager[manager_x*distro+manager]}" ]]
	then :
		if ok_command=$(command -v "${is_menager[manager_x*distro+manager]}" 2>/dev/null)
		then :
			echo "$Nline$Green Now you are going to install additinal tools ;) for it:$Red su -c \""$(dirname $ok_command)/${is_menager[manager_x*distro+install]} ${pakages}"\" $Reset"
			### If you want different scenario for specific manager
			if [[ "$(tr '[A-Z]' '[a-z]' <<<"${is_menager[manager_x*distro+manager]}")" = "zypper" ]]
			then :
				echo "$Nline$Green # su -c zypper install -R ... $Reset$Nline"
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				su -c "echo; \$(dirname $ok_command)/${is_menager[manager_x*distro+install]} ${pakages}; echo"
				# check && turn 0
				return 0
			elif [[ "$(tr '[A-Z]' '[a-z]' <<<"${is_menager[manager_x*distro+manager]}")" = "apt-get" ]]
			then :
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				echo "$Nline$Green # /sbin/apt-get : su -c apt-get update; apt-get install ... $Reset$Nline"
				su -c "apt-get update; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; apt-get install -y \$package; done"
				# check && turn 0
				return 0
			elif [[ "$(tr '[A-Z]' '[a-z]' <<<"${is_menager[manager_x*distro+manager]}")" = "wget" ]]
			then :
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				echo "$LRed Try do it manually by wget."
				# wget .... && turn 0
				break
			
			### Standar scenario for managers
			elif ! [[ "$(tr '[A-Z]' '[a-z]' <<<"${is_menager[manager_x*distro+manager]}")" = '' ]]
			then :
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				echo "$Nline$Green # su -c \"${is_menager[manager_x*distro+init]} 2>/dev/null ||:; for package in $Cream${pakages}$Green; do echo ${Red}\$package${Reset}; ${is_menager[manager_x*distro+install]} \$package... $Reset$Nline"
				su -c "${is_menager[manager_x*distro+init]} 2>/dev/null ||:; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; ${is_menager[manager_x*distro+install]} \$package; done"
				# check &&
				return 0
			fi
		fi
	fi
done
echo "$LRed Can't find suitable software manager for download and install additinal packages. Try do it manually.."
return 1
# FIXME
}

test_integer () {

	number=${1}
	test_integer=^[0-9]+$; test_float='^[0-9]+([.][0-9]+)?$'
	test_positive_integer=^[+]?[0-9]+$; test_positive_float='^[+]?[0-9]+([.][0-9]+)?$'
	test_negative_integer=^[-]?[0-9]+$; test_negative_float='^[-]?[0-9]+([.][0-9]+)?$'
	
	comment=cat <<-EOF
	If the value is not necessarily an integer, consider amending the regex appropriately; for instance:
	^[0-9]+([.][0-9]+)?$
	...or, to handle negative numbers:
	^-?[0-9]+$
	^-?[0-9]+([.][0-9]+)?$
	However, it does not handle positive numbers with the + prefix, but it can easily be fixed as below:
	[[ $var =~ ^[-+]?[0-9]+$ ]]
	
	function isInteger() {
	  [[ ${1} == ?(-)+([0-9]) ]]
	}

	function isFloat() {
	[[ ${1} == ?(-)@(+([0-9]).*([0-9])|*([0-9]).+([0-9]))?(E?(-|+)+([0-9])) ]]
	}

	EOF
	
	
	if [[ ${number} =~ $test_integer ]]
	then :
		RETURN="integer"
		return 0
	elif [[ ${number} =~ $test_positive_integer ]]
	then :
		RETURN="positive integer"
		return 0
	elif [[ ${number} =~ $test_negative_integer ]]
	then :
		RETURN="negative integer"
		return 0
	elif [[ ${number} =~ $test_float ]]
	then :
		RETURN="float"
		return 0
	elif [[ ${number} =~ $test_positive_float ]]
	then :
		RETURN="positive float"
		return 0
	elif [[ ${number} =~ $test_negative_float ]]
	then :
		RETURN="negative float"
		return 0
	else :
		RETURN=${number}
		return 1
	fi

}

find_reala_boot_path () {

	if ! [ -d "$install_folder_x" ]
	then :
		echo "$Red Error: install folder $install_folder_x do not exist, exit 1$Reset$Nline"
		/bin/bash; exit 1
	fi
	
	mount_path_x=$( df --output=target "$install_folder_x" | grep '/' )
	if [[ "$mount_path_x" = '/' ]]
	then real_dev_path_X="$install_folder_x"
	else real_dev_path_X=${install_folder_x#$mount_path_x}
	fi
	isofile="${real_dev_path_X}"/"${file_name_x}"
	distro_dir=${real_dev_path_X#*\/}
	dev_name=$(df $install_folder_x | grep /dev/)
	dev_name=${dev_name%%\ *}
	dev_uuid=$(blkid $dev_name -s UUID)
	dev_uuid=${dev_uuid#*\ }
	uuid=${dev_uuid#*\"}
	uuid=${uuid%\"*}
	dev_file_system_type=$(blkid $dev_name -s TYPE)
	dev_file_system_type=${dev_file_system_type#*\ }
	dev_file_system_type=${dev_file_system_type#*\"}
	dev_file_system_type=${dev_file_system_type%\"*}
	
comment=cat <<-EOF
x=hello1hello2hello3
#                  ^
                   s=${x##*hello}; echo $s # =3
#      ^
       s=${x#*hello}; echo $s # =1hello2hello3

x=hello1hello2hello3
#             ^
              s=${x%hello*}; echo $s # =hello1hello2
#       ^
        s=${x%%hello2*}; echo $s # =hello1
EOF
}

check_free_space () {

	local  unit=${1} path=${2} wrong_parameter=''

	[[ -z ${unit} ]] && unit="KB"
	[[ -z ${path} ]] && path="."
	! [[ -d ${path} ]] &&  echo "$Red Wrong parameter path: „${path}” - Usage: unit - [ B | KB | MB | GB ] [ PATH ]$Reset" && return 1
	if [[ ${unit} = "B" ]]
	then :
		count='*1024'
		
	elif [[ ${unit} = "KB" ]]
	then :
		count=''
	elif [[ ${unit} = "MB" ]]
	then :
		count='/=1024'
	elif [[ ${unit} = "GB" ]]
	then :
		count='/(1024^2)'
	else :
		wrong_parameter=${unit}
		unit="KB"
		count=''
	fi
	
	#df -Pk ${path} | awk 'NR==2 {print $4}'|awk '{$1=$1'$count'; print $1"\n'$unit'\n'$path'"}'
	df -Pk "${path}" | awk 'NR==2 {print $4}' | awk '{result = $1'${count}'; printf "%.1f '${unit}'\n",result}'
	# |awk '{$1/=1024;printf "%.2fMB\n",$1}'
	! [[ -z ${wrong_parameter} ]] && echo "$Red Wrong parameter unit: „${wrong_parameter}” - Usage: unit - [ B | KB | MB | GB ] [ PATH ]$Reset" && return 1
	return 0
}

ask_select () {

	#...# add Quit nad Enter to menu
	local x= loop_time_out= again= rest= select_list=("${options[@]}")
	! [[ -z ${add_options[@]} ]] && select_list+=(${add_options[@]})
	select_list+=("{N}one" "{E}nter")
	
	
	for (( x=$(( ${#select_list[@]}+7 )); x>0; x--))
	do
	 echo "$EraseR"
	done
	Linesup $(( ${#select_list[@]}+7 ))
	
	echo "$ask_info"
	
	# Time out loop
	{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
	while true
	do
	
	loop_time_out=$[$loop_time_out-1]
	
	echo "$Reset$SaveP$EraseR"
	echo -n "$EraseR$Magenta Select and Press:$Green $(( ${#select_list[@]} )) ${select_list[$@-1]} akcept,$Yellow $(( ${#select_list[@]}-1 )) ${select_list[$@-2]}$Reset"
	! [[ -z ${add_options[@]} ]] && echo -n " -$Red $(( ${#select_list[@]}-2 )) ${add_options[$@-1]},$White $(( ${#select_list[@]}-3 )) ${add_options[$@-2]}$Reset"
	echo "$Nline$EraseR"
	# Print menu loop
	for (( x=$(( ${#options[@]} )); x>0; x--))
	do
	
	if [ "$[default]" = "$x" ]; then  echo -n "$Green"; echo -n ""$'\E[6n'""; read -sdR -t 000.1 CURPOS; CURPOS=${CURPOS#*[}; Charsbk 9; fi
	printf "%-4s %s\n" "$x)" "${select_list[$x-1]}$Reset$EraseR"
	
	done
	
	# Read key and print time out
	# IFS= Separator
	IFS= read -p "$EraseR$Nline$EraseR$Orange Preselected:$Green ${select_list[$default-1]%%:*},$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink ?: " -s -N 1 -t 1 key; echo -n "$Reset"
	# \x1b is the start of an escape sequence
	if [ "$key" == $'\x1b' ]; then
	# Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
	IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
	IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
	fi
	
	 echo -n "$EraseR$Nline$EraseR Starting in $loop_time_out seconds... "; # echo -n "${CURPOS}"
	
	Debug () {
	echo -n "$Nline$Nline/${#key}/HEX=$EraseR" >&2
	echo "$key" | hexdump -v -e '"x" 1/1 "%02x" " "' >&2
	echo "$Nline$EraseR$Nline$EraseR$Nline$EraseR$MoveU/Key=/\"$key\"/" >&2
	}
	# Debug
	
	
	# case nuber keys
	case "$key" in
		[1-9] )
		
		if [ 9 -gt $(( ${#select_list[@]}-1 )) ]
		then :
			if ! [ "$key" -gt $(( ${#select_list[@]}-1 )) ]
			then :
				default=$key; loop_time_out=$time_out
			fi
		else :
			IFS= read -r -N 1 -t 1.5 -s rest; key+="$rest"
			if ! [ "$key" -gt $(( ${#select_list[@]}-1 )) ]
			then :
				default=$key; loop_time_out=$time_out
			fi
		fi
		
		;;
	esac
	
	# case arrow keys
	if [ "$key" == $'\x1b[A' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#options[@]} )) ]; then default=1; fi; fi # Up
	if [ "$key" == $'\x1b[C' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi; fi # Right
	
	if [ "$key" == $'\x1b[B' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#options[@]} )); fi; fi # Down
	if [ "$key" == $'\x1b[D' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#select_list[@]}-1 )); fi; fi # Left
	
	# case chars keys
	case $(echo $key | tr '[A-Z]' '[a-z]') in [${keys[@]}] ) for (( x=0; x<${#keys}; x++)) do if [ "${keys:x:1}" = "$(echo $key | tr '[A-Z]' '[a-z]')" ]; then default=$[$x+1]; fi; done; loop_time_out=$time_out ;; esac
	
	# case Esc, Quit, Enter, time out
	if  [ "$key" == $'\x1b' ]; then read -s -N 1 -t 1 key; fi # twice Esc
	if  [ "$key" == $'\x1b' ] || [ "$key" = "$(( ${#select_list[@]}-1 ))" ] || [ "$key" = $'Quit' ] || [ "$key" = $'n' ] || [ "$key" = $'N' ]; then default=$(( ${#select_list[@]}-1 )); break
	elif [ "$key" == $'\x0a' ] || [ "$key" = "$(( ${#select_list[@]} ))" ] || [ "$key" = $'Enter' ] || [ "$key" = $'e' ] || [ "$key" = $'E' ]; then break
	elif [ "$loop_time_out" = 0 ] ; then break
	fi
	echo -n "$RestoreP"
	done
	
	# calculate result
	Selected="${select_list[default-1]}"
	# echo "$Nline Akcepted: $Selected"
	# echo " Pos: $default"
	unset time_out

}


ask_nuber () {

	echo "$EraseR";echo "$EraseR";echo "$EraseR";Linesup 3
	echo -n "$SaveP"
	
	try=("..." ".." "${Blink}!" "rabbit")
	try_length=${#try[@]}
	for again in ${try[@]}
	do :
		read -p "$Nline$Orange$EraseR Give size in MB for file contain a disk image,$SmoothBlue MB$LRed$Blink ?:$Reset$Yellow " size; echo -n "$Reset"
		
		size=$(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" <<<${size}|tr -d '[:blank:][:space:][:cntrl:]')
		
		# integer calculate { let result=${size} >/dev/null 2>&1 && size=${result} ;}|| float calculate using awk
		if ! [[ ${size} =~ [0-9]+$ ]]
		then :
			{ let result=${size} >/dev/null 2>&1 && size=${result} ;}
		else :
			{ result=$(awk '{result = '$size'; print result}' <<<${_ping} 2>/dev/null ) && [ ! -z ${result} ] && size=${result} ;}
		fi
		
		
		if test_integer $size
		then :
			if [[ "$RETURN" = "integer" ]] || [[ "$RETURN" = "positive integer" ]]
			then :
				echo "$EraseR";Linesup 1;echo -n "$Magenta Your answer is $SmoothBlue„${size}”$Cream What seems to be $Green„$RETURN” value$Cream for logic of this prcedure $Reset"
				break
			fi
		fi
		
		if [ "$again" = "${try[${#try[@]}-1]}" ]
		then :
			echo "$Nline$LRed$EraseR Erorr: $again, exit 1 $Nline$Reset"
			exit 1
		fi
		
		echo "$Red$EraseR Error: size:$Cyan „${size}”$Yellow is $Orange„${RETURN}”$Red What seems for logic of this prcedure to be not a valid positive integer number,$Green try again $Yellow$again$Red "${try[${#try[@]}-1]}" $Reset"
		echo -n "$RestoreP"
	done

}

test_size () {

# integer calculate || float calculate using awk
size=$(tr -d "[:blank:][:cntrl:][:space:]" <<<${size})
	#echo ${size}
if ! [[ ${size} =~ [0-9]+$ ]]
then :
		{ let result=${size} >/dev/null 2>&1 && size=${result} ;}
		#echo ${size}
else :
		{ result=$(awk '{result = '$size'; print result}' <<<${_ping} 2>/dev/null ) && [ ! -z ${result} ] && size=${result} ;}
		#echo ${size}
fi

test_integer "$size"
if ! [ $? = 0 ]
then : # ! [ $? = 0 ] is not number
	
	if [[ "$(tr '[A-Z]' '[a-z]' <<<${size})" = "ask" ]]
	then : # "$size" is valid ask sting
		free_space=$(check_free_space "GB" $(dirname "$disk_image"))
		echo -n "$Nline You have $Green$free_space$Cyan free space left on $SmoothBlue(dirname "$disk_image")$Yellow for create image $Reset"
		ask_nuber
	else :
		echo -n "$Nline$Red Error: size:$Cyan „${size}”$Yellow is $Orange„${RETURN}”"
		echo "$Red What seems for logic of this prcedure to be not a valid positive integer number, exit 1 $Reset"
		exit 1
	fi
else
	if ! { [[ "$RETURN" == "integer" ]] || [[ "$RETURN" == "positive integer" ]] ;}
	then :
		echo -n "$Nline$Red Error: size:$Cyan „${size}”$Yellow is $Orange„${RETURN}”"
		echo "$Red What seems for logic of this prcedure to be not a valid positive integer number, exit 1 $Reset"
		exit 1
	fi
fi

}

check_existing_path () {

	local existing_path=${1}
	
	while ! [ -d "${existing_path}" ]
	do :
		existing_path="${existing_path%/*}"
		if [[ -z "${existing_path}" ]]
		then :
			existing_path="/"
			break
		fi
	done
	echo "${existing_path}"

}

check_arch_type () {
arch_type=$(uname -m)
	if [[ "${arch_type}" = *"64"* ]] && [[ ! "${arch_type}" = *"IA-64"* ]]
	then :
		arch_type="amd64"
	else :
		arch_type="i386"
	fi
}


Create_file_for_disk () {

sector=512 # bytes per sector
size=$[$size*1048576] # 1024 × 1024 = 1048576 bytes=1MB
sectors=$[$size/$sector]  # 512 bytes per sector
# https://en.wikipedia.org/wiki/Cylinder-head-sector

 ### The image will behave similarly to a dynamic disk that you see in VM products; space is only taken up on disk when you write to it.
echo "$Nline$Green Create new disk image file - if=/dev/zero of="$disk_image" bs=$sector count=1 seek=$sectors $Reset"

dd if=/dev/zero of="$disk_image" bs=$sector count=1 seek=$sectors
if ! [ $? = 0 ]
then :
		echo "$Nline$Red Error: create new disk image - if=/dev/zero of="$disk_image" bs=$sector count=1 seek=$sectors, exit $Reset"
		/bin/bash; exit
else :
		echo "$Green ok $Reset"
		echo "$Nline$Green chmod 666 $disk_image $Reset"
		chmod 666 $disk_image
		MESSAGE+="$Nline$Green $(( mn+=1 )). Create new $[$size/1048576]MB "$disk_image" file - dd if=/dev/zero of="$disk_image" bs=$sector count=1 seek=$sectors $Reset"
fi

}

Umount_loop () {

if [ -b "$system_device$partition" ]
then :
	umount "$system_device$partition" >/dev/null 2>&1
	losetup -d "$system_device$partition" >/dev/null 2>&1
fi

if [ -b "$system_device" ]
then :
	umount "$system_device" >/dev/null 2>&1
	losetup -d "$system_device" >/dev/null 2>&1
fi

}

Setup_loop_device () {

  # Setup loop device with paririons suport and mount image file as $system_device for stsyem

if [ -b "$system_device" ]
then :
	Umount_loop
fi

echo "$Nline$Green Activate paririons suport for loop devices - modprobe loop max_part=$max_part : $Reset"
modprobe loop max_part=$max_part # activate paririons suport
if ! [ $? = 0 ]
then :
	echo "$Nline$Red Error: modprobe loop max_part=$max_part, exit $Reset"
	/bin/bash; exit
else :
	echo "$Green ok $Reset"
	MESSAGE+="$Nline$Green $(( mn+=1 )). Activate paririons suport for loop devices - modprobe loop max_part=$max_part $Reset"
	sleep 4
fi

echo "$Nline$Green Setup image - losetup "$system_device" --sizelimit $size "$disk_image" : $Reset"
losetup "$system_device" --sizelimit $size "$disk_image"
if ! [ $? = 0 ]
then :
	echo "$Nline$Red Error: losetup "$system_device" --sizelimit $size "$disk_image", exit $Reset"
	/bin/bash; exit
else :
	echo "$Green ok $Reset"
	MESSAGE+="$Nline$Green $(( mn+=1 )). Setup image - losetup "$system_device" --sizelimit $size "$disk_image" $Reset"
	chmod 666 "$system_device"
	sleep 4
fi

}

function r_ask () # v1.1 by Leszek Ostachowski® (©2017) @GPL V2
{
	local info=$1 default=$2 r_key=$3 select1=$4 select2=$5 color_s=$6 color_n=$7 again=$8 select_11 select_22
	[[ "$default" == '' ]] && default="2"; [[ ! "$default" == "1" ]] && default="2"
	[[ "$r_key" == "r_key" ]] && r_key='-N1' || r_key='-e'
	[[ "$select1" == '' ]] && select1="{Y}es"  ; u_select1=$(tr '[:upper:]' '[:lower:]' <<<"$select1") select_1=$(tr -d '{}' <<<"$select1") key1=${u_select1##*'{'} key1=${key1%'}'*}
	[[ "$select2" == '' ]] && select2="{N}o"   ; u_select2=$(tr '[:upper:]' '[:lower:]' <<<"$select2") select_2=$(tr -d '{}' <<<"$select2") key2=${u_select2##*'{'} key2=${key2%'}'*}
	[[ "$color_s" == '' ]] && color_s="${Green}*"
	[[ "$color_n" == '' ]] && color_n="${Red}"
	[[ "$again" == '' ]] && again="10"
	# echo -n "$default $r_key" >&2
	# print menu
	# clear one line more. If cursor is at the bottom then can scroll
	# and change line with combinations different options for read and enter.
	echo "$info" >&2
	echo "$EraseR" >&2
	Linesup "2" >&2
	echo -n "$info"| tail -1 >&2
	
	while true # & read
	do
	! [[  "$default" == '2' ]] && { echo -n "$SaveP$EraseR$Green"$select1" $SmoothBlue"or"$Red "$select2" $Orange$Blink"?:"" >&2 ;}
	[[ "$default" == '2' ]] && { echo -n "$SaveP$EraseR$Red"$select1" $SmoothBlue"or"$Green "$select2" $Orange$Blink"?:"" >&2 ;}
	IFS= read -r -t 000.1 -s clearbuffer
	echo -n "$Yellow*$Reset$EraseR$MoveL$Yellow" >&2
	read "$r_key"
	# calculate result
	[[ "$REPLY" == $'\x1b\x1b' ]] \
	&& { # twice Esc
		echo -n "$RestoreP$EraseR$Yellow exit!$Reset$Nline" >&2
		/bin/bash; exit 1
	   }
	[[ "$REPLY" == $'\x1b'   ]] && { read -s -N 1 key ;} # Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
	[[ "$key" == $'\x1b'   ]] \
	&& { # twice Esc
		echo -n "$RestoreP$EraseR$Yellow exit!$Reset$Nline" >&2
		/bin/bash; exit
	   }
	select_11=$(tr '[:upper:]' '[:lower:]' <<<$select_1) select_22=$(tr '[:upper:]' '[:lower:]' <<<$select_2)
	REPLY=$(tr '[:upper:]' '[:lower:]' <<<$REPLY)
	case $REPLY in
		$key1|$select_11)
				echo -n "$RestoreP$EraseR$Yellow$select_1$Reset" >&2; echo -n "$select_11"
				break
		;;
		$key2|$select_22)
				echo -n "$RestoreP$EraseR$Yellow$select_2$Reset" >&2; echo -n "$select_22"
				break
		;;
		*) # To fix return somefing difrent than "*" - "*yes" "*no" none
			[[ "$r_key" == "" ]] \
			&&
			 {	[[ "$REPLY" == "$select_11" ]] || [[ "$REPLY" == "$key1" ]] && echo -n "$RestoreP$EraseR$Yellow*$select_1$Reset" >&2 && echo -n "$select_11" && break
				[[ "$REPLY" == "$select_22" ]] || [[ "$REPLY" == "$key2" ]] && echo -n "$RestoreP$EraseR$Yellow*$select_2$Reset" >&2 && echo -n "$select_22" && break
				
			 }
			again=$[$again-1]
			echo -n "$RestoreP$Yellow Type - $u_select1 or $u_select2$Red | Again:$again" >&2
			IFS= read -r -s -t 1 sleep1
			echo -n "$RestoreP$EraseR" >&2
			if [[ "$again" = "0" ]]
			then :
				[[  "$default" == '1' ]] && { echo -n "$Red Error: ???, exit 1$Reset" >&2; echo -n "$select_11"; exit 1 ;}
				[[  "$default" == '2' ]] && { echo -n "$Red Error: ???, exit 1$Reset" >&2; echo -n "$select_22"; exit 1 ;}
			fi
		;;
	esac
	done
}

Create_disk_and_partition () {

# Paterns [[ $string == *"My long"* ]];[[ $string =~ "My s" ]]
if [[ "$system_device" = *"/dev/sda"* ]] || [[ "$system_device" = *"/dev/sdb"* ]]
then :
	echo "$Red You porably give one of your system data device $Blink$LRed> "$system_device" <$Red to write new partiton table. Are you$LOrange *really* sure? $Reset"
fi

echo -n "$Nline$Red Write new partiton table to device $LRed> "$system_device" <$Orange, Please answer $Green*[Y]es or $Red[n]o"
read -p "$LRed$Blink ?:$Reset$Yellow *$MoveL" REPLY; echo -n "$Reset";REPLY=$(tr '[A-Z]' '[a-z]' <<<"$REPLY")

if [[ "$REPLY" = "n" ]] || [[ "$REPLY" = "no" ]]
then :
	echo "$Nline$Orange Skipped write new partiton table to device $LRed> "$system_device" <$Orange, exit $Reset"
	/bin/bash; exit
fi

echo -n "$Nline$Red Write to device $LRed> "$system_device" <$LBlue Are you$LOrange *really$Orange sure? $Red[y]es or $Green*[N]o"
read -p "$LRed$Blink ?:$Reset$Yellow *$MoveL" REPLY; echo -n "$Reset";REPLY=$(tr '[A-Z]' '[a-z]' <<<"$REPLY")

if ! { [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "yes" ]] ;}
then :
	echo "$Nline$Orange Skipped write new partiton table to device $LRed> "$system_device" <$Orange, exit $Reset"
	/bin/bash; exit
fi

  # Create partition useing nointeractive script trick on fdisk

echo "$Nline$Green Create partition useing nointeractive script trick on fdisk - echo -e 'o\n n\n p\n1\n \n\n a\n p\n w\n'|fdisk "$system_device" : $Reset"
echo -e 'o\n n\n p\n1\n \n\n a\n p\n w\n'|fdisk "$system_device"
if ! [ $? = 0 ]
then :
	echo "$Nline$Red Error: echo -e 'o\n n\n p\n1\n \n\n a\n p\n w\n'|fdisk "$system_device", exit $Reset"
	/bin/bash; exit
else :
	echo "$Green ok $Reset"
	MESSAGE+="$Nline$Green $(( mn+=1 )). Create prtition table with partition $partition by fdisk $Reset"
	
fi

}

Create_filesystem () {

echo "$Nline$Green Create file system - mkfs.$file_system "$system_device$partition" : $Reset"
if ! [ -b "$system_device$partition" ]
then :
	echo "$Nline$Red Error: device: "$system_device$partition" is not block device, exit $Reset"
	/bin/bash; exit
else :
	mkfs.$file_system "$system_device$partition"
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: mkfs.$file_system "$system_device$partition", exit $Reset"
		/bin/bash; exit
	else :
		echo "$Green ok $Reset"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Format "$system_device$partition" - mkfs.$file_system "$system_device$partition" $Reset"
	fi
fi

}

Mount_new_partiton () {

mkdir -p "$mount_point"
if ! [ $? = 0 ]
then :
	echo "$Nline$Red Error: create mount point: mkdir -p "$mount_point", exit $Reset"
	/bin/bash; exit
fi
echo "$Nline$Green mount "$system_device$partition" "$mount_point" : $Reset"
mount "$system_device$partition" "$mount_point"
if ! [ $? = 0 ]
then :
	echo "$Nline$Red Error: mount "$system_device$partition" "$mount_point", exit $Reset"
	/bin/bash; exit
else :
	echo "$Green ok $Reset"
	MESSAGE+="$Nline$Green $(( mn+=1 )). Mount $system_device$partition on $mount_point $Reset"
	chmod 666 "$system_device$partition"
	sleep 2
fi

}

Copy_boot_folder () {

if [[ "$(tr '[A-Z]' '[a-z]'<<<${copy_boot_folder})" = "ask" ]]
then :
	echo -n "$Nline$Cyan Copy $SmoothBlue"/boot"$Cyan folder to $SmoothBlue"$mount_point/",$Reset"
	read -p "$Orange Please answer {Y} or {n*}$LRed$Blink ?:$Reset$Yellow n$MoveL" copy_boot_folder; echo -n "$Reset"
fi

if [ "$copy_boot_folder" = "yes" ] || [ "$copy_boot_folder" = "Y" ] || [ "$copy_boot_folder" = "y" ]
then :
	echo "$Nline$Green cp -fax /boot "$mount_point"/ : $Reset"
	cp -fax /boot "$mount_point"/
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: cp -fax /boot "$mount_point"/, exit $Reset"
		/bin/bash; exit
	else :
		echo "$Green ok $Reset"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Copy /boot folder to $mount_point/ $Reset"
	fi
else :
	echo "$Green ok$Red skip Copy /boot folder to $mount_point/ $Reset"
	MESSAGE+="$Nline$Red $(( mn+=1 )). Skipped Copy /boot folder to $mount_point/ $Reset"
fi

}

Install_Grub () {

Install_Grub_1 () {

	# install GRUB version less than 1.98
	if command -v grub >/dev/null 2>&1
	then :
		command=$(command -v grub 2>/dev/null)
		grub_version=$($command --version)
		
		mkdir -p "$mount_point"/boot/grub
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: create folder "$mount_point"/boot/grub, exit $Reset"
			/bin/bash; exit
		fi
		
		if ! [[ -z "$Grub_map_device" ]]
		then :
			echo "$Nline$Green Create file "$mount_point"/boot/grub/device.map - echo "$Grub_map_device" "$system_device" > "$mount_point"/boot/grub/device.map $Reset"
			echo ""$Grub_map_device" "$system_device"" > "$mount_point"/boot/grub/device.map
			if ! [ $? = 0 ]
			then :
				echo "$Nline$Red Error: create file "$mount_point"/boot/grub/device.map, exit $Reset"
				/bin/bash; exit
			else :
				echo "$Green ok $Reset"
				MESSAGE+="$Nline$Green $(( mn+=1 )). Create file "$mount_point"/boot/grub/device.map - "$Grub_map_device" "$system_device" $Reset"
			fi
		else :
			echo "$Nline$Orange Skipp Create file "$mount_point"/boot/grub/device.map - echo (hd0) "$system_device" > "$mount_point"/boot/grub/device.map $Reset"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). skipp Create file "$mount_point"/boot/grub/device.map - (hd0) "$system_device" $Reset"
		fi
		
		
		echo "$Nline$Green cp -fax "/boot/grub/stage1" "/boot/grub/stage2" "/boot/grub/e2fs_stage1_5" "$mount_point"/boot/grub/ $Reset"
		cp -fax "/boot/grub/stage1" "/boot/grub/stage2" "/boot/grub/e2fs_stage1_5" "$mount_point"/boot/grub/
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: cp -fax "/boot/grub/stage1" "/boot/grub/stage2" "/boot/grub/e2fs_stage1_5" "$mount_point"/boot/grub/, exit $Reset"
			/bin/bash; exit
		else :
			echo "$Green ok $Reset"
			MESSAGE+="$Nline$Green $(( mn+=1 )). Copy "/boot/grub/stage1" "/boot/grub/stage2" "/boot/grub/e2fs_stage1_5" to "$mount_point"/boot/grub/ $Reset"
		fi
		
		echo "$Nline$Green Install $grub_version into "$disk_image" - grub device (hd0) "$disk_image"; root (hd0,0); setup (hd0) : $Reset"
		echo "device (hd0) "$disk_image" $Nline root (hd0,0) $Nline setup (hd0)"|$command --device-map="$mount_point"/boot/grub/device.map
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: install $grub_version into "$disk_image", exit $Reset"
			/bin/bash; exit
		else :
			echo "$Nline$Green done $Reset"
			MESSAGE+="$Nline$Green $(( mn+=1 )). Install $grub_version - echo device (hd0) "$disk_image" ; root (hd0,0) ; setup (hd0)|$command $Reset"
		fi
	else :
		echo "$Nline$Red Erorr: can't find grub command $Reset"
		MESSAGE+="$Nline$Red $(( mn+=1 )). Error: install GRUB version less than 1.98 $Reset"
	fi

}

Install_Grub_2 () {

	# install GRUB version at least 1.98
	if $(command -v grub2-install >/dev/null 2>&1) && $(command -v grub2-mkconfig >/dev/null 2>&1)
	then :
		command_1=$(command -v grub2-install 2>/dev/null)
		command_2=$(command -v grub2-mkconfig 2>/dev/null)
		grub_boot_folder="/boot/grub2"
	elif $(command -v grub-install  >/dev/null 2>&1) && $(command -v grub-mkconfig >/dev/null 2>&1)
	then :
		command_1=$(command -v grub-install 2>/dev/null)
		command_2=$(command -v grub-mkconfig 2>/dev/null)
		grub_boot_folder="/boot/grub"
	else :
		echo "$Nline$Red Erorr: can't find grub2-install and grub2-mkconfig or grub-mkconfig and grub-mkconfig command $Reset"
		MESSAGE+="$Nline$Red $(( mn+=1 )). Erorr: can't find GRUB version at least 1.98 $Reset"
	fi
	
	if [[ -f $command_1 ]] && [[ -f $command_2 ]]
	then :
		mkdir -p "$mount_point""$grub_boot_folder"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: create folder "$mount_point""$grub_boot_folder", exit $Reset"
			/bin/bash; exit
		fi
		
		if ! [[ -z "$Grub_map_device" ]]
		then :
			mkdir -p "$mount_point"/boot/grub
			if ! [ $? = 0 ]
			then :
				echo "$Nline$Red Error: create folder "$mount_point"/boot/grub, exit $Reset"
				/bin/bash; exit
			fi
		
		
			echo "$Nline$Green Create file "$mount_point"/boot/grub/device.map - echo "$Grub_map_device" "$system_device" > "$mount_point"/boot/grub/device.map $Reset"
			echo ""$Grub_map_device" "$system_device"" > "$mount_point"/boot/grub/device.map
			if ! [ $? = 0 ]
			then :
				echo "$Nline$Red Error: create file "$mount_point"/boot/grub/device.map, exit $Reset"
				/bin/bash; exit
			else :
				echo "$Green ok $Reset"
				MESSAGE+="$Nline$Green $(( mn+=1 )). Create file "$mount_point"/boot/grub/device.map - "$Grub_map_device" "$system_device" $Reset"
			fi
		else :
			echo "$Nline$Orange Skipp Create file "$mount_point"/boot/grub/device.map - echo (hd0) "$system_device" > "$mount_point"/boot/grub/device.map $Reset"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). skipp Create file "$mount_point"/boot/grub/device.map - (hd0) "$system_device" $Reset"
		fi
		
		grub_version=$($command_1 --version)
		grub_version=${grub_version##*$command_1 }
		
		echo "$Nline$Green $command_1 --boot-directory="$mount_point"/boot "$system_device" : $Reset"
		$command_1 --boot-directory="$mount_point"/boot "$system_device"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: install $grub_version into "$system_device", exit $Reset"
			/bin/bash; exit
		else :
			echo "$Nline$Green done $Reset"
			MESSAGE+="$Nline$Green $(( mn+=1 )). Install $grub_version - $(basename "$command_1") --boot-directory="$mount_point"/boot "$system_device" $Reset"
		fi
		
		echo "$Nline$Green $command_2 -o "$mount_point""$grub_boot_folder"/grub.cfg : $Reset"
		$command_2 -o "$mount_point""$grub_boot_folder"/grub.cfg
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: $command_2 -o "$mount_point""$grub_boot_folder"/grub.cfg, exit $Reset"
			/bin/bash; exit
		else :
			echo "$Nline$Green done $Reset"
			MESSAGE+="$Nline$Green $(( mn+=1 )). Configure $(basename "$command_2") -o "$mount_point""$grub_boot_folder"/grub.cfg $Reset"
		fi
	else :
		echo "$Nline$Red Error: Install_Grub_2 - \$command_1 or \$command_2 do not exist, exit $Reset"
			/bin/bash; exit
	fi

}

if [[ "$(tr '[A-Z]' '[a-z]'<<<${grub_version})" = "ask" ]]
then :
	#echo -n "$Nline$Cyan Which Grub - Old ${SmoothBlue}Grub (1)${Cyan} or ${SmoothBlue}New Grub (2),$Reset"
	#read -p "$Orange Please answer [1] or [2] [*] skip$LRed$Blink ?:$Reset$Yellow " grub_version; echo -n "$Reset"
	
		keys=("1""2""3""4") options=( "Grub V1" "Grub V2") default=$(( ${#options[@]}+1)) time_out=30
		ask_info="$Nline$Cyan Which Grub - Old ${SmoothBlue}Grub (1)${Cyan} or ${SmoothBlue}New Grub (2),$Reset"
		ask_select
		[[ "$Selected" = "Grub V1" ]] && grub_version=1
		[[ "$Selected" = "Grub V2" ]] && grub_version=2
fi

if [[ "$grub_version" = "1" ]] || [[ "$grub_version" = "2" ]]
then :
	[[ "$grub_version" = "1" ]] && Install_Grub_1
	[[ "$grub_version" = "2" ]] && Install_Grub_2
else :
	echo "$Green ok$Red skip Grub installation $Reset"
	MESSAGE+="$Nline$Red $(( mn+=1 )). Skipped install GRUB $Reset"
fi

}

End_message () {

 cat <<-EOF
 $Cream
 Hi,
 You:) has successfully:$Reset
${MESSAGE%% }
$Cyan
 To ran:
$Orange
  qemu-system-i386 -vga std -hda $system_device -hdb $system_device$partition$Nline  or :
  [qemu-]kvm -cpu host -vga std -hda $system_device -hdb $system_device$partition
  # -vga cirrus # -vga std # -vga vmware # -vga virtio
  CTR+ALT+G switch cursor control
  $Cream( your user have to be member of qemu or kvm group )
$Magenta
 If you had 2 operating systems installed on 2 different partitions (dual booting)
 you could use qemu to boot one of them inside the other,
 but you must never ever ever boot the same OS twice
 (unless it's a read-only OS like a live CD image for instance)
 $Green$Blink # The end. # $Reset of: $(basename "$0") ...$LBlue `date` $Reset$Nline

EOF

}

Begin "$@"
