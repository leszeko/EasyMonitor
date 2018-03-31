#!/bin/bash
# hardware_info.sh script

################# Variables for color terminal
Color_terminal_variables () {

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
}
Color_terminal_variables
#################
function r_ask() {
    read -p "$1 $Reset$Cyan$Green{Y}es$LBlue or $Red{N}o$Cyan $LYellow$Blink?:$Reset$LYellow " -n1 -r
    echo "$Reset" >&2
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo -n "yes" ;;
        *)     echo -n "no" ;;
    esac
}
#################

echo "$Nline$LGreen # hardware_info.sh script # $Reset"

echo "$Nline$LGreen # Command: lscpu = $Reset$Nline"
lscpu

echo "$Nline$LGreen # Command: sudo lspci -m = $Reset$Nline"
sudo lspci -m

echo "$Nline$LGreen # Command: lsdev = $Reset$Nline"
lsdev

echo "$Nline$LGreen # Command: lsscsi = $Reset$Nline"
lsscsi

echo "$Nline$LGreen # Command: lsblk = $Reset$Nline"
lsblk

echo "$Nline$LGreen # Command: lsdvd = $Reset$Nline"
lsdvd

echo "$Nline$LGreen # Command: sudo lspci -nnk | grep -i usb -A2 = $Reset$Nline"
sudo lspci -nnk | grep -i usb -A2

echo "$Nline$LGreen # Command: lsusb = $Reset$Nline"
lsusb

echo "$Nline$LGreen # Command: lsusb.py = $Reset$Nline"
lsusb.py

echo "$Nline$LGreen # Command: sudo lspci -nnk | grep -i ethernet -A2 =  $Reset$Nline"
sudo lspci -nnk | grep -i ethernet -A2

echo "$Nline$LGreen # Command: sudo lshw -c network =  $Reset$Nline"
sudo lshw -c network

echo "$Nline$LGreen # Command: ls /sys/class/net/*/device/net/*/device/driver/module/drivers/ =  $Reset$Nline"
ls /sys/class/net/*/device/net/*/device/driver/module/drivers/

echo "$Nline$LGreen # Command: sudo lspci -nnk | grep -i vga -A2 =  $Reset$Nline"
sudo lspci -nnk | grep -i vga -A2

echo "$Nline$LGreen # Command: sudo lshw -c video =  $Reset$Nline"
sudo lshw -c video

Command_E=dmidecode
Command_P=$(whereis -b $Command_E|awk '{print $2}')
if [[ -x $Command_P ]] ;then
	echo -n "$Nline$LGreen $Command_P is -"; whatis $Command_E
	echo "$LRed"
	if [[ "no" == $(r_ask "$LGreen Run $Command_P, Please answer:$LRed") || "no" == $(r_ask "$LBlue Are you$LOrange *really*$Orange sure?$Red") ]]; then
	echo "$Nline$Orange Skipped.$Reset $Command_E"
	else
	echo -e "\033[01;32m"; echo " # Command: sudo $Command_P | more = "; echo -e "\033[0;0m"
	echo -en "\033[1;34m"; sudo $Command_P | more; echo -en "\033[0;0m"
	fi
else
	echo "$Nline$LRed # No $Command_E installed in system$Reset"
fi

echo -en "\n\033[5;32m # Done #\033[0;0m\n"
