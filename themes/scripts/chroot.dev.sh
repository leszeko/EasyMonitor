#!/bin/bash
# chroot.dev.sh V1.1
# by Leszek Ostachowski® (©2017) @GPL V2

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

if [ ! -t 0 ]
then :
# script is executed outside terminal
# execute the script inside a terminal window
# Gathering informations about terminal program
if   command -v konsole >/dev/null 2>&1
then :
konsole --hold -e "/bin/bash \"$0\" \"$@\""
return $?
elif command -v terminology >/dev/null 2>&1
then :
terminology --hold -e "/bin/bash \"$0\" \"$@\""
return $?
elif command -v gnome-terminal >/dev/null 2>&1
then :
gnome-terminal -e "/bin/bash \"$0\" \"$@\""
return $?
elif command -v xfce4-terminal >/dev/null 2>&1
then :
xfce4-terminal --hold -e "/bin/bash \"$0\" \"$@\""
return $?
elif command -v xterm >/dev/null 2>&1
then :
xterm -hold -e "/bin/bash \"$0\" \"$@\""
return $?
elif command -v deepin-terminal >/dev/null 2>&1
then :
deepin-terminal -e "\"$0\" \"$@\""
return $?
else :
echo "$Red Error: This script "$0" needs terminal, exit 2$Reset" >&2
return 2
fi
fi
ask_select () {
	
	# Before call fill
	# ask_info=""; list - ${options[]}; extra options - ${add_options[]};
	# default=; keys=("1""2""3""4"); add_options_keys; loop_time_out=0 display- +set;
	local x= loop_time_out= again= rest= select_list=("${options[@]}") First_Select_item=
	
	! [[ -z ${add_options[@]} ]] \
	&&
	{ select_list+=(${add_options[@]})
	
	for (( add=${#add_options[@]}, x=1; add>0; add--, x++))
	do
		u_select[$x]=$(tr '[:upper:]' '[:lower:]' <<<"${add_options[$add-1]}") select_[$x]=$(tr -d '{}' <<<"${add_options[$add-1]}") tigers[$x]=${u_select[$x]##*'{'} tigers[$x]=${tigers[$x]%'}'*}
	done
		 #echo "${#tigers[@]} : ${select_[1]} - ${tigers[1]},  ${select_[2]} - ${tigers[2]},  ${select_[3]} - ${tigers[3]}"
	}

	#...# add None nad Enter to menu
	select_list+=("{N}one" "{Enter}")
	if [ "$Enter_Action" = '' ]
	then :
		  Enter_Action="akcept"
	 fi
	#echo "$Stop_wrap"
	Debug ()
	{
		echo -n "$Nline$Nline/${#key}/HEX=$EraseR"
		echo "$key" | hexdump -v -e '"x" 1/1 "%02x" " "'
		echo "$Nline$EraseR$Nline$EraseR$Nline$EraseR$MoveU/Key=/\"$key\"/"
	}
	
	for (( x=$(( ${#select_list[@]}+7 )); x>0; x--))
	do echo "$EraseR"; done
	Linesup $(( ${#select_list[@]}+7 ))
	
	echo "$ask_info"
	
	# Time out loop
	{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	! [[ -z $default ]] && default=$(( ${#select_list[@]} ))
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
		if [ "$[default]" = "$x" ]
		then :
			# Change color; get cursor position
			echo -n ""$'\E[6n'""; read -sdR -t 000.1 CURPOS; CURPOS=${CURPOS#*[}; Charsbk 9
			printf "%-4s %-1s" "$Green$Blink$x$Reset$Green)"
			printf "%s\n" "${select_list[$x-1]}$Reset$EraseR"
		else :
			# echo " $x) ${select_list[$x-1]}$Reset$EraseR"
			printf "%-4s %s\n" "$x)" "${select_list[$x-1]}$Reset$EraseR"
		fi
		
	done
	
	# Read key and print Preselected; # IFS= Separator
	IFS= read -p "$EraseR$Nline$EraseR$Orange Preselected:$Green ${select_list[$default-1]%%:*},$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink ?: " -s -N 1 -t 1 key; echo -n "$Reset"
	
	# print time out and cursor position
	echo -n "$EraseR$Nline$EraseR Starting in $loop_time_out seconds... "; # echo -n "${CURPOS}"
	# if \x1b is the start of an escape sequence
	if [ "$key" == $'\x1b' ]
	then : # Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
		IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
		IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
		
		# case arrow keys
		if [ "$key" == $'\x1b[A' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#options[@]} )) ]; then default=1; fi; fi # Up
		if [ "$key" == $'\x1b[C' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi; fi # Right
		if [ "$key" == $'\x1b[B' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#options[@]} )); fi; fi # Down
		if [ "$key" == $'\x1b[D' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#select_list[@]}-1 )); fi; fi # Left
		
		# case twice Esc
		[[ "$key" == $'\x1b'   ]] && { read -s -N 1 -t 1 key ;} # twice Esc
		[[ "$key" == $'\x1b'   ]] && { default=$(( ${#select_list[@]}-1 )); echo "$Yellow exit!$Reset"; /bin/bash; exit ;}
		IFS= read -rs -t 000.1 clearbuffer
	fi
	
	# case nuber keys
	case "$key" in
		[1-9] )
		
			if [ 9 -gt $(( ${#select_list[@]}-1 )) ]
			then :
				if ! [ "$key" -gt $(( ${#select_list[@]}-2 )) ]
				then :
					tiger=$(echo $key | tr '[:upper:]' '[:lower:]')
					if [ $tiger -gt $(( ${#options[@]} )) ]
					then :
						Selected_opts="${add_options[$key-${#options[@]}-1]}" key='Enter'
					else :
						default=$key; loop_time_out=$time_out
					fi
				fi
			else :
				IFS= read -r -N 1 -t 1.2 -s rest; key+="$rest"
				if ! [ "$key" -gt $(( ${#select_list[@]}-2 )) ]
				then :
					tiger=$(echo $key | tr '[:upper:]' '[:lower:]')
					if [ $tiger -gt $(( ${#options[@]} )) ]
					then :
						Selected_opts="${add_options[$key-${#options[@]}-1]}" key='Enter'
					else :
						default=$key; loop_time_out=$time_out
					fi
				fi
			fi
		;;
	esac
	
	
	# case chars keys
	tiger=$(echo $key | tr '[:upper:]' '[:lower:]')
	case "$tiger" in
		[${keys[@]}])
			for (( x=0; x<${#keys}; x++))
			do
				if [ "${keys:x:1}" = "$tiger" ]
				then :
				
				default=$[$x+1]
				
				fi
			done
			
			loop_time_out=$time_out
		;;
		
	esac
	# case add_options chars keys
	! [[ -z ${add_options[@]} ]] && [[ ! "$tiger" == '' ]] \
	&&
	{
	for (( x=${#tigers[@]}; x>0; x--))
	do
	[[ "$tiger" == "${tigers[$x]}" ]] && Selected_opts="${add_options[$x]}" key=$'\x0a'
	done
	}
	
	# Debug # uncomment to call
	# if space key
	[[ "$key" == $'\x20' ]] && { let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi ;}  # Right
	
	# case Quit, Enter, time out
	
	
	if   [ "$key" = "$(( ${#select_list[@]}-1 ))" ] || [ "$key" = $'n' ]
	then :
		default=$(( ${#select_list[@]}-1 ))
		break
	elif [ "$key" == $'\x0a' ] || [ "$key" = $'Enter' ] || [ "$key" = "$(( ${#select_list[@]} ))" ]
	then :
		if   [ $default = $(( ${#select_list[@]}-1 )) ]
		then :
			break
		elif [ $default -gt $(( ${#options[@]} )) ]
		then :
			echo -n "$LRed$Blink First Select item $First_Select_item$Reset"
			First_Select_item=$[$First_Select_item+1]
			[ "$First_Select_item" -gt 10 ] && echo "$Yellow exit!$Reset" && exit 1
			sleep 2
			
		else :
			break
		fi
	elif [ "$loop_time_out" = 0 ]
	then :
		if   [ $default -gt $(( ${#select_list[@]}-1 )) ]
		then :
			default="$(( ${#select_list[@]}-1 ))"
			break
		else :
			break
		fi
	fi
	
	echo -n "$RestoreP"
	done
	
	# calculate result
	Selected="${select_list[default-1]}"
	# echo "$Nline Akcepted: $Selected"
	# echo " Pos: $default"
	unset time_out
}

select_volume ()
{
	unset options
	if command -v blkid >/dev/null 2>&1
	then :
		
		options=$( $(command -v blkid) )
		options=$(echo "$options"|awk '{printf "%-12s %s;", $1, $2" "$3" "$4 }'|tr -d '\n,')
		IFS=";" options=($options)
		
	else :
		
	fi
	
	default=$((${#options[@]}+2))
	ask_info="$Nline$Green Select:$Yellow VOLUME$SmoothBlue to$Green chroot:$Green"
	add_options=("{C}ommand" "{L}ogin")
	ask_select
	
	device=${Selected%% *}
	device=$(echo $device|tr -d ':')
	echo "$Nline Akcepted: "$device""
}

if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This script must be run with root privileges.$Reset$Nline"
su -c "/bin/bash \"$0\" $*"
exit $?
fi

# echo "command: \"$1\" \"$2\" $3"
case "$1" in
	  "") echo "$SmoothBlue usage: chroot.dev.sh <device> <command> or bin/bash --login$Reset"
	      select_volume
	      if [ "$device" = "{N}one" ]
	      then :
			echo "exit"; exit 1
	      fi

	      if [ "$Selected_opts" = "{L}ogin" ]
	      then :
			Command="bin/bash --login"
	      fi

	      if [ "$Command" = "" ]
	      then :
			echo -n "$SmoothBlue Enter$Green <command>$SmoothBlue or$Green bin/bash --login$Orange$Blink ?: $Reset"
			read Command
	      fi

	      if [ "$Command" = "" ]
	      then :
			echo "exit"; exit 1
	      fi

	      DIR="${BASH_SOURCE%/*}"
	      if [[ ! -d "$DIR" ]]
	      then :
			DIR="$PWD"
	      fi
	      $DIR/chroot.dev.sh "$device" $Command
	      exit $?
      ;;
      *) if ! [ -b "$1" ]
	  then :
		echo "$Orange „$1” is not block device, exit 1$Reset"; exit 1
	  else :
		device="$1"
	  fi
      ;;
esac

if [ "$Command" = "" ] &&  [ "$2" = "" ]
then :
	echo -n "$SmoothBlue Enter$Green <command>$SmoothBlue or$Green bin/bash --login$Orange$Blink ?: $Reset"
	read Command
	if [  "$Command" = "" ]
	then :
		echo "exit"; exit 1
	fi
	DIR="${BASH_SOURCE%/*}"
	if [[ ! -d "$DIR" ]]
	then :
		DIR="$PWD"
	fi
	$DIR/chroot.dev.sh "$device" $Command
	exit $?
fi

new_root_dev=$(mount -l | grep "$1 " | awk '{print $3}')
if ! [ "$new_root_dev" ]
then
        new_root_dev="/mnt/${USER}${1}"
        mkdir -p /mnt/${USER}${1}
        mount "$1" /mnt/${USER}${1} || { echo "$LRed Erorr: can't mount „$1”, exit 1$Reset$Nline"; exit 1;}
        mounted=1
fi
{
  mount -t proc proc -o nosuid,noexec,nodev "$new_root_dev/proc"
  mount -t sysfs sys -o nosuid,noexec,nodev,ro "$new_root_dev/sys"
  mount -t devtmpfs -o mode=0755,nosuid udev "$new_root_dev/dev"
  mkdir -p "$new_root_dev/dev/pts" "$new_root_dev/dev/shm"
  mount -t devpts -o mode=0620,gid=5,nosuid,noexec devpts "$new_root_dev/dev/pts"
  mount -t tmpfs -o mode=1777,nosuid,nodev shm "$new_root_dev/dev/shm"
  mount -t tmpfs -o nosuid,nodev,mode=0755 run "$new_root_dev/run"
  mount -t tmpfs -o mode=1777,strictatime,nodev,nosuid tmp "$new_root_dev/tmp"
  # Workaround for Debian
  mkdir -p "$new_root_dev/run/shm"
} >/dev/null 2>&1

shift
echo "$Orange Enter in chroot $SmoothBlue- "$device" "$*".$Orange Live - exit $Reset"
chroot "$new_root_dev" /bin/bash -c "$*"
echo "$Orange live chroot$Reset"
if [ "$mounted" ]
then
        fuser -k "$new_root_dev"
        umount -R "$new_root_dev"
fi
