#!/bin/bash
# encoding: utf-8
# set -v
# set -m
Begin ()
{
vdd "$@"
}

function vdd ()
{
Info_data ()
{
   Name="# vdd.sh"
Version="# V1.94,.. \"${White}B${LWhite}l${Red}a${Cyan}c${LRed}k$Magenta|$Orange: ${Yellow}Terminal${LGreen}\" ${LWhite}B$Magenta&"$Orange"C$Orange Test beta script$Reset"
 Author="# Leszek Ostachowski® (©2017) @GPL V2"
Purpose="# Copy or extract image file to device or volume"
Worning="# Data on the device will be overwritten!"
  Usage="# Usage: vdd <file> <device> {e}xtract mode {file system type} {options for mkfs}"
Dependencies=( fdisk dd grep awk tr wc du sort stty )
Optional_dependences=( pv lsblk blkid isohybrid )
Log=''
Licence=$(cat <<-EOF
	by Leszek Ostachowski® (©2017) @GPL V2
	To jest wolne oprogramowanie: masz prawo je zmieniać i rozpowszechniać.
	Autorzy nie dają ŻADNYCH GWARANCJI w granicach Nakazywanych jakimś prawem.
	Poniewarz jak się odwrócisz, to prawo staje się lewo i coś lub raczej
	wszysko się zmiena, a oprócz tego, że prawa to zakazy najcześciej
	przybierajace posatć nakazów$Blink.$Reset
	EOF
	)
}

Begin ()
{
Traps "$@"
Color_terminal_variables
Prepare_check_environment
Info_data
Print_info
Run_as_root "$@"
Test_dependencies
}
Traps ()
{
Start_time=`date +%s`
Finished="No"
CTL_C_pressed="No"
if [ "$1" = "export" ]
then :
	
	export -f vdd
	/bin/bash
	exit
fi

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
Color_terminal_variables ()
{
Esc=""$'\033'"" ESC=""$'\033'""
Csi=""$'\033['""
C=""$'\033['""
CSI () { echo -en "\033[$*" >&2 ;}
ansi ()  { echo -en "\033[${1}m" >&2; echo -en "${*:2}"; echo -en "\033[0m">&2; }
# red () { ansi 31 "$@"; }; red "red"
function f_date { date +%Y-%m-%d_%H-%M-%S ;}
Escape () { echo -en "\033[$*" >&2 ;}

Window_it () { echo -n ""$'\033]0;'$1'\007'"" >&2 ;} # Set Icon and Window Title <string>
Window_t ()  { echo -n ""$'\033]2;'$1'\007'"" >&2 ;} # Set Window Title <string>
Columns132 () {  echo -n ""$'\033[?3h'"" ;} # DECCOLM	Set Number of Columns to 132
Columns80 ()  {  echo -n ""$'\033[?3l'"" ;} # DECCOLM	Set Number of Columns to 80
Terminal_size () { echo -n ""$'\033[8;'$1';'$2't'"" >&2 ;} # Terminal_size $LINES $XXX - shrinks/extends line length
Set_origin_to_relative=""$'\033[?6h'""
Set_origin_to_absolute=""$'\033[?6l'""
Stop_wrap=""$'\033[?7l'""
Start_wrap=""$'\033[?7h'""
# setterm --linewrap [on|off]

 ### Ansi decoration codes
#┌─────────────────────┐┌─────────────────────┐┌─────────────────────┐
#│ Font attributes     ││ Font attributes     ││ Font attributes     │
#├──────┬──────────────┤├──────┬──────────────┤├──────┬──────────────┤
#│ Name │ Code         ││ Name │ Code         ││ Name │ Code         │
#└──────┴──────────────┘└──────┴──────────────┘└──────┴──────────────┘
# reset                      # Select L colors register in linux vt
Nolrmal=""$'\033[0m'""       Bold=""$'\033[1m'""  Faint=""$'\033[2m'"" # Intensity: Faint   not widely supported
 Italic=""$'\033[3m'""  Underline=""$'\033[4m'""  Blink=""$'\033[5m'"" # diffrent color in linux vt
 Fblink=""$'\033[6m'""    Reverse=""$'\033[7m'"" Hidden=""$'\033[8m'"" Strike=""$'\033[9m'"" # (not widely supported)
 # *Black Outline                               #(do not display character echoed locally)
 # MS-DOS ANSI.SYS; 150+ per minute; not widely supported

 ResetC=""$'\033[0m'""        Reset=""$'\033[0;0m'""
 N_Bold=""$'\033[21m'"" N_Intensity=""$'\033[22m'"" N_Underlined=""$'\033[24m'""
N_Blink=""$'\033[25m'""   N_Reverse=""$'\033[27m'""     N_Hidden=""$'\033[28m'""
# 21 set normal intensity (ECMA-48 says "doubly underlined")

# Underline_c=""$'\033[1;1m]'"" # Set color n as the underline color
# linux console\term 8 colors in fact 16 registers of colors. "Bold" work as. intensity
# but in fact its another sets of 8 values for colors swich by intensity.. not intensity or thickness.
# Name of color is only abstract address /as langages/ to register holds value for color.
# So we have 16 basic registers for colors
# named: red,green,,,bold_red,bold_green,,,
# and they do not even have to be sub-branded.
# High Iintense - Bold High Iintense ; 91m - 1;91 - next palete? ...
# (and put color surrounded by another color make mix influences and optical iterfaces influences)
# [ - select  palette register (bold): 0/1; - decoration :blink;undeline;Italic;Strike;Reverse;Hidden;
# - to use on - :foreground; background; intense - 
# [ cout<<"\033["<<color_palete;<<decoration;<<"color-register";intensity<<"m"<<str<<"\033[0m";
# ( profesjonaliści musieli długo myśleć jak to zrobić prościej, a jeszcze jak się wezmą za tłumaczenie.. to sie weź i zlituj :)
Set_color () { echo -n ""$'\033]P'$1''"" >&2 ;} # N######
Reset_palet () { echo -n ""$'\033]R'"" >&2 ;}
# 16 Mode Front Colors # Light LColors
#┌───────────────────────┬───────────────────┐┌───────────────────────────┬───────────────────┐
#│ Regular Colors        │ Palet value       ││ Ligt/Bright/Bold/         │ Palet value       │
#├──────┬────────────────┼───────────────────┤├──────┬────────────────────┼───────────────────┤
#│ Name │ Code           │ Hex               ││ Name │ Code               │ Hex               │
#└──────┴────────────────┴───────────────────┘└──────┴────────────────────┴───────────────────┘
  Black=""$'\033[0;30m'""   hvBlack="000000"     LBlack=""$'\033[1;30m'""   hvLBlack="808080" # rgb=(128,128,128)	hsl=(0,0%,50%)
    Red=""$'\033[0;31m'""     hvRed="800000"       LRed=""$'\033[1;31m'""    hvLRedk="ff0000" # rgb=(255,0,0)	hsl=(0,0%,0%)
  Green=""$'\033[0;32m'""   hvGreen="008000"     LGreen=""$'\033[1;32m'""   hvLGreen="00ff00" # rgb=(0,255,0)	hsl=(0,0%,0%)
 Yellow=""$'\033[0;33m'""  hvYellow="808000"    LYellow=""$'\033[1;33m'""  hvLYellow="ffff00" # rgb=(255,255,0)	hsl=(0,0%,0%)
   Blue=""$'\033[0;34m'""    hvBlue="000080"      LBlue=""$'\033[1;34m'""    hvLBlue="0000ff" # rgb=(0,0,255)	hsl=(0,0%,0%)
Magenta=""$'\033[0;35m'"" hvMagenta="800080"   LMagenta=""$'\033[1;35m'"" hvLMagenta="ff00ff" # rgb=(255,0,255)	hsl=(0,0%,0%)
   Cyan=""$'\033[0;36m'""    hvCyan="008080"      LCyan=""$'\033[1;36m'""    hvLCyan="00ffff" # rgb=(0,255,255)	hsl=(0,0%,0%)
  White=""$'\033[0;37m'""   hvWhite="c0c0c0"     LWhite=""$'\033[1;37m'""   hvLWhite="ffffff" # rgb=(255,255,255)	hsl=(0,0%,0%)
# Background+inverse can work as spare foreground palet if have own registers?
#┌───────────────────────┬───────────────────┐┌───────────────────────────┬───────────────────┐
#│ Background            │ Palet value       ││High Iintense backgrounds  │ Palet value       │
#├──────┬────────────────┼───────────────────┤├──────┬────────────────────┼───────────────────┤
#│ Name │ Code           │ Hex               ││ Name │ Code               │ Hex               │
#└──────┴────────────────┴───────────────────┘└──────┴────────────────────┴───────────────────┘
  BBlack=""$'\033[40m'""   hvBBlack="000000"     BLBlack=""$'\033[0;100m'""   hvBLBlack="808080" # rgb=(128,128,128)	hsl=(0,0%,50%)
    BRed=""$'\033[41m'""     hvBRed="800000"       BLRed=""$'\033[0;101m'""    hvBLRedk="ff0000" # rgb=(255,0,0)	hsl=(0,0%,0%)
  BGreen=""$'\033[42m'""   hvBGreen="008000"     BLGreen=""$'\033[0;102m'""   hvBLGreen="00ff00" # rgb=(0,255,0)	hsl=(0,0%,0%)
 BYellow=""$'\033[43m'""  hvBYellow="808000"    BLYellow=""$'\033[0;103m'""  hvBLYellow="ffff00" # rgb=(255,255,0)	hsl=(0,0%,0%)
   BBlue=""$'\033[44m'""    hvBBlue="000080"      BLBlue=""$'\033[0;104m'""    hvBLBlue="0000ff" # rgb=(0,0,255)	hsl=(0,0%,0%)
BMagenta=""$'\033[45m'"" hvBMagenta="800080"   BLMagenta=""$'\033[0;105m'"" hvBLMagenta="ff00ff" # rgb=(255,0,255)	hsl=(0,0%,0%)
   BCyan=""$'\033[46m'""    hvBCyan="008080"      BLCyan=""$'\033[0;106m'""    hvBLCyan="00ffff" # rgb=(0,255,255)	hsl=(0,0%,0%)
  BWhite=""$'\033[47m'""   hvBWhite="c0c0c0"     BLWhite=""$'\033[0;107m'""   hvBLWhite="ffffff" # rgb=(255,255,255)	hsl=(0,0%,0%)
# Next 16 colors registers Background + foreground ? 3+4=9
#┌───────────────────────┬───────────────────┐┌───────────────────────────┬───────────────────┐
#│ High Iintense         │ Palet value       ││ High Ligt Iintense        │ Palet value       │
#├──────┬────────────────┼───────────────────┤├──────┬────────────────────┼───────────────────┤
#│ Name │ Code           │ Hex               ││ Name │ Code               │ Hex               │
#└──────┴────────────────┴───────────────────┘└──────┴────────────────────┴───────────────────┘
  HBlack=""$'\033[0;90m'""   hvHBlack="000000"   HLBlack=""$'\033[1;90m'""   hvHLBlack="808080" # rgb=(128,128,128)	hsl=(0,0%,50%)
    HRed=""$'\033[0;91m'""     hvHRed="800000"     HLRed=""$'\033[1;91m'""    hvHLRedk="ff0000" # rgb=(0,0,0)	hsl=(0,0%,0%)
  HGreen=""$'\033[0;92m'""   hvHGreen="008000"   HLGreen=""$'\033[1;92m'""   hvHLGreen="00ff00" # rgb=(0,0,0)	hsl=(0,0%,0%)
 HYellow=""$'\033[0;93m'""  hvHYellow="808000"  HLYellow=""$'\033[1;93m'""  hvHLYellow="ffff00" # rgb=(0,0,0)	hsl=(0,0%,0%)
   HBlue=""$'\033[0;94m'""    hvHBlue="000080"    HLBlue=""$'\033[1;94m'""    hvHLBlue="0000ff" # rgb=(0,0,0)	hsl=(0,0%,0%)
HMagenta=""$'\033[0;95m'"" hvHMagenta="800080" HLMagenta=""$'\033[1;95m'"" hvHLMagenta="ff00ff" # rgb=(0,0,0)	hsl=(0,0%,0%)
   HCyan=""$'\033[0;96m'""    hvHCyan="008080"    HLCyan=""$'\033[1;96m'""    hvHLCyan="00ffff" # rgb=(0,0,0)	hsl=(0,0%,0%)
  HWhite=""$'\033[0;97m'""   hvHWhite="c0c0c0"   HLWhite=""$'\033[1;97m'""   hvHLWhite="ffffff" # rgb=(0,0,0)	hsl=(0,0%,0%)

 FRed=""$'\033[0;31;2m'"" FGreen=""$'\033[0;32;2m'"" FYellow=""$'\033[0;33;2m'""
FBlue=""$'\033[0;34;2m'"" FMagenta=""$'\033[0;35;2m'"" FCyan=""$'\033[0;36;2m'""

# 256 Mode                               Cream=""$'\033[0;38;5;5344m'"" # -- mix pair colors -- #(not widely supported) 225;1    [95;1m
 SmoothBlue=""$'\033[0;38;5;111m'""   ;  Cream=""$'\033[0;38;5;5344m'""   ;  Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[0;38;5;111;1m'"" ; LCream=""$'\033[0;38;5;5344;1m'"" ; LOrange=""$'\033[0;38;5;202;1m'""
FSmoothBlue=""$'\033[0;38;5;111;2m'""
  ## 256 colors ##						 ## True Color ##
 # \033[38;5;#m foreground, # = 0 - 255 	# \033[38;2;r;g;bm r = red, g = green, b = blue # foreground
 # \033[48;5;#m background, # = 0 - 255 	# \033[48;2;r;g;bm r = red, g = green, b = blue # background
 # 39 set underscore off, set default foreground color
FDefault=""$'\033[39m'"" # default foreground color
BDefault=""$'\033[49m'"" # default background color

Cursor_blink=""$'\033[?12h'"" # ATT160	 Start blinking the cursor
Cursor_solid=""$'\033[?12l'"" # ATT160	 Stop blinking the cursor
 Cursor_show=""$'\033[?25h'"" # DECTCEM	 Show the cursor
 Cursor_hide=""$'\033[?25l'"" # DECTCEM	 Hide the cursor

 Cursor_blink_underline=""$'\033[?2;c'"" # normal blinking underline
 Cursor_w_block=""$'\033[?17;86;32;c'""  # white non-blinking block
 Cursor_r_block=""$'\033[?17;0;64;c'""   # red non-blinking block
 Cursor_g_block=""$'\033[?17;0;32;c'""   # green non-blinking block
 Cursor_y_block=""$'\033[?17;14;224;c'   # yellow non-blinking block
 Cursor_b_block=""$'\033[?17;0;144;c'""  # blue non-blinking block

 UTF_8=""$'\033%G'""           # Select UTF-8

Fix ()
{
if [[ "$TERM" != *xterm* ]]
then :
	# "ISO 8-color pallette
	#       "$Brown-Yellow"                "$Bold$Blue"             "$$Bold$Magenta"
	 Orange=""$'\033[0;33m'""  SmoothBlue=""$'\033[1;36m'""  Cream=""$'\033[1;35m'""
	LOrange=""$'\033[0;33m'"" LSmoothBlue=""$'\033[1;36m'"" LCream=""$'\033[1;35m'""
	     # $Bold
	LRed=""$'\033[1;31m'""    LGreen=""$'\033[1;32m'"" Yellow=""$'\033[1;33m'""
	LBlue=""$'\033[1;34m'"" LMagenta=""$'\033[0;35m'""  LCyan=""$'\033[0;36m'""
	# "$Bold$Yellow"
	LYellow=""$'\033[1;33m'""
	LWhite=""$'\033[1;37m'"" LBlack=""$'\033[1;30m'""
	Blink="$(setterm --blink on)"
	Faint="$(setterm --half-bright on)"
	
if [ "$TERM" = "linux" ]
then : # palet
echo -e "\033[?47h"
	             #black     #red       #green     #Orange    #blue      #magenta   #cyan     #(S) white
	echo -ne "\e]P0000000\e]P17F0000\e]P2008000\e]P3FF4600\e]P41010FF\e]P5BF00BF\e]P600CDCD\e]P7A0A0A0"
	             #L black   #L red     #L green   #L yellow  #L blue    #L Cream   #S Blue    #L white
	echo -ne "\e]P8404040\e]P9C41414\e]PA3CFF00\e]PBE2E200\e]PC4141FF\e]PDFFC8C8\e]PE9696FF\e]PFFFFFFF"
	# get rid of artifacts
	#clear
echo -e "\033[?47l"
fi
	setterm --ulcolor yellow
	Blink=""
	echo -n "$Cursor_b_block"
	# setfont Lat2-Terminus16 -m 8859-2
	# echo -n "$UTF_8"
else :	       # Yellow="LYellow"        "$Bold$Yellow"
	Yellow=""$'\033[0;93m'"" LYellow=""$'\033[1;93m'""
	LRed=""$'\033[1;38;5;196m'""
	echo -n "$Cursor_b_block"
	# setfont Lat2-Terminus16 -m 8859-2
fi
}

Fix

Nline=""$'\n'"" Beep=""$'\a'"" Back=""$'\b'"" Creturn=""$'\r'"" Ctabh=""$'\t'"" Ctabv=""$'\v'"" Formfeed=""$'\f'""

EraseR=""$'\033[K'"" EraseL=""$'\033[1K'"" ClearL=""$'\033[2K'"" ReturnClear=""$'\033[G\033[2K'""
EraseD=""$'\033[J'"" EraseU=""$'\033[1J'"" ClearS=""$'\033[2J'"" HomeClear=""$'\033[H\033[2J'"" # move to 0,0

SavePv=""$'\0337'"" RestorePv=""$'\0338'"" Reset_term=""$'\033c'""   Visual_Bell=""$'\033g'""
SaveP=""$'\033[s'"" RestoreP=""$'\033[u'"" Sbuffer=""$'\033[?47h'""  Mbuffer=""$'\033[?47l'""

# ("\033[?47h") # enable alternate buffer ("\033[?47l") # disable alternate buffer

Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}
Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
# Cursor movement will be bounded by the current viewport into the buffer.
#  Scrolling (if available) will not occur.

# Direct Cursor Addressing
Left_dn_start=""$'\033[E'"" # CNL Cursor Next Line. Cursor down to beginning of [<n>E th line in the viewport
Left_up_start=""$'\033[F'"" # CPL Cursor Previous Line. Cursor up to beginning of [<n>F th line in the viewport
Horizontal_position () { echo -n ""$'\033['$1'G'"" ;} # CHA Cursor Horizontal Absolute . Cursor moves to <n>th position horizontally in the current line
 Character_position () { echo -n ""$'\033['$1'`'"" ;} # HPA Horizontal Position Absolute [column] (default = [row,1])  Move cursor to indicated column in current row.
  Vertical_position () { echo -n ""$'\033['$1'd'"" ;} # VPA Vertical Position Absolute. Cursor moves to the <n>th position vertically in the current column

    Line_pos () { echo -n ""$'\033['$1'H'"" ;}      # CUP Cursor Position. Moves the cursor to row n, column m. The values are 1-based, and default to 1 (top left corner) if omitted.
    Position () { echo -n ""$'\033['$1';'$2'H'"" ;} # ESC [ <y> ; <x> H CUP Cursor Position
   Positionf () { echo -n ""$'\033['$1';'$2'f'"" ;} # ESC [ <y> ; <x> f HVP Cursor Position

Home=""$'\033[H'""      # '[H': # Home Pos1
Report=""$'\033[6n'""
RI=""$'\033[M'""
# ESC M	RI Reverse Index – Performs the reverse operation of \n moves cursor up
# one line, maintains horizontal position, scrolls buffer if necessary*

Set_scrolling_region () { echo -n ""$'\033['$1';'$2'r'"" ;}

Scroll_up () { echo -n ""$'\033['$1'S'"" ;}
# Scroll text up by <n>. Known as pan down, new lines fill in from the bottom
Scroll_dn () { echo -n ""$'\033['$1'T'"" ;}
# Scroll down by <n>. known as pan up, new lines fill in fromthe top
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

Get_View_port_position () { echo -n "$Black$Report";read -sdR Position; echo -n ""$'\033['$((${#Position} + 2 ))'D'""; VPosition=${Position#*[} CPosition=${VPosition#*;} RPosition=${VPosition%;*} ;}
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
	# printf "%s\b\b\b" -{001..25}
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

Sleep_key () { read -r -s -N1 sleep; read -r -s -t0.1;}

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

}

Prepare_check_environment ()
{
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


Run_as_root ()
{

if ! [ $(id -u) = 0 ]
then :
	echo "$Nline$Orange This $Cyan$(basename "$0")$Orange script must be run with root privileges.$Reset"
	if [[ "$0" == '/bin/bash' ]]
	then :
		  if [ -e  "vdd.sh" ]
		  then :
			echo "$Cream su -c \". vdd.sh $*\"$Reset"
			su -c ". vdd.sh $*"
		  else :
			echo "$Cream su -c \"vdd $*\"$Reset"
			su -c "vdd $*"
	         fi
	else :
	      echo "$Cream su -c \"/bin/bash $0 $*\"$Reset"
	      su -c "/bin/bash \"$0\" $*"
	fi
	exit $?
fi
}

Print_info ()
{
	if ! [ "$Print_info" ]
	then :
		Info_data
		echo "$Green$Name $LBlue$Bold$Version$Reset"
		echo "$Green$Author$Reset"
		echo "$Cyan$Purpose$Reset"
		echo "$Red$Worning$Reset"
		echo "$Cream$Usage$Reset"
		Print_info=+1
		export Print_info
	fi
}

Test_dependencies ()
{
	Is_software=''
	No_software=''
	To_install=''
	Optional_software=''
	To_optional_install=''
	Erorr_software=''
	
	for package in ${Dependencies[@]}
	do
	if ok_command=$(command -v $package 2>/dev/null)
	then :
		Is_software+="$Nline $(( ci+=1 )): $ok_command: $($ok_command --version 2>/dev/null)"
		
	else :
		No_software+="$Nline $(( cn+=1 )): $package"
		To_install+="$package "
	fi
	done
	
	for package in ${Optional_dependences[@]}
	do
	if ok_command=$(command -v $package 2>/dev/null)
	then :
		Is_software+="$Nline $(( ci+=1 )): $ok_command: $($ok_command --version 2>/dev/null)"
		
	else :
		Optional_software+="$Nline $(( cn+=1 )): $package"
		To_optional_install+="$package "
	fi
	done
	if ! [ -z "$Erorr_software" ]
	then :
	      echo "$Red Error: this script needs:$SmoothBlue $Erorr_software$Red software$Reset"
	      echo "$Magenta This script requires to install:$SmoothBlue $No_software$Green software$Reset"
	      echo "$Magenta Recommended to install:$SmoothBlue $Optional_software$Green software$Reset"
	      sleep 5
	      exit 1
	fi
	if ! [ -z "$No_software" ]
	then :
	      echo "$Magenta This script requires to install:$SmoothBlue $No_software$Green software$Reset"
	      sleep 2
	fi
	if ! [ -z "$Optional_software" ]
	then :
	      echo "$Magenta This script recommended to install:$SmoothBlue $Optional_software$Green software$Reset"
	      sleep 2
	fi
}

Install_missing ()
{
	if ! [ -z "$No_software" ] || ! [ -z "$Optional_dependences" ]
	then :
		chmod +x $workdir/jump-for-stuff.sh
		if ! [ -z "$To_install" ]
		then :
			echo "$Nline$LMagenta Missing software - can't find the following commands: ${No_software%%, }$Reset"
			$workdir/jump-for-stuff.sh "${To_install}"
			if ! [ $? = 0 ]
			then :
				echo "$LRed Error: install: ${No_software%%, }. Try do it manually... $Reset"
				/bin/bash; exit
			fi
		fi
		if ! [ -z "$To_optional_install" ]
		then :
			echo "$Nline$LMagenta This script recommended to install - the following package: ${Optional_software%%, }$Reset"
			$workdir/jump-for-stuff.sh "${To_optional_install}"
			if ! [ $? = 0 ]
			then :
			      echo "$LRed Error: install: ${No_software%%, }. Try do it manually... $Reset"
			fi
		fi
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

Get_disks_list ()
{
	if command -v lsblk >/dev/null 2>&1
	then :
		Disks_list=$(lsblk -l -p -a --output NAME,TRAN,SIZE,MODEL,TYPE 2>/dev/null|grep -e 'disk'|awk '{ sub(/ /,": "); print }'|sort -r -k1)
		if [ "$Disks_list" = "" ]; then echo "$LRed Erorr: lsblk, exit$Reset$Nline"; exit 1; fi
	elif command -v fdisk >/dev/null 2>&1
	then :
		Disks_list=$(fdisk -l 2>/dev/null|grep -e ': '|grep -e ' /'|grep -e ' /dev/'|sort -r -k2)
		if [ "$Disks_list" = "" ]; then echo "$LRed Erorr: fdisk, exit$Reset$Nline"; exit 1; fi
		Type=${Disks_list%% *} Disks_list=${Disks_list//$Type /}
		
	else :
		echo "$LRed Erorr: no lsblk or fdisk command, exit$Reset$Nline"; exit 1
	fi
}

Disks ()
{
	Item="DEVICE"
	ask_info="$Nline$Green Select:$Yellow ${Item}$Green to$LRed $Mode$Green image:$Reset"
	Get_disks_list
	OLDIFS="$IFS"; IFS=$'\n'; options=(${Disks_list[@]}); select_list=(${options[@]}); IFS="$OLDIFS"
	select_list+=(${functions[@]})
	select_list+=("{N}one" "{Enter}")
}

Rescan ()
{
	Disks
}
Get_volumes_list ()
{
	if command -v lsblk >/dev/null 2>&1
	then :
		Volumes_list=$(lsblk -l -p -a --output NAME,LABEL,FSTYPE,SIZE,TYPE,TRAN 2>/dev/null|grep -e 'part'|awk '{ sub(/ /,": "); print }')
		if [ "$Volumes_list" = "" ]; then echo "$LRed Erorr: lsblk, exit$Reset$Nline"; exit 1; fi
		
	elif command -v fdisk >/dev/null 2>&1
	then :
		Volumes_list=$(fdisk -l 2>/dev/null|grep '^/'|awk '{ sub(/ /,": "); print }')
		if [ "$Volumes_list" = "" ]; then echo "$LRed Erorr: fdisk, exit$Reset$Nline"; exit 1; fi
	else :
		echo "$LRed Erorr: no lsblk or fdisk command, exit$Reset$Nline"; exit 1
	fi
}
Volumes()
{
	
	
	Item="VOLUME"
	ask_info="$Nline$Green Select:$Yellow ${Item}$Green to$LRed $Mode$Green image:$Reset"
	Get_volumes_list
	OLDIFS="$IFS"; IFS=$'\n'; options=(${Volumes_list[@]}); select_list=(${options[@]}); IFS="$OLDIFS"
	select_list+=(${functions[@]})
	select_list+=("{N}one" "{Enter}")
	destination="volume"
}
Select_volume ()
{
	unset options
	Item="VOLUME"
	Get_volumes_list
	OLDIFS="$IFS"; IFS=$'\n'; options=(${Volumes_list[@]}); IFS="$OLDIFS"
	default=$(( ${#options[@]}+2 ))
	ask_info="$Nline$Green Select:$Yellow ${Item}$Green to$LRed $Mode$Green image:$Reset"
	functions=( "$SmoothBlue!${Back}{V}olumes" "$SmoothBlue!${Back}{R}escan" "$Cream!${Back}$C_Mode" "$Red!${Back}{H}ybridization_iso." )
	Title_list=" $Red$Mode$Green file name:$Blue $file$Nline$EraseR"
	ask_select
	
	device=${Selected%% *}
	device=${device//:/}
	echo "$Nline Akcepted: "$device""
}

Select_device ()
{
	unset options
	Item="DEVICE"
	Get_disks_list
	OLDIFS="$IFS"; IFS=$'\n'; options=(${Disks_list[@]}); IFS="$OLDIFS"
	default=$(( ${#options[@]}+1 ))
	ask_info="$Nline$Green Select:$Yellow ${Item}$Green to$LRed $Mode$Green image:$Reset"
	functions=( "$SmoothBlue!${Back}{V}olumes" "$SmoothBlue!${Back}{R}escan" "$Cream!${Back}$C_Mode" "$Red!${Back}{H}ybridization_iso." )
	Title_list=" $Red$Mode$Green file name:$Blue $file$Nline$EraseR"
	ask_select
	
	device=${Selected%% *}
	device=${device//:/}
	echo "$Nline Akcepted: "$device""
	
}

Extract_mode ()
{
	Mode="{E}xtract_mode"
	C_Mode="{W}rite_mode"
	functions=( "$SmoothBlue!${Back}{V}olumes" "$SmoothBlue!${Back}{R}escan" "$Cream!${Back}$C_Mode" "$Red!${Back}{H}ybridization_iso." )
	ask_info="$Nline$Green Select:$Yellow ${Item}$Green to$LRed $Mode$Green image:$Reset"
	Title_list=" $Red$Mode$Green file name:$Blue $file$Nline$EraseR"
	
	
}

Write_mode ()
{
	Mode="{W}rite_mode"
	C_Mode="{E}xtract_mode"
	functions=( "$SmoothBlue!${Back}{V}olumes" "$SmoothBlue!${Back}{R}escan" "$Cream!${Back}$C_Mode" "$Red!${Back}{H}ybridization_iso." )
	ask_info="$Nline$Green Select:$Yellow ${Item}$Green to$LRed $Mode$Green image:$Reset"
	Title_list=" $Red$Mode$Green file name:$Blue $file$Nline$EraseR"
}

Path.. ()
{
	echo -n "$RestoreP"
	echo "$Title_select"
	echo "$Magenta Functions: $functions_list"
	echo -n "$EraseD"
	read -e -i "$(pwd)" -p "$Green Enter path name to$Red cd $Orange$Blink?:$Reset $SmoothBlue" Path_name
	echo -n "$Reset"
	echo -n "$RestoreP"
	
	if [ -d "$Path_name" ]
	then :
		cd "$Path_name"
		Get_files_list {,*.iso,*.img}
		unset options
		OLDIFS="$IFS";IFS=''
		while read position; do options+=("$position"); done <<<"$files_list"
		IFS="$OLDIFS"
		Title_list="$Green Path name:$Blue $(pwd)$Reset$Nline$EraseR"
	else :
		select_list[default-1]="$Path_name"
		file="$Path_name"
		
		# break
		echo -n "$SaveP"
		break 2
	fi
}
Search ()
{
	# files_list=$(ls --quoting-style=clocale "$@" 2>/dev/null)
	# dir_list=$(ls -d ./*/ 2>/dev/null)
	# ls -d  */ ..; # ls -d .. ./*/
	# ls --file-type -f  | grep /; # ls -d --file-type  */ ..
	files_list=$(ls --file-type --quoting-style=clocale "$@" 2>/dev/null)
	# find * -maxdepth 0 -type d
	# echo {,..*,*}; # echo {,*.iso,*.img}; # echo {*/,*.iso,*.img}
	# ls -al | grep '^d'
	# tree -d ;tree -d -L 1 -i --noreport
	
	if [ "$files_list" = "" ]
	then :
		files_list+=$Nline
	fi
	
	#if [ ! "$dir_list" = "" ]
	#then :
	#	files_list+=$dir_list$Nline".."
	#else :
		files_list=".$Nline""$files_list"
	#fi
	
	if [ "$files_list" = "" ]; then echo "$LRed Erorr: No "$@" files, exit$Reset$Nline";sleep 3 ;return 1;fi
}
Search_file ()
{	# standard IFS=$' \t\n'
	echo -n "$RestoreP"
	echo "$Title_select"
	echo "$Magenta Functions: $functions_list"
	echo -n "$EraseD"
	echo -n "$Reset"
	echo -n "$RestoreP"
	Search {*/*.iso,*/*.img,*.iso,*.img}
	unset options
	OLDIFS="$IFS";IFS=''
	while read position; do options+=("$position"); done <<<"$files_list"
	IFS="$OLDIFS"
	Title_list="$Green Path name:$Blue $(pwd)$Reset$Nline$EraseR"
}

Get_files_list ()
{
	files_list=$(ls --quoting-style=clocale "$@" 2>/dev/null)
	dir_list=$(ls -d --color ./*/ 2>/dev/null)
	# ls -d  */ ..; # ls -d .. ./*/
	# ls --file-type -f  | grep /; # ls -d --file-type  */ ..
	# search - ls --file-type {*/*.iso,*/*.img,*.iso,*.img} 2>/dev/null
	# find * -maxdepth 0 -type d
	# echo {,..*,*}; # echo {,*.iso,*.img}; # echo {*/,*.iso,*.img}
	# ls -al | grep '^d'
	# tree -d ;tree -d -L 1 -i --noreport
	
	if [ ! "$files_list" = "" ]
	then :
		files_list+=$Nline
	fi
	
	if [ ! "$dir_list" = "" ]
	then :
		files_list+=$dir_list$Nline".."
	else :
		files_list+=".."
	fi
	
	if [ "$files_list" = "" ]; then echo "$LRed Erorr: No "$@" files, exit$Reset$Nline";sleep 3 ;return 1;fi
}

Select_file ()
{
	file_type="{*.iso,*.img}"
	if  [ "$file" = "{S}earch_file" ]
	then :
		Search {*/*.iso,*/*.img,*.iso,*.img}
	else :
		Get_files_list {,*.iso,*.img}
	fi
	
	unset options
	OIFS="$IFS";IFS=''
	while read position; do options+=("$position"); done <<<"$files_list"
	IFS="$OIFS"
	
	# IFS='' readarray -t options <<<"$files_list"
	# OLDIFS="$IFS";IFS=$'\n'; declare -a options=($files_list); IFS="$OLDIFS"
	
	ask_info="$Nline$Green Select:$Cyan "$file_type" file$Green to$LRed write$Reset"
	options=$options keys=() default=1
	functions=("$SmoothBlue!${Back}{P}ath.." "$Cyan!${Back}{S}earch_file" "$Red!${Back}{H}ybridization_iso")
	Title_list="$Green Path name:$Blue $(pwd)$Nline$EraseR"
	ask_select
	
	Selected=${Selected#*„}
	Selected=${Selected%”*}
	if [ "$Selected" == "{Q}uit" ]; then echo " Select file {Q}uit exit"; exit 1; fi
	if [ "$Selected" == "{N}one" ]; then echo " Select file {N}one exit"; exit 1; fi
	file="$Selected"
}

Hybridization_iso ()
{
	Preselected=${Preselected#*„}
	Preselected=${Preselected%”*}
	if [ ! -f "$Preselected" ]
	then :
		echo -n "$Sbuffer"; clear
		echo "$Green Help: „Hybridization”:$Blue isohybrid -partok <iso file>:$Reset"
		echo "$Yellow modifi in place iso MBR for wirite into volume$Reset"
		echo "$Orange$Blink 1$Reset$Orange) first:$Reset$Green preselect <iso file> then press {H} for action.$Magenta"
		isohybrid --help
		read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
		echo -n "$Mbuffer"
		return 1
	else :
		echo -n "$Sbuffer"; clear
		echo "$Yellow „Hybridization”: isohybrid -partok$Blue $Preselected"
		if [[ "yes" == $(r_ask "$Orange converting iso$Blue $file$Orange MBR in place$Nline$Orange Please answer " "2" "r_key") ]]
		then :
			echo
			SttyS="$(stty size|awk '{print $1-3;}')"
			isohybrid -v -partok "$Preselected" | head -n"$SttyS"
			read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
			echo -n "$Mbuffer"
		else :
			echo -n "$Sbuffer"; clear
			echo "$Green Help: „Hybridization”:$Magenta"
			echo "$Blue „Hybridization”: isohybrid -partok <iso file>:$Reset"
			echo "$Yellow modifi in place iso MBR for wirite into volume$Reset"
			echo "$Orange Skipped.$Magenta"
			isohybrid --help
			read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
			echo -n "$Mbuffer"
		fi
	fi
}
Hybridization_iso. ()
{
	if [ -f "$file" ]
	then :
		echo -n "$Sbuffer"; clear
		echo "$Yellow „Hybridization”: isohybrid -partok$Blue $file"
		if [[ "yes" == $(r_ask "$Orange converting iso$Blue $file$Orange MBR in place$Nline$Orange Please answer " "2" "r_key") ]]
		then :
			echo
			SttyS="$(stty size|awk '{print $1-3;}')"
			isohybrid -v -partok "$file" | head -n"$SttyS"
			read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
			echo -n "$Mbuffer"
		else :
			echo -n "$Sbuffer"; clear
			echo "$Green Help: „Hybridization”:$Magenta"
			echo "$Blue „Hybridization”: isohybrid -partok <iso file>:$Reset"
			echo "$Yellow modifi in place iso MBR for wirite into volume$Reset"
			echo "$Orange Skipped.$Magenta"
			isohybrid --help
			read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
			echo -n "$Mbuffer"
		fi
	else :
		echo -n "$Sbuffer"; clear
		echo "$Green Help: „Hybridization”:$Magenta"
		echo "$Blue „Hybridization”: isohybrid -partok <iso file>:$Reset"
		echo "$Yellow modifi in place iso MBR for wirite into volume$Reset"
		echo "$Orange Press $Blink{H}$Reset$Green for action.$Magenta"
		isohybrid --help
		read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
		echo -n "$Mbuffer"
		return 1
		
	fi
}

Write_pv_progress ()
{
	local source="$1" destination="$2"
	source_size=$(du -BM --apparent-size -s "$source" | awk '{ print $1 }')
	echo "$Yellow Wait a while... writing:$Green $source $Cyan($source_size)$Green to:$Red $destination $Reset"
	if command -v dd >/dev/null 2>&1
	then :
		pv -tpreb "$source" | dd of="$destination" bs=4096 conv=notrunc,noerror
	else :
		pv -tpreb "$source" >"$destination"
	fi
}

Write_dd_progress ()
{
	local source="$1" destination="$2" Progress=$(mktemp) || return 1
	
	function cleanup
	{
		if [ -f "$Progress" ]
		then :
			rm -f "$Progress"
			# echo "Removing temp working files $Progress"
			# sleep 3
		fi
	}
	
	test $# == 2 || { echo "Usage: $0 <source> <destination>"; return 1 ;}
	test "$source" = "$destination" \
	&& { echo "<source> <destination> have to be different"; return 1 ;}
	
	source_size=$(du -BM --apparent-size -s "$source" | awk '{ print $1 }')
	echo "$Yellow Wait a while... writing:$Green $source $Cyan($source_size)$Green to:$Red $destination $Reset"
	# but with notrunc why not?
	dd bs=4096 if="$source" 2>/dev/null | dd bs=4096 of="$destination" conv=notrunc >"$Progress" 2>&1 & dd_pid=$!
	sleep 1
	
	while kill -USR1 $dd_pid >/dev/null 2>&1
	do
		progres_bar=$(tail -1 "$Progress")
		echo -n "  $progres_bar$EraseR$Creturn"; sleep 0.5
	done
	progres_bar=$(tail -1 "$Progress")
	echo "  $progres_bar$EraseR"
	cleanup
}

Ask_file_system ()
{
	  ask_info="$Nline$Green Select:$Cyan file system$Green to use for $LRed format $device$Reset"
	  options=( "ext4" "ext3" "ext2" "btrfs" "vfat" "ntfs" )
	  options=$options keys=() default=1
	  #unset functions
	  # Title_list="$Green Device:$Blue $(pwd)$Nline$EraseR"
	  ask_select
	  volume_fs=$Selected
	  if [ "$Selected" == "{Q}uit" ]; then echo "exit"; return 1; fi
	  if [ "$Selected" == "{N}one" ]; then volume_fs="skip"; fi
}

Format_vlume ()
{
	volume_fs=$(tr '[:upper:]' '[:lower:]' <<<"$volume_fs")
	if [ "$volume_fs" = "ext2" ] || [ "$volume_fs" = "ext3" ] || [ "$volume_fs" = "ext4" ]
	then L="-L"
	elif [ "$volume_fs" = "btrfs" ]
	then L="-fL"
	elif [ "$volume_fs" = "ntfs" ]
	then L="-QL"
	elif  [ "$volume_fs" = "vfat" ] || [ "$volume_fs" = "fat" ] || [ "$volume_fs" = "msdos" ]
	then L="-n"
	else :
	fi
	
	label="$file_contest_label"
	
	echo
	if ! [ -z "$L" ]
	then :
		echo "$Yellow mkfs.$volume_fs $5 $L \"${label}\" $device $Reset"
		mkfs.$volume_fs $5 $L "${label}" "$device"
	elif [ "$volume_fs" = "skip" ] || [ "$volume_fs" = "none" ]
	then :
		echo "$Yellow Skip mkfs$Reset$Nline"
	else :
		echo "$Yellow mkfs.$volume_fs $5 $device $Reset"
		mkfs.$volume_fs $5 "$device"
	fi
}

Extract_tar_cp_progress ()
{
	local source="$1" destination="$2"
	if command -v pv >/dev/null 2>&1
	then :
		if [ -d "${source}" ] && [ -d "${destination}" ]
		then :
			source_size=$(du -sb "$source" | cut -f1)
			echo
			( cd "$source" && tar cpf - . ) \
			| pv -s "$source_size" \
			| ( cd "$destination" && tar xpf - --checkpoint-action=ttyout='\033[1A %{Write,w}T (%d sec) : %t%*\r\033[1B')
		else :
			( cd "$source" && tar cpf - . ) \
			| ( cd "$destination" && tar xpf - --checkpoint-action=ttyout=' %{w,d}T (%d sec) : %t%*\r')
		fi
	else :
		if [ -d "${source}" ] && [ -d "${destination}" ]
		then :
			echo
			echo
			( cd "$source" && tar cpf - . --checkpoint-action=ttyout='\033[1A\033[1A\r %{r,Read}T (%d sec) : %t\r\033[1B\033[1B')\
			| ( cd "$destination" && tar xpf - --checkpoint-action=ttyout='\033[1A%{Write,w}T (%d sec) : %t\r\033[1B')
		fi
	fi
}
comment () {
	
	if [ "$size" \< "$free_space" ]
	then :
	Errors=$(mktemp) || return 1
	
	if [ -d "${Source}" ] && [ -d "${Destination}" ]
	then :
		( cd "${Source}" && cd .. && tar cpf - "$1" 2>"$Errors" ) | pv -s "${size}" | ( cd "${Destination}" && tar xpf - )
	else :
		( tar cpf - . "${Source}" 2>"$Errors" ) | pv -s "${size}" | ( cd "${Destination}" && tar xpf - )
	fi
	cat "$Errors"
	else :
	
	fi
	
}

Extract_cp_progress ()
{
	local source="$1" destination="$2"
	cp -r "$source"/* "$destination"
}

Write_to_volume ()
{
	if [[ "no" == $(r_ask "$Nline$Red File: $Green$file $Cyan($file_size)$Nline$Cyan$file_description $SmoothBlue $file_contest$Nline$Nline$Red Device: $LRed$device$Nline$Cyan$device_description$SmoothBlue$device_contest$Nline$warn$Red Write to device: $LRed$device " "2") || "no" == $(r_ask " $Blink$LRed> $device <$Reset$LBlue Are you$LOrange *really$Orange sure? $Red" "2") ]]
	then :
		echo "$Nline$Orange Skipped.$Reset write file: "$file" to device: "$device""
	else :
		echo
		echo "$Red Write:$Reset"
		
		if command -v pv >/dev/null 2>&1
		then :
		        Write_pv_progress "$file" "$device"
		elif command -v dd >/dev/null 2>&1
		then :
			Write_dd_progress "$file" "$device"
		else :
			echo "$LRed Erorr: no dd command, exit$Reset$Nline"; exit 1
		fi
		echo "$Yellow Wait a while... syncing disk buffers"
		sync && sleep 25
		# echo "$Green Done - $Reset"
	fi
}

Extract_to_volume ()
{
  Clean_temp ()
  {
	  { umount "$mount_dir" && rm -rf "$mount_dir" ;} \
	  || { echo "$LRed Erorr: clean temp dir "$mount_dir"$Reset$Nline" ;}
	  { umount "$extract_dir" && rm -rf  "$extract_dir" ;} \
	  || { echo "$LRed Erorr: clean temp dir "$extract_dir"$Reset$Nline" ;}
  }

	volume=$(blkid| grep "$device:") volume_description=${volume#*':'}
	if [ "$volume" = "" ]
	then echo "$LRed Erorr: for extract mode destination have to be a volme$Reset$Nline"; return 1;fi
	
	if [[ "no" == $(r_ask "$Nline$Red File: $Green$file $Cyan($file_size)$Nline$Cyan$file_description $SmoothBlue $file_contest$Nline$Nline$Red Device: $LRed$device$Nline$Cyan$device_description$SmoothBlue$device_contest$Nline$warn$Red Extract to device: $LRed$device " "2") || "no" == $(r_ask " $Blink$LRed> $device <$Reset$LBlue Are you$LOrange *really$Orange sure? $Red" "2") ]]
	then :
		echo "$Nline$Orange Skipped.$Reset Extract file: "$file" to device: "$device""
	else :
		echo
		if [ -z "$destination_fs" ]
		then :
			Ask_file_system
		else :
			volume_fs="$destination_fs"
	fi
	Format_vlume
	if ! [ $? = 0 ]
	then echo "$LRed Erorr: format vlume "$device", exit$Reset$Nline"; return 1;fi
	
	#volume_fs=${volume_description#*' TYPE="'} volume_fs=${volume_fs%%'"'*}
	volume_fs=$(blkid "$device" -o value -s TYPE)
	if [ "$volume_fs" = "" ]; then echo "$LRed Erorr: for extract mode destination have to be a volme with valid file system$Reset$Nline"; return 1;fi
	
	
	    mount_dir=$(mktemp -d)
	    if ! [ $? = 0 ]; then echo "$LRed Erorr: create temp dir, exit$Reset$Nline"; return 1;fi
	    extract_dir=$(mktemp -d)
	    if ! [ $? = 0 ]; then echo "$LRed Erorr: create temp dir, exit$Reset$Nline"; Clean_temp; return 1;fi
	    mount "$file" "$mount_dir"
	    if ! [ $? = 0 ]; then echo "$LRed Erorr: mount dir, exit$Reset$Nline"; Clean_temp; return 1;fi
	    mount "$device" "$extract_dir"
	    if ! [ $? = 0 ]; then echo "$LRed Erorr: mount dir, exit$Reset$Nline"; Clean_temp; return 1;fi
	
	    source="$mount_dir"
	    destination="$extract_dir"
	    source_size=$(du -BM --apparent-size -s "$source" | awk '{ print $1 }')
	
	    echo "$Red Extract:$Reset"
	    echo "$Yellow Wait a while... extracting:$Green $file $Cyan($source_size)$Green to:$Red $device $Reset"
	
	
	if command -v tar >/dev/null 2>&1
	then :
		Extract_tar_cp_progress  "$source" "$destination"
	else :
		Extract_cp_progress "$source" "$destination"
	fi
	
	
	if ! [ $? = 0 ]
	then echo "$LRed Erorr: extract files to "$device", exit$Reset$Nline"; Clean_temp; return 1
	else :
		volume_Label=$(blkid "$device" -o value -s LABEL)
		if ! [ "$volume_Label" = "$file_contest_label" ]
		then :
			echo "$Yellow Labels are different!$Nline$Green Volume label:$SmoBlue „$volume_Label”$Reset$Nline$Green Image label :$SmoBlue „$file_contest_label”$Reset"
		fi
		# echo "$Green Done - $Reset"
		
		Clean_temp
	fi
	fi
}

 ###


Begin "$@"

file="$1" device="$2"
Mode="{W}rite_mode" C_Mode="{E}xtract_mode"
if ! [ -z "$3" ]
then :
	Mode=$(tr '[:upper:]' '[:lower:]' <<<"$3")
	if [ "$Mode" = "e" ] || [ "$Mode" = "extract" ]
	then Mode="{E}xtract_mode" C_Mode="{W}rite_mode"
	else Mode="{W}rite_mode" C_Mode="{E}xtract_mode"
	fi
fi
if ! [ -z "$4" ]
then :
	destination_fs=$(tr '[:upper:]' '[:lower:]' <<<"$4")
fi

if [ -d "$file" ]
then :
	cd "$file"
	unset file
fi

if [ -z "$file" ]
then :
	echo -n "$SaveP"
	while true
	do
	
	if [ "$file" = "{P}ath.." ]
	then :
		echo -n "$RestoreP"
		unset file
		Path..
		Select_file
	elif [ "$file" = "{H}ybridization_iso" ]
	then :
		echo -n "$RestoreP"
		echo -n "$Sbuffer"; clear
		echo "$Green Help: „Hybridization”:$Magenta"
		echo "$Blue „Hybridization”: isohybrid -partok <iso file>:$Reset"
		echo "$Yellow modifi in place iso MBR for wirite into volume$Reset"
		echo "$Orange$Blink 1$Reset$Orange) first:$Reset$Green preselect <iso file> then press {H} for action.$Magenta"
		isohybrid --help
		read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
		echo -n "$Mbuffer"
		Select_file
	elif [ "$file" = "{S}earch_file" ]
	then :
	        echo -n "$RestoreP"
		Select_file
	elif [ "$file" = ".." ]
	then :
	        echo -n "$RestoreP"
		cd ..
		Select_file
	elif [ -d "$file" ]
	then :
		echo -n "$RestoreP"
		cd "$file"
		Select_file
	elif [ -f "$file" ]
	then :
		break
	else :
		echo -n "$RestoreP"
		Select_file
	fi
	done
fi

if ! [ -f "$file" ]; then echo "$Red Error: file $Cyan"$file"$Red do not exist$Reset."; return 1; fi

if [ "$file" ] && [ -z "$device" ]
then :
	echo -n "$SaveP"
	device="{R}escan"
	
	while true
	do
		if [ "$Selected" == "{Q}uit" ]; then echo "Exit Select device"; exit 1; fi
		if [ "$Selected" == "{N}one" ]; then echo "Exit Select device"; exit 1; fi
		if [ "$device" = "{R}escan" ] || [ "$device" = "{V}olumes" ] || [ "$device" = "{H}ybridization_iso." ] || [ "$device" = "{E}xtract_mode" ] || [ "$device" = "{W}rite_mode" ]
		then :
			if [ "$again" = "15" ]
			then :
			echo "$LRed Erorr: ???, exit$Nline$Reset"
			return 1
			fi
			again=$[$again+1]
			if [ "$device" = "{R}escan" ]
			then :
				echo -n "$RestoreP"
				Select_device
				
			elif [ "$device" = "{V}olumes" ]
			then :
				echo -n "$RestoreP"
				Select_volume
				
			elif [ "$device" = "{E}xtract_mode" ]
			then :
				echo -n "$RestoreP"
				Mode="{E}xtract_mode"
				C_Mode="{W}rite_mode"
				Select_volume
				
			elif [ "$device" = "{W}rite_mode" ]
			then :
				echo -n "$RestoreP"
				Mode="{W}rite_mode"
				C_Mode="{E}xtract_mode"
				Select_volume
				
			elif [ "$device" = "{H}ybridization_iso." ]
			then :
				echo -n "$RestoreP"
				echo -n "$Sbuffer"; clear
				echo "$Green Help: „Hybridization”:$Magenta"
				isohybrid --help
				echo "$Blue isohybrid -partok <iso file>:$Reset"
				echo "$Yellow modifi in place iso MBR for wirite into volume$Reset"
				echo -n "$Orange$Blink *$Orange Press:$Reset$Green {H} for action"
				read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
				echo -n "$Mbuffer"
				Select_volume
			else :
				echo -n "$RestoreP"
				Select_device
			fi
			
		else :
			break
		fi
	done
	
fi

if ! [ -b "$device" ]; then echo "$Red Error: $Yellow"$device"$Red is not block device$Reset."; return 1; fi

if [ "$file" ] && [ "$device" ]
then :
	file_size=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		wc -c <"$file" | awk '{result = $1'${count}'
		printf "'${precision}' '${unit}'",result}'
		)
		
	file_contest=$(fdisk -l "$file") file_description=$(blkid "$file") file_description=${file_description#*':'}
	file_contest_label=${file_description#*' LABEL="'} file_contest_label=${file_contest_label%%'"'*}
	# file_contest_label=$(blkid "$file" -o value -s LABEL)
	device_contest=$(fdisk -l "$device") device_description=$(blkid "$device") device_description=${device_description#*':'}
	
	
	if [ "$device" = "/dev/sda" ]
	then :
		warn="$Red You give your first device $Blink$LRed> "$device" <$Red to write. Are you$LOrange *really* sure? $Reset$Nline"
	else :
		warn=''
	fi
	if [ "$Mode" = "{W}rite_mode" ]
	then :
		Write_to_volume
	elif [ "$Mode" = "{E}xtract_mode" ]
	then :
		Extract_to_volume
	else :
	fi
fi

Elapsed_time=$((`date +%s` - $Start_time))
echo "$Green Done $LWhite- Finished in $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec"
}

Begin "$@"
