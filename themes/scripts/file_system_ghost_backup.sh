#!/bin/bash
# encoding: utf-8
# set -v
# set -m
# set -o xtrace          # useful for debuging

Info_data ()
{
    Name=" # file_system_ghost_backup.sh"
 Version=" # v1.95,.. \"${White}B${LWhite}l${Red}a${Cyan}c${LRed}k$Magenta|$Orange: ${Yellow}Terminal${LGreen}\" ${LWhite}B$Magenta&"$Orange"C$Orange Test beta script$Reset"
  Author=" # Leszek Ostachowski® (© 2016 2017) @GPL V2"
 Purpose=" # Backup file system into a tar.gz arhive from partition"
 Worning=""
   Usage=" # Usage: bash file_system_ghost_backup.sh$Nline"
  Usage+=" # Arguments - Mode: <{B}ackup|{C}opy> Source: <volume> Destination: <volume>$Nline"
  Usage+=" # Backup name: <{name}|LABEL> <MBR|no|ask> <Go|no>$Nline"
  Usage+=" # Exaple: bash file_system_ghost_backup.sh backup /dev/sda1 /dev/sda13 LABEL nO gO"
Dependencies=( fdisk tar blkid lsblk grep awk tr rsync readlink cat )
Optional_dependences=( dd pv tilde )
Log=''

Destination_backup_dir="/BACKUPS"
Destination_backup_file="DISK_LABEL_DATE"
Source_backup="/dev/<disk-partition>"
Destination_backup="/dev/<disk-partition>/$Destination_backup_dir/$Destination_backup_file$File_date$File_type"
Worning+="${Magenta} # To preserve file atributes do it as $Red\$${Magenta}root$Reset"
Editor="tilde"

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
#for (( x=200; x>0; x--)); do echo ""; done
# echo -e "\033[9999;1H"
Traps "$@"
Color_terminal_variables
Info_data
Prepare_check_environment "$@"
Print_info
Run_as_root "$@"
Test_dependencies
Install_missing

Ask_source_destination_device_names
Mount_source_backup
Mount_destination_backup
Ask_destination_backup_file_name
Ask_for_store_additional_informations
Make_backup
#Umount_source_destination

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
		        #Sleep_key
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
		
		if [ -z "$Elapsed_time" ]
		then :
			Elapsed_time=$((`date +%s` - $Start_time))
		fi
		
		if [ "$Finished" = "Yes" ]
		then :
			[ "$No_log" != "yes" ] && \
			{
			echo "$Cyan"
			MESSAGE="[ $(( Nr+=1 )). VIEW LOG ]$Reset"
			Bar "$MESSAGE"
			
			echo "$Nline$LGreen$Blink $Finished$Reset$Cream finished in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset"
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
			
			echo "$Nline$Red$Blink $Finished$Reset$Cream finished in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset"
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
	
	SIGWINCH_S ()
	{
	Get_View_port_size
	[ "$Vcolumns" -lt 100 ] && Terminal_size $Vlines 100
	sleep 0.1
	}
	
	
	Trace ()
	{
	echo "Press CTRL+C to proceed."
	trap "pkill -f 'sleep 1h'" INT
	trap "set +x ; sleep 1h ; set -x" DEBUG
	set -x
	}

function ERR_S ()
{
        Script="${0##*/}"  # equals to script name
        Last_line="$1"     # argument 1: last line of error occurence
        Last_error="$2"    # argument 2: error code of last command
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
	if [ -z $TMPDIR ]
	then TMPDIR=/tmp
	fi
	workdir="${BASH_SOURCE%/*}"
	if [[ ! -d "$workdir" ]]
	then workdir="$PWD" 
	
	fi
	workdir="${workdir}/"
	cd "$workdir"
	
	Mode="$1" Source="$2" Destination="$3" backup_name="$4" Mbr="$5" Go="$6"
	
	if [ "$1" ]
	then :	
		Mode=$(tr '[:upper:]' '[:lower:]' <<<"$Mode")
		if [ "$1" = "-v" ]
		then :	
			Print_info
			echo "$Nline$Green$Licence$Reset"
			No_log=yes
			exit 0
		fi
		
		Mbr=$(tr '[:upper:]' '[:lower:]' <<<"$Mbr")
		Go=$(tr '[:upper:]' '[:lower:]' <<<"$Go")
		
		if [ "$Mode" = "b" ] || [ "$Mode" = "backup" ]
		then 	Mode="Backup" Mode_type="f.tar.gz"
		
		elif [ "$Mode" = "c" ] || [ "$Mode" = "copy" ]
		then 	Mode="Copy" Mode_type=".f.copy" backup_name="copy"
		
		else 	echo "Mode: $Mode - not suportet yet"
			exit
		fi
		
			Source="$2"
			if [ ! -b "$Source" ]
			then :
				echo "Source not block device, unset"
				unset Source
				Mbr="ask"
				Go=""
			fi
		
			Destination="$3"
			if [ ! -b "$Destination" ]
			then :
				echo "Destination not block device, unset"
				unset Destination
				Mbr="ask"
				Go=""
			fi
		
			backup_name="$4"
			if [ "$backup_name" = "" ]
			then :
				unset backup_name
			fi
		
			if  [ "$Mbr" = "mbr" ] || [  "$Mbr" = "no" ] || [  "$Mbr" = "" ]
			then :
				Mbr="$Mbr"
			else :
				Mbr="ask"
			fi
		
			if [ "$Go" = "go" ]
			then :
				Go="$Go"
			else :
				Go=""
			fi
		
	else :
		      Mode="Backup" Mode_type="f.tar.gz"
		      Mbr="ask"
		      Go=""
	fi
	File_type=".$Mode_type"
	File_date="(`date +%F`_$(date '+%H-%M-%S'))"

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
	# false
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
		chmod +x ${workdir}jump-for-stuff.sh
		if ! [ -z "$To_install" ]
		then :
			echo "$Nline$LMagenta Missing software - can't find the following commands: ${No_software%%, }$Reset"
			${workdir}jump-for-stuff.sh "${To_install}"
			if ! [ $? = 0 ]
			then :
				echo "$LRed Error: install: ${No_software%%, }. Try do it manually... $Reset"
				/bin/bash; exit
			fi
		fi
		if ! [ -z "$To_optional_install" ]
		then :
			echo "$Nline$LMagenta This script recommended to install - the following package: ${Optional_software%%, }$Reset"
			${workdir}jump-for-stuff.sh "${To_optional_install}"
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
	local x= loop_time_out= again= rest= select_list=("${options[@]}") u_select=
	unset u_select select_ tigers
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
	Title_select="$ask_info$Magenta and press:$Green $(( ${#select_list[@]} )) ${select_list[$@-1]} $Enter_Action$Reset"
	
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
			#echo -n ""$'\033[6n'""; read -sdR VPosition; VPosition=${VPosition#*[}; echo -n "$Creturn" # hang terminology
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
	   echo "$Procedure" "$Preselected"$Reset #; sleep 6
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

Select_list () # v1.6 by Leszek Ostachowski® (©2017) @GPL V2
{
	# Before call fill
	# ${list[]};
	local info="$1" suggest="$2" char= rest= length=
	
	[ "$suggest" = '' ] && suggest=${#list[@]} || suggest=$suggest-1
	#echo "${list[@]} ${#list[@]} $suggest"
	answer="${list[$suggest]}"
	unset Selected
	#echo -n "$Stop_wrap"
	#  The -v option causes hexdump to display all input data. -e, --format format_string
	Debug () { Linesup 1; printf "\r$Yellow hexdump > "; echo -en "${1}" |  hexdump -v -e '"|" 1/1 "%02_c" " "' | tr '\n' ';'; echo -n "$Reset" ;read -r -s -N1 sleep;}
	
	Print_in_columns ()
	
	{ #  e.g.  Print_in_columns  spacing=2 #  left_margin=6 number=yes separator='|' spacing=3
	
	Get_View_port_size
	echo "$info$EraseD$Nline"
	trim_length=$(( $Vcolumns ))
	local Array=("${list[@]}") length=${#list[@]} Erase_U=''
	local position_nr=0 line=0 col=0 NL=''
	local prefix=${#Array[@]}
	prefix="$prefix" prefix=${#prefix}
	local left_margin=${left_margin:-1} prefix=${prefix:-0} padding=${spacing:-1} separator=${separator:-'|'}
	local terminal_Width=$(( ${Vcolumns:-80} - $left_margin ))
	## Calculate the length of the longest item in Array
	local max_length=$(( $(echo "${Array[*]/%/$'\n'}"|wc -L)+$padding ))
	# max_length=1
	# for String in "${Array[@]}"
	# do :
	# 	[ ${#String} -gt ${max_length} ] && max_length=${#String}
	# done
	local max_col_length=$(( $max_length+$padding+$prefix+${#separator} ))
	#echo -n "$Mbuffer"
	#[ $(( $max_col_length )) -gt $(( $Vcolumns - 15 )) ] && max_length=$(( $Vcolumns-$left_margin-$padding-$prefix-${#separator} )) && echo -n "$Sbuffer" #&&  Erase_U="$Home"
	
	max_columns=$(( $terminal_Width / $max_col_length ))
	[ $max_columns = 0 ] && max_columns=1 columns=1 length=${Vlines}
	[ $length -gt $max_columns ] && lines=$(( $length / $max_columns )) || lines=1
	[ $lines -gt 1  ] && [ $(( $length % $max_columns )) != 0 ] && (( lines++ ))
	[ $(( $length - $max_columns )) -lt 0 ] && (( columns = $length )) || (( columns = $max_columns ))
	[ $(($Vlines*$columns)) -lt $length ] && (( length = $Vlines*$columns ))
	# position=R*C+P]
	for (( field=0; field<$length; field++))
	do :
		
		[[ $col == 0 ]] && { echo -n "$Reset"; printf "$EraseR$NL%*s" "$left_margin"; (( line++ )); NL=$separator$'\n' ;} # add newlines from now on...
		#sleep 0.1
		(( position_nr++ )); (( Cnr =  ( ($col) % ($columns+ 1) )+1 )) ;(( nr = (Cnr)*line )) # (( number =  ( ($col ) % ($columns+ 1) )+1   ))
		[ "$position_nr" = "$((suggest+1))" ] \
		&& {  echo -n "$Green$Blink"; printf "%${prefix}s$Reset$Green$separator" "$position_nr"; printf "%-*s$Reset" "$max_length" "${Array[$field]}" ;} \
		|| { printf "%${prefix}s$separator" "$position_nr"; printf "%-*s" "$max_length" " ${Array[$field]}" ;}
		#sleep 0.05
		(( col = ($col + 1) % $columns ))
		# || { printf "%${prefix}s$separator" "$position_nr"; printf "%-*s" "$max_length" " ${Array[$field}" ;}
	done
	printf "$EraseR$NL"
	(( line+3 ))
	echo "$EraseR"; Linesup $line;Linesdn $line
	#echo -n "max_length $max_length max_col_length $max_col_length columns $columns";sleep 4
	Linesup $line;Linesup 4;echo -n "$SaveP";Linesdn $(( line+2 ))
	
	Message=$(printf "suggest $suggest+1 length $length lines $lines columns $columns max columns $max_columns $max_length=$Vcolumns")
	String_length=${#Message}
	#Linesup 1; printf "$Creturn$Yellow$Faint%*.*s$EraseR$Reset\n" "0" "$trim_length" "$Message"
	
	}
	
	# Initial print
	Print_in_columns "${list[@]}"
	trim_length=$(( $Vcolumns ))
	printf "$Creturn$SmoothBlue Preselected$Orange$Blink:$Reset$Green ${answer}$Yellow *$Magenta [$((suggest+1))-${#list[@]}]$Orange and {E}nter for confirm$Blink?:$Reset"
	
	Print_selection () # declare Print_selection for SIGWINCH signal
	{
	echo -n "$RestoreP"
	Print_in_columns "${list[@]}"
	printf "\r$EraseD$SmoothBlue Preselected$Orange$Blink:$Reset$Green ${answer}$Yellow$Blink<:$Orange Select $Magenta[$((suggest+1))-${#list[@]}]$Orange and {E}nter for confirm$Blink?:$Reset"
	}
	# trap 'Print_selection' SIGWINCH
	
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
	check () { Linesup 1; echo "$Creturn;check$1 $answer;suggest |$suggest|{"${list[$suggest]}"} ;$EraseR";Sleep_key ;}
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
	#trap '' SIGWINCH
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
	list=$(ls --sort=time *$File_Type)
	OLDIFS="$IFS"
	IFS=$'\n' #IFS=$' \t\n'
	list=( ${list} )
	IFS="$OLDIFS"
}

Rescan ()
{
Get_volumes_list
OLDIFS="$IFS"
IFS=$'\n' #IFS=$' \t\n'
options=(${Volumes_list[@]})
select_list=(${options[@]})
select_list+=(${functions[@]})
select_list+=("{N}one" "{Enter}")
IFS="$OLDIFS"
Log+="$Green Rescan $Title_list"
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

Select_volume ()
{
	echo "$Nline$Green Volumes list:$Reset"
	Get_volumes_list
	echo "${Volumes_list[*]}"
	echo "$LCyan Tip - You can use mouse to highlight names and then use copy paste in konsole for give answers.$Reset"
}

Select_volume ()
{
	unset options
	Get_volumes_list
	#IFS=$'\n' # IFS=$' \t\n'
	OLDIFS="$IFS"; IFS=$'\n' options=(${Volumes_list[@]}); IFS="$OLDIFS"
	# OLDIFS="$IFS"; IFS=$'\n'; declare -a options=(${Volumes_list[@]}); IFS="$OLDIFS"
	# IFS='' readarray -t options <<<"$Volumes_list"
	# IFS=''; while read position; do options+=("„$position”"); done <<<"$Volumes_list"
	
	default=$((${#options[@]}+1))
	ask_info="$Nline$Green Select:$Yellow VOLUME$Green to:$S_Mode,$Reset"
	
	
	ask_select
	
	Volume=${Selected%% *}
	Volume=${Volume//:/}
	#echo "$Nline Akcepted: "$device""
	dest="volume"
}

Copy_mode ()
{
	File_type=".f.copy"
	Mode="Copy" Mode_type=".f.copy"
	S_Mode="$LRed $Mode$LCyan Source"
	C_Mode="{B}ackp_mode"
	functions=("${Cyan}!${Back}{R}escan" "$Cream!${Back}$C_Mode" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
	ask_info="$Nline$Green Select:$Yellow VOLUME$Green to:$S_Mode,$Reset"
}
Backp_mode ()
{
	File_type="f.tar.gz"
	Mode="Backup" Mode_type="f.tar.gz"
	S_Mode="$LRed $Mode$LCyan Source"
	C_Mode="{C}opy_mode"
	functions=("${Cyan}!${Back}{R}escan" "$Cream!${Back}$C_Mode" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
	ask_info="$Nline$Green Select:$Yellow VOLUME$Green to:$S_Mode,$Reset"
	
	
}

Ask_source_destination_device_names ()
{
	Ask_Source_Device_Name ()
	{
	local again="0" x="1 2 3 rabbit"
	for again in $x
	do :
		if [ "$again" = "rabbit" ]
		then :
			echo "$Nline$LRed Erorr: ???, exit$Nline$Reset"
			Log+="$Red Erorr: Var source:  is not a block device, $again exit$Nline"
			exit 1
		fi
		
		if [ ! "$Source" ]
		then :
		Log+="$Orange Var source:$Red „$Source”, select...\$2$Nline"
		echo "$Green"
		MESSAGE="[ $(( Nr+=1 )). SELECT SOURCE VOLUME TO BACKUP ]$Reset"
		Bar "$MESSAGE"
		
		S_Mode="$LRed $Mode$LCyan Source"
		if [ "$Mode" = "Backup" ]
		then :
		      C_Mode="{C}opy_mode"
		elif [ "$Mode" = "Copy" ]
		then :
		      C_Mode="{B}ackp_mode"
		else :
		fi
		
		Title_list="$LRed Backup$Green posibilities:$EraseR$Nline$EraseR"
		functions=("${Cyan}!${Back}{R}escan" "$Cream!${Back}$C_Mode" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
		Select_volume
		Source_backup="$Volume"
		echo -n "$Reset"
		
		else :
			Source_backup="$Source"
			Log+="$Green Var source:$SmoothBlue „$Source_backup”$Nline"
		fi
		
		if [ -b "$Source_backup" ]
		then :
			echo "$Nline$Green Volume: $LRed$Source_backup$Green to$Red archive$Green files system$Reset"
			Log+="$Orange Selected source:$SmoothBlue „$Source_backup”$Nline"
			break
		else :
			if [ "$Source_backup" = "{R}escan" ]
			then :
				echo "$Orange „$Source_backup”, try again...$Reset"
				Log+="$Red Erorr: „$Source_backup” is not a block device, try again...$again$Nline"
				Rescan 1
			elif [ "$Source_backup" = "{C}opy_mode" ]
			then :
				Copy_mode
			elif [ "$Source_backup" = "{B}ackp_mode" ]
			then :
				Backp_mode
			elif [ "$Source_backup" = "{I}nfo" ]
			then :
				Info
			elif [ "$Source_backup" = "E{x}it" ]
			then :
				Exit
			else :
				echo "$Orange „$Source_backup” is not a block device, try again...$Reset"
				Log+="$Orange „$Source_backup” is not a block device, try again...$again$Nline"
			fi
		fi
		
	done
	}
	
	Ask_Destination_Device_Name ()
	{
	local again=0 x="1 2 3 rabbit"
	for again in $x
	do :
		if [ "$again" = "rabbit" ]
		then :
			echo "$Nline$LRed Erorr: ???, exit$Nline$Reset"
			Log+="$Red Erorr: Var destination: „$Destination” is not a block device, $again exit$Nline"
			exit 1
		fi
		
		if [ ! "$Destination" ]
		then :
		#read -e -p "$Green Device name to$Yellow store$LBlue /$Destination_backup_dir/$Destination_backup_file$File_type:? $Yellow" Destination_backup
		Log+="$Orange Var destination:$Red „$Destination”, select...\$3$Nline"
		echo "$Yellow"
		MESSAGE="[ $(( Nr+=1 )). SELECT DESTINATION VOLUME ]$Reset"
		Bar "$MESSAGE"
		
		S_Mode="$LBlue Store $Mode$LCyan $Mode_type"
		Title_list="$LBlue Store$Green posibilities:$Nline$EraseR"
		functions=("${Cyan}!${Back}{R}escan" "${Red}!${Back}{F}ormat" "${Red}!${Back}F{d}isk" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
		Title_select="$Nline$Green Select:$Yellow VOLUME$Green to$LRed $S_Mode$Green image:$Reset"
		Select_volume "$Title_select"
		Destination_backup="$Volume"
		echo -n "$Reset"
		
		else :
			Destination_backup="$Destination"
			Log+="$Green Var destination:$SmoothBlue „$Destination”$Nline"
		fi
		
		if [ -b "$Destination_backup" ]
		then :
			echo "$Nline$Green Volume: $Yellow$Destination_backup$Reset$Green to$Yellow store$LBlue /$Destination_backup_dir/$Destination_backup_file$File_type"
			Log+="$Orange Selected destination:$SmoothBlue „$Destination_backup”$Nline"
			break
		else :
			if [ "$Destination_backup" = "{R}escan" ]
			then :
				echo "$Orange „$Destination_backup”, try again...$Reset"
				Log+="$Red Erorr: „$Destination_backup” is not a block device, try again...$again$Nline"
				Rescan 2
			elif [ "$Destination_backup" = "{F}ormat" ]
			then :
				echo "$Red First highlight Volume and pres: $Blink{F}$Reset"
				Sleep_key
			elif [ "$Destination_backup" = "F{d}isk" ]
			then :
				Fdisk
				S_Mode="$LBlue Store $Mode$LCyan file"
				Title_list="$LBlue Store$Green posibilities:$Nline$EraseR"
				functions=("${Cyan}!${Back}{R}escan" "${Red}!${Back}{F}ormat" "${Red}!${Back}F{d}isk" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
				Title_select="$Nline$Green Select:$Yellow VOLUME$Green to$LRed $S_Mode$Green image:$Reset"
			elif [ "$Destination_backup" = "{I}nfo" ]
			then :
				Info
			elif [ "$Destination_backup" = "E{x}it" ]
			then :
				Exit
			else :
				echo "$Orange „$Destination_backup” is not a block device, try again...$Reset"
				unset Destination_backup
			fi
		fi
	done
	}
	
	Check_Device_Names ()
	{
	local again=1
	
	Ask_Source_Device_Name;Ask_Destination_Device_Name
	
	while true
	do :
		if ! [ "$Source_backup" = "$Destination_backup" ]
		then :
			break
		else :
			if [ "$again" = "3" ]
			then echo "$LRed Erorr: ???, exit$Nline$Reset"
			Log+="$LRed Erorr: Source and destination have to be different devices,$again exit$Nline"
			exit 1
			fi
			
			echo "$Nline$Red$Blink !!!$Orange Source and destination have to be different devices$Reset"
			echo "$Red$Blink ( in this version of scripts )$Orange, try again...$Reset"
			Log+="$Orange Source and destination have to be different devices, try again...$again$Nline"
			
			again=$[$again+1]
			Ask_Source_Device_Name;Ask_Destination_Device_Name
		fi
	done
	}
	
	Check_Device_Names
	
}

Mount_source_backup ()
{
	mkdir -p $TMPDIR/EasyMonitor-$USER/Source_backup
	umount -vfR $TMPDIR/EasyMonitor-$USER/Source_backup >/dev/null 2>&1
	#fuser -k "$Source_backup"
	
	echo "$Nline$Green Mount$Red source$Green backup: $LRed„$Source_backup”$Green on: $Magenta$TMPDIR/EasyMonitor-$USER/Source_backup :$Reset"
	mount -v $Source_backup $TMPDIR/EasyMonitor-$USER/Source_backup
	if [ ! $? = 0 ]
	then :
		echo "$LRed Erorr: can't mount source backup: „$Source_backup”, exit$Reset$Nline"
		Log+="$LRed Erorr: can't mount source backup: „$Source_backup”, exit$Nline"
		exit 1
	else :
		Source_mounted="yes"
		Source_info=$(blkid $Source_backup)
		echo "$Cream $Source_info$Reset"
		Log+="$Green Source backup mounted:$SmoothBlue $Source_info$Nline"
	fi
}

Mount_destination_backup ()
{
	mkdir -p $TMPDIR/EasyMonitor-$USER/Destination_backup
	#umount -vfR $TMPDIR/EasyMonitor-$USER/Destination_backup >/dev/null 2>&1
	Mount_Point_Destination_backup=$(mount -l | grep "$Destination_backup " | awk '{print $3}')

	if [ "$Mount_Point_Destination_backup" = "" ]
	then :
		Mount_Point_Destination_backup=$TMPDIR/EasyMonitor-$USER/Destination_backup
		echo "$Nline$Green Mount$Yellow destination$Green backup: $Cyan„$Destination_backup”$Green on: $LBlue$TMPDIR/EasyMonitor-$USER/Destination_backup :$Reset"
		mount -v $Destination_backup $TMPDIR/EasyMonitor-$USER/Destination_backup 2>&1
		
		if [ ! $? = 0 ]
		then echo "$LRed Erorr: can't mount destination: „$Destination_backup”, exit$Reset$Nline"
		Log+="$LRed Erorr: can't mount destination: „$Destination_backup”, exit$Nline"
		exit 1
		fi
		Destination_info=$(blkid $Destination_backup)
		echo "$Cream $Destination_info $Reset"
		Destination_munted="yes"
		Log+="$Green Destination backup mounted:$SmoothBlue $Destination_info$Nline"
		
	else :
		echo "$Nline$LBlue Destination backup: „$Destination_backup”$Green is mounted as: $LBlue$Mount_Point_Destination_backup"
		Destination_info=$(blkid $Destination_backup)
		echo "$Cream $Destination_info $Reset"
		Log+="$Cream Destination backup: $Destination_info is mounted on: $Mount_Point_Destination_backup$Nline"
		
	fi
	
	# If the file already exists and is not a directory
	if [ -e "$Mount_Point_Destination_backup/$Destination_backup_dir" -a  ! -d "$Mount_Point_Destination_backup/$Destination_backup_dir" ]
	then :
		echo "$LRed Erorr: the file: $Destination_backup_dir already exists and is not a directory, exit$Reset$Nline"
		Log+="$LRed Erorr: the file: $Destination_backup_dir already exists and is not a directory, exit$Nline"
		exit 1
	fi

	# If any directory does not exist
	if [ ! -d "$Mount_Point_Destination_backup/$Destination_backup_dir" ]
	then :
		mkdir -p "$Mount_Point_Destination_backup/$Destination_backup_dir"
		# If mkdir success
		if [ $? = 0 ]
		then :
			echo "$Green $Mount_Point_Destination_backup/$Destination_backup_dir directory has been created$Reset"
			Log+="$Green $Mount_Point_Destination_backup/$Destination_backup_dir directory has been created$Nline"
		else :
			echo "$LRed Erorr: $Mount_Point_Destination_backup/$Destination_backup_dir directory can't be created, exit$Reset$Nline"
			Log+="$LRed Erorr: $Mount_Point_Destination_backup/$Destination_backup_dir directory can't be created, exit$Nline"
			exit 1
		fi
	fi
}

Label_volume ()
{
	echo "$LBlue"
	MESSAGE="{ $(( Nr+=1 )). LABEL SOURCE VOLUME }$Reset"
	Bar "$MESSAGE"
	
	read -p "$Nline$Red Enter a$LBlue LABEL$Green for$Red $Source_backup $Orange$Blink?: $Reset$Green" Destination_backup_file
	echo "$Red"
	if [ ! "$Destination_backup_file" = '' ]
	then :
	Type_File_System=$(blkid $Source_backup -o value -s TYPE)
	if [ $Type_File_System = "ext2" ] || [ $Type_File_System = "ext3" ] || [ $Type_File_System = "ext4" ]
	then :
		echo "$Orange tune2fs -L $Destination_backup_file $Source_backup$Reset"
		tune2fs -L $Destination_backup_file $Source_backup
		if [ $? = 0 ]
		then :
			Log+="$Orange Label:$Green tune2fs -L $Red„$Source_backup”$Green „$Destination_backup_file”$Nline"
			echo "$Yellow $(blkid $Source_backup)$Reset"
		else :
			echo "$LRed Erorr: tune2fs -L „$Source_backup”$Green „$Destination_backup_file”, exit$Reset$Nline"
			Log+="$LRed Erorr: tune2fs -L „$Source_backup”$Green „$Destination_backup_file”, exit$Nline"
			exit 1
		fi
	fi
	
	if [ $Type_File_System = "vfat" ] # dosfstools - Utilities for Making and Checking MS-DOS FAT File Systems on Linux
	then :
		Destination_backup_file=$(echo $Destination_backup_file | tr '[:lower:]' '[:upper:]')
		umount $Source_backup
		if [ $? = 0 ]
		then :
			
			Log+="$Green Umount: „$Source_backup”$Nline"
		else :
			Log+="$LRed Erorr: umount: „$Source_backup”, exit$Nline"
			exit 1
		fi
		
		echo "$Orange fatlabel $Source_backup $Destination_backup_file$Reset"
		fatlabel $Source_backup $Destination_backup_file
		if [ $? = 0 ]
		then :
			echo "$Yellow $(blkid $Source_backup)$Reset"
			Log+="$Orange Label:$Green fatlabel $Red„$Source_backup”$Green „$Destination_backup_file”$Nline"
		else :
			echo "$LRed Erorr: fatlabel „$Source_backup” „$Destination_backup_file”, exit$Reset$Nline"
			Log+="$LRed Erorr: fatlabel „$Source_backup” „$Destination_backup_file”, exit$Nline"
			exit 1
		fi
		
		mount $Source_backup $TMPDIR/EasyMonitor-$USER/Source_backup
		if [ $? = 0 ]
		then :
			
			Log+="$Green Mount: „$Source_backup” „$TMPDIR/EasyMonitor-$USER/Source_backup”$Nline"
		else :
			Log+="$LRed Erorr: mount: „$Source_backup” „$TMPDIR/EasyMonitor-$USER/Source_backup”, exit$Nline"
			exit 1
		fi
	fi
	
	if [ $Type_File_System = "ntfs" ] # ntfsprogs - NTFS Utilities
	then :
		umount $Source_backup
		if [ $? = 0 ]
		then :
			
			Log+="$Green Umount: „$Source_backup”$Nline"
		else :
			Log+="$LRed Erorr: umount: „$Source_backup”, exit$Nline"
			exit 1
		fi
		
		echo "$Orange ntfslabel $Source_backup $Destination_backup_file$Reset"
		ntfslabel $Source_backup $Destination_backup_file
		if [ $? = 0 ]
		then :
			echo "$Yellow $(blkid $Source_backup)$Reset"
			Log+="$Orange Label:$Green ntfslabel $Red„$Source_backup”$Green „$Destination_backup_file”$Nline"
		else :
			echo "$LRed Erorr: ntfslabel „$Source_backup” „$Destination_backup_file”, exit$Reset$Nline"
			Log+="$LRed Erorr: ntfslabel „$Source_backup” „$Destination_backup_file”, exit$Nline"
			exit 1
		fi
		
		mount $Source_backup $TMPDIR/EasyMonitor-$USER/Source_backup
		if [ $? = 0 ]
		then :
			
			Log+="$Green Mount: „$Source_backup” „$TMPDIR/EasyMonitor-$USER/Source_backup”$Nline"
		else :
			Log+="$LRed Erorr: mount: „$Source_backup” „$TMPDIR/EasyMonitor-$USER/Source_backup”, exit$Nline"
			exit 1
		fi
		
	fi
	# jfs_tune -L <label> <device>
	# jfsutils - IBM JFS Utility Programs
	# tunefs.reiserfs -l <label> <device>
	# reiserfs - Reiser File System utilities
	# xfs_admin -L <label> <device>
	# xfsprogs - Utilities for managing the XFS file system
	else :
	      echo "$Red You give empty LABEL for the volume: $LRed„$Source_backup”, skipped label it.$Reset"
	      Log+="$Red You give empty LABEL for the volume: $LRed„$Source_backup”, skipped label it.$Nline"
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

Rescan_disks ()
{
Get_disks_list
OLDIFS="$IFS"; IFS=$'\n'; options=(${Disks_list[@]}); select_list=(${options[@]}); IFS="$OLDIFS"
}

Fdisk ()
{
	echo "$Red"
	MESSAGE="[ $(( Nr+=1 )). RUN FDISK ]$Reset"
	Bar "$MESSAGE"
	(
		ask_info="$Nline$Green Select:$Yellow DEVICE:$Reset"
		Title_list="$LRed Fdisk$Green posibilities:$Nline$EraseR"
		functions=("${Cyan}!${Back}{R}escan_disks" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
		Rescan_disks
		select_list+=(${functions[@]})
		
		ask_select
		
		Device_Name=${Selected}
		Device_Name=${Device_Name%% *}
		Device_Name=${Device_Name//:/}
		Partition_Num=${Device_Name##*[![:digit:]]}
		Device=${Device_Name%$Partition_Num*}
		fdisk -l "$Device"
		fdisk "$Device" <<-List_of_Commands
		m
		q
		List_of_Commands
		fdisk "$Device"
		unset Selected
	)
	Rescan
	#S_Mode="$LBlue Store $Mode$LCyan file"
	#Title_list="$LBlue Store$Green posibilities:$Nline$EraseR"
	#functions=("$Cyan!${Back}{R}escan" "${Red}!${Back}{F}ormat" "${Red}!${Back}F{d}isk" "${SmoothBlue}!${Back}{I}nfo" "${Orange}!${Back}E{x}it")
	#Title_select="$Nline$Green Select:$Yellow VOLUME$Green to$LRed $S_Mode$Green image:$Reset"
	
	echo "$Yellow"
	MESSAGE="[ $(( Nr+=1 )). SELECT DESTINATION VOLUME ]$Reset"
	Bar "$MESSAGE"
	
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo ""; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
	# Time out loop
	#{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
}

Format ()
{
	Device_Name=${Preselected}
	Device_Name=${Device_Name%% *}
	Device_Name=${Device_Name//:/}
	if [ -b "$Device_Name" ]
	then :
	echo "$Red"
	MESSAGE="[ $(( Nr+=1 )). FORMAT DESTINATION PARTITION ]$Reset"
	Bar "$MESSAGE"
	Make_file_system_type
	fi
}

Change_id_type ()
{
	local Device_Name="$1"  Partition_Num="$2" Os_id_type="$3" Old_os_id="$4"
	t[83]="Linux" t[c]="FAT32" t[7]="NTFS"
	echo "$Red Change partition ID type: "$Old_os_id" - ${t[Old_os_id]} to: ID 0x$Os_id_type - ${t[Os_id_type]}"
	
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
	# Format and label filesystem on $Destination
	local label_for_partition
	
	echo "$Nline$Orange Format Volume: $LRed„$Preselected”$Reset"
	#echo "$Green to$Red STORE$Green files system from:$LBlue „$Source_backup”$Reset"
	Device_Name=${Preselected}
	Device_Name=${Device_Name%% *}
	Device_Name=${Device_Name//:/}
	file_system_type=$(blkid "$Device_Name" -o value -s TYPE)
	#file_system_type=$(lsblk "$Device_Name" --output FSTYPE 2>/dev/null|tail -1)
	
	Partition_Num=${Device_Name##*[![:digit:]]}
	Device=${Device_Name%$Partition_Num*}
	
	Read_label ()
	{
		if [[ "$label_for_partition" = "" ]]
		then :	
			label_for_partition=${Destination_backup_file%%_*}
			label_for_partition=${label_for_partition%%(*}
			
			echo "$Orange Enter$Cyan label$Orange for volume $LRed$Device_Name$Orange$Blink ?: $Reset$Yellow"
			read -ei "$label_for_partition" label_for_partition
		fi
	}
	Read_label
	
	echo "$Nline # mkfs $Yellow DESTINATION -> $LRed$Device_Name$Red <- The data on this device will be lost !!!."
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
		
		if [ ! "$file_system_type" = '' ]
		then :	
			
			Mount_Point_Destination_backup=$(mount -l | grep "$Device_Name "| awk '{print $3}')
			if [ ! "$Mount_Point_Destination_backup" = '' ]
			then :
				echo "$Yellow Umount destination „$Device_Name”:"
				umount -v $Device_Name; echo -n "$Reset"
				if ! [ $? = 0 ]
				then :
					echo "$LRed Erorr: can't umount destination, skipp fromat„$Device_Name”$Reset"
					Log+="$Red Erorr: can't umount destination, skipp fromat „$Device_Name”$Reset$Nline"
					skip=1
				else :	
					 Log+="$Yellow Umount destination „$Device_Name”$Reset$Nline"
					 skip=0
				fi
				
			else :
				skip=0
			fi
			
			if [ $skip = 0 ]
			then :
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
					echo "$LRed Erorr: mkfs -t $file_system_type „$Device_Name”$Reset$Nline"
					Log+="$LRed Erorr: mkfs -t $file_system_type „$Device_Name”$Reset$Nline"
					
				else :	
					Log+="$Orange Format:$Red mkfs -t $file_system_type „$Device_Name”$Reset$Nline"
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
				fi
			fi
			
		else :	
			echo "$Orange Empty file system type.$Red Skipped Format:$Green „$Device_Name”$Reset"
			Log+="$Orange Empty file system type.$Red Skipped Format:$Green „$Device_Name”$Reset$Nline"
		fi
		
		if [[ "$label_for_partition" = "" ]]
		then :	
			
			echo "$Orange Empty label.$Red Skipped label$Green „$Device_Name”$Reset"
			Log+="$Orange Empty label.$Red Skipped label$Green „$Device_Name”$Nline"
		else :	
			file_system_type=$(blkid "$Device_Name" -o value -s TYPE)
			# label ext file systems
			if [ "$file_system_type" = "ext2" ] || [ "$file_system_type" = "ext3" ] || [ "$file_system_type" = "ext4" ]
			then :	
				echo "$Green # LABEL: tune2fs -L "$label_for_partition" „$Device_Name”$Reset$Nline"
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
			# ntfsprogs - NTFS Utilities
			# jfs_tune -L <label> <device>
			# jfsutils - IBM JFS Utility Programs
			# tunefs.reiserfs -l <label> <device>
			# reiserfs - Reiser File System utilities
			# xfs_admin -L <label> <device>
			# xfsprogs - Utilities for managing the XFS file system
			
		fi
	else :	
	 	echo "$Orange Format:$Red „$Device_Name”$Green partiition skipped.$Reset"
	 	Log+="$Orange Format:$Red „$Device_Name”$Green partiition skipped.$Nline"
	fi
	echo "$Yellow"
	MESSAGE="[ $(( Nr+=1 )). SELECT DESTINATION VOLUME ]$Reset"
	Bar "$MESSAGE"
	
	Rescan
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo ""; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
	# Time out loop
	#{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
}

Ask_destination_backup_file_name ()
{
	if [ "$backup_name" ] && [ ! "$backup_name" = "LABEL" ]
	then :
	Destination_backup_file="$backup_name"
	Log+="$Orange Var backup name:$SmoothBlue „$backup_name”$Nline"
	
	else :
	Log+="$Orange Var backup name:$Red „$backup_name”, get LABEL for \$4$Nline"
	
	Destination_backup_file=$(blkid $Source_backup -o value -s LABEL)
	if [ "$Destination_backup_file" = '' ]
	then :
		echo "$LBlue LABEL$Yellow is empty for the volume: $LRed„$Source_backup”$Reset"
		
		again=-10
		echo "$EraseD"; Linesup 1
		echo "$SaveP"
		while true
		do :
			 echo -n "$RestoreP$EraseR"
			
			 read -p "$Orange Do you want give a LABEL for it, Please answer $Red{Y} ${SmoothBlue}or $Green{N} $Orange$Blink?: $Reset$Yellow"
			 echo -n "$Reset"
			 again=$[$again+1]
			
			 case $REPLY in
			 [Yy]* ) echo "$Orange Label volume: „$Source_backup”$Reset"
				Log+="$Orange LABEL$Yellow is empty for the volume: $Red„$Source_backup”$Nline"
			Label_volume
			break
			;;
			[Nn]* ) echo "$Orange Label volume: „$Source_backup” skipped.$Reset"
				Log+="$Orange Label volume: „$Source_backup” skipped.$Nline"
				break
			;;
			* )	echo -n "$RestoreP$EraseR$Yellow Please answer $Red{Y} ${SmoothBlue}or $Green{N}$Reset. ${Blink}Again:$Reset $again"
				IFS= read -r -s -t2 sleep2
				if [ "$again" = "0" ]
				then :
					echo "$LRed Erorr: ???, exit$Nline$Reset"
					Log+="$Red Erorr: ??? label „$Source_backup”, exit$Nline"
					exit 1
				fi
			;;
			esac
		done
	fi
	
	fi

	if [ "" = "$Destination_backup_file" ]
	then :
		echo "$Red Backup file name:„$Destination_backup_file” is empty$Reset"
		Log+="$Red Backup file name:„$Destination_backup_file” is empty$Nline"
		echo -n "$Red Enter a$Green name$Red for backup file $Orange$Blink?:$LBlue $Reset"
		Log+="$Red Enter a$Green name$Red for backup file.$Nline"
		
		read -e  -i "$Destination_backup_file$File_date" Destination_backup_file
		if [ "$Destination_backup_file" = '' ]
		then :
			echo "$LRed Erorr: no backup filename, exit$Nline$Reset"
			Log+="$Red Erorr: you give empty name for backup filename:„$Destination_backup_file”, exit$Nline"
			exit 1
		fi
	fi
	
	if [ -f "$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file$File_date$File_type" ]
	then : 	# backup file exist
		
		echo "$Nline$LGreen List of files in:$LBlue ”$Mount_Point_Destination_backup/$Destination_backup_dir/”$Reset"
		old_pwd="$(pwd)"
		cd "$Mount_Point_Destination_backup/$Destination_backup_dir/"
		if [ $? = 0 ]
			then	
				Log+="$Green cd:$SmoothBlue „$Mount_Point_Destination_backup/$Destination_backup_dir/”$Nline"
			else	
				Log+="$Red Erorr: cd: „$Mount_Point_Destination_backup/$Destination_backup_dir/”, exit$Nline"
				exit 1
			fi
		echo "$Green"
		ls -T 8 * 2>/dev/null
		echo "$Reset"
		
		Destination_backup_file_size=$(du -BM --apparent-size -s $Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file | awk '{ print $1 }')
		echo "$Orange$Blink File$Reset$Red „$Destination_backup_file$File_date$File_type” ($Destination_backup_file_size) exist!.$Reset"
		echo -n "$Red Chage a$Green base name$LBlue for backup file $Orange$Blink?:$LBlue $Reset"
		read -e -i "$Destination_backup_file$File_date" Destination_backup_file
		
		if [ "$Destination_backup_file" = '' ] 
		then :
			echo "$LRed Erorr: chage a backup filename, exit$Nline$Reset"
			Log+="$Red Erorr: chage a backup filename:„$Destination_backup_file”, exit$Nline"
			cd "$old_pwd"
			exit 1
		else :	# check again
			Destination_backup_file=$Destination_backup_file$File_date$File_type
			if [ -f "$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file" ]
			then :	 # ask for remove
				
				Destination_backup_file_size=$(du -BM --apparent-size -s $Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file | awk '{ print $1 }')
				
				echo "$Orange$Blink File$Reset$Red „$Destination_backup_file” ($Destination_backup_file_size) $Blink exist!.$Reset"
				Log+="$Red Ask: overwrite the backup file:„$Destination_backup_file” ($Destination_backup_file_size)$Nline"
				answer=$(
					r_ask_select "$Red {C}ontinue - (overwrite)$Green or$Orange {R}emove file! and Continue :$LRed "$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file" \
						$Nline$Orange Please select: " "1"  "{E}xit" "{C}ontinue" "{R}emove" '' '' '' "$Orange"
					) # info=$1 default=$2 select1="$3" select2="$4" select3="$5" color_s=$6 color_n=$7 color_u=$8 color_3="$9"
				[[ "$answer" == "Continue" ]] && \
				{
					echo "$Nline$Nline$Orange File will be overwrite$Blink!$LRed : $Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file$Reset"
					echo "$Green Freeing ($Destination_backup_file_size)$Reset"
					Log+="$Red Selected: overwrite the backup file:„$Destination_backup_file” ($Destination_backup_file_size)$Nline"
				}
				[[ "$answer" == "Remove" ]] && \
				{
					echo "$Nline$Nline$Orange Remove file$Blink!$LRed : $Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file$Reset"
					echo "$Green Freeing ($Destination_backup_file_size)$Reset"
					rm -f "$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file"
					if [ ! $? = 0 ]
					then :
						echo "$LRed Erorr: can't remove file$Blink!$LRed, exit$Reset$Nline"
						Log+="$Red Erorr: can't remove file:„$Destination_backup_file” ($Destination_backup_file_size)$Nline"
						exit 1
					else :
					Log+="$Red Selected: remove the backup file:„$Destination_backup_file” ($Destination_backup_file_size)$Nline"
					fi
				}
				[[ "$answer" == "Exit" ]] && \
				{
					echo "$Nline$Nline$Red exit$Reset$Nline"
					Log+="$Red Selected: exit$Nline"
					/bin/bash; exit
				}
				
			unset answer
			fi
			
		fi
		cd "$old_pwd"
	else : 	# new backup
		Destination_backup_file=$Destination_backup_file$File_date$File_type
		
	fi
}

Ask_for_store_additional_informations ()
{
	Device_Name=${Source_backup}
	Partition_Num=${Device_Name##*[![:digit:]]}
	
	Device_Name=${Device_Name%$Partition_Num*}
	
	Partition_UUID=${Source_info##* PARTUUID=}
	Partition_UUID=${Partition_UUID#*\"}
	Partition_UUID=${Partition_UUID%\"*}
	
	Device_UUID=${Partition_UUID%-*}
	
	Device_Boot_Gap_Record=$(fdisk -l "$Device_Name" | awk '{print $1,$2,$3}' | grep ""$Device_Name"1 "|awk '{print $2}')
	if [ "$Device_Boot_Gap_Record" = '*' ]
	then :
		Device_Boot_Gap_Record=$(fdisk -l "$Device_Name" | awk '{print $1,$2,$3}' | grep ""$Device_Name"1 "|awk '{print $3}')
	fi
	#echo "MBR  $Mbr"
	if [ "$Mbr" = "ask" ] || [ "$Mbr" = "mbr" ] || [ "$Mbr" = "separate" ]
	then :
		echo "$Yellow"
		MESSAGE="[ $(( Nr+=1 )). STORE SOME ADDITIONAL INFORMATIONS ON THE SOURCE ]$Reset"
		Bar "$MESSAGE"
		
		echo "$Nline$Red If you need, store some additional informations on the source - „$Source_backup” file system:$Reset"
		
		echo "$Nline$Green # partition info	  	blkid $Source_backup		 > „$Source_backup”/EM_Backup_log.txt$Reset"
		echo "$Green # report disk space usage 	df -h $Source_backup		>> „$Source_backup”/EM_Backup_log.txt$Reset"
		
		echo "$Green # fdisk partition table 	fdisk -l		>> „$Source_backup”/EM_Backup_log.txt$Reset"
		echo "$Green # Date `date`			>> „$Source_backup”/EM_Backup_log.txt$Reset"
		
		echo "$Nline$Green # Device Bootstrap       MBR   0 -> 446, 446 bytes.	> „$Source_backup”/EM_$Device_UUID-MBR.img$Reset"
		echo "$Green # Device Partition Table DPT 446 -> 510,  64 bytes.	> „$Source_backup”/EM_$Device_UUID-DPT.img$Reset"
		echo "$Green # Device Boot Gap Record GAP 512 -> Start(* 512 bytes)	> „$Source_backup”/EM_$Device_UUID-GAP.img$Reset"
		
		echo "$Nline$Green - blkid $Source_backup	>  „$Source_backup”/EM_Backup_log.txt$Reset"
		echo "$Green - df -h $Source_backup	>> „$Source_backup”/EM_Backup_log.txt$Reset"
		echo "$Green - fdisk -l		>> „$Source_backup”/EM_Backup_log.txt$Reset"
		
		echo "$Nline$Green - dd if=$Device_Name	of=„$Source_backup”/EM_$Device_UUID-MBR.img bs=446 count=1 conv=notrunc$Reset"
		echo "$Green - dd if=$Device_Name	of=„$Source_backup”/EM_$Device_UUID-DPT.img bs=1 skip=446 count=64 conv=notrunc$Reset"
		echo "$Green - dd if=$Device_Name	of=„$Source_backup”/EM_$Device_UUID-GAP.img bs=512 skip=1 count="$Device_Boot_Gap_Record"$Reset"
	fi
	
	if [ "$Mbr" = "ask" ]
	then :
		answer=$(
		r_ask_select "$Nline$Orange STORE some$Red additional informations,$Orange Please select:" "2"  "{Y}es" "{N}o" "E{x}it"  '' '' '' "$Orange"
		) # info=$1 default=$2 select1="$3" select2="$4" select3="$5" color_s=$6 color_n=$7 color_u=$8 color_3="$9"
		[[ "$answer" == "Yes" ]] && { :
			Mbr="mbr"
			echo "$Yellow Yes$Reset$Nline"
			echo "$Red Wirite$Green additional informations to:$LRed „$Source_backup”$Reset"
		}
		[[ "$answer" == "No" ]] && { :
			Mbr=""
			echo "$Yellow No$Reset$Nline"
			echo "$Orange Wirite$Green additional informations$Orange skipped.$Reset"
		}
		[[ "$answer" == "Exit" ]] && { :
			Log+="$Orange Selected: exit !$Reset$Nline"
			echo "$Yellow exit !$Reset"
			exit 0
		}
		
	fi
	
	if [ "$Mbr" = "mbr" ]
	then :	
		Log+="$Red Wirite$Green additional informations (MBR,DPT,GAP...) to:$Red „$Source_backup”$Nline"
		echo "$Nline$Yellow blkid $Source_backup > EM_Backup_log.txt$Reset"
		blkid $Source_backup > $TMPDIR/EasyMonitor-$USER/Source_backup/EM_Backup_log.txt
		echo "$Yellow df -h $Source_backup >> EM_Backup_log.txt$Reset"
		df -h $Source_backup >> $TMPDIR/EasyMonitor-$USER/Source_backup/EM_Backup_log.txt
		echo "$Yellow fdisk -l >> EM_Backup_log.txt$Reset"
		fdisk -l >> $TMPDIR/EasyMonitor-$USER/Source_backup/EM_Backup_log.txt
		echo "$Yellow Date `date` >> EM_Backup_log.txt$Reset"
		echo -n "Date " >> $TMPDIR/EasyMonitor-$USER/Source_backup/EM_Backup_log.txt
		date >> $TMPDIR/EasyMonitor-$USER/Source_backup/EM_Backup_log.txt
		
		echo "$Nline$Yellow dd if=$Device_Name  of=„$Source_backup”/EM_$Device_UUID-MBR.img bs=446 count=1 conv=notrunc$Reset"
		dd if=$Device_Name  of=$TMPDIR/EasyMonitor-$USER/Source_backup/EM_$Device_UUID-MBR.img bs=446 count=1 conv=notrunc
		
		echo "$Yellow dd if=$Device_Name  of=„$Source_backup”/EM_$Device_UUID-DPT.img bs=1 skip=446 count=64 conv=notrunc$Reset"
		dd if=$Device_Name  of=$TMPDIR/EasyMonitor-$USER/Source_backup/EM_$Device_UUID-DPT.img bs=1 skip=446 count=64 conv=notrunc
		
		echo "$Yellow dd if=$Device_Name of=„$Source_backup”/EM_$Device_UUID-GAP.img bs=512 skip=1 count="$Device_Boot_Gap_Record" conv=notrunc$Reset"
		dd if=$Device_Name of=$TMPDIR/EasyMonitor-$USER/Source_backup/EM_$Device_UUID-GAP.img bs=512 skip=1 count="$Device_Boot_Gap_Record" conv=notrunc
	else :	
		Log+="$Red Skipped wirite additional informations to:$Green „$Source_backup”.$Nline"
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
	SttyS="$(stty size|awk '{print $1-3;}')"
	echo "$Green Help: „MBR info”:$Magenta"
	more <<<"$MBR_info"
	read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
	echo -n "$Mbuffer"
}

Check_patch_name ()
{ :<<'COMMENT_EOF'
 Is there any difference between /... and //... ?
 A pathname consisting of a single slash shall resolve to the root directory
 Why is this? Is there any difference between /... and //... ?
 For the most part, repeated slahes in a path are equivalent to a single slash.
 The exception is that “a pathname that begins with two successive slashes
 may be interpreted in an implementation-defined manner”
 (but ///foo is equivalent to /foo).
 Linux doing anything special with //: it's bash's current directory
 The double slash (//) at the start also means root / directory but it still
 shows your CWD as // when you run pwd.

 filename=$(basename "$fullfile")
 extension="${filename##*.}"
 filename="${filename%.*}"
 and avoid calling an extra basename
 Alternatively, you can focus on the last '/' of the path instead of the '.'
 which should work even if you have unpredictable file extensions:
 filename="${fullfile##*/}"
 Path_to_file=$(dirname "$Path_file")
 Path_to_file="${Path_file%/*}"
COMMENT_EOF
}

Edit_path_name ()
{
	
	Read_path_neme ()
	{
	echo "$Nline$LBlue „$Destination_backup”|$Orange Enter a$Red path/name $Orange$Blink?: $Reset$Green"
	read -e -i "$Destination_backup_dir/$Destination_backup_file"
	echo -n "$Reset"
	
	#if [ "$REPLY" = '' ]
	#then :
	#echo "$Yellow Empty Destination$Red exit !$Reset$Nline"
	#exit 1
	#fi
	function path_remove {
	# Delete path by parts so we can never accidentally remove sub paths
	PATH=${PATH//":$1:"/":"} # delete any instances in the middle
	PATH=${PATH/#"$1:"/} # delete any instance at the beginning
	PATH=${PATH/%":$1"/} # delete any instance in the at the end
	}
	#REPLY=$(realpath -m -s "$REPLY")
	REPLY=$(readlink -m "$REPLY")
	
	Destination_backup_dir="$(dirname "$REPLY")"
	Destination_backup_file="${REPLY##*/}"
	Destination="$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file"
	Destination=$(readlink -m "$Destination")
	Volume_Patah="$Destination_backup_dir/$Destination_backup_file"
	Volume_Patah=$(readlink -m "$Volume_Patah")
	if [[ "$Destination_backup_file" = "" ]]
	then :
		Backup_log="$Mount_Point_Destination_backup/$Destination_backup_dir/$Mode_type.log"
		log_file="$SmoothBlue„$Destination_backup”|„$Volume_Patah/$Mode_type.log”"
		Backup_log=$(readlink -m "$Backup_log")
	else :
		Backup_log="$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file.log"
		log_file="$SmoothBlue„$Destination_backup”|„$Destination_backup_dir/$Destination_backup_file.log”"
		Backup_log=$(readlink -m "$Backup_log")
	fi
	Log+="$Green Edited backup file name:$SmoothBlue „$Destination_backup”|„$Volume_Patah”$Reset$Nline"
	
	}
	
	Read_path_neme
	
	if [ "$Mode" = "Backup" ]
	then :
		again="0" x="1 2 3 rabbit"
		for again in $x
		do :
			#Also worth trying: -e to test if a path exists without testing what type of file it is.
			#echo "$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file"
			#echo "$Destination"
			
			if [[ -d "$Destination" ]]
			then :
				echo "$Red$Blink Destination backup file is a folder!$Reset"
				Log+="$Red Destination backup file is a folder!$Reset$Nline"
				Destination_backup_file=''
				Go=""
			fi
			
			if [[ -f "$Destination" ]]
			then :
				Log+="$Red Destination backup file exist!$Reset$Nline"
				if [[ "yes" == $(r_ask "$Nline$Red Destination backup file exist.$Blink Ovewrite,$Reset$Orange Please answer: " "2" "r_key") ]]
				then :
					Log+="$Red Selected: Ovewrite destination backup file!$Reset$Nline"
					Go="go"
					break
				else :
					Destination_backup_file=''
					Go=""
				fi
				
			fi
			
			if [[ ! "$Destination_backup_file" = "" ]]
			then :
				Go="go"
				break
			fi
			if [ "$again" = "rabbit" ]
			then :
				Go=""
				echo "$Red$Blink Destination backup file name can't be empty, exit!$Reset$Nline"
				Log+="$Red Backup file name can't be empty,$again exit!$Reset$Nline"
				exit 1
			fi
			Read_path_neme
		done
		
	fi
	if [ "$Mode" = "Copy" ]
	then :
		again="0" x="1 2 3 rabbit"
		for again in $x
		do :
			if [[ -f "$Destination" ]]
			then :
				Log+="$Red Destination for copy is a file and exist!$Reset$Nline"
				if [[ "yes" == $(r_ask "$Nline$Red Destination for copy is a file and exist!.$Blink Remove$Reset$Orange Please answer: " "2" "r_key") ]]
				then :
					Log+="$Red Selected: Remove destination file!$Reset$Nline"
					rm -f "$Destination"
					Go="go"
					break
				else :
					if [ "$again" = "rabbit" ]
					then :
						Go=""
						echo "$Red$Blink Destination for copy can't be a file, exit!$Reset$Nline"
						Log+="$Red Destination for copy can't be a file,$again exit!$Reset$Nline"
						exit 1
					fi
					Destination_backup_file=''
					Go=""
					Read_path_neme
				fi
			else :
				Go="go"
				break
			fi
		done
	fi
}

Make_backup ()
{
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). MAKE $LRed$Mode$Green ]$Reset"
	Bar "$MESSAGE"
	# whitespace=$(printf '\n\t ')
	if [[ ${Destination_backup_file} == *[[:space:]]* ]]
	then :
		
		Log+="$Red Remove spaces from backup file name:$SmoothBlue „$Destination_backup”„$Destination_backup_dir”„$Destination_backup_file”$Reset$Nline"
		Destination_backup_file="${Destination_backup_file// /_}"
	fi
	
	Volume_Patah="$Destination_backup_dir/$Destination_backup_file"
	Volume_Patah=$(readlink -m "$Volume_Patah")
	Log+="$Green Backup file name:$SmoothBlue „$Destination_backup”|„$Volume_Patah”$Reset$Nline"
	
	Source=$TMPDIR/EasyMonitor-$USER/Source_backup
	
	
tar_root_exclude_list=(
"*./BACKUPS
./dev/*
./lost+found
./media/*
./mnt/*
./proc/*
./run/*
./sys/*
./tmp/*
./var/spool/*
./var/run/*
./var/tmp/*
./home/*"
)
rsync_root_exclude_list=(
"/BACKUPS/*
/dev/
/lost+found/
/media/
/mnt/
/proc/
/run/
/sys/
/tmp/
/var/spool/
/var/run/
/var/tmp/"
)
	#------------------------
	if [ "$Mode" = "Backup" ]
	then :
		exclude_file="backup_tar_exclude.txt"
	fi
	#------------------------
	if [ "$Mode" = "Copy" ]
	then :
		exclude_file="backup_rsync_exclude.txt"
	fi
	#------------------------
	# serch for exclude file on source backup or in script work dir
	if [ -f "${Source}/$exclude_file" ]
	then :
		backup_exclude_source=$(readlink -m "${Source}/")
		backup_exclude="--exclude-from=$(readlink -m "${Source}/$exclude_file")"
		
		echo "$Orange found exclude file: --exclude-from $backup_exclude_source"
		echo "$Magenta#$backup_exclude_source/$exclude_file"
		cat "$backup_exclude_source/$exclude_file"
		echo "$Reset$Nline"
		
	elif [ -f "${workdir}$exclude_file" ]
	then :
		backup_exclude_source=$(readlink -m "${workdir}")
		backup_exclude="--exclude-from=$(readlink -m "${workdir}$exclude_file")"
		
		echo "$Orange found exclude file: --exclude-from $backup_exclude_source"
		echo "$Yellow#$backup_exclude_source/$exclude_file"
		cat "$backup_exclude_source/$exclude_file"
		echo "$Reset$Nline"
		
	else :
		echo "$Orange $LRed No file:$Orange $exclude_file $LRed in:$Red „$Source_backup”"
		echo " Or in work dir$LRed in:$Red ${workdir}$exclude_file"
		echo "$Orange Exsample of exclude list in \"$exclude_file\":"
		echo "$Magenta"
		if [ "$Mode" = "Copy" ]
		then :	
			echo "${rsync_root_exclude_list[@]}"
		else :	
			echo "${tar_root_exclude_list[@]}"
		fi
		echo "$Reset"
		unset exclude_file
	fi
	
	echo "$Nline$Green You are as $Red\$${Magenta}root$Green going to:$LRed $Mode$Cyan flies$Nline"
	echo "$Nline$Yellow # CD $Source_backup$Reset"
	cd $TMPDIR/EasyMonitor-$USER/Source_backup
	if [ ! $? = 0 ]
	then :
		echo "$LRed Erorr: can't cd: $TMPDIR/EasyMonitor-$USER/Source_backup, exit$Reset$Nline"
		Log+="$Red Erorr: cd: „$TMPDIR/EasyMonitor-$USER/Source_backup”, exit$Nline"
		exit 1
	fi
	
	echo "$Yellow Wait a while for counting$Blink:$Cyan source files size...$Reset$Nline"
	Source_size=0
	Source_size=$(du -BM --apparent-size -s $Source | awk '{ print $1 }')
	Free_space=$(df -BM "$Mount_Point_Destination_backup/$Destination_backup_dir" | awk 'NR==2 {print $4}')
	
	(( enough=${Free_space%%[![:digit:]]*}-${Source_size%%[![:digit:]]*} ))
	[ "$enough" -lt "0" ] && Enough="$Red$Blink" || Enough="$Green"
	
	## Calculate the length of the longest item in Strings
	max_length=1
	for String in "${Source_size}" "${Free_space}"
	do :
		[ "${#String}" -gt "${max_length}" ] && max_length=${#String}
	done
	
	printf "$Red Source     :$LRed %-17s%s$Reset" "„$Source_backup”/."
	printf "$Orange(%*s)$Reset$Cyan flies to archive in:$LBlue „$Destination_backup”|$Destination_backup_dir$Reset\n" "$max_length" "$Source_size"
	#printf ".. %*s ..\n" $Max_lenght "$String"
	printf "$Yellow Destination:$LBlue %-*s$Reset" "17" "„$Destination_backup”|"
	printf "$Enough(%*s)$Reset$Cyan free for:$LBlue $Destination_backup_file $Reset\n" "$max_length" "$Free_space"
	if [ "$enough" -lt "0" ]
	then :
		echo "$Orange This is rather mission iposiple, bat you are judge, master and commander behind the wheel.
		So maybe there are a few files on the way && ju kan hearring :)$Reset"
	fi
		
	if [ "$Mode" = "Backup" ]
	then :
		echo  "$Yellow #$Reset tar cpz$Yellow S: „$Source_backup”/. -> $Cyan($Source_size)$Green D:-f ->$LBlue„$Destination_backup”|$Destination_backup_dir/$Destination_backup_file$Green<- $Reset"
		echo "$Orange # --exclude-from $backup_exclude_source/$Red$exclude_file$Reset"
		Start_time=`date +%s`
	fi
	
	if [ "$Mode" = "Copy" ]
	then :
		echo "$Yellow #$Reset rsync -aAXv$Yellow S: „$Source_backup”* -> $Cyan($Source_size)$Green D: ->$LBlue„$Destination_backup”|$Destination_backup_dir/$Destination_backup_file$Green<- $Reset"
		echo "$Orange # --exclude-from $backup_exclude_source/$Red$exclude_file$Reset"
	fi

	if [ "$Go" = "" ]
	then :
		if [ "$Mode" = "Copy" ]
		then :
			echo "$Nline$LCyan Tip - You can use \"/\" as name and then you get the clone of partition.$Reset"
		fi
	
		answer=$(
		r_ask_select "$Nline$Orange SURE,$LRed $Mode$Green flies,$Orange Please answer:$Red {C}ontinue$Green or$Orange {E}dit$LRed path/file!:\
		$Nline$Orange Please select: " "1"  "{C}ontinue" "{E}dit" "E{x}it"  '' '' '' "$Orange"
		) # info=$1 default=$2 select1="$3" select2="$4" select3="$5" color_s=$6 color_n=$7 color_u=$8 color_3="$9"
		[[ "$answer" == "Continue" ]] && { :
			Log+="$Orange Selected: Go$Reset$Nline"
			Go="go"
		}
		[[ "$answer" == "Edit" ]] && { :
			Log+="$Orange Selected: Edit path name$Reset$Nline"
			Edit_path_name
			Go="go"
		}
		[[ "$answer" == "Exit" ]] && { :
			Log+="$Orange Selected: exit !$Reset$Nline"
			echo "$Yellow exit !$Yellow exit"
			exit 0
		}
	fi
	
	if [ "$Go" = "go" ]
	then :
		Destination="$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file"
		Volume_Patah="$Destination_backup_dir/$Destination_backup_file"
		Destination=$(readlink -m "$Destination")
		Volume_Patah=$(readlink -m "$Volume_Patah")
		
		if [[ "$Destination_backup_file" = "" ]]
		then :
			Backup_log="$Mount_Point_Destination_backup/$Destination_backup_dir/$Mode_type.log"
			log_file="$SmoothBlue„$Destination_backup”|„$Volume_Patah/$Mode_type.log”"
			Backup_log=$(readlink -m "$Backup_log")
		else :
			Backup_log="$Mount_Point_Destination_backup/$Destination_backup_dir/$Destination_backup_file.log"
			log_file="$SmoothBlue„$Destination_backup”|„$Destination_backup_dir/$Destination_backup_file.log”"
			Backup_log=$(readlink -m "$Backup_log")
		fi
		
		Log+="$Orange Backup log file : $log_file$Reset$Nline"
		
		blkid $Source_backup > "$Backup_log"
		df -h $Source_backup >> "$Backup_log"
		fdisk -l >> "$Backup_log"
		echo "Backup destination: ${Backup_log%.log*}" >> "$Backup_log"
		echo "exclude file: $backup_exclude" >> "$Backup_log"
		if [ "$exclude_file" != "" ]
		then :
			cat "$backup_exclude_source/$exclude_file" >> "$Backup_log"
		else :
			echo "No exclude file" >> "$Backup_log"
		fi
		
		echo "$Nline$Red Start:$Green $Mode$LRed „$Source_backup”$Green to: $LBlue„$Destination_backup”|$Volume_Patah$Reset"
		echo "$Red$Blink Wait or go for a walk:$Reset"
		echo "$Orange '# Begin #'$Green $Mode files:$Reset$Blue `date`$Reset$Nline"
		
	#------------------------
	# tar backup
	if [ "$Mode" = "Backup" ]
	then :
		
		comment=<<-'EOF'
		`%{r,w,d}T'
		Print number of bytes transferred so far and approximate transfer
		speed.  Optional arguments supply prefixes to be used before number
		of bytes read, written and deleted, correspondingly.  If absent,
		they default to `R'. `W', `D'.  Any or all of them can be omitted,
		so, that e.g. `%{}T' means to print corresponding statistics
		without any prefixes.  Any surplus arguments, if present, are
		silently ignored.
		EOF
		echo  "'# Begin $Mode files #' `date`: „$Source_backup” -> ($Source_size)" >> "$Backup_log"
		Log+="$Orange '# Begin $Mode files #'$Reset$LBlue `date`:$Yellow „$Source_backup” -> $Cyan($Source_size)$Reset$Nline"
	#------------------------
	# Finaly simply backup command
	
		if command -v pv >/dev/null 2>&1
		then :
			Start_time=`date +%s`
			( cd "$Source" && tar cpz  $backup_exclude -f - . --checkpoint-action=ttyout='\033[1A\r  Read: %{}T (%d sec) : %t\033[1B\r'  2>>"$Backup_log") \
			| ( pv -c -N "$Creturn  Write" -s "$Source_size" -tpreb >$Destination )
			Elapsed_time=$((`date +%s` - $Start_time))
		else :
			Start_time=`date +%s`
			( tar cpz . $backup_exclude -f $Destination --checkpoint-action=ttyout='\033[1A\r Read %{ , , }T Write %{R, ,D}T  (%d sec) : %t\033[1B\r' 2>>"$Backup_log" )
			#| ( tar cpz -f $Destination --checkpoint-action=ttyout='\033[1B Write: %{R,W,D}T (%d sec) : %t\r\033[1B' - )
			Elapsed_time=$((`date +%s` - $Start_time))
		fi
		
		echo "$LGreen '# Done #' $Reset$Blue `date`$Reset"
		Dest_size=$(du -BM --apparent-size -s "$Destination" | awk '{ print $1 }')
		echo "$Cyan Compression: $Source_size -> $Dest_size : $((${Source_size%%[!0-9]*}-${Dest_size%%[!0-9]*}))${Dest_size#*${Dest_size%%[!0-9]*}} less, in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset$Nline"
		
		echo  "'# Done  $Mode files #' `date`: „$Destination_backup” <- ($Dest_size)" >> "$Backup_log"
		echo  "Compression: $Source_size -> $Dest_size : $((${Source_size%%[!0-9]*}-${Dest_size%%[!0-9]*}))${Dest_size#*${Dest_size%%[!0-9]*}} less, in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec" >> "$Backup_log"
		
		Log+="$LGreen '# Done  $Mode files #'$Reset$LBlue `date`:$Red „$Destination_backup” <- $Cyan($Dest_size)$Nline"
		Log+="$Cyan Compression: $Source_size -> $Dest_size : $((${Source_size%%[!0-9]*}-${Dest_size%%[!0-9]*}))${Dest_size#*${Dest_size%%[!0-9]*}} less, in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset$Nline"
	
	fi
	#------------------------
	# rsync copy
	
	if [ "$Mode" = "Copy" ]
	then :
	
	echo  "'# Begin $Mode files #' `date`: „$Source_backup” -> ($Source_size)" >> "$Backup_log"
	Log+="$Orange '# Begin $Mode files #'$Reset$LBlue `date`:$Yellow „$Source_backup” -> $Cyan($Source_size)$Reset$Nline"
	
	#------------------------
	# Finaly simply copy command
		if command -v  rsync >/dev/null 2>&1
		then :
			Start_time=`date +%s`
			( cd "$Source" && rsync $backup_exclude --stats --info=progress2 --info=name0 -aAX  * $Destination 2>>"$Backup_log")
			Elapsed_time=$((`date +%s` - $Start_time))
		else :
			echo "cp  -afxv * $Destination"
			Sleep_key
			Start_time=`date +%s`
			( cd "$Source" && cp  -afxv /* $Destination 2>>"$Backup_log")
			Elapsed_time=$((`date +%s` - $Start_time))
		fi
	
	echo "$LGreen '# Done #' $Reset$Blue `date`$Reset$Nline"
	echo  "$Cyan in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset"
	echo  "'# Done  $Mode files #' `date`: „$Destination_backup” <- in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec" >> "$Backup_log"
	Log+="$LGreen '# Done  $Mode files #'$Reset$LBlue `date`:$Red „$Destination_backup” <-$Cyan in: $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec$Reset$Nline"
	
	fi
	
	#------------------------
	
	Finished="Yes"
	
	else :
		echo "$Orange Backup$Red files$Orange skipped.$Reset"
		Log+="$Orange Backup$Red files$Orange skipped.$Reset"
	fi
}
Command_info=$(cat <<'EOF'

 That creates the files.xz archive :
 tar --xz -cf example.tar.xz file1 file2 file3
 or :
 tar --use-compress-program xz -cf example.tar.xz file1 file2 file3
 Which you can then unpack using :
 tar --xz -xf example.tar.xz
 or :
 tar --use-compress-program xz -xf example.tar.xz

 That creates the files.lzma archive :
 tar -cf files.lzma --lzma file* file* # -v  verbose option
 Which you can then unpack using :
 tar -xf files.lzma

 That creates the files.tar.gz archive :
 tar -czf files.tar.gz file* file*
 Which you can then unpack using :
 tar -xzf files.tar.gz

 Backup witch preserve file atributes (do as root) :
 cd Monunted_Partition; tar -cpzf /Destination/file.tar.gz *
 Restore witch preserve file atributes (do as root) :
 cd Monunted_Partition; date; tar -xpzf /Destination/file.tar.gz

 That creates the files.zip archive :
 zip -r files.zip file* file*
 Which you can then unpack using :
 unzip  files.zip

 That creates the files.cpio archive : ls | cpio -ov > filws.cpio
 Which you can then unpack using :
 cpio -idv < files.cpio

 rsync --exclude=relative/path/to/exclusion /source /dest
 rsync -avz --exclude-from 'exclude-list.txt' source/ destination/
 -z Compression of data transfer between server and client - not niden for local copy
 rsync -aAX --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /* /path/to/destination/
 (and to make it easy to read), don’t give / in front of the exclude path.
 The “–exclude” option works like a pattern, so:
 rsync -av –delete /home/me/.mozilla –exclude=Cache /media/hddext/backup
 will exclude any folder which has a name of “Cache”.
 /dir/ means exclude the root folder /dir
 /dir/* means get the root folder /dir but not the contents
 dir/ means exclude any folder anywhere where the name contains dir/
 -A preserve ACLs (implies -p)
 -X, --xattrs preserve extended attributes
 -x “Do not cross filesystem boundaries” means “do not look inside mount points”.
 A boundary between filesystems is a mount point. Effectively, this means 
 “only act on the specified partition”, except that not all filesystems are on a partition.
 See What mount points exist on a typical Linux system?
 When you make a backup, you should avoid a number of filesystems, in particular:
 remote filesystems (NFS, Samba, SSHFS, …);

 tar --exclude "logs" --exclude "*.tar.gz" -zcvf "Archive.tar.gz" -C "/path/to/files" .
 --exclude=/data/{sub1,sub2,sub3,sub4}
 tar -cvf myFile.tar --exclude=**/.git/* --exclude=**/node_modules/*  -T /data/txt/myInputFile.txt 2> /data/txt/myTarLogFile.txt
 tar -X <(for i in ${EXCLD}; do echo $i; done) -cjf backupfile.bz2 /home/*

 You can use standard "ant notation" to exclude directories relative.
 This works for me and excludes any .git or node_module directories.

 tar -cvf myFile.tar --exclude=**/.git/* --exclude=**/node_modules/*  -T /data/txt/myInputFile.txt 2> /data/txt/myTarLogFile.txt

 {*.png,*.mp3,*.wav,.git,node_modules} -Jcf ${target_tarball}  ${source_dirname}
 You can use cpio(1) to create tar files. cpio takes the files to archive on stdin
 so if you've already figured out the find command you want to use to select the files t
 he archive, pipe it into cpio to create the tar file:
 find ... | cpio -o -H ustar | gzip -c > archive.tar.gz
 While a FreeBSD root (i.e. using csh) I wanted to copy my whole root filesystem to
 /mnt but without /usr and (obviously) /mnt. This is what worked (I am at /):
 tar --exclude ./usr --exclude ./mnt --create --file - . (cd /mnt && tar xvd -)
 tar -cvzf destination_folder source_folder -X /home/folder/excludes.txt
 -X indicates a file which contains a list of filenames which must be excluded from the backup.
 For Instance, you can specify *~ in this file to not include
 any filenames ending with ~ in the backup.
 To exclude from root file system
 (cd first, so backup is relative to that directory)

 I'm trying to zip a directory (on Unix via SSH) but I need to exclude a 
 couple of subdirectories (and all files and directories within them).
 zip -r myarchive.zip dir1 -x dir1/ignoreDir1/* dir1/ignoreDir2/*
 However that will still include subdirectories within ignoreDir1 and ignoreDir2.
 ( globing)
 zip -r myarchive.zip dir1 -x "dir1/ignoreDir1/*" "dir1/ignoreDir2/*"
 zip -r myarchive.zip dir1 -x dir1/ignoreDir1/**\* dir1/ignoreDir2/**\*
 Instead of this: -x dir1/ignoreDir1/**\*, you can do this: -x dir1/ignoreDir1/\*

EOF
)

Umount_source_destination ()
{
	cd /
	if [ "$Source_mounted" ]
	then :
		echo -n "$Green"
		fuser -v -k "$Source_backup"
		umount -v "$Source_backup" && unset Source_mounted
		echo -n "$Reset"
		
	fi
	if [ "$Destination_munted" ]
	then :
		echo -n "$Green"
		umount -v "$Destination_backup" && unset Destination_munted
		echo -n "$Reset"
	fi
}
#################
Begin "$@"
