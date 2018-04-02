#!/bin/bash
# fill_entry.sh
# fields onto the screen
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
## Font attributes ##
Bold=""$'\033[1m'"" Faint=""$'\033[2m'"" Italic=""$'\033[3m'"" Underline=""$'\033[4m'""
Blink=""$'\033[5m'"" Reverse=""$'\033[7m'"" Strike=""$'\033[9m'"" # (on monochrome display adapter only)
# Disable blinking text. echo -en '\E[25m'
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

if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
	Yellow="$LYellow"
fi

}; Color_terminal_variables

Fill_form ()
{

function Print_form ()
{
   View_port_position ${RPosition} ${CPosition}
   echo -n "$EraseD"
   echo "${form[@]}"
}

# Initialise screen
echo -n "$EraseD"
echo "${form[@]}"
echo
echo
(( form_lines = ${#form[@]} + 3 ))
Linesup "$form_lines"
Get_View_port_position

# Loop round each entry until filled, moving cursor to correct entry point, and
# repainting the screen to show filled in variables

while [ ${#Docket_number} -lt 1 ]
do :	
	View_port_position $(( RPosition+4 )) $(( CPosition+18 ))
	read Docket_number
	form[4]=" Docket Number : $Docket_number$Nline"
	Print_form
done

while [ ${#Supplier_code} -lt 1 ]
do :	
	View_port_position $(( RPosition+5 )) $(( CPosition+18 ))
	read Supplier_code
	form[5]=" Supplier Code : $Supplier_code$Nline"
	Print_form
done

while [ ${#Carrier} -lt 1 ]
do :	
	View_port_position $(( RPosition+6 )) $(( CPosition+18 ))
	read Carrier
	form[6]=" Carrier       : $Carrier$Nline"
	Print_form
done

while [ ${#Goods_code} -lt 1 ]
do :	
	View_port_position $(( RPosition+7 )) $(( CPosition+18 ))
	read Goods_code
	form[7]=" Goods Code    : $Goods_code$Nline"
	Print_form
done

while [ ${#Goods_name} -lt 1 ]
do :	
	View_port_position $((${RPosition}+8)) $(( CPosition+18 ))
	read Goods_name
	form[8]=" Goods Name    : $Goods_name$Nline"
	Print_form
done

while [ ${#Quantity} -lt 1 ]
do :	
	View_port_position $((${RPosition}+9)) $(( CPosition+18 ))
	read Quantity
	form[9]=" Quantity      : $Quantity$Nline"
	Print_form
done

while [ ${#Measure} -lt 1 ]
do :	
	View_port_position $((${RPosition}+10)) $(( CPosition+18 ))
	read Measure
	form[10]=" Measure       : $Measure$Nline"
	Print_form
	done

while [ ${#Received_by} -lt 1 ]
do :	
	
	View_port_position $((${RPosition}+11)) $(( CPosition+18 ))
	read Received_by
	form[11]=" Received by   : $Received_by$Nline"
	Print_form
done

function Calculate ()
{
   result="$Entry_date#$Docket_number#$Supplier_code#$Carrier#$Goods_code#$Goods_name#$Quantity#$Measure#$Received_by"
}

# Request ok
View_port_position $((${RPosition}+14)) $((${CPosition}+1))
echo -n "ok to akcept fill (y or n):"
read ok


ok=`echo $ok | tr a-z A-Z`
if [ "$ok" = "Y" ]
then
   Calculate
   echo $result

fi

}

# Initialise variables

Entry_date=$(f_date)
Docket_number=""
Supplier_code=""
Carrier=""
Goods_code=""
Goods_name=""
Quantity=""
Measure=""
Received_by=""

Init_form ()
{
form=(
"$Nline"
" Title: ${#form[@]}$Nline"
"$Nline"
" Entry Date    : $Entry_date$Nline"
" Docket Number : $Docket_number$Nline"
" Supplier Code : $Supplier_code$Nline"
" Carrier       : $Carrier$Nline"
" Goods Code    : $Goods_code$Nline"
" Goods Name    : $Goods_name$Nline"
" Quantity      : $Quantity$Nline"
" Measure       : $Measure$Nline"
" Received by   : $Received_by$Nline"
"$Nline"
)
}
Init_form
form[1]=" Title: ${#form[@]}$Nline"

Fill_form




