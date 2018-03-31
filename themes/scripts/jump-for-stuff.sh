#!/bin/bash
Begin () {
Traps "$@"
Prepare_check_environment "$@"
Color_terminal_variables
Info_data
Print_info
Run_as_root "$@"
Test_software

}
Info_data ()
{
   Name="# jump-for-stuff.sh"
Version="# V1.2,.. \"${White}B${LWhite}l${Red}a${Cyan}c${LRed}k$Magenta|$Orange: ${Yellow}Terminal${LGreen}\" ${LWhite}B$Magenta&"$Orange"C$Orange Test beta script$Reset"
 Author="# Leszek Ostachowski® (©2017) @GPL V2"
Purpose="# Install packages by different managers"
Worning="# "
  Usage="# Usage: Clik on script"
Dependencies=( )
Optional_dependences=( )
Licence=$(cat <<-EOF
	by Leszek Ostachowski® (©2017) @GPL V2
	To jest wolne oprogramowanie: masz prawo je zmieniać i rozpowszechniać.
	Autorzy nie dają ŻADNYCH GWARANCJI w granicach Nakazywanych jakimś prawem.
	Poniewarz jak się odwrócisz, to prawo staje się lewo i coś się zmiena, a
	oprócz tego, że prawa to zakazy najcześciej przybierajace posatć nakazów$Blink.$Reset
	EOF
	)
}

Run_as_root ()
{
	if ! [ $(id -u) = 0 ]
	then :
	      echo "$Nline$Orange This $Cyan$(basename "$0")$Orange script must be run with root privileges.$Reset"
	      echo "$Cream su -c \"/bin/bash \"$(basename "$0")\" $*\"$Reset"
	      su -c "/bin/bash \"$0\" \"$@\""
	      exit $?
	fi
}

Traps ()
{
Start_time=`date +%s`
Finished="No"
CTL_C_pressed="No"
trap 'The_end' EXIT # 0
trap "echo -e '\033[00;36m SIGHUP - \033[0;0m'; exit" SIGHUP # 1
trap 'CTL_C' SIGINT # 2
trap "echo -e '\033[00;36m SIGQUIT - Ctrl-\ - Pressed \033[0;0m\n'; exit" SIGQUIT # 3
trap "echo -e '\033[00;36m SIGTERM - software termination signal \033[0;0m\n'; exit" SIGTERM
 The_end ()
 {
 	echo -n "$Nline$EraseR$Cyan EXIT:$Reset"
 	if [ "$CTL_C_pressed" = "Yes" ]
 	then :
 		echo "$Cyan SIGINT - CTL-C Pressed $CTL_C_pressed$Reset"
 		CTL_C_pressed="No"
 	else :
 	fi
 	echo "$Green$Blink # The end # $Reset$Cream of: $(basename "$0").#$LBlue `date` $Reset"
 	Finished="Yes"
 	CTL_C_pressed="Yes"
 	trap '' EXIT # 0
 }
 CTL_C ()
 {
 		CTL_C_pressed="Yes"
 		exit
 }
}
################# Variables for color terminal
Color_terminal_variables ()
{
## Font attributes ##                                         (on monochrome display adapter only)
Bold=""$'\033[1m'"" Faint=""$'\033[2m'"" Italic=""$'\033[3m'"" Underline=""$'\033[4m'""
Blink=""$'\033[5m'"" Reverse=""$'\033[7m'"" Strike=""$'\033[9m'""

FDefault=""$'\033[39m'"" # default foreground    ## 256 colors ##			 ## True Color ##
BDefault=""$'\033[49m'"" # default background   # \033[38;5;#m foreground, # = 0 - 255 	# \033[38;2;r;g;bm r = red, g = green, b = blue # foreground
ResetC=""$'\033[0m'"" Reset=""$'\033[0;0m'""    # \033[48;5;#m background, # = 0 - 255	# \033[48;2;r;g;bm r = red, g = green, b = blue # background

# 16 Mode Front Colors # Light LColors				  # Back BColors
 Red=""$'\033[0;31m'""    Green=""$'\033[0;32m'""    Yellow=""$'\033[0;33m'"" ;   BRed=""$'\033[41m'""     BGreen=""$'\033[42m'""   BYellow=""$'\033[43m'""
LRed=""$'\033[0;91m'""   LGreen=""$'\033[0;92m'""   LYellow=""$'\033[0;93m'"" ;  BLRed=""$'\033[101m'""   BLGreen=""$'\033[102m'"" BLYellow=""$'\033[103m'""
 Blue=""$'\033[0;34m'""   Magenta=""$'\033[0;35m'""  Cyan=""$'\033[0;36m'""   ;  BBlue=""$'\033[44m'""   BMagenta=""$'\033[45m'""     BCyan=""$'\033[46m'""
LBlue=""$'\033[0;94m'""  LMagenta=""$'\033[0;95m'"" LCyan=""$'\033[0;96m'""   ; BLBlue=""$'\033[104m'"" BLMagenta=""$'\033[105m'""   BLCyan=""$'\033[106m'""
 White=""$'\033[0;37m'""  Black=""$'\033[0;30m'"" ; BWhite=""$'\033[0;47m'""    BBlack=""$'\033[40m'""
LWhite=""$'\033[0;97m'"" LBlack=""$'\033[0;90m'"" ;LBWhite=""$'\033[0;107m'""  LBBlack=""$'\033[100m'""
# 256 Mode
 SmoothBlue=""$'\033[00;38;5;111m'"" ;   Cream=""$'\033[0;38;5;225m'"" ;  Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[01;38;5;111m'"" ;  LCream=""$'\033[1;38;5;225m'"" ; LOrange=""$'\033[1;38;5;202m'""

Nline=""$'\n'"" Beep=""$'\a'"" Back=""$'\b'"" Creturn=""$'\r'"" Ctabh=""$'\t'"" Ctabv=""$'\v'"" Formfeed=""$'\f'""
EraseR=""$'\033[K'"" EraseL=""$'\033[1K'"" ClearL=""$'\033[2K'""
EraseD=""$'\033[J'"" EraseU=""$'\033[1J'"" ClearS=""$'\033[2J'"" ClearH=""$'\033[H\033[2J'"" # move to 0,0

SaveP=""$'\033[s'"" RestoreP=""$'\033[u'"" Sbuffer=""$'\033[?47h'""  Mbuffer=""$'\033[?47l'""
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
Report=""$'\033[6n'""
# ("\033[?47h") # enable alternate buffer ("\033[?47l") # disable alternate buffer
# Cursor movement will be bounded by the current viewport into the buffer. Scrolling (if available) will not occur.
Get_View_port_position () { echo -n "$Report"; read -sdR Position; VPosition=${Position#*[} CPosition=${VPosition#*;} RPosition=${VPosition%;*};echo -n ""$'\033['${Position#}'D'"" ;}
Get_View_port_size () { View_port_size=$(stty size); OLDIFS="$IFS"; IFS=' ' View_size=($View_port_size); IFS="$OLDIFS"; Vlines=${View_size[0]} Vcolumns=${View_size[1]} ;}
View_port_position () { echo -n ""$'\033['$1';'$2'H'"" ;}

Big_colaps ()
{
	Get_View_port_size
	echo -n "$ClearS"
	View_port_position $((${Vlines}/2)) $((${Vcolumns}/2))
	echo -n "$((${Vlines}/2))" "$((${Vcolumns}/2)) Position $Formfeed"
	Get_View_port_position
	echo "$RPosition $CPosition Position"
}
Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}

if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
fi

}

Print_info ()
{
	if ! [ "$Print_info" ]
	then :
		echo "$Green$Name $LBlue$Bold$Version$Reset"
		echo "$Green$Author$Reset"
		echo "$Cyan$Purpose$Reset"
		echo "$Red$Worning$Reset"
		echo "$Cream$Usage$Reset"
		Print_info=+1
		export Print_info
	fi
}


Prepare_check_environment ()
{
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	packages_to_install="$@"
	if [ ! -t 0 ]
	then :
	# script is executed outside terminal
	# execute the script inside a terminal window
	# gathering informations about terminal program
	
	if   command -v konsole >/dev/null 2>&1
	then :
		konsole --hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v terminology >/dev/null 2>&1
	then :
		terminology --hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v gnome-terminal >/dev/null 2>&1
	then :
		gnome-terminal -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v xfce4-terminal >/dev/null 2>&1
	then :
		xfce4-terminal --hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v xterm >/dev/null 2>&1
	then :
		xterm -hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	else :
		echo "$Red Error: This script "$0" needs terminal, exit 2$Reset" >&2
		exit 2
	fi
	fi
	
	workdir="${BASH_SOURCE%/*}"
	if [[ ! -d "$workdir" ]]; then workdir="$PWD"; fi;
	cd "$workdir"
}

veryfy_packages_list_names () { : ;}

function ping_gw () {
  COMMAND=$(command -v ping) && sudo $COMMAND -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2>&1 && return 0 || return 1
}

Test_software ()
{

if ! [[ -z "$packages_to_install" ]]
then :
	get_additinal_packages "$packages_to_install"
	exit
fi

read -p "$Nline$Orange Give names of packages to install,$LRed$Blink ?:$Reset$Yellow " packages_to_install; echo -n "$Reset"

if ! [[ -z "$packages_to_install" ]]
then :
	get_additinal_packages "$packages_to_install"
	exit
fi

 ### Check software
Is_software=''
No_software=''
Erorr_software=''

	command="bb"
	if ok_command=$(command -v $command 2>/dev/null)
	then :
		Is_software+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan $($ok_command --version 2>/dev/null) $Reset"
		found_commands+="$ok_command"
	else :
		No_software+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
		packages_to_install+="$command "
	fi
	
	command="$0"
	if ok_command=$(ls $command 2>/dev/null)
	then :
		Is_software+="$Nline$Green $(( cn+=1 )). ok: $ok_command:$Cyan
		by Leszek Ostachowski® (©2017) @GPL V2
		To jest wolne oprogramowanie: masz prawo je zmieniać i rozpowszechniać.
		Autorzy nie dają ŻADNYCH GWARANCJI w granicach Nakazywanych jakimś prawem.
		Poniewarz jak się odwrócisz, to prawo staje się lewo i coś się zmiena, a
		oprócz tego, że prawa to zakazy najcześciej przybierajace posatć nakazów.$Reset"
	else :
		Erorr_software+="$Nline$Red $(( cn+=1 )). can't find: $command $Reset"
	fi
	
	
	###
	if ! [ -z "$Is_software" ]
	then :
		echo "$Nline$LMagenta Checked software - program find the following commands: ${Is_software%%, }$Reset"
		answer=$(r_ask_select "$SmoothBlue Run -$Orange {*y}$found_commands $SmoothBlue"or"$Green *{n} bash$Red *twice Esc exit!:$Orange Please select - " "2")
		[[ "$answer" == "yes" ]] \
		&&
		{
		echo "$Nline$Green run $found_commands"
		$found_commands
		} \
		||
		{
		[[ "$answer" == "no" ]] && echo "$Nline" && /bin/bash && exit
		} \
		||
		{
		[[ "$answer" == "none" ]] && echo "$Nline"
		}
		
	fi
	
	if ! [ -z "$Erorr_software" ]
	then :
		echo "$Nline$LMagenta Error - Missing software can't find the following commands: ${Erorr_software%%, }$Reset"
		echo "Exit"
		/bin/bash; exit
	fi
	
	if ! [ -z "$No_software" ]
	then :
		echo "$Nline$LMagenta Missing software - can't find the following commands: ${No_software%%, }$Reset"
		#Remove color codes (special characters) with sed
		get_additinal_packages "${packages_to_install%% }"
		if ! [ $? = 0 ]
		then :
			echo "$LRed Error: install: ${pakages}. Try do it manually... $Reset"
		fi
		/bin/bash; exit
	fi
	###

}

get_additinal_packages () {
pakages=$@
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
"r$(( rn+=1 ))" "With tables"	 "it is so that you"	 "always feel called up" "# and have to explain : ...						# aaa"
)


ask_array () {

local S_row=$1 S_column=$2 E_row=$3 E_column=$4
echo
# echo ${managers[R*C+P]}
R=0 P=0  ; [[ $R > $rn || $R < 0 ]] && echo 0 || echo ${managers[R*c+P]} ${managers[R*c+P]}
R=0 P=0  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]} ${managers[R*c+P]}
R=1 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=2 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=3 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=4 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=5 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=6 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=7 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=8 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=9 P=1  ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=10 P=1 ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=11 P=1 ; [[ $P > $c  || $P < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=12 P=1 ; [[ $R > $rn || $R < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=13 P=1 ; [[ $R > $rn || $R < 0 ]] && echo 0 || echo ${managers[R*c+P]}
R=14 P=1 ; [[ $R > $rn || $R < 0 ]] && echo 0 || echo ${managers[R*c+P]}
echo
echo "Start: Sr = 1 Sc = 1"
echo "End  :	 	Er = $rn Ec = $cn"
echo

}
# ask_array
# let command_meneger_x=manager_x*distro+manager ; echo "${managers[command_meneger_x]}" ${managers[command_meneger_x+insyall]}

list_menagers () {

unset is_menager
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
	echo
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
	
	keys=("a""b""c""d") options=(${options[@]}) default=1 time_out=30
	ask_info="$Cyan You was found for you more than one coach!$Nline Then now you have to choose Which one,$Reset"
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
			if [[ "$(tr '[:upper:]' '[:lower:]' <<<"${is_menager[manager_x*distro+manager]}")" = "zypper" ]]
			then :
				echo "$Nline$Green # su -c zypper install -R ... $Reset$Nline"
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				su -c "echo; \$(dirname $ok_command)/${is_menager[manager_x*distro+install]} ${pakages}; echo"
				# check && turn 0
				return 0
			elif [[ "$(tr '[:upper:]' '[:lower:]' <<<"${is_menager[manager_x*distro+manager]}")" = "apt-get" ]]
			then :
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				echo "$Nline$Green # /sbin/apt-get : su -c apt-get update; apt-get install ... $Reset$Nline"
				su -c "apt-get update; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; apt-get install -y \$package; done"
				# check && turn 0
				return 0
			elif [[ "$(tr '[:upper:]' '[:lower:]' <<<"${is_menager[manager_x*distro+manager]}")" = "wget" ]]
			then :
				veryfy_packages_list_names ${pakages} # check and convert names of packages?
				echo "$LRed Try do it manually by wget."
				# wget .... && turn 0
				break
			
			### Standar scenario for managers
			elif ! [[ "$(tr '[:upper:]' '[:lower:]' <<<"${is_menager[manager_x*distro+manager]}")" = '' ]]
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
# echo "$Nline$Green Now you are going to install additinal tools for it $Reset"
# OpenSuse zypper

if [ -x /usr/bin/zypper ]
then :
	echo "$Nline$Green # /usr/bin/zypper : su -c /usr/bin/zypper install -R ...$Reset$Nline"
	su -c "/usr/bin/zypper install -R ${pakages}"
# Ubuntu apt-get
elif [ -x /sbin/apt-get ]
then :
	echo "$Nline$Green # /sbin/apt-get : su -c apt-get update; apt-get install ...$Reset$Nline"
	su -c "apt-get update; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; apt-get install -y \$package; done"
	
# Ubuntu apt-get
elif [ -x /usr/bin/apt-get ]
then :
	echo "$Nline$Green # /usr/bin/apt-get : su -c apt-get update; apt-get install ...$Reset$Nline"
	su -c "apt-get update; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; apt-get install -y \$package; done"

# Mandriva urpmi
elif [ -x /usr/sbin/urpmi ]
then :
	echo "$Nline$Green # /usr/sbin/urpmi : su -c urpmi --auto-select; urpmi ...$Reset$Nline"
	su -c "urpmi --auto-select; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; /usr/sbin/urpmi \$package; done"

# Arch pacman
elif [ -x /usr/bin/pacman ]
then :
	echo "$Nline$Green # /usr/bin/pacman : su -c pacman -Syu; pacman -Su --needed ...$Reset$Nline"
	su -c "pacman -Syu; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; pacman -Su --needed \$package; done"

# Fedora yum
elif [ -x /usr/bin/yum ]
then :
	echo "$Nline$Green # /usr/bin/yum : su -c yum install ...$Reset$Nline"
	su -c "echo; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; yum install \$package; done"

# Sabayon equo
elif [ -x /usr/bin/equo ]
then :
	echo "$Nline$Green # /usr/bin/equo : su -c equo up; equo install --ask ...$Reset$Nline"
	su -c "equo up; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; equo install --ask \$package; done"

# Proteus usm
elif [ -x /usr/bin/usm ]
then :
	echo "$Nline$Green # /usr/bin/usm : su -c usm -u all; /usr/bin/usm -g ...$Reset$Nline"
	su -c "usm -u all; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; /usr/bin/usm -g \$package; done"

# Solus eopkg
elif [ -x /usr/bin/eopkg ]
then :
	echo "$Nline$Green # /usr/bin/eopkg upgrade : su -c eopkg upgrade; eopkg install -g ... $Reset$Nline"
	su -c "eopkg upgrade; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; eopkg install -g \$package; done"
	
# Slakware netpkg
elif [ -x /usr/sbin/netpkg ]
then :
	echo "$Nline$Green # /usr/sbin/netpkg : su -c /usr/sbin/netpkg ...$Reset$Nline"
	su -c "echo; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; /usr/sbin/netpkg \$package; done"

# Slakware slackpkg
elif [ -x /usr/sbin/slackpkg ]
then :
	echo "$Nline$Green # /usr/sbin/slackpkg : su -c slackpkg update; slackpkg install ...$Reset$Nline"
	su -c "slackpkg update; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; slackpkg install \$package; done"

# Vector slapt-get
elif [ -x /usr/sbin/slapt-get ]
then :
	echo "$Nline$Green # /usr/sbin/slapt-get : su -c slapt-get -u; slapt-get --install ...$Reset$Nline"
	su -c "slapt-get -u; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; slapt-get --install \$package; done"

# VOID xbps-install
elif [ -x /usr/bin/xbps-install ]
then :
	echo "$Nline$Green # /usr/bin/xbps-install : su -c xbps-install -S ; /usr/bin/xbps-install ...$Reset$Nline"
	su -c "xbps-install -S ; for package in ${pakages}; do echo '${Red}' Trying install: '$SmoothBlue'\$package'${Reset}'; /usr/bin/xbps-install \$package; done"
else :
	
	echo "$LRed Can't find suitable software manager for download and install additinal packages. Try do it manually"
	echo "You need install: ${pakages}$Reset"
fi

}

function r_ask () # v1.4 by Leszek Ostachowski® (©2017) @GPL V2
{
	local info=$1 default=$2 r_key=$3 select1=$4 select2=$5 color_s=$6 color_n=$7 again=$8 select_11 select_22
	[[ "$default" == '' ]] && default="2"; [[ ! "$default" == "1" ]] && default="2"
	[[ "$r_key" == "r_key" ]] && r_key='-N1' || r_key='-e'
	[[ "$select1" == '' ]] && select1="{Y}es"  ; declare -l u_select1="${select1}"; select_1="${select1//['{'-'}']/}" key1=${u_select1##*'{'} key1=${key1%'}'*}
	[[ "$select2" == '' ]] && select2="{N}o"   ; declare -l u_select2="${select2}"; select_2="${select2//['{'-'}']/}" key2=${u_select2##*'{'} key2=${key2%'}'*}
	[[ "$color_s" == '' ]] && color_s="${Green}*"
	[[ "$color_n" == '' ]] && color_n="${Red}"
	[[ "$again" == '' ]] && again="10"
	# print menu
	# clear one line more. If cursor is at the bottom then can scroll
	# and change line with combinations different options for read and enter.
	echo "$info" >&2
	echo "$EraseR" >&2
	Linesup "2" >&2
	echo -n "$info"| tail -1 >&2
	
	while true
	do
	! [[ "$default" == '2' ]] && { echo -n "$SaveP$EraseR$Green"$select1" $SmoothBlue"or"$Red "$select2" $Orange$Blink"?:"" >&2 ;}
	[[ "$default" == '2' ]] && { echo -n "$SaveP$EraseR$Red"$select1" $SmoothBlue"or"$Green "$select2" $Orange$Blink"?:"" >&2 ;}
	
	IFS= read -r -t0.1 -s clearbuffer
	echo -n "$Yellow*$Reset$EraseR$MoveL$Yellow" >&2
	# & read
	read "$r_key"
	
	# calculate result
	[[ "$REPLY" == $'\033\033' ]] \
	&& { # twice Esc
		echo -n "$RestoreP$EraseR$Yellow exit!$Reset$Nline" >&2
		/bin/bash; exit 1
	   }
	[[ "$REPLY" == $'\033' ]] && { read -s -N1 key ;} # Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
	[[ "$key" == $'\033' ]] \
	&& { # twice Esc
		echo -n "$RestoreP$EraseR$Yellow exit!$Reset$Nline" >&2
		/bin/bash; exit
	   }
	select_11=${select_1,,}; select_22=${select_2,,}
	REPLY=${REPLY,,}
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
			IFS= read -r -s -t1 sleep1
			echo -n "$RestoreP$EraseR" >&2
			if [[ "$again" = "0" ]]
			then :
				[[ "$default" == '1' ]] && { echo -n "$Red Error: ???, exit 1$Reset" >&2; echo -n "$select_11"; exit 1 ;}
				[[ "$default" == '2' ]] && { echo -n "$Red Error: ???, exit 1$Reset" >&2; echo -n "$select_22"; exit 1 ;}
			fi
		;;
	esac
	done
}

function r_ask_select ()  # v1.4 by Leszek Ostachowski® (©2017) @GPL V2
{
	local info=$1 default=$2 pselected="$2" select1="$3" select2="$4" select3="$5" color_s=$6 color_n=$7 color_u=$8
	# before call set time out or time_out=0 to display loop
	
	[[ "$default" == '' ]] && default="1" pselected="1"
	
	[[ ! -z "$time_out" ]]  && loop_time_out=$time_out
	
	[[ "$select1" == '' ]] && select1="{Y}es"               ; declare -l u_select1="${select1}"; select_1="${select1//['{'-'}']/}" key1=${u_select1##*'{'} key1=${key1%'}'*}
	[[ "$select2" == '' ]] && select2="{N}o" selekts=2      ; declare -l u_select2="${select2}"; select_2="${select2//['{'-'}']/}" key2=${u_select2##*'{'} key2=${key2%'}'*}
	[[ "$select3" == '' ]] || select[3]="$select3" selekts=3; declare -l u_select3="${select3}"; select_3="${select3//['{'-'}']/}" key3=${u_select3##*'{'} key3=${key3%'}'*}
	
	[[ "$color_s" == '' ]] && color_s="${Green}*"
	[[ "$color_n" == '' ]] && color_n="${Red}"
	[[ "$selekts" == '3' ]] && color_u="${Cream}" select3="${SmoothBlue}or $color_s$select3" u_select3="${SmoothBlue}or $color_u$u_select3"
	[[ "$again" == '' ]] && again="10"
	#
	Debug ()
	{
	echo "$Nline$default $select_1 ${select_1} $select_2 $select_3 $selekts $loop_time_out" >&2
	echo -n "$Nline$Nline/${#key}/HEX=$EraseR" >&2
	echo "$key" | hexdump -v -e '"x" 1/1 "%02x" " "' >&2
	echo "$Nline$EraseR$Nline$EraseR$Nline$EraseR$MoveU/Key=/\"$key\"/" >&2
	}
	
	# clear one line more. If cursor is at the bottom then can scroll
	# and change line with combinations different options for read and enter.
	for (( line=$lines+2; line>0; line--))
	do
		echo "$EraseR" >&2
	done
	Linesup $(( $lines+2 )) >&2
	IFS= read -r -t0.01 -s clearbuffer
	
	echo -n "$info$SaveP" >&2
	while true # loop until akcept enter
	do loop_time_out=$[$loop_time_out-1]; [[ ! -z "$time_out" ]] && time_out="(wait-$loop_time_out)"
		
		# print menu
		case "$default" in
			1|$key1) echo -n "$RestoreP$color_s$select1$SmoothBlue or $color_n$u_select2 $u_select3$Orange$time_out$Blink ?:$EraseR$Yellow $select_1$Reset" >&2
			         echo -n ""$'\033['${#select_1}'D'"" >&2
			;;
			2|$key2) echo -n "$RestoreP$color_n$u_select1$SmoothBlue or $color_s$select2 $u_select3$Orange$time_out$Blink ?:$EraseR$Yellow $select_2$Reset" >&2
			         echo -n ""$'\033['${#select_2}'D'"" >&2
			;;
			3|*) 	[[ ! "$select3" == '' ]] \
				&&
				{
				 echo -n "$RestoreP$color_u$u_select1$SmoothBlue or $color_u$u_select2 $select3$Orange$time_out$Blink ?:$EraseR$Yellow $select_3$Reset" >&2
			         echo -n ""$'\033['${#select_3}'D'"" >&2
			         }
			;;
		esac
	
		# read key
		IFS= read -s -N1 -t1 key
		
		# if \x1b is the start of an escape sequence
		if [ "$key" == $'\033' ]
		then :	# Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
			IFS= read -r -N1 -t0.01 -s rest; key+="$rest"
			IFS= read -r -N1 -t0.01 -s rest; key+="$rest"
			# case arrow keys
			[[ "$key" == $'\033[A' ]] && { let "default += 1"; loop_time_out=$time_out; [ $default -gt $selekts ] && default=$selekts ;} # Up - mwhell
			[[ "$key" == $'\033[C' ]] && { let "default += 1"; loop_time_out=$time_out; [ $default -gt $selekts ] && default=$selekts ;} # Right
			[[ "$key" == $'\033[B' ]] && { let "default -= 1"; loop_time_out=$time_out; [ $default -le "0" ] && default=1 ;} # Down - mwhell
			[[ "$key" == $'\033[D' ]] && { let "default -= 1"; loop_time_out=$time_out; [ $default -le "0" ] && default=1 ;} # Left
			[[ "$key" == $'\033'   ]] && { read -s -N1 -t1 key ;}
			[[ "$key" == $'\033'   ]] \
			&& { # twice Esc
				echo -n "$RestoreP$color_u$u_select1$SmoothBlue or $color_u$u_select2 $select3$Orange$time_out$Blink ?:$EraseR$Yellow exit!$Reset$Nline" >&2
				/bin/bash; kill -s HUP 0
			   }
			
			IFS= read -r -t0.01 -s clearbuffer
			loop_time_out=$time_out
		fi
		# Debug # uncomment to call
		# case nuber keys
		case "$key" in
			[0-9] ) default=$key; loop_time_out=$time_out ;;
		esac
		# case chars keys
		case "$key" in
		[[:lower:]]|[[:upper:]] )
			tiger=${key,,}
			if [[ "$tiger" == $key1 ]] || [[ "$tiger" == $key2 ]] || [[ "$tiger" == $key3 ]]
			then :
				default="$tiger"
			else :
				default="$pselected"
			fi
			loop_time_out=$time_out
			;;
		esac
		
		# if space key
		[[ "$key" == $'\x20' ]] && { let "default += 1"; loop_time_out=$time_out; [ $default -gt $selekts ] && default=1 ;}
		# if Enter key
		[[ "$key" == $'\x0a' ]] && break
		[[ "$loop_time_out" = 0 ]] && break
		[[ ! -t 0 ]] && kill -s HUP 0
	done
	unset time_out
	# calculate result
	case "$default" in  # To fix return somefing difrent than "*" - "*0yes" "*0no" none
		1|"$key1") echo -n "${select_1}"
		;;
		2|"$key2") echo -n "${select_2}"
		;;
		3|*)	[[ ! "$select3" == '' ]] \
			&&
			{
			echo -n "${select_3}"
			}
		;;
	esac
}

ask_select ()  # v1.4 by Leszek Ostachowski® (©2017) @GPL V2
{
	
	# Before call fill
	# ask_info=""; list - ${options[]}; extra options - ${functions[]};
	# default=; keys=("1""2""3""4"); functions_keys; loop_time_out=0 display- +set; 
	local x= loop_time_out= again= rest= select_list=("${options[@]}")
	
	#...# add None nad Enter to menu
	select_list+=("{N}one" "{Enter}")
	if [ "$Enter_Action" = '' ]
	then :
		  Enter_Action="akcept"
	 fi
	#echo "$Stop_wrap"
	
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo "$EraseR"; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
	# Time out loop
	{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
	
	Debug ()
	{
		echo -n "$Nline$Nline/${#key}/HEX=$EraseR"
		echo "$key" | hexdump -v -e '"x" 1/1 "%02x" " "'
		echo "$Nline$EraseR$Nline$EraseR$Nline$EraseR$MoveU/Key=/\"$key\"/"
	}
	
	###
	# clear
	# Main loop
	while true
	do
	View_port_size=$(stty size); OLDIFS="$IFS"; IFS=' ' View_size=($View_port_size); IFS="$OLDIFS"; Vlines=${View_size[0]} Vcolumns=${View_size[1]}
	loop_time_out=$[$loop_time_out-1]
	if ! [[ -z ${functions[@]} ]]
	then :
	
	  unset functions_list
	  unset tigers
	  for (( x=${#functions[@]}, add=1; x>0; x--, add++ ))
	  do
		declare -l u_select[$x]="${functions[$add-1]}"
		select_[$x]="${functions[$add-1]//['{'-'}']/}"
		tigers[$x]=${u_select[$x]##*'{'} tigers[$x]=${tigers[$x]%'}'*}
		functions_list+="$Cream $(( $add+${#options[@]} )) ${functions[$add-1]},$Reset"
	  done
	else :
	 unset functions_list
	fi
	select_list=("${options[@]}")
	select_list+=("${functions[@]}")
	select_list+=("{N}one" "{Enter}")
	Title_select="$ask_info$Magenta and press:$Green $(( ${#select_list[@]} )) ${select_list[$@-1]} $Enter_Action,$Yellow $(( ${#select_list[@]}-1 )) ${select_list[$@-2]}$Reset"
	
	echo "$EraseR$Title_select$EraseR"
	echo "$EraseR$Magenta Functions: $functions_list$EraseR"
	echo -n "$EraseR$Title_list$Reset$Nline$EraseR"
	# Print list loop
	#list_lenght=$(( ${#select_list[@]} ))
	list_lenght=$(( ${#options[@]} ))
	if (( "$list_lenght">"$Vlines"-9  ))
	then :
		list_lenght="$Vlines"-9
	fi
	for (( x="$list_lenght"; x>0; x-- ))
	do
		if [ "$[default]" = "$x" ]
		then :	# Change color; get cursor position
			echo -n ""$'\033[6n'""; read -sdR CURPOS; CURPOS=${CURPOS#*[}; Charsbk 9
			printf "%-6s %-1s" " $Green$Blink$x$Reset$Green)"
			printf "%s\n" "${select_list[$x-1]}$Reset$EraseR"
		else :
			printf "%-6s %s\n" " $x)" "${select_list[$x-1]}$Reset$EraseR"
		fi
		
	done
	# and print Preselected
	echo -n "$EraseR$Nline$EraseR$Orange Preselected:$Green ${select_list[$default-1]%%:*},$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink ?: "
	echo -n "$Reset"
	# print time out and cursor position
	echo -n "$EraseR$Nline$EraseR Starting in $loop_time_out seconds... "; echo -n "${CURPOS}"
	echo -n "$EraseD"
	IFS= read -s -N1 -t1 key
	# check key
	# if \x1b is the start of an escape sequence
	if [ "$key" == $'\033' ]
	then : # Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
		IFS= read -r -N1 -t0.01 -s rest; key+="$rest"
		IFS= read -r -N1 -t0.01 -s rest; key+="$rest"
		# case arrow keys
		if [ "$key" == $'\033[A' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#options[@]} )) ]; then default=1; fi; fi # Up
		if [ "$key" == $'\033[C' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi; fi # Right
		if [ "$key" == $'\033[B' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#options[@]} )); fi; fi # Down
		if [ "$key" == $'\033[D' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#select_list[@]}-1 )); fi; fi # Left
		
		# case twice Esc
		[[ "$key" == $'\033' ]] && { read -s -N1 -t1 key ;} # twice Esc
		[[ "$key" == $'\033' ]] && { default=$(( ${#select_list[@]}-1 )); echo "$Yellow exit!$Reset"; /bin/bash; exit ;}
		IFS= read -r -s -t0.01 clearbuffer
	fi
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
				IFS= read -r -s -N1 -t1.1 rest; key+="$rest"
				if ! [ "$key" -gt $(( ${#select_list[@]}-1 )) ]
				then :
					default=$key; loop_time_out=$time_out
				fi
			fi
		;;
	esac
	
	# case chars keys
	tiger=${key,,} #; echo; echo  "${key} $tiger"; sleep 6
	case "$tiger" in
		[${keys[@]}])
			for (( x=0; x<${#keys}; x++))
			do
				if [ "${keys:x:1}" = "$tiger" ]
				then default=$[$x+1]
				fi
			done
			loop_time_out=$time_out
		;;
		
	esac
	# case functions chars keys
	! [[ -z ${functions[@]} ]] && [[ ! "$tiger" == '' ]] \
	&&
	{
	for (( x=${#tigers[@]}; x>0; x--))
	do
	 [[ "$tiger" == "${tigers[$x]}" ]] \
	 &&
	 {
	   Procedure=${select_list[${#select_list[@]}-$x-2]##*$'!\b'}
	   Procedure=${Procedure//['{'-'}']/}
	   Preselected="${select_list[default-1]##*$'!\b'}"
	   if [ "$Preselected" == "{N}one" ]; then echo "Procedure {N}one"; exit 1; fi
	   loop_time_out=$time_out
	   echo "$Procedure" "$Preselected"$Reset #; sleep 6
	   "$Procedure"
	   unset Procedure
	 }
	done
	}
	# Debug # uncomment to call
	# if space key
	[[ "$key" == $'\x20' ]] && { let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi ;}  # Right
	
	# case Quit, Enter, time out
	if   [ "$key" = "$(( ${#select_list[@]}-1 ))" ] || [ "$key" = $'Quit' ] || [ "$key" = $'n' ]; then default=$(( ${#select_list[@]}-1 )); break
	elif [ "$key" == $'\x0a' ] || [ "$key" = "$(( ${#select_list[@]} ))" ] || [ "$key" = $'Enter' ]; then break
	elif [ "$loop_time_out" = 0 ] ; then break
	fi
	
	echo -n "$RestoreP"
	done
	
	# calculate result
	Selected="${select_list[default-1]##*$'!\b'}"
	Selected=${Selected[@]#*;*m}
	Selected=${Selected[@]%%$'\033'[*}
	echo "$Nline Akcepted: ${Selected}" #; sleep 5
	unset time_out
	unset functions
}

ask_nuber () {

	echo "$EraseR";echo "$EraseR";echo "$EraseR";Linesup 3
	echo -n "$SaveP"
	
	try=("..." ".." "${Blink}!" "rabbit")
	try_length=${#try[@]}
	for again in ${try[@]}
	do :
		read -p "$Nline$Orange$EraseR Give size in MB for file contain a disk image,$SmoothBlue MB$LRed$Blink ?:$Reset$Yellow " size; echo -n "$Reset"
		#Remove color codes (special characters) with sed
		size=$(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" <<<${size}|tr -d '[:blank:][:cntrl:][:space:]')
		
		# integer calculate # integer calculate /^?/ { let result=${size} >/dev/null 2>&1 && size=${result} ;} || float calculate using awk
		{ result=$(awk '{result = '$size'; print result}' <<<${_ping} 2>/dev/null ) && [ ! -z ${result} ] && size=${result} ;}
		
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

calculate () {
	# integer calculate # integer calculate /^?/ { let result=${size} >/dev/null 2>&1 && size=${result} ;} || float calculate using awk
	{ result=$(awk 'result = '$1'; print result}' <<<${_ping} 2>/dev/null ) && [ ! -z ${result} ] && echo ${result} ;}
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

check_arch_type () {
arch_type=$(uname -m)
	if [[ "${arch_type}" = *"64"* ]] && [[ ! "${arch_type}" = *"IA-64"* ]]
	then :
		arch_type="amd64"
	else :
		arch_type="i386"
	fi
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
	
	df -Pk "${path}" | awk 'NR==2 {print $4}'|awk '{result = $1'${count}'; printf "%.1f '${unit}'",result}'
	! [[ -z ${wrong_parameter} ]] && echo "$Red Wrong parameter unit: „${wrong_parameter}” - Usage: unit - [ B | KB | MB | GB ] [ PATH ]$Reset" && return 1
	return 0
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

remove_color_codes () {

	#Remove color codes (special characters) with sed
	echo $(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" <<<${1})

}

Begin "$@"
