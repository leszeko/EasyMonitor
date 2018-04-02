#!/bin/bash
# os_info.sh script

Color_terminal_variables ()
{
Esc=""$'\033'"" ESC=""$'\033'""
CSI=""$'\033['""
function f_date { date +%Y-%m-%d_%H-%M-%S ;}
Escape () { echo -en "\033[$1" >&2 ;}
Columns132 () {  echo -n ""$'\033[?3h'"" ;} # DECCOLM	Set Number of Columns to 132
Columns80 ()  {  echo -n ""$'\033[?3l'"" ;} # DECCOLM	Set Number of Columns to 80
Stop_wrap=""$'\033[?7l'""
Start_wrap=""$'\033[?7h'""

Window_it () { echo -n ""$'\033]0;'$1$'\007'"" >&2 ;} # Set Icon and Window Title <string>
Window_t () { echo -n ""$'\033]2;'$1$'\007'"" >&2 ;} # Set Window Title <string>

## Font attributes ##                            # Intensity: Faint   not widely supported
Nolrmal=""$'\033[0m'""      Bold=""$'\033[1m'""  Faint=""$'\033[2m'""
 Italic=""$'\033[3m'"" Underline=""$'\033[4m'""  Blink=""$'\033[5m'""
 Fblink=""$'\033[6m'""   Reverse=""$'\033[7m'"" Hidden=""$'\033[8m'"" Strike=""$'\033[9m'"" # (not widely supported)
 # *Black Outline                               #(do not display character echoed locally)
 # MS-DOS ANSI.SYS; 150+ per minute; not widely supported

 ResetC=""$'\033[0m'""        Reset=""$'\033[0;0m'""
 N_Bold=""$'\033[21m'"" N_Intensity=""$'\033[22m'"" N_Underlined=""$'\033[24m'""
N_Blink=""$'\033[25m'""   N_Reverse=""$'\033[27m'""     N_Hidden=""$'\033[28m'""
# 21 set normal intensity (ECMA-48 says "doubly underlined")

#Underline_c=""$'\033[1;1m]'"" # Set color n as the underline color
# linux term 8 colors in fact 16 registers of colors. "Bold" not work.. intensity in fact is another sets of 8 values swich by intensity .. not intensity or thickness..
# [ - select  palette register (bold): 0/1; - decoration :blink;undeline;Italic;Strike;Reverse;Hidden; - to use on - :foreground; background; intense - 
# [ cout<<"\033["<<color_palete;<<decoration;<<"color-register";intensity<<"m"<<str<<"\033[0m";

# 16 Mode Front Colors # Light LColors				  # Back BColors ( profesjonaliści musieli długo myśleć jak to zrobić prościej:)
 Red=""$'\033[0;31m'""    Green=""$'\033[0;32m'""    Yellow=""$'\033[0;33m'"" ;   BRed=""$'\033[41m'""     BGreen=""$'\033[42m'""   BYellow=""$'\033[43m'""
FRed=""$'\033[0;31;2m'"" FGreen=""$'\033[0;32;2m'"" FYellow=""$'\033[0;33;2m'""
LRed=""$'\033[0;91m'""   LGreen=""$'\033[0;92m'""   LYellow=""$'\033[0;93m'"" ;  BLRed=""$'\033[101m'""   BLGreen=""$'\033[102m'"" BLYellow=""$'\033[103m'""

 Blue=""$'\033[0;34m'""    Magenta=""$'\033[0;35m'""    Cyan=""$'\033[0;36m'""   ;  BBlue=""$'\033[44m'""   BMagenta=""$'\033[45m'""     BCyan=""$'\033[46m'""
FBlue=""$'\033[0;34;2m'"" FMagenta=""$'\033[0;35;2m'"" FCyan=""$'\033[0;36;2m'""
LBlue=""$'\033[0;94m'""   LMagenta=""$'\033[0;95m'""   LCyan=""$'\033[0;96m'""   ; BLBlue=""$'\033[104m'"" BLMagenta=""$'\033[105m'""   BLCyan=""$'\033[106m'""

White=""$'\033[0;37m'""  Black=""$'\033[0;30m'"" ; BWhite=""$'\033[0;47m'""    BBlack=""$'\033[40m'""
LWhite=""$'\033[0;97m'"" LBlack=""$'\033[0;90m'"" ;LBWhite=""$'\033[0;107m'""  LBBlack=""$'\033[100m'""
# 256 Mode                               Cream=""$'\033[0;38;5;5344m'"" # -- mix pair colors -- #(not widely supported) 225;1    [95;1m
 SmoothBlue=""$'\033[0;38;5;111m'"" ;   Cream=""$'\033[0;38;5;5344m'"" ;  Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[0;38;5;111;1m'"" ;  LCream=""$'\033[0;38;5;5344;1m'"" ; LOrange=""$'\033[0;38;5;202;1m'""
FSmoothBlue=""$'\033[0;38;5;111;2m'""
  ## 256 colors ##						 ## True Color ##
 # \033[38;5;#m foreground, # = 0 - 255 	# \033[38;2;r;g;bm r = red, g = green, b = blue # foreground
 # \033[48;5;#m background, # = 0 - 255 	# \033[48;2;r;g;bm r = red, g = green, b = blue # background
 # 39 set underscore off, set default foreground color
FDefault=""$'\033[39m'"" # default foreground color
BDefault=""$'\033[49m'"" # default background color

Nline=""$'\n'"" Beep=""$'\a'"" Back=""$'\b'"" Creturn=""$'\r'"" Ctabh=""$'\t'"" Ctabv=""$'\v'"" Formfeed=""$'\f'""
EraseR=""$'\033[K'"" EraseL=""$'\033[1K'"" ClearL=""$'\033[2K'"" ReturnClear=""$'\033[G\033[2K'""
EraseD=""$'\033[J'"" EraseU=""$'\033[1J'"" ClearS=""$'\033[2J'"" HomeClear=""$'\033[H\033[2J'"" # move to 0,0

SaveP=""$'\033[s'"" RestoreP=""$'\033[u'"" Sbuffer=""$'\033[?47h'""  Mbuffer=""$'\033[?47l'""

# ("\033[?47h") # enable alternate buffer ("\033[?47l") # disable alternate buffer

# ESC 7	DECSC	Save Cursor Position in Memory**
# ESC 8	DECSR	Restore Cursor Position from Memory**

# ESC [ s	ANSISYSSC	Save Cursor – Ansi.sys emulation	
# **With no parameters, performs a save cursor operation like DECSC
# ESC [ u	ANSISYSSC	Restore Cursor – Ansi.sys emulation
# **With no parameters, performs a restore cursor operation like DECRC
# **ANSI.sys historical documentation can be found at
# https://msdn.microsoft.com/library/cc722862.aspx
# and is implemented for convenience/compatibility.
# ESC [ ? 12 h	ATT160	Text Cursor Enable Blinking  Start the cursor blinking
# ESC [ ? 12 l	ATT160	Text Cursor Enable Blinking  Stop blinking the cursor
# ESC [ ? 25 h	DECTCEM	Text Cursor Enable Mode Show Show the cursor
# ESC [ ? 25 l	DECTCEM	Text Cursor Enable Mode Hide Hide the cursor

Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}
Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
# Cursor movement will be bounded by the current viewport into the buffer.
#  Scrolling (if available) will not occur.
# -- New scrolling lines after save position can mix save position
# ESC [ <n> S	SU	Scroll Up   Scroll text up by <n>.
# Also known as pan down, new lines fill in from the bottom of the screen
# ESC [ <n> T	SD	Scroll Down Scroll down by <n>.
# Also known as pan up, new lines fill in from the top of the screen
# The text is moved starting with the line the cursor is on.
# If the cursor is on the middle row of the viewport, then scroll up would
# move the bottom half of the viewport, and insert blank lines at the bottom.
# Scroll down would move the top half of the viewport’s rows
# and insert new lines at the top.
# Also important to note is scroll up and down are also affected by
# the scrolling margins. Scroll up and down won’t affect any lines
# outside the scrolling margins.

Report=""$'\033[6n'""
RI=""$'\033[M'""
# ESC M	RI Reverse Index – Performs the reverse operation of \n moves cursor up
# one line, maintains horizontal position, scrolls buffer if necessary*
# ESC [ <n> E	CNL			- Cursor Next Line	Cursor down to beginning of <n>th line in the viewport
Rightend=""$'\033[F'""  # End line      - Cursor Previous Line	Cursor up to beginning of <n>th line in the viewport
Leftstart=""$'\033[G'"" # Left end line - Cursor Horizontal Absolute	Cursor moves to <n>th position horizontally in the current line
# ESC [ <n> d	VPA	                - Vertical Line Position Absolute	Cursor moves to the <n>th position vertically in the current column
Home=""$'\033[H'""      # '[H': # Home Pos1
# ESC [ <y> ; <x> f HVP	 ESC [ <y> ; <x> H CUP Cursor Position

Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
Horizontal_position () { echo -n ""$'\033['$1'G'"" ;}; Line_pos () { echo -n ""$'\033['$1'H'"" ;}
Get_View_port_position () { echo -n "$Report"; read -sdR Position; VPosition=${Position#*[} CPosition=${VPosition#*;} RPosition=${VPosition%;*};echo -n ""$'\033['${Position#}'D'"" ;}
Get_View_port_size () { View_port_size=$(stty size); OLDIFS="$IFS"; IFS=' ' View_size=($View_port_size); IFS="$OLDIFS"; Vlines=${View_size[0]} Vcolumns=${View_size[1]} ;}
View_port_position () { echo -n ""$'\033['$1';'$2'H'"" ;}
Echo_# () { Get_View_port_position >&2; echo -ne "\E[${1};${2}H""$3" >&2; View_port_position ${RPosition} ${CPosition} >&2 ;}
Bar ()
{
	Get_View_port_size
	local Message=${1} String_length=0 Prefix=${2-#} Ruler=${3--} Rigt_shift=${4-2}
	local Postfix=${5-"$Prefix"}
	String_length=$(printf "%*s" $Vcolumns) && echo -n ${String_length// /$Ruler} && echo -n "$Back$Ruler$Postfix"
	echo -n "$Creturn$Prefix" && Charsfd "$Rigt_shift" && echo "$Message"
	# max_length=1
	# for String in "${Array[@]}"
	# do :
	# 	[ ${#String} -gt ${max_length} ] && max_length=${#String}
	# done
	
	# Message=$(printf "%*s" $Vcolumns)
	# echo -n ${Message: 1 : $Vcolumns-1 }
}

Big_colaps ()
{
	Get_View_port_size
	echo -n "$ClearS"
	View_port_position $((${Vlines}/2)) $((${Vcolumns}/2))
	echo -n "$((${Vlines}/2))" "$((${Vcolumns}/2)) Position $Formfeed"
	Get_View_port_position
	echo "$RPosition $CPosition Position"
}

sleep_key () { read -r -s -N1 sleep; read -r -s -t0.1;}

ccho ()
{
	OLD_IFS="$IFS" IFS=$'\033' Parameters="$@"
	for Parameter in $Parameters
	do :	
	if [ ! -z "$Parameter" ]
		then :	
			if [[ ${Parameter:0:1} = '[' ]]
			then :	
			      Data=${Parameter/'['*m/} Code=${Parameter//"$Data"/}
			      echo -en "\033$Code" >&2; echo -en "$Data"
			else :	
			      echo -en "${Parameter}"
			fi
		fi
	done
	IFS="$OLD_IFS"
	#echo
}

Fix ()
{
if [[ "$TERM" != *xterm* ]]
then :	#       "$Yellow"                   "$Bold$Blue"               "$$Bold$Magenta"
	 Orange=""$'\033[0;33m'""  SmoothBlue=""$'\033[1;34m'""   Cream=""$'\033[1;35m'""
	LOrange=""$'\033[1;31m'"" LSmoothBlue=""$'\033[1;34m'"" LCream=""$'\033[1;35m'""
	     # $Bold
	LRed=""$'\033[1;31m'""  LGreen=""$'\033[1;32m'""   Yellow=""$'\033[1;33m'""
	LBlue=""$'\033[1;34m'"" LMagenta=""$'\033[1;35m'"" LCyan=""$'\033[1;36m'""
	LYellow=""$'\033[1;33m'""
	Blink=""
	echo -n "$Cursor_solid"
else :	       # Yellow="LYellow"        "$Bold$Yellow"
	Yellow=""$'\033[0;93m'"" LYellow=""$'\033[1;93m'""
	LRed=""$'\033[01;38;5;196m'""
fi
}
Fix
}; Color_terminal_variables


function r_ask() {
    read -p "$1 $Reset$Cyan$Green{Y}es$LBlue or $Red{N}o$Cyan $LYellow$Blink?:$Reset$LYellow " -n1 -r
    echo "$Reset" >&2
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo -n "yes" ;;
        *)     echo -n "no" ;;
    esac
}
#################
echo "$Nline$LGreen # os_info.sh script # $Reset"

echo "$Nline$LGreen # Command: uname --all :$Reset$Nline"
uname --all

DISTRO="Unkown"
CODENAME="n/a"
LSB_RELASE_COMMAND=`which lsb_release`



if [ -e "$LSB_RELASE_COMMAND" ]; then
	DISTRO=`"$LSB_RELASE_COMMAND" -d |awk -F'\t' '{print $2} '`; CODENAME=`"$LSB_RELASE_COMMAND" -c |awk -F'\t' '{print $2}'`
	echo "$Nline$LGreen # Command: lsb_release = $Reset$DISTRO $CODENAME"
fi
test -r "/etc/sabayon-release"		&& DISTRO=`cat "/etc/sabayon-release"`		&& echo "$Nline$LGreen # File /etc/sabayon-release : $Reset$Nline"	&& cat "/etc/sabayon-release"
test -r "/etc/SuSE-release"		&& DISTRO=`cat "/etc/SuSE-release"`		&& echo "$Nline$LGreen # File /etc/SuSE-release : $Reset$Nline"		&& cat "/etc/SuSE-release"
test -r "/etc/redhat-release"		&& DISTRO=`cat "/etc/redhat-release"`		&& echo "$Nline$LGreen # File /etc/redhat-release : $Reset$Nline"	&& cat "/etc/redhat-release"
test -r "/etc/mandrake-release"		&& DISTRO=`cat "/etc/mandrake-release"`		&& echo "$Nline$LGreen # File /etc/mandrake-release : $Reset$Nline"	&& cat "/etc/mandrake-release"
test -r "/etc/slackware-version"	&& DISTRO=`cat "/etc/slackware-version"`	&& echo "$Nline$LGreen # File /etc/slackware-version : $Reset$Nline"	&& cat "/etc/slackware-version"
test -r "/etc/debian_version"		&& DISTRO=`cat "/etc/debian_version"`		&& echo "$Nline$LGreen # File /etc/debian_version : $Reset$Nline"	&& cat "/etc/debian_version"
test -r "/etc/vector-version" 		&& DISTRO="Vector"				&& echo "$Nline$LGreen # File /etc/vector-version : $Reset$Nline"	&& cat "/etc/vector-version" && CODENAME=`cat "/etc/vector-version"` 
test -r "/etc/os-release" 		&& DISTRO=`cat "/etc/os-release"`		&& echo "$Nline$LGreen # File /etc/os-release : $Reset$Nline"		&& cat "/etc/os-release"


#echo "$DISTRO $CODENAME"
echo "$Nline"
echo "Normal: ""$Green"Green "$Red"Red "$White"White "$Yellow"Yellow "$Cyan"Cyan "$Blue"Blue "$SmoothBlue"SmoothBlue "$Magenta"Magenta "$Orange"Orange "$Cream"Cream ""
echo " Light: ""$LGreen"Green "$LRed"Red "$LWhite"White "$LYellow"Yellow "$LCyan"Cyan "$LBlue"Blue "$LSmoothBlue"SmoothBlue "$LMagenta"Magenta "$LOrange"Orange "$LCream"Cream ""
echo "$Nline"

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; cd "$DIR/"

Command_P="color_info.sh"
if [[ "no" == $(r_ask "$LGreen Run: $LBlue\"$DIR/$Command_P\",$Nline$Orange Please answer:$Reset") ]]
	then :
		echo "$Nline$Orange Skipped.$Reset $Command_P"
	else :
		echo
		echo "$(pwd)/$Command_P"
		echo
		"./$Command_P"
	fi
	

echo "$Reset$Nline"
Command_P="$DIR/key_board_reader.py"
if [[ "no" == $(r_ask "$LGreen # Command: Run: $Command_P,$Nline$Orange Please answer:$Reset") ]]
	then :
		echo "$Nline$Orange Skipped.$Reset $Command_P"
	else :
		echo "$Green$Nline"
		$DIR/key_board_reader.py
		echo "$Nline"
fi


echo "$Reset$Nline"
Command_P="$DIR/xterm-color-chooser.py"
if [[ "no" == $(r_ask "$LGreen # Command: Run: $Command_P,$Nline$Orange Please answer:$Reset") ]]
	then :
		echo "$Nline$Orange Skipped.$Reset $Command_P"
	else :
		echo "$Green$Nline"
		$DIR/xterm-color-chooser.py
		echo "$Nline"
fi

echo "$Nline$LGreen # Command: sudo os-prober, give administrator password if you need = $Reset$Nline"
Command_P="os-prober"
if [[ "no" == $(r_ask "$LGreen Run: $Command_P,$Nline$Orange Please answer:$Reset") ]]
then :
	echo "$Nline$Orange Skipped.$Reset $Command_P"
else :
	echo "$Green$Nline"
	sudo os-prober
	echo "$Nline"
fi

read -r -N1 -s -p "$Magenta To display locale configurations: Press key: continue $Reset" Sleep_key

echo "$Nline$n$LGreen # cat /etc/vconsole.conf =$Reset$Nline"
cat /etc/vconsole.conf

echo "$Nline$Cyan https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console $n\
 https://wiki.archlinux.org/index.php/Fonts$Reset$Nline"

echo "$Nline$LGreen # cat /etc/locale.conf =$Reset$Nline"
cat /etc/locale.conf

echo "$Nline$LGreen # cat /etc/locale.gen =$Reset$Nline"
cat /etc/locale.gen

echo "$Nline$Cyan https://wiki.archlinux.org/index.php/Locale$Reset$Nline"

echo "$Nline$LGreen # localectl status =$Reset$Nline"
localectl status

echo "$Nline$LGreen # cat /etc/X11/xorg.conf.d/00-keyboard.conf =$Reset$Nline"
cat /etc/X11/xorg.conf.d/00-keyboard.conf

echo "$Nline$Cyan https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg$Reset$Nline"

echo "$Nline$LGreen # ls -L /etc/localtime =$Reset$Nline"
ls -l /etc/localtime

echo "$Nline$Cyan https://wiki.archlinux.org/index.php/Time$Reset$Nline"

echo "$Nline$LGreen$Blink # Done # $Reset$Nline"


read -p "$X_X $Yellow( Hay key to display Tips )" -n 1 -r

echo "$Nline$Cyan"
cat <<-EOF
	#----------------------------------------------#
	
	# To set the default global system locale for all users, type the following command as root:
	
	sudo localectl set-locale LANG=pl_PL.UTF-8 
	# or
	sudo localectl set-locale LANG=en_US.UTF-8
	
	localectl list-keymaps
	
	sudo localectl set-keymap pl
	
	# For Xorg:
	
	sudo localectl set-x11-keymap pl
	
	# Temporary configuration loadkeys keymap
	
	setxkbmap -layout pl
	setfont Lat2-Terminus16 -m 8859-2
	
	# To temporary launch application with different locale from terminal. Example:
	
	env LANG=LANG=pl_PL.UTF-8 abiword &
	# or
	env LANG=pl_PL.UTF-8 kate -new Polski_LANG &  LANG=C kate -new System_LANG
	
	# Launch application with different locale from desktop. Example:
	
	cp /usr/share/applications/abiword.desktop ~/.local/share/applications/
	# Edit the Exec command: kate ~/.local/share/applications/abiword.desktop
	# Exec=env LANG=pl_PL.UTF-8 abiword %U
	
	#----------------------------------------------#
	EOF



