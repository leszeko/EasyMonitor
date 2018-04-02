#!/bin/bash
# encoding: utf-8
# set -v
# set -m

Info_data ()
{
    Name=" # disk_tools.sh"
 Version=" # v1.1,.. \"${White}B${LWhite}l${Red}a${Cyan}c${LRed}k$Magenta|$Orange: ${Yellow}Terminal${LGreen}\" ${LWhite}B$Magenta&"$Orange"C$Orange Test beta script$Reset"
  Author=" # Leszek Ostachowski® (© 2016 2017) @GPL V2"
 Purpose=" # Collect basic disk tools$Nline"
Purpose+=" #"
 Worning=" # To do it as $Red\$${Magenta}root$Reset"
   Usage=" # Usage: bash disk_tools.sh. Arguments - Click on script"
Log=''
Dependencies=( fdisk tar blkid lsblk grep awk tr rsync readlink cat )
Optional_dependences=( dd pv tilde )
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

Begin () {

Traps "$@"
Color_terminal_variables
Info_data
Prepare_check_environment "$@"
Print_info
Run_as_root "$@"
Test_dependencies
Install_missing

Ask_device_name

}
##################
Traps ()
{
	Start_time=`date +%s`
	Finished="No"
	The_end="No"
	CTL_C_pressed="No"
	
	trap 'EXIT_S' EXIT # 0
	trap 'SIGHUP_S' SIGHUP # 1
	trap 'CTL_C' SIGINT # 2
	trap 'SIGQUIT_S' SIGQUIT # 3
	trap 'SIGTERM_S' SIGTERM
	trap 'SIGWINCH_S' SIGWINCH
	# trap 'ERR_S ${LINENO} ${?}' ERR
	#trap 'RETURN_S ${LINENO} ${?}' RETURN
	#trap ':' SIGCHLD
	
	Run_as_root ()
	{
		if ! [ $(id -u) = 0 ]
		then :
		      echo "$Nline$Orange This $Cyan$(basename "$0")$Orange script must be run with root privileges.$Reset"
		      echo "$Cream su -c \"/bin/bash \"$(basename "$0")\" $*\"$Reset"
		      Finished=""
		      Child () { CTL_C_pressed="Yes" The_end="Yes" ;}; export -f Child
		      su -c "/bin/bash \"$0\" $*"
		      exit $?
		fi
	Child >/dev/null 2>&1
	}
	
	CTL_C ()
	{
		if [ "$CTL_C_pressed" = "Yes" ]
		then :
		        #ccho  "$Cyan"; echo "SIGINT"; ccho "$Reset"
		        #sleep_key
			exit
		else :
			ccho  "$Cyan"; echo "SIGINT"; ccho "$Reset"
			CTL_C_pressed="Yes"
			echo "$Nline$EraseR$Cyan SIGINT: CTL-C Pressed $CTL_C_pressed$Reset"
			exit
		fi
		
	}
	
	SIGHUP_S ()
	{
	 exit
	}
	
	SIGQUIT_S ()
	{
		ccho  "$Cyan"; echo "SIGQUIT - Ctrl-\ - Pressed"; ccho "$Reset"
		
	 exit
	}
	
	SIGTERM_S ()
	{
		ccho  "$Cyan"; echo "SIGTERM_S Pressed"; ccho "$Reset"
		if [[ "no" == $(r_ask "$SmoothBlue Continue -$Green [Y]es$SmoothBlue or$Orange [N]no$Red exit!$Orange : Please answer - " "2") ]]
		then :	
			echo "$Red - exit! $Reset"
			sleep 5
			exit
		else :	
			echo "$Green - OK Continue $Reset"
		fi
		
	}
	
	EXIT_S ()
	{
		Umount_source_destination
		
		Elapsed_time=$((`date +%s` - $Start_time))
		if [ "$Finished" = "Yes" ]
		then :
			[ "$No_log" != "yes" ] && \
			{
			echo "$Cyan"
			MESSAGE="[ $(( Nr+=1 )). VIEW LOG ]$Reset"
			Bar "$MESSAGE"
			
			echo "$Nline$LGreen$Blink $Finished$Reset$Cream finished in $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset"
			echo "$Log"
			}
			Finished=""
			
		elif [ "$Finished" = "No" ]
		then :
			[ "$No_log" != "yes" ] && \
			{
			echo "$Cyan"
			MESSAGE="[ $(( Nr+=1 )). VIEW LOG ]$Reset"
			Bar "$MESSAGE"
			
			echo "$Nline$Red$Blink $Finished$Reset$Cream finished in $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset"
			echo "$Log"
			}
			Finished=""
		fi
		
		if [ "$The_end" = "No" ]
		then :
			[ "$No_log" != "yes" ] && \
			{
			echo "$Cyan"
			MESSAGE="[ $(( Nr+=1 )).$Red EXIT:$Cyan ]$Reset"
			Bar "$MESSAGE"
			
			echo "$Log"
			}
			The_end="Yes"
			#echo -n "$EraseR$Cyan EXIT:$Reset"
			echo "$Green$Blink # The end # $Reset$Cream of: $(basename "$0").#$LBlue `date` $Reset"
		fi
		exit
	}
	Trace ()
	{
	echo "Press CTRL+C to proceed."
	trap "pkill -f 'sleep 1h'" INT
	trap "set +x ; sleep 1h ; set -x" DEBUG
	set -x
	}
	
	SIGWINCH_S ()
	{
	Get_View_port_size
	[ "$Vcolumns" -lt 120 ] && Terminal_size $Vlines 120
	sleep 0.1
	}
	
	
	
function ERR_S ()
{
        Script="${0##*/}"        # equals to script name
        Last_line="$1"            # argument 1: last line of error occurence
        Last_error="$2"             # argument 2: error code of last command
# BASH_LINENO
# An array variable whose members are the line numbers in source files where
# each corresponding member of FUNCNAME was invoked. ${BASH_LINENO[$i]}
# is the line number in the source file (${BASH_SOURCE[$i+1]})
# where ${FUNCNAME[$i]} was called (or ${BASH_LINENO[$i-1]}
# if referenced within another shell function).
# Use LINENO to obtain the current line number.
echo "$Magenta
 Script          : "${Script}"
 Last command    : "$BASH_COMMAND"
 Return last err : "${Last_error}"
 Line no         : "${Last_line}"
 Bash line no    : "${BASH_LINENO[*]}"
 $Reset
"
# do additional processing: send email or SNMP trap, write result to database, etc.

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
	echo -n "$Cursor_r_block"
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
	
	if command -v konsole >/dev/null 2>&1
	then :
		konsole --hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v mate-terminal >/dev/null 2>&1
	then :
		mate-terminal -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v lxterminal >/dev/null 2>&1
	then :
		lxterminal -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif  command -v guake >/dev/null 2>&1
	then :
		guake -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif  command -v terminator >/dev/null 2>&1
	then :
		terminator -e "/bin/bash \"$0\" \"$@\""
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
	elif command -v urxvt >/dev/null 2>&1
	then :
		urxvt -hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v roxterm >/dev/null 2>&1
	then :
		roxterm -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v Eterm >/dev/null 2>&1
	then :
		Eterm -e " \"$0\" \"$@\""
		exit $?
	elif  command -v tilda >/dev/null 2>&1
	then :
		tilda -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v xiterm >/dev/null 2>&1
	then :
		xiterm -e $0
		exit $?
	elif command -v xterm >/dev/null 2>&1
	then :
		xterm -hold -e "/bin/bash \"$0\" \"$@\""
		exit $?
	elif command -v fbterm >/dev/null 2>&1
	then :
		fbterm "/bin/bash \"$0\" \"$@\""
		exit $?
	else :
		echo "$Red Error: This script "$0" needs terminal, exit 2$Reset" >&2
		exit 2
	fi
	fi
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	workdir="${BASH_SOURCE%/*}"
	if [[ ! -d "$workdir" ]]; then workdir="$PWD"; fi;
	cd "$workdir"

	if [ "$1" ]
	then :	
		if [ "$1" = "-v" ]
		then :	
			Print_info
			echo "$Nline$Green$Licence$Reset"
			No_log=yes
			exit 0
		fi
	fi

if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi

}

Print_info ()
{
	SIGWINCH_S
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
	do :	
		if ok_command=$(command -v $package 2>/dev/null)
		then :
			Is_software+="$Nline $(( ci+=1 )): $ok_command: $($ok_command --version 2>/dev/null)"
		
		else :
			No_software+="$Nline $(( cn+=1 )): $package"
			To_install+="$package "
		fi
	done
	
	for package in ${Optional_dependences[@]}
	do :	
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
	do :
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
			 {
			 [[ "$REPLY" == "$select_11" ]] || [[ "$REPLY" == "$key1" ]] && echo -n "$RestoreP$EraseR$Yellow*$select_1$Reset" >&2 && echo -n "$select_11" && break
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

function r_ask_select ()  # v1.5 by Leszek Ostachowski® (©2017) @GPL V2
{
	local info=$1 default=$2 pselected="$2" select1="$3" select2="$4" select3="$5" color_s="$6" color_n="$7" color_u="$8" color_3="$9"
	# before call set time out or time_out=0 to display loop
	Debug ()
	{
	echo "$Nline$default $select_1 ${select_1} $select_2 $select_3 $selekts $loop_time_out" >&2
	echo -n "$Nline$Nline/${#key}/HEX=$EraseR" >&2
	echo "$key" | hexdump -v -e '"x" 1/1 "%02x" " "' >&2
	echo "$Nline$EraseR$Nline$EraseR$Nline$EraseR$MoveU/Key=/\"$key\"/" >&2
	}
	
	[[ "$default" == '' ]] && default="1" pselected="1"
	
	[[ ! -z "$time_out" ]]  && loop_time_out=$time_out
	
	[[ "$select1" == '' ]] && select1="{Y}es"               ; declare -l u_select1="${select1}"; select_1="${select1//['{'-'}']/}" key1=${u_select1##*'{'} key1=${key1%'}'*}
	[[ "$select2" == '' ]] && select2="{N}o" selekts=2      ; declare -l u_select2="${select2}"; select_2="${select2//['{'-'}']/}" key2=${u_select2##*'{'} key2=${key2%'}'*}
	[[ "$select3" == '' ]] || select[3]="$select3" selekts=3; declare -l u_select3="${select3}"; select_3="${select3//['{'-'}']/}" key3=${u_select3##*'{'} key3=${key3%'}'*}
	
	[[ "$color_s" == '' ]] && color_s="${Green}*"
	[[ "$color_n" == '' ]] && color_n="${Red}"
	[[ "$color_3" == '' ]] && color_3="${Cream}"
	[[ "$selekts" == '3' ]] && color_u="${Cream}" select3="${SmoothBlue}or $color_s$select3" u_select3="${SmoothBlue}or $color_3$u_select3"
	[[ "$again" == '' ]] && again="10"
	
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
			IFS= read -r -N2 -t0.01 -s rest; key+="$rest"
			# case arrow keys
			[[ "$key" == $'\033[A' ]] && { (( default++ )); [ $default -gt $selekts ] && default=$selekts ;} # Up - mwhell
			[[ "$key" == $'\033[C' ]] && { (( default++ )); [ $default -gt $selekts ] && default=$selekts ;} # Right
			[[ "$key" == $'\033[B' ]] && { (( default-- )); [ $default -le "0" ] && default=1 ;} # Down - mwhell
			[[ "$key" == $'\033[D' ]] && { (( default-- )); [ $default -le "0" ] && default=1 ;} # Left
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

ask_select ()  # v1.6 by Leszek Ostachowski® (©2017) @GPL V2
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
	
	Debug ()
	{
		echo -n "$Nline$Nline/${#key}/HEX=$EraseR"
		echo "$key" | hexdump -v -e '"x" 1/1 "%02x" " "'
		echo "$Nline$EraseR$Nline$EraseR$Nline$EraseR$MoveU/Key=/\"$key\"/"
	}
	
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo ""; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
	# Time out loop
	{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
	###
	# clear
	# Main loop
	while true
	do :	
	
	loop_time_out=$[$loop_time_out-1]
	
	if ! [[ -z ${functions[@]} ]]
	then :	
		unset functions_list
		unset tigers
		for (( x=${#functions[@]}, add=1; x>0; x--, add++ ))
		do :	
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
	
	echo "${Title_select}$EraseR"
	echo "$Magenta Functions: $functions_list$EraseR"
	echo "$Title_list$EraseR"
	
	# Print list loop
	#list_lenght=$(( ${#select_list[@]} ))
	list_lenght=$(( ${#options[@]} ))
	if (( "$list_lenght">"$Vlines"-9  ))
	then :	
		(( list_lenght="$Vlines"-9 ))
	fi
	View_port_size=$(stty size); OLDIFS="$IFS"; IFS=' ' View_size=($View_port_size); IFS="$OLDIFS"; Vlines=${View_size[0]} Vcolumns=${View_size[1]}
	trim=$(( ${Vcolumns} - 4 ))
	for (( x="$list_lenght"; x>0; x-- ))
	do :	
		if [ "$[default]" = "$x" ]
		then :	# Change color; get cursor position
			Get_View_port_position
			#echo -n ""$'\033[6n'""; read -sdR POS; CURPOS=${POS#*[}; echo -n "$Creturn" # hang terminology
			printf "$Green$Blink%3s$Reset$Green)" " $x"
			printf "%.*s$Reset$EraseR\n" "$trim" " ${select_list[$x-1]}"
		else :
			printf "$Reset%3s)" " $x"
			printf "%.*s$Reset$EraseR\n" "$trim" "  ${select_list[$x-1]}"
			
		fi
		
	done
	
	# and print Preselected
	Message="$EraseR$Nline$Orange Preselected$Yellow$Blink:$Green ${select_list[$default-1]%%:*}$Yellow$Blink<:,$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink?:$Reset$EraseR"
	printf "%s\n" "$Message"
	# print time out and cursor position
	
	Message=" Starting in $loop_time_out seconds...; ${VPosition}"
	printf "%.*s$EraseR" "$(( ${Vcolumns} - 1 ))" "$Message"
	
	IFS= read -s -N1 -t1 key
	# check key
	# if \x1b is the start of an escape sequence
	if [ "$key" == $'\033' ]
	then : # Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
		IFS= read -r -N2 -t0.01 -s rest; key+="$rest"
		# case arrow keys
		[ "$key" == $'\033[A' ] && { (( default++ )); [ $default -gt $(( ${#options[@]} )) ] && default=1 ;}       # Up
		[ "$key" == $'\033[C' ] && { (( default++ )); [ $default -gt $(( ${#select_list[@]}-1 )) ] && default=1 ;} # Right
		[ "$key" == $'\033[B' ] && { (( default-- )); [ $default -le 0 ] && default=$(( ${#options[@]} )) ;}       # Down
		[ "$key" == $'\033[D' ] && { (( default-- )); [ $default -le 0 ] && default=$(( ${#select_list[@]}-1 )) ;} # Left
		
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
	   loop_time_out=$time_out
	   echo "$Procedure;"  "$Preselected;"$Reset #; sleep 6
	   #echo -n "$Start_wrap"
	   "$Procedure"
	   #echo "$Stop_wrap"
	   unset Procedure
	 }
	done
	}
	# Debug # uncomment to call
	# if space key
	[[ "$key" == $'\x20' ]] && { let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi ;}  # Right
	
	# case Quit, Enter, time out
	if   [ "$key" = "$(( ${#select_list[@]}-1 ))" ] || [ "$key" = $'n' ]; then default=$(( ${#select_list[@]}-1 )); break
	elif [ "$key" == $'\x0a' ] || [ "$key" = "$(( ${#select_list[@]} ))" ] || [ "$key" = $'Enter' ]; then break
	elif [ "$loop_time_out" = 0 ] ; then break
	fi
	echo -n "$EraseD"
	echo -n "$RestoreP"
	done
	#echo -n "$Start_wrap"
	
	# calculate result
	Selected="${select_list[default-1]##*$'!\b'}"
	Selected=${Selected[@]#*;*m}
	Selected=${Selected[@]%%$'\033'[*}
	#Selected="${Selected[@]##*$': '}"
	#Selected="${Selected[@]%%:*}"
	echo "$Nline Akcepted: \"${Selected}\"" #; sleep 5
	unset time_out
	unset functions
	
}

Print_in_columns ()
	{ #  e.g.  Print_in_columns  spacing=2 #  left_margin=6 number=yes separator='|' spacing=3
	echo -n "$Stop_wrap"
	Get_View_port_size
	echo "$info$EraseR$Nline$EraseR"
	trim_length=$(( $Vcolumns ))
	local Array=("${list[@]}") length=${#list[@]} Erase_U=''
	local position_nr=0 line=0 col=0 NL=''
	local prefix=${#Array[@]}
	prefix="$prefix" prefix=${#prefix}
	local left_margin=${left_margin:-1} prefix=${prefix:-0} padding=${spacing:-2} separator=${separator:-'|'}
	local terminal_Width=$(( ${Vcolumns:-80} - $left_margin ))
	## Calculate the length of the longest item in Array
	local max_length=$(( $(echo "${Array[*]/%/$'\n'}"|wc -L)+$padding ))
	# max_length=1
	# for String in "${Array[@]}"
	# do :
	# 	[ ${#String} -gt ${max_length} ] && max_length=${#String}
	# done
	local max_col_length=$(( $max_length+$padding+$prefix+${#separator} ))
	#echo -n "$Mbuffer""$Stop_wrap"
	#[ $(( $max_col_length )) -gt $(( $Vcolumns - 15 )) ] && max_length=$(( $Vcolumns-$left_margin-$padding-$prefix-${#separator} )) && echo -n "$Sbuffer""$Stop_wrap" #&&  Erase_U="$Home"
	
	max_columns=$(( $terminal_Width / $max_col_length ))
	[ $max_columns = 0 ] && max_columns=1 columns=1 length=${Vlines}
	[ $length -gt $max_columns ] && lines=$(( $length / $max_columns )) || lines=1
	[ $lines -gt 1  ] && [ $(( $length % $max_columns )) != 0 ] && (( lines++ ))
	[ $(( $length - $max_columns )) -lt 0 ] && (( columns = $length )) || (( columns = $max_columns ))
	[ $(($Vlines*$columns)) -lt $length ] && (( length = $Vlines*$columns ))
	# position=R*C+P]
	for (( field=0; field<$length; field++))
	do :
		
		[[ $col == 0 ]] && { echo -n "$Reset"; printf "$NL%*s" "$left_margin"; (( line++ )); NL=$separator$EraseR$'\n' ;} # add newlines from now on...
		#sleep 0.1
		(( position_nr++ )); (( Cnr =  ( ($col) % ($columns+ 1) )+1 )) ;(( nr = (Cnr)*line )) # (( number =  ( ($col ) % ($columns+ 1) )+1   ))
		[ "$position_nr" = "$((suggest+1))" ] \
		&& {  echo -n "$Green$Blink"; printf "%${prefix}s$Reset$Green$separator" "$position_nr"; printf "%-*s$Reset" "$max_length" "${Array[$field]}" ;} \
		|| { printf "%${prefix}s$separator" "$position_nr"; printf "%-*s" "$max_length" " ${Array[$field]}" ;}
		#sleep 0.05
		(( col = ($col + 1) % $columns ))
		# || { printf "%${prefix}s$separator" "$position_nr"; printf "%-*s" "$max_length" " ${Array[$field}" ;}
	done
	printf "$NL"
	(( line+3 ))
	echo "$EraseR"; Linesup $line;Linesdn $line
	#echo -n "max_length $max_length max_col_length $max_col_length columns $columns";sleep 4
	Linesup $line;Linesup 4;echo -n "$SaveP";Linesdn $(( line+2 ))
	
	Message=$(printf "suggest $suggest+1 length $length lines $lines columns $columns max columns $max_columns $max_length=$Vcolumns")
	String_length=${#Message}
	# Linesup 1; printf "$Creturn$Yellow$Faint%*.*s$EraseR$Reset\n" "0" "$trim_length" "$Message"
	echo -n "$Start_wrap"
	}
	
Select_list () # v1.6 by Leszek Ostachowski® (©2017) @GPL V2
{
	# Before call fill
	# ${list[]};
	local info="$1" suggest="$2" char= rest= length=
	
	[ "$suggest" = '' ] && suggest=${#list[@]} || suggest=$suggest-1
	#echo "${list[@]} ${#list[@]} $suggest"
	answer="${list[$suggest]}"
	unset Selected
	
	#  The -v option causes hexdump to display all input data. -e, --format format_string
	Debug () { Linesup 1; printf "\r$Yellow hexdump > "; echo -en "${1}" |  hexdump -v -e '"|" 1/1 "%02_c" " "' | tr '\n' ';'; echo -n "$Reset$EraseR" ;read -r -s -N1 sleep;}
	
	
	# Initial print
	Print_in_columns "${list[@]}"
	trim_length=$(( $Vcolumns ))
	#echo -n "$Stop_wrap"
	printf "$Creturn$SmoothBlue Preselected$Orange$Blink:$Reset$Green ${answer}$Yellow *$Magenta [$((suggest+1))-${#list[@]}]$Orange and {E}nter for confirm$Blink?:$Reset$EraseR"
	
	Print_selection () # declare Print_selection for SIGWINCH signal
	{
	echo -n "$RestoreP"
	Print_in_columns "${list[@]}"
	#echo -n "$Stop_wrap"
	printf "\r$SmoothBlue Preselected$Orange$Blink:$Reset$Green ${answer}$Yellow$Blink<:$Orange Select $Magenta[$((suggest+1))-${#list[@]}]$Orange and {E}nter for confirm$Blink?:$Reset$EraseR"
	echo -n "$EraseD"
	}
	trap 'SIGWINCH_S; Print_selection ' SIGWINCH
	
	# Main read print loop
	while IFS= read -r -s -N1 char
	do
	# Debug "$char"
	if [ "$char" = $'\x0a' ]
	then :	# ENTER pressed
		# printf "\n${answer}\n"
		Selected=${answer}
		break
	fi
	
	[ "$char" = $'\t' ] && { answer="${list[$suggest]}" char='' ;} # completion
	[ "$char" = $'\x20' ] && { char=$'\033' rest=$'[B';} # if space key -> # Down
	
	if [ "${char[0]}" = $'\033' ]
	then :	# Esc sequence # Read rest sequence
		[ "$rest" = '' ] && { IFS= read -r -s -t0.01 -N2 rest ;}
		char+="$rest"
		
		# Debug "$char"
		length="${#list[@]}"
		[ "$char" == $'\033[A' ] && { [ $(( $suggest )) -eq $(( $length )) ] && (( suggest-- )) || { (( suggest=$suggest-$columns )); [ $(( $suggest )) -lt 0 ] && (( suggest=($suggest+$columns+$columns+1)%$columns )) ;};} # Up
		[ "$char" == $'\033[B' ] && { (( suggest=$suggest+$columns )); [ $(( $suggest )) -gt $(( $length )) ] && (( suggest=($suggest+1-$columns)%$columns )) ;} # Down
		[ "$char" == $'\033[C' ] && (( suggest++ )) # Right
		[ "$char" == $'\033[D' ] && (( suggest-- )) # Left
		[ $suggest -gt $length ] && suggest=0
		[ $suggest -lt 0 ] && suggest=$length
		
		[ "$char" = $'\033' ] && { read -s -N1 -t1 key ;} 	# wait while for twice Esc
		[ "$key" = $'\033' ] && Exit 				# Esc Esc pressed
		
		if [ "$char" = $'\033' ]
		then :	# Esc
			echo
			Command ()
			{
			 while :; do read -e -p $(pwd )\>\  line
			 (( nline++ ))
			 [[ ${line} == "exit" ]] && break
			 [[ ${line} == '' ]] && break
			 history -s ${line}
			 /bin/bash -c "${line}"
			 done
			}
			Command
			#Get_View_port_position
			#echo $nline $((${Vlines})) $((${Vcolumns}))
			#View_port_position "(( ${Vlines}-nline ))" "(( ${Vcolumns} ))"
		fi
		
		[ "$char" == $'\033[3' ] && suggest=${#list[@]} # if Delete
		
		answer="${list[$suggest]}" char='' rest='' key=''
		IFS= read -r -s -t0.01 clearbuffer
	fi
	
	if [ "$char" == $'\x7f' ]
	then :  # Backspace was pressed; # Remove last char from output variable.
		[[ -n "$answer" ]] && answer="${answer%?}"
		
	else :  # Add typed char to output variable.
		answer+="$char"
		
	fi
	# completion
	check () { Linesup 1; echo "$Creturn;check$1 $answer;suggest |$suggest|{"${list[$suggest]}"} ;$EraseR";sleep_key ;}
	#check 0
	for (( suggest=0; suggest<=${#list[@]}; suggest++))
	do :
		if [[ "${list[$suggest]}" == "$answer"* ]]
		then :
			[[ "$answer" = "" ]] && suggest=${#list[@]}
			#check 1
			break
		else :
			[[ "$suggest" = "${#list[@]}" ]] && suggest=-1 && [[ -n "$answer" ]] && answer="${answer%?}"
			#check 2
		fi
		
	done
	#check 3
	Print_selection
	
	done
	
	#echo -n "$Start_wrap"
	trap - SIGWINCH
	trap 'SIGWINCH_S' SIGWINCH
	# calculate result
	
	unset answer
	echo "$Nline Akcepted: \"${Selected}\"$Reset" #; sleep 5
	
}

Exit ()
{
Umount_source_destination
Log+="$LRed Selected: „Exit”"
exit
}

Get_file_list ()
{
	list=$(ls -T 8 --sort=time ls -d $File_Type 2>/dev/null)
	OLDIFS="$IFS"
	IFS=$'\n' #IFS=$' \t\n'
	list=( ${list} )
	IFS="$OLDIFS"
}


Get_volumes_list ()
{
	if command -v lsblk >/dev/null 2>&1
	then :
		Volumes_list=$(lsblk -l -p -a --output NAME,LABEL,FSTYPE,SIZE,TYPE,TRAN 2>/dev/null|grep -e 'part'|awk '{ sub(/ /,": "); print }')
		if [ "$Volumes_list" = "" ]
		then :	
			echo "$LRed Erorr: lsblk, exit$Reset$Nline"
			exit 1
		fi
		
	elif command -v fdisk >/dev/null 2>&1
	then :
		Volumes_list=$(fdisk -l 2>/dev/null|grep '^/'|awk '{ sub(/ /,": "); print }')
		if [ "$Volumes_list" = "" ]
		then :	
			echo "$LRed Erorr: fdisk, exit$Reset$Nline"
			exit 1
		fi
	else :
		echo "$LRed Erorr: no lsblk or fdisk command, exit$Reset$Nline"; exit 1
	fi
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

Rescan ()
{
	 Get_volumes_list
	 OLDIFS="$IFS"
	 IFS=$'\n' #IFS=$' \t\n'
	 options=(${Volumes_list[@]})
	 select_list=(${options[@]})
	 select_list+=(${functions[@]})
	 IFS="$OLDIFS"
	 Log+="$Green Rescan $LRed List of$Green volumes$Reset$Nline"
	 select_list+=( "{N}one" "{Enter}" )
	 Enter_Action="mount"
}

Rescan_disks ()
{
	 Get_disks_list
	 OLDIFS="$IFS"
	 IFS=$'\n'
	 options=(${Disks_list[@]})
	 select_list=(${options[@]})
	 select_list+=(${functions[@]})
	 IFS="$OLDIFS"
	 
	 select_list+=( "{N}one" "{Enter}" )
	 Enter_Action="akcept"
}

Select_volume ()
{
	unset options
	Get_volumes_list
	#IFS=$'\n' # IFS=$' \t\n'
	OLDIFS="$IFS"; IFS=$'\n' options=(${Volumes_list[@]}); IFS="$OLDIFS"
	default=$((${#options[@]}+1))
	
	ask_select
	
	Volume=${Selected%% *}
	unset Selected
	Volume=${Volume//:/}
	#echo "$Nline Akcepted: "$device""
	dest="volume"
}



Fdisk ()
{
	echo "$Red"
	MESSAGE="[ $(( Nr+=1 )). RUN FDISK ]$Reset"
	Bar "$MESSAGE"
	Log+="$Green Rescan $LRed List of$Green disks$Reset$Nline"
	Log+="$Green Run $LRed Fdisk$Green function:$Reset$Nline"
	(
		
		
	while true
	do :	
		ask_info="$Nline$Green Select:$Yellow DEVICE:$Reset"
		Title_list="$LRed List of$Green disks:$Nline$EraseR"
		functions=( "${Cyan}!${Back}{R}escan_disks" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it" )
		Rescan_disks
		select_list+=(${functions[@]})
		default=$(( ${#select_list[@]}-5 ))
		ask_select
		
		Device_Name=${Selected}
		Device_Name=${Device_Name%% *}
		Device_Name=${Device_Name//:/}
		Partition_Num=${Device_Name##*[![:digit:]]}
		Device=${Device_Name%$Partition_Num*}
		
		if [ -b "$Device" ]
		then :	
			Log+="$Green Selected :$SmoothBlue „$Device”$Reset$Nline"
			fdisk -l "$Device"
			fdisk "$Device" <<-List_of_Commands
			m
			q
			List_of_Commands
			fdisk "$Device"
			unset Selected
			Rescan_disks
			
		else :	
			if [ "$Device" = "{R}escan_disks" ]
			then :	
				Log+="$Orange „{R}escan_disks”,..$Reset$Nline"
				Rescan_disks
				echo -n "$RestoreP"
			elif [ "$Device" = "{I}nfo" ]
			then :
				Log+="$Orange „{I}nfo”,..$Reset$Nline"
				
				Info
				
			elif [ "$Device" = "E{x}it" ]
			then :
				Log+="$Orange „E{x}it”,..$Reset$Nline"
				Exit
			else :	
				echo "$Orange Selected : „$Device”$Reset"
				Log+="$Orange Selected : „$Device”$Reset$Nline"
				break
			fi
		fi
	done
	)
	
	
	echo "$Yellow"
	MESSAGE="[ $(( Nr+=1 )). SELECT DEVICE ]$Reset"
	Bar "$MESSAGE"
	
	Rescan
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo ""; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
}


Ask_device_name ()
{
	while true
	do :	
		echo "$Green"
		MESSAGE="[ $(( Nr+=1 )). SELECT DEVICE ]$Reset"
		Bar "$MESSAGE"
		
		S_Mode="Device"
		ask_info="$Nline$Green Select:$Yellow $S_Mode,$Reset"
		functions=( "$Cyan!${Back}{R}escan" "${Red}!${Back}{F}ormat" "${Red}!${Back}F{d}isk" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it" )
		Title_list="$LSmoothBlue List of$Green volumes:$EraseR$Nline$EraseR"
		Enter_Action="mount"
		Select_volume
		
		echo -n "$Reset"
		
		
		if [ -b "$Volume" ]
		then :	
			Log+="$Green Mount Selected:$SmoothBlue „$Volume”$Reset$Nline"
			Mount_device_name
		else :	
			if [ "$Volume" = "{R}escan" ]
			then :	
				Log+="$Orange „{R}escan”,..$Reset$Nline"
				Rescan 1
				echo -n "$RestoreP"
			elif [ "$Volume" = "{I}nfo" ]
			then :
				Log+="$Orange „{I}nfo”,..$Reset$Nline"
				Info
			elif [ "$Volume" = "{F}ormat" ]
			then :
				Log+="$Orange „{F}ormat”,..$Reset$Nline"
				Format
			elif [ "$Volume" = "F{d}isk" ]
			then :
				Log+="$Orange „F{d}isk”,..$Reset$Nline"
				Fdisk
			elif [ "$Volume" = "E{x}it" ]
			then :
				Log+="$Orange „E{x}it”,..$Reset$Nline"
				Exit
			else :	
				echo "$Orange „$Volume” is not a block device, try again...$Reset"
				Log+="$Orange „$Volume” is not a block device, try again...$again$Reset$Nline"
			fi
		fi
	done
}


Format ()
{
	echo "$Red"
	MESSAGE="[ $(( Nr+=1 )). FORMAT PARTITION ]$Reset"
	Bar "$MESSAGE"
	Make_file_system_type
	
}

Change_id_type ()
{
	local Device_Name="$1"  Partition_Num="$2" Os_id_type="$3" Old_os_id="$4"
	t[83]="Linux" t[c]="FAT32" t[7]="NTFS"
	echo "$Red Change partition ID type: $Old_os_id - ${t[$Old_os_id]} to: ID 0x$Os_id_type - ${t[$Os_id_type]}"
	
	if [[ "yes" == $(r_ask "$LRed # fdisk$Yellow "$Device_Name"$Orange partition $Yellow"$Partition_Num"$Orange - ID$Yellow 0x$Os_id_type,$Nline$Orange Please answer - " "2") ]]
	then :	
		echo " ok change partition type$Reset"
		fdisk "$Device_Name" <<-List_of_Commands
		t
		$Partition_Num
		$Os_id_type
		w
		q
		List_of_Commands
		Log+="$Orange Change partition type:$Red $Device_Name $Orange$Partition_Num$Yellow $Os_id_type$Nline"
	else :	
		echo "$Orange Change partition type$Green skipped.$Reset"
		Log+="$Orange Change partition type$Green skipped.$Nline"
	fi
}

Make_file_system_type ()
{
	Linux='83' FAT32='0c' NTFS='07'
	
	Device_Name=${Preselected}
	Device_Name=${Device_Name%% *}
	Device_Name=${Device_Name//:/}
	file_system_type=$(blkid "$Device_Name" -o value -s TYPE)
	#file_system_type=$(lsblk "$Device_Name" --output FSTYPE 2>/dev/null|tail -1)
	
	Partition_Num=${Device_Name##*[![:digit:]]}
	Device=${Device_Name%$Partition_Num*}
	
	echo "$Nline$Green Preselectet Volume: $LRed„$Device_Name”$Green to$Red Make files system$Reset"
	Mount_Point_Destination=$(mount -l | grep "$Device_Name"| awk '{print $3}')
	if [ ! "$Mount_Point_Destination" = '' ]; then
	echo "$Red Umount „${Device_Name}”:"
	umount -v "${Device_Name}"; echo -n "$Reset"
	Log+="$Red Umount destination restore „${Device_Name}”$Nline"
	fi
	Read_label ()
	{
		label_for_partition=$(blkid ${Device_Name} -o value -s LABEL)
		echo -n "$Orange Enter$Cyan label$Orange for volume $LRed$Device_Name$Orange or empty for skipp$Blink ?: $Reset$Nline$Yellow"
		read -ei "$label_for_partition" label_for_partition
		
	}
	Read_label
	
	echo "$Nline # mkfs $Yellow -> $LRed$Device_Name$Red <- The data on this device will be lost !!!."
	if [[ "yes" == $(r_ask  "$Orange SURE, Please answer -$Blink Format: " "2") ]]
	then :	
		echo "$Yellow ok start format partition$EraseR$Reset"
		# ls /sbin/mk*
		exec_dir=$(dirname $(whereis -b mkfs|awk '{print $2}'))
		cd $exec_dir; echo "$Nline$Green # ls mkfs:$Nline$Cream"
		ls -T 8 mk*
		echo
		list=( ext4 ext3 ext2 btrfs ntfs vfat msdos )
		Select_list "$Orange Which file$Cyan system$Orange type, posibilities$Blink:$Reset$Magenta ext4 ext3 ext2 btrfs ntfs vfat msdos$Reset"
		
		echo "$Reset"
		file_system_type="$Selected"
		unset Selected
		
		if [ "$file_system_type" = '' ]
		then :	
			echo "$Orange Empty file system type.$Red Skipped Format:$Green „$Device_Name”$Reset"
			Log+="$Orange Empty file system type.$Red Skipped Format:$Green „$Device_Name”$Nline"
		
		else :	
			if [ "$file_system_type" = "ntfs" ]
			then :
				mkfs_option="--fast"
			elif [ "$file_system_type" = "btrfs" ]
			then :
				if [ "$label_for_partition" != '' ]
				then :
					mkfs_option="-f -L $label_for_partition"
				else :
					mkfs_option="-f"
				fi
			else :
				mkfs_option=""
			fi
			
			echo "$Red # Make $file_system_type on $Device_Name$Red : mkfs -t "$file_system_type" "$mkfs_option" "$Device_Name" $Reset$Nline"
			mkfs -t "$file_system_type" $mkfs_option "$Device_Name"
			if ! [ $? = 0 ]
			then :	
				echo "$LRed Erorr: mkfs -t $file_system_type „$Device_Name”, exit$Reset$Nline"
				Log+="$LRed Erorr: mkfs -t $file_system_type „$Device_Name”, exit$Nline"
				exit 1
			else :	
				Log+="$Orange Format:$Red mkfs -t $file_system_type „$Device_Name”$Nline"
				# Chek os id
				if [ "$file_system_type" = "ext2" ] || [ "$file_system_type" = "ext3" ] || [ "$file_system_type" = "ext4" ]
				then Os_id='83' ;fi # ext file systems
				if [ "$file_system_type" = "vfat" ] || [ "$file_system_type" = "fat" ] || [ "$file_system_type" = "msdos" ]
				then Os_id='c' ;fi # dosfstools - Utilities for Making and Checking MS-DOS FAT File Systems on Linux
				if [ "$file_system_type" = "ntfs" ]
				then Os_id='7' ;fi
				[ "$Os_id" = "" ] && Os_id='83'
				
				Os_id_types=$(fdisk -l 2>/dev/null|grep '^/'|awk '{ sub(/*/,""); print $1,$6}')
				Chek_os_id=$(grep "$Device_Name" <<<"$Os_id_types"|awk '{print $2}')
				if [ "$Chek_os_id" != "$Os_id" ]
				then :
					Change_id_type "$Device" "$Partition_Num" "$Os_id" "$Chek_os_id"
				fi
				Os_id_types=$(fdisk -l 2>/dev/null|grep '^/'|awk '{ sub(/*/,""); print $1,$6}')
				Chek_os_id=$(grep "$Device_Name" <<<"$Os_id_types"|awk '{print $2}')
				if [ "$Chek_os_id" != "$Os_id" ]
				then :
					Change_id_type "$Device_Name" "$Partition_Num" "$Os_id" "$Chek_os_id"
				fi
			fi
		fi
	else :	
	 	echo "$Orange Format:$Red „$Device_Name”$Green partiition skipped.$Reset"
	 	Log+="$Orange Format:$Red „$Device_Name”$Green partiition skipped.$Nline"
	fi
	
	if [[ "$label_for_partition" = "" ]]
	then :	
			
			echo "$Orange Empty label.$Red Skipped label$Green „$Device_Name”$Reset"
			Log+="$Orange Empty label.$Red Skipped label$Green „$Device_Name”$Nline"
	else :	
		# label ext file systems
		if [ "$file_system_type" = "ext2" ] || [ "$file_system_type" = "ext3" ] || [ "$file_system_type" = "ext4" ]
		then :	
			echo "$Nline$Green # LABEL: tune2fs -L "$label_for_partition" „$Device_Name”$Reset$Nline"
			tune2fs -L "$label_for_partition" "$Device_Name"
			Log+="$Orange Label:$Green tune2fs -L $label_for_partition$Red „$Device_Name”$Nline"
		fi
			
		# label dosfstools - Utilities for Making and Checking MS-DOS FAT File Systems on Linux
		if [ "$file_system_type" = "vfat" ] || [ "$file_system_type" = "fat" ] || [ "$file_system_type" = "msdos" ]
		then :	
			label_for_partition=$(echo "$label_for_partition" | tr '[a-z]' '[A-Z]')
			echo "$Nline$Green # LABEL : fatlabel „$Device_Name” „$label_for_partition”$Reset$Nline"
			fatlabel "$Device_Name" "$label_for_partition"
			Log+="$Orange Label:$Green fatlabel „$Device_Name” „$label_for_partition”$Nline"
		fi
			
		# label ntfsprogs - NTFS Utilities
		if [ "$file_system_type" = "ntfs" ]
		then :	
			echo "$Nline$Green # LABEL : ntfslabel „$Device_Name” „$label_for_partition”$Reset$Nline"
			ntfslabel "$Device_Name" "$label_for_partition"
			Log+="$Orange Label:$Green ntfslabel „$Device_Name” „$label_for_partition”$Nline"
		fi
		# jfs_tune -L <label> <device>
		# jfsutils - IBM JFS Utility Programs
		# tunefs.reiserfs -l <label> <device>
		# reiserfs - Reiser File System utilities
		# xfs_admin -L <label> <device>
		# xfsprogs - Utilities for managing the XFS file system
		fi
	echo "$Yellow"
	MESSAGE="[ $(( Nr+=1 )). SELECT DEVICE ]$Reset"
	Bar "$MESSAGE"
	
	Rescan
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo ""; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
}

Mount_device_name ()
{
	local again=0
	while true
	do	
		# udisksctl mount -b Device
		# Mount_Point_Device=$(lsblk "$Volume" --output MOUNTPOINT | grep -v "MOUNTPOINT")
		Mount_Point_Device=$(mount -l | grep "$Volume " | awk '{print $3}')
		Device_Info=$(blkid $Volume)
		
		if [ "$Mount_Point_Device" = '' ]
		then :
			echo "$Cream $Device_Info$Reset"
			echo -n "$Green udisksctl $Yellow"
			udisksctl mount -b "$Volume"
			echo -n "$Reset"
			sleep 0.2
			
			Mount_Point_Device=$(mount -l | grep "$Volume " | awk '{print $3}')
			if [ "$Mount_Point_Device" != '' ]
			then :
				df -BM "$Mount_Point_Device"
				Device_mounted=+"$Volume $Mount_Point_Device$Nline"
				Log+="$Green Mounted:$SmoothBlue $Device_Info$Nline"
				cd "$Mount_Point_Device"
				echo "$LCyan Tip: Press twice Esc - run /bin/bash.$Reset"
			else :
				echo "$LRed Erorr: can't mount: „$Volume”$Reset$Nline"
				Log+="$LRed Erorr: can't mount: „$Volume”$Nline"
			fi
		else :
			echo "$Cream $Device_Info$Reset"
			echo "$SmoothBlue „$Volume”$Green is mounted on:$Yellow $Mount_Point_Device$Reset"
			df -BM "$Mount_Point_Device"
			Log+="$Cream „$Volume”: $Device_Info is mounted on: $Mount_Point_Device$Nline"
			cd "$Mount_Point_Device"
			echo "$LCyan Tip: Press twice Esc - run /bin/bash.$Reset"
		fi
		break
	done

:<<'COMMENTEOF'
https://unix.stackexchange.com/questions/32008/mount-an-image-file-without-root-permission
 ###--[ udisksctl utility ]---------------#

## The utility for udisks2 is called udisksctl. It uses /run/media/$USERNAME/<label>
udisksctl mount -b /dev/sda1

## Mounted /dev/sdc1 at /run/media/t-8ch/<label>.
udisksctl unmount -b /dev/sda1

## You might need to run
udisksctl loop-setup -r -f $PATH_TO_IMAGE
udisksctl mount -b /dev/loop0p1

## You can look at files on the disk
ls -l /media/$USER/$IMAGE_NAME/

## You can unmount it when you're done
udisksctl unmount -b /dev/loop0p1

 ###--[ udisks utility ]---------------#
## Mounted /org/freedesktop/UDisks/devices/sdc1 at /media/<label>
udisks --unmount /dev/sda1

 ###--[ Mount net fs and resources utility ]----------------#
## install smbnetfs bindfs
mkdir -p ~/win ~/winsrc
smbnetfs ~/win
bindfs ~/win/BRANDON-PC/project/src ~/winsrc
cd ~/winsrc

 ###--[ guestmount utility ]----------------#
mkdir dvd
guestmount -a image.iso -r -i dvd 
## df will show image.iso mounted
df
## to umount we have :
 guestunmount dvd

 ###------------------#
Here are two very short (5 lines + comments) Bash scripts that will do the job:

for mounting

#!/bin/sh
# usage: usmount device dir
# author: babou 2013/05/17 on https://unix.stackexchange.com/questions/32008/mount-an-loop-file-without-root-permission/76002#76002
# Allows normal user to mount device $1 on mount point $2
# Use /etc/fstab entry :
#       /tmp/UFS/drive /tmp/UFS/mountpoint  auto users,noauto 0 0
# and directory /tmp/UFS/
# Both have to be created (as superuser for the /etc/fstab entry)
rm -f /tmp/UFS/drive /tmp/UFS/mountpoint
ln -s `realpath -s $1` /tmp/UFS/drive
ln -s `realpath -s $2` /tmp/UFS/mountpoint
mount /tmp/UFS/drive || mount /tmp/UFS/mountpoint
# The last statement should be a bit more subtle
# Trying both is generally not useful.
and for dismounting

#!/bin/sh
# usage: usumount device dir
# author: babou 2013/05/17 on https://unix.stackexchange.com/questions/32008/mount-an-loop-file-without-root-permission/76002#76002
# Allows normal user to umount device $1 from mount point $2
# Use /etc/fstab entry :
#       /tmp/UFS/drive /tmp/UFS/mountpoint  auto users,noauto 0 0
# and directory /tmp/UFS/
# Both have to be created (as superuser for the /etc/fstab entry)
rm -f /tmp/UFS/drive /tmp/UFS/mountpoint
ln -s `realpath -s $1` /tmp/UFS/drive
ln -s `realpath -s $2` /tmp/UFS/mountpoint
umount /tmp/UFS/drive || umount /tmp/UFS/mountpoint
# One of the two umounts may fail because it is ambiguous
# Actually both could fail, with careless mounting organization :-)
The directory /tmp/UFS/ is created to isolate the links and avoid clashes. But the symlinks can be anywhere in user space, as long as they stay in the same place (same path). The /etc/fstab entry never changes either.
###------------------#
COMMENTEOF
}


Restore_backup ()
{
	echo "$Red"
	Bar "[ $(( Nr+=1 )). RESTORE FILES FROM BACKUP ]$Reset"
	echo
	
	Source_size=$(du -BM --apparent-size -s "$Mount_Point_Device/$Destination_Backup_Dir/$Source_Restore_File" | awk '{ print $1 }')
	[ "$Source_size" = '' ] && { echo "$LRed Erorr: can't get source size, exit$Reset$Nline"; exit 1;}
	Free_space=$(df -BM "$TMPDIR/EasyMonitor-$USER/source_backup" | awk 'NR==2 {print $4}')
	[ "$Free_space" = '' ] && { echo "$LRed Erorr: can't get free space, exit$Reset$Nline"; exit 1;}
	max_length=1
	for String in "${Source_size}" "${Free_space}"
	do :	
		[ "${#String}" -gt "${max_length}" ] && max_length=${#String}
	done
	(( enough=${Free_space%%[![:digit:]]*}-${Source_size%%[![:digit:]]*} ))
	[ "$enough" -lt "0" ] && Enough="$Red$Blink" || Enough="$Green"
	
	printf "$Green Source size:$SmoothBlue (%*s)$Reset" "$max_length" "$Source_size"
	printf "$LBlue flies in archive „$Source_Restore_File”$Reset\n"
	
	printf "$Yellow Free  space:$Enough (%*s)$Reset" "$max_length" "$Free_space"
	printf "$Red „${Selected}” $Reset\n"
	if [ "$enough" -lt "0" ]
	then :	
		 echo "$Orange This is rather mission iposiple, bat you are judge, master and commander behind the wheel.
		 So maybe there are a few files on the way && ju kan hearring :)$Reset"
	fi
	echo "$Red Start:$Green Restore files:$Reset"
	Errors=$(mktemp) || return 1
	
	if [ "$Mode" = "Backup" ]
	then :
	
		echo " # tar -xpzf $Yellow DESTINATION -> $Red${Selected}/$LGreen <- SOURCE $LBlue$Source_Restore_File"
		#echo "$Red Start:$Reset tar -xpzf  $LBlue$Source_Restore_File$Reset to: $Red$TMPDIR/EasyMonitor-$USER/source_backup$Reset"
		
		cd $TMPDIR/EasyMonitor-$USER/source_backup
		if [ ! $? = 0 ]
		then :	
			echo "$LRed Erorr: can't cd ${Selected}, exit$Reset$Nline"
		exit 1
		fi
		if [[ "yes" == $(r_ask "$Orange SURE,$Green restore files,$Orange Please answer " "2") ]]
		then :	
			echo "$Nline$Orange '# Begin #' $Reset$Blue `date`$Reset"
			Log+="$Orange '# Begin restore files #'$Reset$LBlue `date`$Nline"
			echo "$Red$Blink Wait or go for a drink:$Reset"
			#------------------------
			# Finaly simply restore command
			if ok_command=$(command -v pv 2>/dev/null)
			then :	
				echo
				Start_time=`date +%s`
				( pv "$Mount_Point_Device/$Destination_Backup_Dir/$Source_Restore_File"  ) \
				| ( tar -xpzf - -C "$TMPDIR/EasyMonitor-$USER/source_backup" --checkpoint-action=ttyout='\033[1B \r Write: %{}T (%d sec) : %t \r \033[1A' 2>"$Errors" )
				Elapsed_time=$((`date +%s` - $Start_time))
				echo
			else :	
				Start_time=`date +%s`
				tar -xpzf $Mount_Point_Device/$Destination_Backup_Dir/$Source_Restore_File 2>"$Errors"
				Elapsed_time=$((`date +%s` - $Start_time))
			fi
			Finished="Yes"
			echo "$LGreen '# Done #' $Reset$Blue `date`$Reset$Nline"
			Log+="$LGreen '# Restore  files done #'$Reset$LBlue `date`$Reset"
		else :	
			echo "$Orange Restore$Red files$Orange skipped.$Reset"
			Log+="$Orange Restore$Red files$Orange skipped.$Reset"
		fi
		#------------------------
	elif [ "$Mode" = "Copy" ]
	then :
		echo " # rsync $Yellow DESTINATION -> $Red${Selected}/$LGreen <- SOURCE $LBlue$Source_Restore_File/"
		#echo "$Red Start:$Reset rsync  $LBlue$Source_Restore_File/$Reset to: $Red$TMPDIR/EasyMonitor-$USER/source_backup/$Reset"
		
		cd "$Mount_Point_Device/$Destination_Backup_Dir/$Source_Restore_File"
		if [ ! $? = 0 ]
		then :	
			echo "$LRed Erorr: can't cd $Mount_Point_Device/$Destination_Backup_Dir/$Source_Restore_File, exit$Reset$Nline"
		exit 1
		fi
		if [[ "yes" == $(r_ask "$Orange SURE,$Green restore files,$Orange Please answer " "2") ]]
		then :	
			echo "$Nline$Orange '# Begin #' $Reset$Blue `date`$Reset"
			Log+="$Orange '# Begin restore files #'$Reset$LBlue `date`$Nline"
			echo "$Red$Blink Wait or go for a drink:$Reset"
			#------------------------
			# Finaly simply copy command
		
			if command -v  rsync >/dev/null 2>&1
			then :
				Start_time=`date +%s`
				( cd $Mount_Point_Device/$Destination_Backup_Dir/$Source_Restore_File && rsync --stats --info=progress2 --info=name0 -aAX  * $TMPDIR/EasyMonitor-$USER/source_backup/ 2>"$Errors")
				Elapsed_time=$((`date +%s` - $Start_time))
			else :
				echo "cp  -afxv * $TMPDIR/EasyMonitor-$USER/source_backup/"
				Sleep_key
				Start_time=`date +%s`
				( cd "$Source" && cp  -afxv /* $Destination 2>"$Errors")
				Elapsed_time=$((`date +%s` - $Start_time))
			fi
			Finished="Yes"
			echo "$LGreen '# Done #' $Reset$Blue `date`$Reset$Nline"
			Log+="$LGreen '# Restore  files done #'$Reset$LBlue `date`$Reset"
		else :	
			echo "$Orange Restore$Red files$Orange skipped.$Reset"
			Log+="$Orange Restore$Red files$Orange skipped.$Reset"
		fi
	else :
	fi
	
	
}

Info ()
{
  MBR_info=$( cat <<'MBR_info_EOF'
  „MBR info” ### NOTE: ###
  The MBR - first sector of device - 512 bytes, but those 512 bytes seems to be
  divided into three different structures. So the MBR mean only first sector
  of any device (FSD), contains three different structures and copying them
  together to difrent drives or back all of it after repartiton can lead
  to ovewrite two or three different things.

  In old style BIOS and prtition table:

  1. Bootstrap (MBR) 446 bytes #
  2. Partition table. 64 bytes #
  3. Signature. 2 bytes        #

  And after 512 bytes of first sector
  4. MBR gap, or "embedding area" and which is usually at least
     62*512 - 31 KiB (DOS compability) or 2048*512.

  #---------------------
  Using dd on the old MBR

  1.1 Copy Bootstrap. 446 bytes to file
  dd if=<device> of=MBR.img bs=446 count=1 conv=notrunc
  dd if=MBR.img of=<device> bs=446 count=1

  2.1 Copy Partition table. 64 bytes to file
  dd if=<device> of=Partition_Table.img bs=1 skip=446 count=64 conv=notrunc
  dd if=Partition_Table.img of=<device> bs=1 seek=446 count=64

  3.1 Copy Signature. 2 bytes to file
  dd if=<device> of=Signature.img bs=1 skip=500 count=2 conv=notrunc
  dd if=Signature.img of=<device> bs=1 seek=500 count=2

  iflag=skip_bytes
  oflag=seek_bytes
  bs=BYTES - per block used to count
  Do not truncate the output file. conv=notrunc
  Preserve blocks in the output file not explicitly written by this invocation
  of the dd utility. So you can replace some contents of file by another one
  or with combination of skip seek try re-read bloks with errors to file again,
  without repped all read operation again.

  #---------------------
  1.2
  Bootstrap (MBR). 446 bytes
  Old GRUB Legacy <1.98 - "Stage 1"; GRUB 2 >1.98 - "boot.img"
  The sole function of boot.img is to read the first sector of the core image
  32KB from a local disk and jump to it. Because of the size restriction
  boot.img cannot understand any file system structure.

  So grub-setup ### hardcodes ### the location of the first sector of the core
  image ( contain old Stage 1.5) or Stage 2 into boot.img when installing GRUB.
  It can be "MBR gap", or "embedding area" holds stage "1.5 - 2", but in new
  style all rest of code boot loader is stored in "stage 2" hardcoded as blok
  list on filesytem belong to partition.

  #---------------------
  Device naming has changed between GRUB Legacy and GRUB.
  Partitions are numbered from 1 instead of 0, drives are still numbered from 0
  and prefixed with partition-table type. For example: /dev/sda1 would be
  referred to as  (hd0,msdos1) (for MBR) or (hd0,gpt1) (for GPT).
  ( Old Grub start count disks from 0, partitions from 0)
  ( New Grub start count disks from 0, partitions from 1)

  https://www.gnu.org/software/grub/manual/html_node/BIOS-installation.html
  https://en.wikipedia.org/wiki/GNU_GRUB

  #---------------------
  mbrback - Linux Shell Script To Backup and Restore MBR
  change partition id linux from script : sfdisk --change-id /dev/hdb 5 83
  store partition table in text format  : sfdisk -d /dev/sda > sda-part-table-txt.sf

# FIXME
# 2.
# VBR - volume boot record - Stage 1.5 - partition boot sector- first sector of partition don't have to provide copy of partition table...
# "Stage 1.5" - area befor first parition from 1 to 62 sector, which leaves at least 512*62 = 31 kiB after MBR.
# In GRUB Legacy - Stage 1.5;  GRUB 2 - diskboot.img - first sector of GRUB 2 - core.img ( Stage 2)
# 2.2
# In some configurations, an intermediate stage 1.5 can be used, which locates and loads stage 2 from an appropriate file system. If possible
# In Grub Legacy Stage 1.5 is capable of understanding (read-only) ext2 file system and start system
# or read more code from regular file system # for increased functionality..
# The old Stage 1.5 had a fixed place between MBR and first partition. It was (most often) unused space on the hard drive.
# ( smoe - 30 kB are usually available non-partitionned "free" disk space, because for historical reasons
# Stage 1.5 might be sufficient if the boot information is small enough to fit in the area immediately after MBR.
# GPT partitioning and other (unusual) layouts do not provide this space.

# The new Stage 2  - core image is cobinet with Stage 1.5 - ( diskboot.img ### hardcodes sectoers ### or another hader for read iso or difrent devices
# witch read biger ### hardcodes sectoers (using a block list format) ### ( stage 2 -rest of core.img )
# with contain pre selected file systems, and then read rest filesystems and rest of modules to read another filesystems...
# (
# So Stage 1.5 still exist, but in GRUB 2  ">1.98" is not enough to hold all code
# and dont have a fixed place between MBR and first partition and become part of Stage 2 on partition area
# )

# 2.3
# NTFS Boot Record's “Backup Sector”.
# The Win 2000/XP OSs make a "backup" of each NTFS volume's Boot Record which they store in the very last sector of its partition!
# [ Note: I said "partition" not volume. This is why an NTFS partition's Total Sectors count in the MBR/EBR's Partition Table is always 1
# sector more than the "Total Sectors (in Volume)" count found in its Boot Record. Although the words partition (primary)
# and volume are often thought of as being synonymous (we may even use them as such here!), this shows they are not always the same. ]

# Unlike all previous Windows versions, if you install Windows Vista on a hard disk with no existing partitions, the first partition will
# start at Absolute Sector 2048 (counting from zero; Sector 0 is where the MBR is located). This is an offset of exactly 1 Binary Megabyte
# (2048 * 512 = 1,048,576 bytes) into the disk. In hexadecimal, this is an offset of 100,000 hex (100000h = 1 MiB). The main reason Microsoft
# gave for doing this is found in their article,  KB-923332; in which the number of sectors is given only in hexadecimal: 0x800 = 2048 and
# 0x3F = 63.
# http://thestarman.narod.ru/asm/mbr/NTFSBR.htm
# So is need to count differences between partitions tables and volume sizes to collect informations of reserved sectors areas..

MBR_info_EOF
# No tak, niema to jak profesionalnie komercyjny bajzel ( chroniony ${B}prawnie )
)
	echo -n "$Sbuffer"; clear
	
	Device_Name=${Preselected}
	Device_Name=${Device_Name%% *}
	Device_Name=${Device_Name//:/}
	if [ -b "$Device_Name" ]
	then :
		 (
		 blkid "$Device_Name"
		 fdisk -l "$Device_Name"
		 )
	else :
	
	SttyS="$(stty size|awk '{print $1-3;}')"
	echo "$Green Help: „MBR info”:$Magenta"
	more <<<"$MBR_info"
	fi
	read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
	echo -n "$Mbuffer"
}

Restore_GAP ()
{
# FIXME
	echo "$Nline$LRed 3. RESTORE DEVICE BOOT GAP RECORD - 512 -> Start Partition (* 512 bytes)"
	echo -n " ";EM_Device_UUID_GAP=$(ls *GAP.img)
	
	echo "$Orange !!! This function is not well tested !!!$Reset"
	
	
	 echo "$Nline$Reset # dd bs=512 skip 1 $Yellow DESTINATION -> $LRed$Device_Name$LGreen <- SOURCE $Blue$EM_Device_UUID_GAP$Reset"
	
	 if [[ "yes" == $(r_ask  "$Nline$Orange Restore Device Boot Gap Record, If you are SURE, Please answer - " "2") ]]
	 then
	 	echo " ok restore GAP$Reset"
	 	echo "$Nline$Red Write:$Reset dd$Green if=$Blue$EM_Device_UUID_GAP$Yellow of=$LRed$Device_Name$Red bs=512 skip 1 conv=notrunc$Reset$Nline"
	 	dd if=$EM_Device_UUID_GAP of=$Device_Name bs=512 skip 1 conv=notrunc
	 else
	 	echo "$Orange ok restore GAP skipped.$Reset"
	 fi
}

Umount_source_destination ()
{
	cd /
	if [ "$Destination_mounted" = "yes" ]
	then :
		echo -n "$Green"
		umount -v ${Selected} && unset Destination_mounted
		echo -n "$Reset"
	fi
	
	if [ "$Source_mounted" = "yes" ]
	then :
		echo -n "$Green"
		umount -v $Source_Restore && unset Source_mounted
		echo -n "$Reset"
	fi
	
	if [ -f "$Errors" ]
	then :
		echo -n "Errors: "; cat "$Errors" | wc -l
		echo "Removing temp working files $Errors"
		rm -f "$Errors"
		echo -n "$Reset"
	fi
}
#################
Begin "$@"
