#!/bin/bash
 ### --------- ### ### Program ### include data ### Program ### ### --------- ###
comment= <<-'EOF'
if .... then
distro_data="$1"; DIR="${BASH_SOURCE%/*}"; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi;
 . "$DIR/${distro_data}"
EOF

Info_data ()
{
    Name=" # new_instal_distro.sh"
 Version=" # V1.5,.. \"${White}B${LWhite}l${Red}a${Cyan}c${LRed}k$Magenta|$Orange: ${Yellow}Terminal${LGreen}\" ${LWhite}B$Magenta&"$Orange"C$Orange Test beta script$Reset"
  Author=" # Leszek Ostachowski® (©2017) @GPL V2"
 Purpose=" # Script for download Linux live/distro/iso/packages/*$Nline # and add to GRUB boot menu or install"
 Worning=" # Highly flexibly specialized dynamic arrayed relational database$Nline"
Worning+=" # Infos about distros are mostly based on https://distrowatch.com"
#Worning+="$Nline # crouched in the bashingizm on school board @style free"
   Usage=" # Usage: Click on script"
  Usage+=""
  Usage+=""
  Usage+=""
Dependencies=( bash wget grep awk )
Optional_dependences=( konsole curl gpg )
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
		#Umount_source_destination
		
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
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	workdir="${BASH_SOURCE%/*}"
	if [[ ! -d "$workdir" ]]; then workdir="$PWD"; fi;
	cd "$workdir"
	
	# Gathering informations about dowload program
	if command -v wget >/dev/null 2>&1
	then :
		_get_command() { wget --tries=4 --timeout=40 -c "$@" ; }
		_chk_command() { env LANG=C wget --spider "$@" 2>&1 | grep Length | awk '{print $2}' ;}
		_snp_command() { wget -k -O "$@" ;}
	elif command -v curl >/dev/null 2>&1
	then :
		_get_command() { echo "$@"; curl -f --speed-time 1 -L -O -C - "$@" ; }
		_chk_command() { env LANG=C curl -sI "$@" | grep Content-Length | cut -d ' ' -f 2 ;}
		_snp_command() { curl -L "$2" -o "$1" ;}
	else :
		echo "$Red Eroor: This script needs curl or wget, exit$Reset$Nline" >&2
		exit 2
	fi
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
Exit ()
{
Log+="$LRed Selected: „Exit”"
exit
}
Info ()
{
echo -n "$Sbuffer"; clear
echo "${comment[$default]}" | more
read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
echo -n "$Mbuffer"
}

Run_as_root ()
{
	if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This install $Cyan$(basename "$0")$Orange script must be run with root privileges.$Reset"
	echo "$Cream su -c \"/bin/bash \"$(basename "$0")\" $*\"$Reset"
	su -c "/bin/bash \"$0\" $*"
	exit $?
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
	echo "$Stop_wrap"
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
			#echo -n ""$'\033[6n'""; read -sdR POS; CURPOS=${POS#*[}; echo -n ""$'\033['${#POS}'D'""
			printf "$Green$Blink%3s$Reset$Green)" " $x"
			printf "%.*s$Reset$EraseR\n" "$trim" " ${select_list[$x-1]}"
		else :
			printf "$Reset%3s)" " $x"
			printf "%.*s$Reset$EraseR\n" "$trim" "  ${select_list[$x-1]}"
			
		fi
		
	done
	
	# and print Preselected
	Message="$Nline$Orange Preselected$Yellow$Blink:$Green ${select_list[$default-1]%%:*}$Yellow$Blink<:,$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink?:$Reset$EraseR"
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
	   echo -n "$Start_wrap"
	   "$Procedure"
	   echo "$Stop_wrap"
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
	
	echo -n "$RestoreP"
	done
	echo -n "$Start_wrap"
	
	# calculate result
	Selected="${select_list[default-1]##*$'!\b'}"
	Selected=${Selected[@]#*;*m}
	Selected=${Selected[@]%%$'\033'[*}
	#Selected="${Selected[@]##*$': '}"
	Selected=${Selected[@]%%:*}
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
	
	#  The -v option causes hexdump to display all input data. -e, --format format_string
	Debug () { Linesup 1; printf "\r$Yellow hexdump > "; echo -en "${1}" |  hexdump -v -e '"|" 1/1 "%02_c" " "' | tr '\n' ';'; echo -n "$Reset" ;read -r -s -N1 sleep;}
	
	Print_in_columns ()
	{ #  e.g.  Print_in_columns  spacing=2 #  left_margin=6 number=yes separator='|' spacing=3
	trap 'exit' SIGTERM
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
	echo -n "$Mbuffer"
	[ $(( $max_col_length )) -gt $(( $Vcolumns - 15 )) ] && max_length=$(( $Vcolumns-$left_margin-$padding-$prefix-${#separator} )) && echo -n "$Sbuffer" #&&  Erase_U="$Home"
	
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
	Linesup 1; printf "$Creturn$Yellow$Faint%*.*s$EraseR$Reset\n" "0" "$trim_length" "$Message"
	
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
	trap 'Print_selection' SIGWINCH
	
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
	
	trap '' SIGWINCH
	# calculate result
	
	unset answer
	echo "$Nline Akcepted: \"${Selected}\"$Reset" #; sleep 5
	
}

function ping_gw ()
{ COMMAND=$(command -v ping) && sudo $COMMAND -q -w 3 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2>&1 && return 0 || return 1
}

get_it ()
{
	# Build download command, mirror and path
	local mirror= mirrors="$1" file="$2"
	shift
	for try in 1 2 3 4 5 6 7 8 9
	do :
		Bar "[$Red try nr. $try$Reset ]"
		for mirror in $mirrors
		do :
			_get_command "$mirror$file" && return 0
		done
	done
	return 1

}

get_size_file_to_download ()
{
	local mirror= mirrors="$1" file="$2"
	shift
	for try in 1 2 3 4 5
	do :
		for mirror in $mirrors
		do :
			_chk_command "$mirror$file" && return 0
		done
	done
	return 1

}

get_key_from_key_servers ()
{
	# Pull public key from key servers
	local keyring="$1" key_servers="$2" key="$3"
	
	for key_server in $key_servers; do
		echo "$Nline$Green Pull the public key from the $key_server to $keyring $Reset$Nline"
		gpg --no-default-keyring --keyring $keyring --keyserver $key_server --recv-key $key &&  return 0
	done
	
	if [[ "${distro[X]}" = *"manjaro"* ]]
	then :
	echo "$Nline$Green Pull the public key from the -$SmoothBlue https://github.com/manjaro/packages-core/raw/master/manjaro-keyring/manjaro.gpg$Green to $keyring $Reset$Nline"
	wget https://github.com/manjaro/packages-core/raw/master/manjaro-keyring/manjaro.gpg
	gpg --no-default-keyring --keyring $keyring --import manjaro.gpg && return 0
	fi
	
	if [[ "${distro[X]}" = *"sparkylinux"* ]]
	then :
	echo "$Nline$Green Pull the public key from the -$SmoothBlue http://sparkylinux.org/files/klucz/sparkylinux-iso.gpg.keyy$Green to $keyring $Reset$Nline"
	wget http://sparkylinux.org/files/klucz/sparkylinux-iso.gpg.key
	gpg --no-default-keyring --keyring $keyring --import sparkylinux-iso.gpg.key && return 0
	fi
	return 1
}

get_download_parameters ()
{
for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
do
comment=cat <<EOF
echo $distro_x
echo ${use_get_download_parameters[distro_x]}
EOF
if ! [[ -z ${file_name[distro_x]} ]] && ! [[ -z ${distro[distro_x]} ]] && [[ ${use_get_download_parameters[distro_x]} = "yes" ]]

then :
	cd "${install_folder[distro_x]}"
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: cd to install folder $Cyan"${install_folder[distro_x]}",$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	fi
	
	get_download_parameters[$distro_x]
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: Get download parameters $Cyan"${file_name[distro_x]}",$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	else :
		MESSAGE+="$Nline$Green $(( mn+=1 )). Get download parameters: $Cyan"${file_name[distro_x]}"$Reset$Nline"
	fi
else :
	true
fi
done

}

function check_free_space ()
{
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
	
	df -Pk "${path}" | awk 'NR==2 {print $4}' | awk '{result = $1'${count}'; printf "%.3f '${unit}'",result}'
	! [[ -z ${wrong_parameter} ]] && echo "$Red Wrong parameter unit: „${wrong_parameter}” - Usage: unit - [ B | KB | MB | GB ] [ PATH ]$Reset" && return 1
	return 0
}

calculate ()
{ # integer calculate { (let result='$1') <<<${size_ping} >/dev/null 2>&1 && echo ${result} ;} || float calculate using awk
	 result=$(awk '{result = '${1}'; print result}' <<<${_ping} 2>/dev/null ) && [ ! -z ${result} ] && echo ${result}
}

remove_color_codes ()
{
	#Remove color codes (special characters) with sed
	echo $(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" <<<${1})
}

test_integer ()
{
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


ask_nuber ()
{
	echo "$EraseR";echo "$EraseR";echo "$EraseR";Linesup 3
	echo -n "$SaveP"
	
	try=("..." ".." "${Blink}!" "rabbit")
	try_length=${#try[@]}
	for again in ${try[@]}
	do :
		read -p "$Nline$Orange$EraseR Give size in MB for file contain a disk image,$SmoothBlue MB$LRed$Blink ?:$Reset$Yellow " size; echo -n "$Reset"
		
		size=$(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" <<<${size}|tr -d '[:blank:][:cntrl:][:space:]')
		
		# integer calculate /^?-/ { let result=${size} >/dev/null 2>&1 && size=${result} ;} ||  float calculate using awk
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


install_package ()
{
for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
do
if ! [[ -z ${file_name[distro_x]} ]] && ! [[ -z ${distro[distro_x]} ]] && [[ ${use_install_script[distro_x]} = "yes" ]]
then :
	cd "${install_folder[distro_x]}"
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: Cd to install folder $Cyan"${install_folder[distro_x]}",$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	fi
	
	install_package[$distro_x]
	if ! [ $? = 0 ]
	then :
	      echo "$Nline$Red Error: install $Cyan${file_name[distro_x]}, exit 1 $Reset$Nline"
	      /bin/bash
	      exit
	else :
		echo "$Green ok$Reset"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Install: $Cyan${file_name[distro_x]} $Reset$Nline"
	fi
	
fi
done
}

gen_boot_menus ()
{
#root=your_iso_image isoloop=$isofile
#!FIXME
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
	do
		if ! [[ -z ${file_name[distro_x]} ]] && ! [[ -z ${distro[distro_x]} ]] && [[ ${add_to_boot_menu[distro_x]} = "yes" ]]
		then :
			gen_boot_menus[$distro_x]
		elif ! [[ -z ${file_name[distro_x]} ]] && ! [[ -z ${distro[distro_x]} ]] && [[ ${add_to_boot_menu[distro_x]} = "no" ]]
		then :
		else :
		fi
	done
}

Get_post_mesage ()
{
unset Important_after_installations
for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
do
	if ! [ -z "${distro[$distro_x]}" ]
	then :
		 Important_after_installations=${Important_after_installation[$distro_x]}
	fi
done

Post_MESSAGE=$( cat<<-EOF
Important after installation:
${Important_after_installations}
EOF
)
}

end_message()
{
	Elapsed_time=$((`date +%s` - $Start_time))
	
	Get_post_mesage
	cat <<-EOF
		$Green
		 Hi,
		 You:) has successfully:
		 $MESSAGE
		 $Post_MESSAGE
		 $Nline Finished in $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec
		 $Green$Blink # The end. # $Reset of: $(basename "$0") ...$LBlue `date` $Reset$Nline
	EOF
}

ask_for_install ()
{
	ask_for_instal_distro () {
	
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
	dir_to_check=$(check_existing_path ${install_folder[$distro_x]})
	echo "$Cyan Check free space on:$SmoothBlue „${dir_to_check}”$Reset"
	
	left_space=$(check_free_space GB ${dir_to_check}) # && echo "Free space in: $install_folder_x - $left_space"
	
	enough=$(calculate "${left_space%% *}-${free_space_x%% *}")
		
		if test_integer ${enough}
		then :
			if [[ "$RETURN" = *"negative"* ]]
			then :
				after_download="$Red$Blink [= ${enough} GB]$Reset"
			else :
				after_download="$Green [= ${enough} GB]$Reset"
			fi
		fi
	Bar="[>            <]"
	
	String="$free_space_x"
	free_space_x=$(echo -n "${Bar:0:-${#String}}"; echo -n "$String"; echo "${Bar: -1}")
	String="$left_space"
	left_space=$(echo -n "${Bar:0:-${#String}}"; echo -n "$String"; echo "${Bar: -1}")
	if [[ "No" == $(r_ask_select "$Nline$Magenta You are as $Red\$${Magenta}root$Green going to:\
			$Nline$Green Download file:$Reset „$file_name_x”$Green from:$Nline$Cyan $mirrors_x $Nline$Green And install or add it to boot menu for run.\
			$Nline$Cyan You need for files -$Orange $free_space_x$Cyan free space.\
			$Nline$Cyan Left free space is -$Green $left_space$Cyan for:$Reset „$install_folder_x”$Cyan folder.\
			$Nline$Cyan Free space after download$after_download$Cyan on :$Reset „${dir_to_check}”
			$Nline$Orange Please select - " "1")
	]]
	then :
		echo "$Nline$Orange ok, next time$Reset$Nline"
		return 1
	else :
		umask 000 # full access for everybody
		mkdir -p "${install_folder[$distro_x]}"
		if ! [ $? = 0 ]
		then :
			echo "$Red Error: Cannot creat folder ${install_folder[$distro_x]}, exit$Reset$Nline"
			exit 1
		fi
		echo "$Reset"
		return 0
	fi
	
	}
		
	###
	# Select distro
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ )); do
	if ! [[ -z "${distro[$distro_x]}" ]] && ! [[ -z ${file_name[$distro_x]} ]]
	then :
	     Distro_name[$distro_x]=${comment[$distro_x]##*'['}
	     Distro_name[$distro_x]=${Distro_name[$distro_x]%']'*}
		options[$distro_x]=" ${file_name[$distro_x]}: ${Distro_name[$distro_x]}"
	fi
	done
	
	if  [ "${#options[*]}" -gt "1" ]
	then :
		#echo "$Nline$Green You are as $Red\$${Magenta}root$Green going to download and install package or live linux distro into boot menu:$Reset"
		keys=("1""2""3""4") default="1" # options=( "1" "..") default=$(( ${#options[@]}+1))
		ask_info="$Green You are as $Red\$${Magenta}root$Green going to download and install package or live linux distro into boot menu:$Reset$Nline$Green Select$Yellow Distro$LBlue image$Green to download:$Reset"
		functions=("$Cyan!${Back}{I}nfo" "$Orange!${Back}E{x}it")
		Title_list="$SmoothBlue Posibilities:$Nline"
		ask_select
	###
		echo "$Nline$Green Selected = $Cyan$Selected$Reset$Nline"
		for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
		do
		if ! [ -z "${distro[$distro_x]}" ]
		then :
			if ! [[ $Selected = ${file_name[$distro_x]} ]]
			then :
				distro[$distro_x]=''
			fi
		fi
		done
	fi
	###
	
	
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
	do
	 if ! [[ -z "${distro[$distro_x]}" ]] && ! [[ -z ${file_name[$distro_x]} ]]
	 then :
	    file_name_x=${file_name[$distro_x]}
	    mirrors_x=${mirrors[$distro_x]}
	    install_folder_x="${install_folder[$distro_x]}"
	    free_space_x="${free_space[$distro_x]}"
	    ask_for_instal_distro
	    if ! [ $? = 0 ]; then unset distro[$distro_x]; fi
	 fi
	done
}

download_distro ()
{
	download_it ()
	{
	 Debug ()
	 {
		echo "install_folder_x="$install_folder_x""
		echo "mirrors_x="$mirrors_x""
		echo "file_name_x="$file_name_x""
		echo "file_type_x="$file_type_x""
		echo "sum_x="$sum_x""
		echo "gpg_file_x="$gpg_file_x""
		echo "sum_file_x="$sum_file_x""
	 }
	# Debug
	
	umask 000 # full access for everybody
	# find . -type f -exec chmod 666 -- {} + "$install_folder_x" # full access for everybody
	mkdir -p "$install_folder_x"
	if ! [ $? = 0 ]
	then :
		echo "$Red Error: Cannot creat folder $install_folder_x, exit$Reset$Nline"
		exit 1
	fi
	
	cd "$install_folder_x"
	if ! [ $? = 0 ]
	then :
		echo "$Red Error: Cannot cd to folder $install_folder_x, exit$Reset$Nline"
		exit 1
	fi
	
	# Get gpg_file_x
	if ! [[ -z $gpg_file_x ]]
	then :
		if [ -f "$gpg_file_x" ]
		then :
			echo "$SmoothBlue gpg$Cyan file:$Reset „$gpg_file_x”$Green for:$Reset „$file_name_x”$Orange, exist $Reset$Nline"
			! [[ "$url_to_download" = "Off_line_" ]] && \
			{
			if ! [[ "No" == $(r_ask_select "$Green Clear and try redownload again,$Orange Please select - " "2") ]]
			then :
				
				echo "$Nline$Green Clear and redownload from:$Cyan „$mirrors_x”$Green gpg file:$Reset „$gpg_file_x”$Green to:$Cyan„$install_folder_x”$Green folder $Reset$Nline"
				rm -f "$gpg_file_x"
				get_it "$mirrors_x" "$gpg_file_x"
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: download, exit 1 $Reset$Nline"
					/bin/bash ; exit
				else :
					echo "$Green ok $Reset"
				fi
				MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload: „$gpg_file_x” to „$install_folder_x” folder $Reset$Nline"
			else :
				echo "$Nline$Orange Skipped.$Reset$Nline"
				MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload: „$gpg_file_x” to „$install_folder_x” folder $Reset$Nline"
			fi
			}
		
		else :
			echo "$Nline$Green Download:$SmoothBlue gpg$Cyan from:$Reset„$mirrors_x”$SmoothBlue file:$Reset„$gpg_file_x”$Green for:$Reset„$file_name_x”: $Reset$Nline"
			if ! [[ "$url_to_download" = "Off_line_" ]]
			then :
				get_it "$mirrors_x" "$gpg_file_x"
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: download, exit 1 $Reset$Nline"
					/bin/bash ; exit
				else :
					echo "$Green ok $Reset"
				fi
				MESSAGE+="$Nline$Green $(( mn+=1 )). Download „$gpg_file_x” to „$install_folder_x” folder $Reset$Nline"
			else :
				echo "$Nline$Orange Skipped,$Blink Off line.$Reset$Nline"
				MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped download: „$gpg_file_x” to „$install_folder_x” folder $Reset$Nline"
			fi
		fi
		#!FIXME
		# Set sum file name of current file to download
		if [ -f "$gpg_file_x" ]
		then :
			sum_=$(cat "$gpg_file_x"|grep -e "$file_name_x"| head -1 | tr -d '*()='| tr -dc '[[:print:]]'| awk '{print $1}')
			
		fi
		Debug ()
		  {
			echo "$Yellow$Blink!$Reset$Yellow Strip gpg_file_x:„$gpg_file_x”  file_name_x:„$file_name_x”  sum:\"$sum_\" file_name_:\"$file_name_\"$Reset"
			#echo "$SmoothBlue"; cat "$gpg_file_x"; echo "$Reset"
		  }
		# Debug
		if ! [ -z "$sum_" ]
		then :
			file_name_=$(cat "$gpg_file_x"|grep -e "$file_name_x"| head -1 | tr -d '*()='| tr -dc '[[:print:]]'| awk '{print $2}')
			file_name_=${file_name_##*/}
			lengt=${#sum_}
			[[ $lengt = 32 ]] && name_sum="md5_sums_"
			[[ $lengt = 40 ]] && name_sum="sha1_sums_"
			[[ $lengt = 64 ]] && name_sum="sha256_sums_"
			[[ $lengt = 128 ]] && name_sum="sha512_sums_"
			if [ -z "$name_sum" ]
			then :
				Debug
				echo "$Nline$Red Error: string - „$sum_”  for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			echo "$sum_ $file_name_" > "$name_sum$title_name_x.txt"
		fi
	fi
	
	# Get sum_file_x
	if ! [[ -z $sum_file_x ]]
	then :
	###
		if [ -f "$sum_file_x" ]
		then :
			echo "$SmoothBlue sum$Cyan file: $Reset„$sum_file_x”$Green for: $Reset„$file_name_x”$Orange, exist$Reset$Nline"
			! [[ "$url_to_download" = "Off_line_" ]] && \
			{
			if ! [[ "No" == $(r_ask_select "$Green Clear and try redownload again,$Orange Please select - " "2") ]]
			then :
				echo "$Nline$Green Clear and redownload from: $Cyan„$mirrors_x”$Reset „$sum_file_x”$Green to: $Cyan„$install_folder_x”$Green folder: $Reset$Nline"
				rm -f "$sum_file_x"
				get_it "$mirrors_x" "$sum_file_x"
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: download, exit 1 $Reset$Nline"
					/bin/bash ; exit
				else :
					echo "$Green ok$Reset"
				fi
				MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload: „$sum_file_x” to: „$install_folder_x” folder $Reset$Nline"
			else :
				echo "$Nline$Orange Skipped.$Reset$Nline"
				MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload:„$sum_file_x” to: „$install_folder_x” folder $Reset$Nline"
			fi
			}
		else :
			echo "$Nline$Green Download:$SmoothBlue sum$Cyan file$Green from:$Nline$Cyan „$mirrors_x”$Nline$Reset„$sum_file_x”$Green for: $Reset„$file_name_x” : $Reset$Nline"
			if ! [[ "$url_to_download" = "Off_line_" ]]
			then :
				get_it "$mirrors_x" "$sum_file_x"
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: download, exit 1 $Reset$Nline"
					/bin/bash ; exit
					else :
						echo "$Green ok$Reset"
					fi
				MESSAGE+="$Nline$Green $(( mn+=1 )). Download: „$sum_file_x” to: „$install_folder_x” folder $Reset$Nline"
			else :
				echo "$Nline$Orange Skipped,$Blink Off line.$Reset$Nline"
				MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped download: „$sum_file_x” to: „$install_folder_x” folder $Reset$Nline"
			fi
		fi
		#!FIXME
		# Set sum and file name of current file to download
		#sum_=$(cat "$sum_file_x"|grep -e "elive"| head -1 | tr -d '*()=' | tr -dc '[[:print:]]' | awk '{print $1}') #!FIXME
		if [ -f "$sum_file_x" ]
		then :
			sum_=$(cat "$sum_file_x"|grep -e "$file_name_x"| head -1 | tr -d '*()=' | tr -dc '[[:print:]]' | awk '{print $1}')
			file_name_=$(cat "$sum_file_x"|grep -e "$file_name_x"| head -1 | tr -d '*()=' | tr -dc '[[:print:]]' | awk '{print $2}')
			file_name_=${file_name_##*/}
			if [ "$sum_" = "${file_name_x##*/}" ]
			then :
			fi
				
		fi
		Debug ()
		 {
			echo "$Yellow$Blink!$Reset$Yellow Strip sum_file_x:„$sum_file_x”  file_name_x:„$file_name_x”  sum:\"$sum_\" file_name_:\"$file_name_\"$Reset"
			#echo "$SmoothBlue"; cat "$sum_file_x"; echo "$Reset"
		 }
		# Debug
		if ! [ -z "$sum_" ]
		then :
			#file_name_=$file_name_x #!FIXME
			lengt=${#sum_}
			[[ $lengt = 32 ]] && name_sum="md5_sums_"
			[[ $lengt = 40 ]] && name_sum="sha1_sums_"
			[[ $lengt = 64 ]] && name_sum="sha256_sums_"
			[[ $lengt = 128 ]] && name_sum="sha512_sums_"
			if [ -z "$name_sum" ]
			then :
				Debug
				echo "$Nline$Red Error: string - „$sum_”  for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			echo "$sum_ $file_name_" > "$name_sum$title_name_x.txt"
		fi
	###
	else :
		# Set sum from string
		if ! [ -z "$sum_x" ]
		then :
			lengt=${#sum_x}
			[[ $lengt = 32 ]] && name_sum="md5_sums_"
			[[ $lengt = 40 ]] && name_sum="sha1_sums_"
			[[ $lengt = 64 ]] && name_sum="sha256_sums_"
			[[ $lengt = 128 ]] && name_sum="sha512_sums_"
			if [ -z "$name_sum" ]
			then :
				echo "$Nline$Red Error: sum strung - „$sum_x” for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			echo "$sum_x $file_name_x" > "$name_sum$title_name_x.txt"
		fi
	fi
	
	# Get file_name_x
	if ! [[ -z $file_name_x ]]
	then :
		# if sum file get name of current file to download
		if [ -e "md5_sums_$title_name_x.txt" ]
		then :
			read -r md5 file_name_x < "md5_sums_$title_name_x.txt"
			# echo "„file_name_x”: „$file_name_x”"
			lengt=${#md5}
			if ! [ "$lengt" = 32 ]
			then :
				echo "$Nline$Red Error: md5 sum strung - „$md5” in - „md5_sums_$title_name_x.txt” for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			if [ -z "$file_name_x" ]
			then  echo "$Nline$Red Error: file name in - „md5_sums_$title_name_x.txt” is not correct set, exit 1 $Reset$Nline"
			/bin/bash ; exit
			fi
		fi
	
		if [ -e "sha1_sums_$title_name_x.txt" ]
		then :
			read -r sha1 file_name_x < "sha1_sums_$title_name_x.txt"
			lengt=${#sha1}
			if ! [ "$lengt" = 40 ]
			then :
				echo "$Nline$Red Error: sha1 sum strung - „$sha1” in - „$sha1_sums_$title_name_x.txt” for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			if [ -z "$file_name_x" ]
			then :
			      echo "$Nline$Red Error: file name in - „sha1_sums_$title_name_x.txt” is not correct set, exit 1 $Reset$Nline"
			      /bin/bash ; exit
			fi
		fi
	
		if [ -e "sha256_sums_$title_name_x.txt" ]
		then :
			read -r sha256 file_name_x < "sha256_sums_$title_name_x.txt"
			lengt=${#sha256}
			if ! [ "$lengt" = 64 ]
			then :
				echo "$Nline$Red Error: sha256 sum strung - „$sha256” in - „sha256_sums_$title_name_x.txt” for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			if [ -z "$file_name_x" ]
			then :
				echo "$Nline$Red Error: filename in - „sha256_sums_$title_name_x.txt” is not correct set, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
		fi
		
		if [ -e "sha512_sums_$title_name_x.txt" ]
		then :
			read -r sha512 file_name_x < "sha512_sums_$title_name_x.txt"
			lengt=${#sha512}
			if ! [ "$lengt" = 128 ]
			then :
				echo "$Nline$Red Error: sha512 sum strung - „$sha512” in - „sha512_sums_$title_name_x.txt” for file name - „$file_name_x” is not correct length, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
			if [ -z "$file_name_x" ]
			then :
				echo "$Nline$Red Error: filename in - „sha512_sums_$title_name_x.txt” is not correct set, exit 1 $Reset$Nline"
				/bin/bash ; exit
			fi
		fi
		
		
	
	if [ -f "$file_name_x" ]
	then :
		echo "$SmoothBlue distro$Cyan file:$Reset „$file_name_x”$Orange, exist!$Reset"
		! [[ "$url_to_download" = "Off_line_" ]] && \
		{
		[[ -z "$file_Size_to_download" ]] && \
		file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "$mirrors_x" "$file_name_x" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
		)
		echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Reset"
		}
		
		actual_size=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		wc -c <"$install_folder_x"/"$file_name_x" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
		)
		echo "$Cyan Actual downloaded file Size is =$Cream ${actual_size} GB$SmoothBlue of - $Green„$file_name_x” $Reset"
		
		! [[ "$url_to_download" = "Off_line_" ]] && \
		{
		niden_free_space=$(
		count="=${file_Size_to_download%% *}-${actual_size%% *}" precision='%.3f' unit='GB'
		awk '{result = $1'${count}'; printf "'${precision}'",result}' <<<${_ping}
		)
		echo
		echo "$Cyan The free space you need for it =$SmoothBlue ${niden_free_space} GB$Reset"
		
		left_free_space=$(check_free_space GB "$install_folder_x" )
		echo "$Cyan Left free space to download is =$Orange ${left_free_space} $Reset"
		
		enough=$(calculate "${left_free_space%% *}-${niden_free_space%% *}")
		
		if test_integer ${enough}
		then :
			if [[ "$RETURN" = *"negative"* ]]
			then :
				echo "$Cyan Left free space after download =$Red$Blink ${enough} GB$SmoothBlue in -$Cream „$install_folder_x” $Reset"
			else :
				echo "$Cyan Left free space after download =$Green ${enough} GB$SmoothBlue in -$Cream „$install_folder_x” $Reset"
			fi
		fi
		
		if [ "${niden_free_space}" = "0.000" ]
		then :
			default_action="2"
		else :
			default_action="1"
		fi
		
		if ! [[ "No" == $(r_ask_select "$Nline$Green Try continue / download again,$Orange Please select - " "$default_action") ]]
		then :
			echo "$Nline$Green Redownload from:$Cyan $mirrors_x$Nline$Green file: $Cyan„$file_name_x” : $Reset$Nline"
			get_it "$mirrors_x" "$file_name_x"
			if ! [ $? = 0 ]; then echo "$Nline$Red Error: download, exit 1 $Reset$Nline"; /bin/bash ; exit; else echo "$Green ok$Reset"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload: $file_name_x to $install_folder_x folder $Reset$Nline"
		else :
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload: $file_name_x to $install_folder_x folder $Reset$Nline"
		fi
		}
	else :
		echo "$Nline$Green Download$Cyan distro$Green from:$Cyan $mirrors_x$Nline$Green file:$Reset „$file_name_x” : $Reset$Nline"
		if ! [[ "$url_to_download" = "Off_line_" ]]
		then :
			get_it "$mirrors_x" "$file_name_x"
			if ! [ $? = 0 ]
			then :
				echo "$Nline$Red Error: download, exit 1 $Reset$Nline"
				/bin/bash ; exit
			else :
				echo "$Green ok$Reset"
			fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Download: $file_name_x to $install_folder_x folder $Reset$Nline"
		else :
			echo "$Nline$Orange Skipped,$Blink Off line.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped download: $file_name_x to $install_folder_x folder $Reset$Nline"
		fi
	fi
	
	fi
	# find . -type f -exec chmod 666 -- {} + "$install_folder_x" # full access for everybody
	} # end download_it
	
	
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
	do :
		if ! [[ -z "${distro[$distro_x]}" ]] && ! [[ -z ${file_name[$distro_x]} ]]
		then :
			install_folder_x=${install_folder[$distro_x]}
			mirrors_x=${mirrors[$distro_x]}
			file_name_x=${file_name[$distro_x]}
			file_type_x=${file_type[$distro_x]}
			title_name_x=${file_name[$distro_x]%.*}
			sum_file_x=${sum_file[$distro_x]}
			sum_x=${sum[$distro_x]}
			gpg_file_x=${gpg_file[$distro_x]}
			home_page_x=${home_page[$distro_x]}
			
			ping_gw # && echo "Online" ||  echo "Off_line_"
			if [ $? -eq 0 ]
			then :
			download_it
			elif ! [ $? -eq 0 ]
			then :
				echo "$Nline$Cyan No internet connection go$Red$Blink Off line$Reset$Nline"
				url_to_download="Off_line_"
				download_it
				
				if ! [ -f "$file_name_x" ]
				then :
					echo "$Nline$Red Error: missing file:$SmoothBlue „$file_name_x”,$Red exit 1 $Reset$Nline"; /bin/bash; exit 1
				else :
					echo "$Nline$Green ok file:$SmoothBlue „$file_name_x”$Green exist, continue$Reset"
				fi
				actual_size=$(
				count='/1024/1024^2' precision='%.3f' unit='GB'
				wc -c <"$install_folder_x"/"$file_name_x" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
				)
				echo "$Cyan Actual downloaded file Size is =$Cream ${actual_size} GB$SmoothBlue of - $Green„$file_name_x” $Reset"
			else :
				
			fi
		fi
	done

}

check_sum_downloaded_files ()
{
	check_sum_of_downloaded_file ()
	{
	
	if ! [[ -z $file_name_x ]]; then
	
		cd "$install_folder_x"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: cd „$install_folder_x”, exit 1 $Reset$Nline"
			/bin/bash ; exit 1
		fi
			
		if ! [[ -z $gpg_file_x ]]; then
			echo "$Nline$Green Check sign file: $Cyan„$gpg_file_x”  $Reset$Nline"
			#  check gpg sig of downloaded file
			key_file=""; key_id=''
			
			# Strip off the name of the key ID
			
			if [[ -z $key_id ]]; then key_file="$gpg_file_x"; file_to_check="$gpg_file_x"
			
			key_id=$(env LANG=C gpg --verify $key_file 2>&1 |grep 'key '|head -n1| awk '{print $NF}')
			
			if ! [[ -z $key_id ]]; then echo "$Nline$Green The key ID striped from:$Cyan gpg --verify $key_file $Reset$Nline"; fi; fi
			
			if [[ -z $key_id ]]; then key_file="$gpg_file_x"; file_to_check="$sum_file_x"; key_id="`env LANG=C gpg --verify $key_file "$sum_file_x" 2>&1 |grep 'key '|head -n1| awk '{print $NF}'`"; if ! [[ -z $key_id ]]; then echo "$Nline$Green The key ID striped from:$Cyan gpg --verify $key_file $sum_file_x $Reset$Nline"; fi; fi
			
			if [[ -z $key_id ]]; then key_file="$gpg_file_x"; file_to_check="$file_name_x"; key_id="`env LANG=C gpg --verify $key_file "$file_name_x" 2>&1 |grep 'key '|head -n1| awk '{print $NF}'`"; if ! [[ -z $key_id ]]; then echo "$Nline$Green The key ID striped from:$Cyan gpg --verify $key_file $file_name_x $Reset$Nline"; fi; fi
			
			if [[ -z $key_id ]]
			then :
				echo "$Nline$Red Error: strip the key ID from: „$key_file”$Reset$Nline"
				answer=$(
					r_ask_select "$Green Continue - [*] or$Orange [R]$Red Remove files!: "$key_file" \
						$Nline$Orange Please select: " "1"  "{C}ontinue" "{R}emove" "{E}xit"
					)
				[[ "$answer" == "Remove" ]] && \
				{
					rm -f "$key_file"
					echo "$Nline$Red exit 1 $Reset$Nline"
					/bin/bash; exit
				}
				[[ "$answer" == "Exit" ]] && \
				{
					echo "$Nline$Red exit 1 $Reset$Nline"
					/bin/bash; exit
				}
				echo "$Reset$Nline"
				MESSAGE+="$Nline$Red$Blink $(( mn+=1 )). Error: strip the key ID from: $key_file $Reset$Nline"
			else
				echo "$Green The striped public key ID is: $SmoothBlue"0x$key_id"$Reset"
				# Check the public key is in Vendor keyring
				echo "$Nline$Green Check the striped public key ID: $SmoothBlue"0x$key_id"$Green is in keyring: $Cyan"$vendor_keyring"$Reset"
				echo "$Nline$Green gpg --keyring $Cyan"$vendor_keyring"$Green --list-key --with-fingerprint $SmoothBlue"0x$key_id"$Reset$Nline"
			
				gpg --keyring "$vendor_keyring" --list-key --with-fingerprint 0x$key_id
				if ! [ $? = 0 ]
				then :
					# Pull the public key from the key server to the Vendor keyring
					get_key_from_key_servers "$vendor_keyring" "$key_server_x" 0x$key_id
					if ! [ $? = 0 ]
					then :
						answer=$(
							r_ask_select "$Nline$Red Error: recive public key:$Orange „0x$key_id”$SmoothBlue for: $Red„$key_file”$SmoothBlue from:$Cyan $key_server_x,$Nline$Orange Please select: " "1"  "{C}ontinue" "{E}xit"
							)
						[[ "$answer" == "Exit" ]] && \
						{
							echo "$Nline$Red exit 1 $Reset$Nline"
							/bin/bash; exit
						}
						MESSAGE+="$Nline$Red $(( mn+=1 )). Error: Pull the public key:$Orange „0x$key_id”$Red for:$SmoothBlue $key_file$Red from key servers to: $vendor_keyring $Reset$Nline"
						echo "$Nline$Green ok$Reset$Nline"
				else :
					MESSAGE+="$Nline$Green $(( mn+=1 )). Pull the public key:$Orange „0x$key_id”$Green from the: "$key_server_x" to: "$vendor_keyring" ok$Reset$Nline"
					echo "$Nline$Green ok$Reset$Nline"
				fi
				fi
			
				# Verify the file
				echo "$Green Verify gpg sign:$Reset$Nline"
			
				{ verify_key=$(gpg --keyring $vendor_keyring --verify "$key_file" "$sum_file_x" 2>&1) && echo "gpg --keyring $vendor_keyring --verify "$key_file" "$sum_file_x"" ;} \
				|| { verify_key=$(gpg --keyring "$vendor_keyring" --verify "$key_file" 2>&1) && echo "gpg --keyring "$vendor_keyring" --verify "$key_file"" ;} \
				|| { verify_key=$(gpg --keyring $vendor_keyring --verify "$key_file" "$file_name_x" 2>&1) && echo "gpg --keyring $vendor_keyring --verify "$key_file" "$file_name_x"" ;}
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: check the $verify_key $Reset$Nline"
					answer=$(
						r_ask_select "$Green Continue - [*] or$Orange [R]$Red Remove files!: "$file_name_x" "$key_file" "$sum_file_x" \
						$Nline$Orange Please select: " "1"  "{C}ontinue" "{R}emove" "{E}xit"
						)
					[[ "$answer" == "Remove" ]] && \
					{
						rm -f "$file_name_x" "$key_file" "$sum_file_x"
						echo "$Nline$Red exit 1 $Reset$Nline"
						/bin/bash; exit
					}
					[[ "$answer" == "Exit" ]] && \
					{
						echo "$Nline$Red exit 1 $Reset$Nline"
						/bin/bash; exit
					}
					echo "$Reset$Nline"
					MESSAGE+="$Nline$Red$Blink $(( mn+=1 )). Error: Check the $verify_key $Reset$Nline"
				else
					echo "$Nline$Green Check the $verify_key$Nline ok$Reset"
					MESSAGE+="$Nline$Green $(( mn+=1 )). Check the $verify_key$Nline ok$Reset$Nline"
				fi
			fi
		else
			# Otherwise complain that it does not exist
			echo "$Nline$Red No GPG signature File for $file_name_x $Reset$Nline"
		fi
	
	#  check sums of downloaded file
	
	check_sums=""
	
	if [ -e "md5_sums_$title_name_x.txt" ]; then check_sums="md5sum -c" sum_file="md5_sums_$title_name_x.txt"; fi
	if [ -e "sha1_sums_$title_name_x.txt" ]; then check_sums="sha1sum -c" sum_file="sha1_sums_$title_name_x.txt"; fi
	if [ -e "sha256_sums_$title_name_x.txt" ]; then check_sums="sha256sum -c" sum_file="sha256_sums_$title_name_x.txt"; fi
	if [ -e "sha512_sums_$title_name_x.txt" ]; then check_sums="sha512sum -c" sum_file="sha512_sums_$title_name_x.txt"; fi
	
	echo "$Nline$Green Check sum for: $Cyan„${file_name_x}”$Green - $check_sums „$sum_file” :$Reset$Nline"
	if ! [[ $check_sums = "" ]]
	then
	 $check_sums "$sum_file"
	 if ! [ $? = 0 ]
	 then :
		echo "$Nline$Red Error: check sum of „$file_name_x” $Reset$Nline"
		answer=$(
			r_ask_select "$Green Continue - [*] or$Orange [R]$Red Remove files!: „${file_name_x}” „${sum_file}” \
			$Nline$Orange Please select: " "1"  "{C}ontinue" "{R}emove" "{E}xit"
			)
		[[ "$answer" == "Remove" ]] && \
		{
			rm -f "$file_name_x" "$sum_file"
			echo "$Nline$Red exit 1 $Reset$Nline"
			/bin/bash; exit
		}
		[[ "$answer" == "Exit" ]] && \
		{
			echo "$Nline$Red exit 1 $Reset$Nline"
			/bin/bash; exit
		}
		echo "$Reset$Nline"
		MESSAGE+="$Nline$Red$Blink $(( mn+=1 )). Error: check sum of $file_name_x $Reset$Nline"
	 else
	
	 echo "$Nline$Green Check sum of $Cyan$file_name_x$Green ok$Reset$Nline"
	 MESSAGE+="$Nline$Green $(( mn+=1 )). Check sum of $file_name_x ok$Reset$Nline"
	
	 fi
	else
	 echo "$Nline$Red No file to check sum of $file_name_x $Reset$Nline"
	 MESSAGE+="$Nline$Red $(( mn+=1 )). No file to check sum of $file_name_x $Reset$Nline"
	fi
	fi
	} # end check_sum_of_downloaded_file
	
	
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ )); do
	
	  if ! [[ -z "${distro[$distro_x]}" ]] && ! [[ -z ${file_name[$distro_x]} ]]
	  then :
	    install_folder_x="${install_folder[$distro_x]}"
	    file_name_x="${file_name[$distro_x]}"
	    title_name_x=${file_name[$distro_x]%.*}
	    sum_file_x="${sum_file[$distro_x]}"
	    gpg_file_x="${gpg_file[$distro_x]}"
	    key_server_x="${key_server[$distro_x]}"
	    check_sum_of_downloaded_file
	  fi
	
	done
}

extract_from_iso()
{
	extract_distro_from_iso ()
	{
	
	extract_boot_files ()
	{
	#!FIXME
	echo "$Nline$Green Extract from $file_name_x boot files folder to $install_folder_x $Reset"
	if [ -d "/mnt/$file_name_x/isolinux" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/isolinux" folder from $file_name_x to $install_folder_x/ $Reset"
		mkdir -p "$install_folder_x/isolinux" && cp -rf "/mnt/$file_name_x/isolinux" "$install_folder_x/"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from iso $file_name_x/isolinux, exit 1 $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/isolinux boot files folder to $install_folder_x $Reset$Nline"
		fi
	fi
	
	if [ -d "/mnt/$file_name_x/boot/isolinux" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/boot/isolinux/"* files from $file_name_x to $install_folder_x/ $Reset"
		mkdir -p "$install_folder_x/boot/isolinux" && cp -fr "/mnt/$file_name_x/boot/isolinux/"* "$install_folder_x/boot/isolinux/"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from iso $file_name_x/boot/isolinux/*, exit 1 $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/boot/isolinux/* boot files folder to $install_folder_x $Reset$Nline"
		fi
	fi
	
	if [ -d "/mnt/$file_name_x/syslinux" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/syslinux" folder from $file_name_x to $install_folder_x/ $Reset"
		mkdir -p "$install_folder_x/syslinux" && cp -rf "/mnt/$file_name_x/syslinux" "$install_folder_x/"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from iso $file_name_x/syslinux, exit 1 $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/syslinux boot files folder to $install_folder_x $Reset$Nline"
		fi
	fi
	
	if [ -d "/mnt/$file_name_x/boot/grub" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/boot/grub/"*cfg "/mnt/$file_name_x/boot/grub/"*lst "$install_folder_x/boot/grub/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/boot/grub" && {
		ls /mnt/"$file_name_x"/boot/grub/*.cfg >/dev/null 2>&1
		if [ $? = 0 ]
		then :
			{ cp -vf "/mnt/$file_name_x/boot/grub/"*cfg "$install_folder_x/boot/grub/" || { echo "$Nline$Red Error: Extract from iso $file_name_x/boot/grub/*cfg, exit 1 $Reset$Nline"; /bin/bash ; exit 1;} ;}
		fi
		ls /mnt/"$file_name_x"/boot/grub/*.lst >/dev/null 2>&1
		if [ $? = 0 ]
		then :
			{ cp -vf "/mnt/$file_name_x/boot/grub/"*lst "$install_folder_x/boot/grub/" || { echo "$Nline$Red Error: Extract from iso $file_name_x/boot/grub/*lst, exit 1 $Reset$Nline"; /bin/bash ; exit 1;} ;}
		fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/boot/grub/*cfg boot files folder to $install_folder_x $Reset$Nline"
		}
	fi
	
	if [ -d "/mnt/$file_name_x/boot" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/boot/"* "$install_folder_x/boot/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/boot" && cp -fr "/mnt/$file_name_x/boot/"* "$install_folder_x/boot/"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract "/mnt/$file_name_x/boot/"* "$install_folder_x/boot/" from $file_name_x/boot/* files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from  Extract from $file_name_x/boot/* files to $install_folder_x $Reset$Nline"
		fi
	fi
	# /arch/boot
	if [ -d "/mnt/$file_name_x/arch/boot" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/arch/boot/"* "$install_folder_x/arch/boot/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/arch/boot" &&  cp -fr "/mnt/$file_name_x/arch/boot/"* "$install_folder_x/arch/boot/"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from "/mnt/$file_name_x/arch/boot/"* "$install_folder_x/arch/boot/" files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from Extract from $file_name_x/boot/* files to $install_folder_x $Reset$Nline"
		fi
	fi
	# /manjaro/boot
	if [ -d "/mnt/$file_name_x/manjaro/boot" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/manjaro/boot/"* "$install_folder_x/manjaro/boot/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/manjaro/boot" &&  cp -fr "/mnt/$file_name_x/manjaro/boot/"* "$install_folder_x/manjaro/boot/"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from "/mnt/$file_name_x/manjaro/boot/"* "$install_folder_x/manjaro/boot/" files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from Extract from $file_name_x/manjaro/boot/* files to $install_folder_x $Reset$Nline"
		fi
	fi
	# /chakra/boot
	if [ -d "/mnt/$file_name_x/chakra/boot" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/chakra/boot/"* "$install_folder_x/chakra/boot/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/chakra/boot" &&  cp -fr "/mnt/$file_name_x/chakra/boot/"* "$install_folder_x/chakra/boot/"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from "/mnt/$file_name_x/chakra/boot/"* "$install_folder_x/chakra/boot/" files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from Extract from $file_name_x/chakra/boot/* files to $install_folder_x $Reset$Nline"
		fi
	fi
	
	# /parabola/boot
	if [ -d "/mnt/$file_name_x/parabola/boot" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/parabola/boot/"* "$install_folder_x/parabola/boot/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/parabola/boot" &&  cp -fr "/mnt/$file_name_x/parabola/boot/"* "$install_folder_x/parabola/boot/"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from "/mnt/$file_name_x/parabola/boot/"* "$install_folder_x/parabola/boot/" files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from Extract from $file_name_x/parabola/boot/* files to $install_folder_x $Reset$Nline"
		fi
	fi
	
	# /kdeos/boot
	if [ -d "/mnt/$file_name_x/kdeos/boot" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/kdeos/boot/"* "$install_folder_x//chakra/boot/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/kdeos/boot" &&  cp -fr "/mnt/$file_name_x/kdeos/boot/"* "$install_folder_x/kdeos/boot"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from "/mnt/$file_name_x/kdeos/boot/"* "$install_folder_x/kdeos/boot" files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from Extract from $file_name_x/kdeos/boot/* files to $install_folder_x $Reset$Nline"
		fi
	fi
	
	# zenwalk /kernels
	if [ -d "/mnt/$file_name_x/kernels" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/kernels" "$install_folder_x" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/kernels" &&  cp -fr "/mnt/$file_name_x/kernels" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from "/mnt/$file_name_x/kernels" "$install_folder_x" files to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/kernels files to $install_folder_x $Reset$Nline"
		fi
	fi
	# xerus /vmlinuz /initrd.q
	if [ -f "/mnt/$file_name_x/vmlinuz" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/vmlinuz" file from $file_name_x to $install_folder_x $Reset"
		cp -fr "/mnt/$file_name_x/vmlinuz" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract "/mnt/$file_name_x/vmlinuz" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract $file_name_x/vmlinuz file to $install_folder_x $Reset$Nline"
		fi
	fi
	if [ -f "/mnt/$file_name_x/initrd.q" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/initrd.q" file from $file_name_x to $install_folder_x $Reset"
		cp -fr "/mnt/$file_name_x/initrd.q" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract "/mnt/$file_name_x/initrd.q" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract $file_name_x/initrd.q file to $install_folder_x $Reset$Nline"
		fi
	fi
	# austrumi /austrumi/bzImage /austrumi/initrd.gz
	if [ -f "/mnt/$file_name_x/austrumi/bzImage" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/austrumi/bzImage" file from $file_name_x to $install_folder_x $Reset"
		cp -fr "/mnt/$file_name_x/austrumi/bzImage" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract "/mnt/$file_name_x/austrumi/bzImage" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract $file_name_x/austrumi/bzImage file to $install_folder_x $Reset$Nline"
		fi
	fi
	if [ -f "/mnt/$file_name_x/austrumi/initrd.gz" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/austrumi/initrd.gz" file from $file_name_x to $install_folder_x $Reset"
		cp -fr "/mnt/$file_name_x/austrumi/initrd.gz" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract "/mnt/$file_name_x/austrumi/initrd.gz" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract $file_name_x/austrumi/initrd.gz file to $install_folder_x $Reset$Nline"
		fi
	fi
	
	if [ -d "/mnt/$file_name_x/live" ]
	then :
		ls /mnt/"$file_name_x/live/vmlinuz"* >/dev/null 2>&1 && ls "/mnt/$file_name_x/live/init"* >/dev/null 2>&1
		if [ $? = 0 ]
		then :
			echo "$Nline$Green Extract "/mnt/$file_name_x/live/vmlinuz"* "/mnt/$file_name_x/live/init"* "$install_folder_x/live/" files from $file_name_x to $install_folder_x $Reset"
			mkdir -p "$install_folder_x/live" && cp -fr "/mnt/$file_name_x/live/vmlinuz"* "/mnt/$file_name_x/live/init"* "$install_folder_x/live/"
			if ! [ $? = 0 ]
			then :
				echo "$Nline$Red Error: Extract from iso $file_name_x/live, exit 1 $Reset$Nline"; /bin/bash ; exit 1
			else :
				MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/live boot files to $install_folder_x $Reset$Nline"
			fi
		fi
	fi
	#&& cp -ru "/mnt/$file_name_x/liver" /
	
	if [ -d "/mnt/$file_name_x/casper" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/casper/vmlinuz"* "/mnt/$file_name_x/casper/init"* "$install_folder_x/casper/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/casper" && cp -fr "/mnt/$file_name_x/casper/vmlinuz"* "/mnt/$file_name_x/casper/init"* "$install_folder_x/casper/"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from iso $file_name_x/casper, exit 1 $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/casper boot files to $install_folder_x $Reset$Nline"
		fi
	fi
	#&& cp -ru "/mnt/$file_name_x/casper" /
	
	if [ -d "/mnt/$file_name_x/antiX" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/antiX/vmlinuz"* "/mnt/$file_name_x/antiX/init"* "$install_folder_x/antiX/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/antiX" && cp -fr "/mnt/$file_name_x/antiX/vmlinuz"* "/mnt/$file_name_x/antiX/init"* "$install_folder_x/antiX/"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from iso $file_name_x/antiX, exit 1 $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/antiX boot files to $install_folder_x $Reset$Nline"
		fi
	fi
	
	if [ -d "/mnt/$file_name_x/install" ]
	then :
		echo "$Nline$Green Extract "/mnt/$file_name_x/install" "$install_folder_x/" files from $file_name_x to $install_folder_x $Reset"
		mkdir -p "$install_folder_x/install" && cp -rf "/mnt/$file_name_x/install" "$install_folder_x/"
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: Extract from iso $file_name_x/install, exit 1 $Reset$Nline"; /bin/bash ; exit 1
		else :
			MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x/install boot files folder to $install_folder_x $Reset$Nline"
		fi
	fi
	}
	###
	extract_from_iso_all()
	{
	echo "$Nline$Green Extract$Red all$Green files from $file_name_x to $install_folder_x $Reset"
	cp -rf "/mnt/$file_name_x/"* "$install_folder_x/"
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: Extract from $file_name_x files to $install_folder_x, exit 1 $Reset$Nline"
		/bin/bash
		exit 1
	else :
		MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x files to $install_folder_x $Reset$Nline"
	fi
	 }
	###
	cd "$install_folder_x"
	if ! [ $? = 0 ]; then echo "$Red Error: Cannot cd to folder $install_folder_x, exit 1"; /bin/bash ; exit 1; fi
	umask 000 # full access for everybody
	mkdir -p "/mnt/$file_name_x"
	umount "/mnt/$file_name_x"
	mount -o loop "$install_folder_x/$file_name_x" "/mnt/$file_name_x"
	if ! [ $? = 0 ]; then echo "$Nline$Red Error: mount iso, exit 1 $Reset$Nline"; /bin/bash ; exit 1; fi
	
	# extract_from_iso_all # extract_from_iso="all"
	if [ ${extract_from_iso[$distro_x]} = "all" ]
	then :
		extract_from_iso_all
	else :
		extract_boot_files
	fi
	
	umount "/mnt/$file_name_x"
	cd "/mnt/"
	rm -df "$file_name_x"
	cd "$install_folder_x"
	find . -type f -exec chmod 666 -- {} + # full access for everybody
	find . -type d -exec chmod 777 -- {} +
	} # end extract_distro_from_iso
	
	
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ ))
	do
	
	if ! [[ -z "${distro[$distro_x]}" ]] && ! [[ -z ${file_name[$distro_x]} ]]
	then :
		if [[ "${extract_from_iso[$distro_x]}" = "yes" ]] || [[ "${extract_from_iso[$distro_x]}" = "boot" ]] || [[ "${extract_from_iso[$distro_x]}" = "all" ]]
		then :
			install_folder_x="${install_folder[$distro_x]}"
			file_name_x="${file_name[$distro_x]}"
			extract_distro_from_iso
			gen_vdd_sh_script
		elif  [[ "${file_type[$distro_x]}" = ".iso" ]]
		then :
			gen_vdd_sh_script
		fi
		
	fi
	
	done
}


download_memdisk ()
{

 get_memdisk ()
 {

memdisk_folder="/boot" # ( folder for download syslinux-6.03.tar.xz and extract memedisk)
: ${mirrors_memdisk="https://www.kernel.org/pub/linux/utils/boot/syslinux/"}; file_memdisk="syslinux-6.03.tar.xz"; sha256sums_file_memdisk="sha256sums.asc"

#The security of the RSA algorithm is based on the fact that factorization of large integers is known to be "difficult",
#whereas DSA security is based on the discrete logarithm problem. Today the fastest known algorithm for
#factoring large integers is the General Number Field Sieve,
#also the fastest algorithm to solve the discrete logarithm problem in finite fields modulo a large prime p as specified for DSA.
key_server_memdisk="pgpkeys.mit.edu pgp.mit.edu"
#
# https://www.kernel.org/pub/linux/utils/boot/syslinux/

	if ! [ -e "$memdisk_folder"/memdisk ]; then
	if ! [[ -z $file_memdisk ]]; then
	old_pwd=$(pwd)
	mkdir -p "$memdisk_folder"
	if ! [ $? = 0 ]; then echo "$Red Error: Cannot creat folder $memdisk_folder, exit 1$Reset$Nline"; /bin/bash ; exit; fi
	cd $memdisk_folder
	if ! [ $? = 0 ]; then echo "$Red Error: Cannot cd to folder $memdisk_folder, exit 1$Reset$Nline"; /bin/bash ; exit; fi
	
	if [ -f $file_memdisk ] && [ -f "$sha256sums_file_memdisk" ]; then
		echo "$Nline file $file_memdisk exist$Reset$Nline"
		if ! [[ "No" == $(r_ask_select "$Green Try continue / download again,$Orange Please select - " "1") ]]; then
			echo "$Nline$Green Redownload: "$mirrors_memdisk" „$file_memdisk” : $Reset$Nline"
			get_it "$mirrors_memdisk" "$sha256sums_file_memdisk"
			if ! [ $? = 0 ]; then echo "$Nline$Red Error: download, exit 1 $Reset$Nline"; /bin/bash ; exit; else echo "$Nline$Green ok$Reset$Nline"; fi
			get_it "$mirrors_memdisk" "$file_memdisk"
			if ! [ $? = 0 ]; then echo "$Nline$Red Error: download, exit 1 $Reset$Nline"; /bin/bash ; exit; else echo "$Nline$Green ok$Reset$Nline"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload: $file_memdisk to $memdisk_folder folder $Reset$Nline"
		else
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload: $file_memdisk to $memdisk_folder folder $Reset$Nline"
		fi
	else
		echo "$Nline$Green Download "$mirrors_memdisk" "$file_memdisk" : $Reset$Nline"
		get_it "$mirrors_memdisk" "$sha256sums_file_memdisk"
		if ! [ $? = 0 ]; then echo "$Nline$Red Error: download, exit 1 $Reset$Nline"; /bin/bash ; exit; else echo "$Nline$Green ok$Reset$Nline"; fi
		get_it "$mirrors_memdisk" "$file_memdisk"
		if ! [ $? = 0 ]; then echo "$Nline$Red Error: download, exit 1 $Reset$Nline"; /bin/bash ; exit; else echo "$Nline$Green ok$Reset$Nline"; fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Download $file_memdisk to $memdisk_folder folder $Reset$Nline"
		
	fi
	
	gpg_file_x="$sha256sums_file_memdisk"
	file_name_x="sha256sums"
	key_server_x="$key_server_memdisk"
	
	if ! [[ -z $gpg_file_x ]]; then
			echo "$Nline$Green Check sign file $gpg_file_x $Reset$Nline"
			#  check gpg sig of downloaded file
			key_file=""; key_id=''
			
			# Strip off the name of the key ID
			
			if [[ -z $key_id ]]; then key_file="$gpg_file_x"; file_to_check="$gpg_file_x"
			
			key_id=$(env LANG=C gpg --verify $key_file 2>&1 |grep 'key '|head -n1| awk '{print $NF}')
			
			if ! [[ -z $key_id ]]; then echo "$Nline$Green The key ID striped from:$Cyan gpg --verify $key_file $Reset$Nline"; fi; fi
			
			if [[ -z $key_id ]]; then key_file="$gpg_file_x"; file_to_check="$sum_file_x"; key_id="`env LANG=C gpg --verify $key_file "$sum_file_x" 2>&1 |grep 'key '|head -n1| awk '{print $NF}'`"; if ! [[ -z $key_id ]]; then echo "$Nline$Green The key ID striped from:$Cyan gpg --verify $key_file $sum_file_x $Reset$Nline"; fi; fi
			
			if [[ -z $key_id ]]; then key_file="$gpg_file_x"; file_to_check="$file_name_x"; key_id="`env LANG=C gpg --verify $key_file "$file_name_x" 2>&1 |grep 'key '|head -n1| awk '{print $NF}'`"; if ! [[ -z $key_id ]]; then echo "$Nline$Green The key ID striped from:$Cyan gpg --verify $key_file $file_name_x $Reset$Nline"; fi; fi
			
			if ! [[ -z $key_id ]]
			
			then echo "$Green The striped public key ID is: $SmoothBlue"0x$key_id"$Reset"
			else echo "$Nline$Red Error: strip the key ID from: $key_file, exit 1 $Reset$Nline"; /bin/bash ; exit
			fi
			
			# Check the public key is in Vendor keyring
			echo "$Nline$Green Check the striped public key ID: $SmoothBlue"0x$key_id"$Green is in keyring: $Cyan"$vendor_keyring"$Reset"
			echo "$Nline$Green gpg --keyring $Cyan"$vendor_keyring"$Green --list-key --with-fingerprint $SmoothBlue"0x$key_id"$Reset$Nline"
			gpg --keyring "$vendor_keyring" --list-key --with-fingerprint 0x$key_id
			if ! [ $? = 0 ]; then
				# Pull the public key from the key server to the Vendor keyring
				get_key_from_key_servers "$vendor_keyring" "$key_server_x" 0x$key_id
				if ! [ $? = 0 ]
				then  echo "$Nline$Red Error: recive public key: "$key_file" from: "$key_server_x", exit 1 $Reset$Nline"; /bin/bash ; exit
				else MESSAGE+="$Nline$Green $(( mn+=1 )). Pull the public key from the: "$key_server_x" to: "$vendor_keyring" ok$Reset$Nline"
				echo "$Nline$Green ok$Reset$Nline"
				fi
			fi
			
			# Verify the file
			if [[  $file_to_check = $gpg_file_x ]]
			then
			verify_key="gpg --keyring $vendor_keyring --verify "$key_file""
			else
			verify_key="gpg --keyring $vendor_keyring --verify "$key_file" "$file_to_check""
			fi
			
			
			echo "$Nline$Green $verify_key $Reset$Nline"
			$verify_key
			if ! [ $? = 0 ]; then
				echo "$Nline$Red Error: check the $verify_key $Reset$Nline"
				answer=$(
					r_ask_select "$Green Continue - [*] or$Orange [R]$Red Remove files!: "$file_name_x" "$key_file" "$sum_file_x" \
					$Nline$Orange Please select: " "1"  "{C}ontinue" "{R}emove" "{E}xit"
					)
				[[ "$answer" == "Remove" ]] && \
				{
					rm -f "$file_name_x" "$key_file" "$sum_file_x"
					echo "$Nline$Red exit 1 $Reset$Nline"
					/bin/bash; exit
				}
				[[ "$answer" == "Exit" ]] && \
				{
					echo "$Nline$Red exit 1 $Reset$Nline"
					/bin/bash; exit
				}
				echo "$Reset$Nline"
				MESSAGE+="$Nline$Red$Blink $(( mn+=1 )). Error: Check the $verify_key $Reset$Nline"
			else
				echo "$Nline$Green Check the $verify_key ok $Reset"
				MESSAGE+="$Nline$Green $(( mn+=1 )). Check the $verify_key ok $Reset$Nline"
			fi
		else
			# Otherwise complain that it does not exist
			echo "$Nline$Red No GPG signature File for $file_name_x $Reset$Nline"
		fi
	
	# Get sum to check
	sha256=$(cat "$sha256sums_file_memdisk"|grep -e "$file_memdisk"| head -1 | tr -d '*()=' | tr -dc '[[:print:]]' | awk '{print $1}')
	file_memdisk=$(cat "$sha256sums_file_memdisk"|grep -e "$file_memdisk"| head -1 | tr -d '*()=' | tr -dc '[[:print:]]' | awk '{print $2}')
	echo "$sha256 $file_memdisk" > "sha256_sums_$file_memdisk.txt"
	#  check sums of $file_memdisk
	check_sums=""
	if [ -e "md5_sums_$file_memdisk.txt" ]; then check_sums="md5sum -c "md5_sums_$file_memdisk.txt""; fi
	if [ -e "sha1_sums_$file_memdisk.txt" ]; then check_sums="sha1sum -c "sha1_sums_$file_memdisk.txt""; fi
	if [ -e "sha256_sums_$file_memdisk.txt" ]; then check_sums="sha256sum -c "sha256_sums_$file_memdisk.txt""; fi
	if [ -e "sha512_sums_$file_memdisk.txt" ]; then check_sums="sha512sum -c "sha512_sums_$file_memdisk.txt""; fi
	
	echo "$Nline$Green check $check_sums $file_memdisk : $Reset$Nline"
	if ! [[ $check_sums = "" ]]
	then
	 $check_sums
	 if ! [ $? = 0 ]
	  then echo "$Nline$Red Error: check sum of $file_memdisk $Reset$Nline"
	   if [[ "No" == $(r_ask_select "$Green Continue - [*] or$Orange [R]$Red Remove files!: "$file_memdisk" "$sha256sums_file_memdisk" \
	   $Nline$Orange Please select: " "1"  "{C}ontinue" "{R}emove" "{E}xit") ]]
	   then :
		rm -f "$file_memdisk" "$sha256sums_file_memdisk"
		echo "$Nline$Red exit 1 $Reset$Nline"
		/bin/bash; exit
	   fi
	  echo "$Reset$Nline"
	  MESSAGE+="$Nline$Red$Blink $(( mn+=1 )). Error: check sum of $file_memdisk $Reset$Nline"
	  else
	  echo "$Nline$Green Check sum of $Cyan$file_memdisk$Green ok$Reset$Nline"
	  MESSAGE+="$Nline$Green $(( mn+=1 )). Check sum of $Cyan$file_memdisk$Green ok$Reset$Nline"
	  fi
	 else
	 echo "$Nline$Red No file to check sum of $file_memdisk $Reset$Nline"
	 MESSAGE+="$Nline$Red $(( mn+=1 )). No file to check sum of $file_memdisk $Reset$Nline"
	 fi
	
	else
	 echo "$Nline$Red No file $file_memdisk to download, exit 1 $Reset$Nline"; /bin/bash ; exit
	fi
	
	if ! [[ -z $file_memdisk ]]; then
	 echo "$Nline$Green Extract from $file_memdisk memdisk : $Reset$Nline"
	 tar -xvf $file_memdisk syslinux-6.03/bios/memdisk/memdisk
	 if ! [ $? = 0 ]; then echo "$Nline$Red Error: Extract from tar, exit 1 $Reset$Nline"; /bin/bash ; exit
	 else
	 MESSAGE+="$Nline$Green $(( mn+=1 )). Extract memdisk from $file_memdisk $Reset$Nline"
	 fi
	 echo "$Nline$Green mv syslinux-6.03/bios/memdisk/memdisk $memdisk_folder/ : $Reset$Nline"
	 mv syslinux-6.03/bios/memdisk/memdisk $memdisk_folder/
	 MESSAGE+="$Nline$Green $(( mn+=1 )). Install memdisk in $memdisk_folder/  $Reset$Nline"
	 rm -fr syslinux-6.03
	else
	 echo "$Nline$Red No file $file_memdisk to extract, exit 1 $Reset$Nline"; /bin/bash ; exit
	fi
	
	cd  "$old_pwd"
	fi
	}
	
	for (( distro_x=1; distro_x<=${#distro[*]};distro_x++ )); do
	
	  if ! [[ -z "${distro[$distro_x]}" ]] && ! [[ -z ${file_name[$distro_x]} ]] && [[ "${boot_memdisk[$distro_x]}" = "yes" ]]
	  then :
	    get_memdisk
	    echo "$Nline$Green Copy memdisk for use$Reset"
	    cp -v "$memdisk_folder"/memdisk "${install_folder[$distro_x]}"/memdisk
	  fi
	
	done
	
}

extract_from_tar()
{
	 echo "$Nline$Green Extract from "$file_name_x" : $Reset$Nline"
	 tar -xvf "$file_name_x"
	 if ! [ $? = 0 ]
	 then :
		echo "$Nline$Red Error: Extract from $file_name_x, exit 1 $Reset$Nline"; /bin/bash ; exit
	 else :
		MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x to $install_folder_x $Reset$Nline"
	 fi
}

extract_from_zip ()
{
	echo "$Nline$Green Extract from $file_name_x : $Reset$Nline"
	unzip "$file_name_x"
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Red Error: Extract from $file_name_x, exit 1 $Reset$Nline"; /bin/bash ; exit
	else :
		MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_x to $install_folder_x $Reset$Nline"
	fi

}

extract_from_gzip ()
{
	echo "$Nline$Green Change compression from gzip to zip of $file_name_x for boot from Grub 2 : $Reset$Nline"
	gzip -d $file_name_x
	if ! [ $? = 0 ]; then echo "$Nline$Red Error: Extract from $file_name_x, exit 1 $Reset$Nline"; /bin/bash ; exit;fi
	
	# change compression to zip for pass Grub 2 bug?
	zip ${file_name[1]} boot.img
	if ! [ $? = 0 ]; then echo "$Nline$Red Error: zip $file_name_x, exit 1 $Reset$Nline"; /bin/bash ; exit
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Change compression from gzip to zip of $file_name_x in $install_folder_x $Reset$Nline"
	fi
	rm -f boot.img
}

find_reala_boot_path ()
{
	if ! [ -d "$install_folder_x" ]
	then :
		echo "$Red Error: install folder $install_folder_x do not exist, exit 1$Reset$Nline"
		/bin/bash; exit 1
	fi
	
	mount_path_x=$( df --output=target "$install_folder_x" | grep '/' )
	if [[ "$mount_path_x" = '/' ]]
	then real_dev_path_X="$install_folder_x" real_boot_root='/'
	else real_dev_path_X=${install_folder_x#$mount_path_x} real_boot_root=${install_folder_x%$real_dev_path_X}
	fi
	isofile="${real_dev_path_X}"/"${file_name_x}"
	distro_dir=${real_dev_path_X#*\/}
	dev_name=$(df "$install_folder_x" | grep /dev/)
	dev_name=${dev_name%%\ *}
	dev_uuid=$(blkid $dev_name -s UUID)
	dev_uuid=${dev_uuid#*\ }
	uuid=${dev_uuid#*\"}
	uuid=${uuid%\"*}
	dev_file_system_type=$(blkid $dev_name -s TYPE)
	dev_file_system_type=${dev_file_system_type#*\ }
	dev_file_system_type=${dev_file_system_type#*\"}
	dev_file_system_type=${dev_file_system_type%\"*}
	dev_type=$(blkid $dev_name -s TYPE)
	dev_type=${dev_type#*\ }
	dev_type=${dev_type#*\"}
	dev_type=${dev_type%\"*}
}

add_to_xxx_menu ()
{
return 0
comment=cat <<-EOF
 skip it for now - lilo have many limitations
 so it seems to be better try do it by combination chainloader grub4dos/grub/grub2 from syslinux and vice versa

LABEL GRUB
  MENU LABEL Grub2 chainload
  COM32 CHAIN.C32
  APPEND file=/boot/grub/boot.img

LABEL Other Linux (Linux installed on sda3 & Syslinux installed on sda)
  MENU LABEL Grub2 chainload
  COM32 chain.c32
  APPEND boot 3


if ! [[ -z ${add_menu_label_x} ]]
then
  lilo_conf=''

  if [[ -f "/etc/lilo.conf" ]]
  then
  if [[ $iso_command_x = "memdisk" ]];then kernel="kernel ${real_dev_path_X}/memdisk ${append_x}"; initrd_x="/$file_name_x"; else  kernel="kernel ${real_dev_path_X}${kernel_x} ${iso_command_x}${real_dev_path_X}"/"${file_name_x} ${append_x}"; fi
lilo_conf+="
   image = ${kernel}
   label = \"${file_name_x} ${add_menu_label_x}\"
   root = ${dev_name}
   optional
   initrd = ${real_dev_path_X}${initrd_x}"

echo "$Nline$Red Do you wish add below lines to:$SmoothBlue /etc/lilo.conf:$Reset$Nline$Cyan $lilo_conf $Reset$Nline"
	if [[ "No" == $(r_ask_select "$Green Add abowe lines to /etc/lilo.conf ?$Orange Please select - " "2") ]]; then
		echo "$Nline$Orange Skipped.$Reset$Nline"
		MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped add belowe lines to /etc/lilo.conf:$Nline $lilo_conf $Nline $Reset"
	else
		echo "$lilo_conf" >> "/etc/lilo.conf"
		echo "$Nline$Orange ok add $Reset$Nline"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Add belowe lines to /etc/lilo.conf:$Nline $lilo_conf $Nline $Reset"
	fi
  fi
fi
EOF
}

add_to_grub_menu ()
{
	if ! [[ -z ${add_menu_label_x} ]]; then
	
	comment=cat <<-EOF
	echo
	echo "real_dev_path_X=$real_dev_path_X"
	echo "distro_dir=$distro_dir"
	echo "dev_uuid=$dev_uuid"
	echo "uuid=$uuid"
	echo "dev_file_system_type=$dev_file_system_type"
	echo
	EOF
	
	grub_menu_lst=''
	grub_40_custom=''
	# Old Grub
	command=$(whereis -b grub|awk '{print $2}')
	if [[ -f $command ]]; then
	grub_root_dev=$(echo "find "${real_dev_path_X}"/"${file_name_x}" "|grub|grep "(hd"| head -1)
	if [[ $iso_command_x = "memdisk" ]];then kernel="kernel ${real_dev_path_X}/memdisk ${append_x}"; initrd_x="/$file_name_x"; else  kernel="kernel ${real_dev_path_X}${kernel_x} ${iso_command_x}${real_dev_path_X}"/"${file_name_x} ${append_x}"; fi
	
	# Grub 1 "/boot/grub/menu.lst"
	grub_menu_lst+="

title $file_name_x ${add_menu_label_x}
	root $grub_root_dev
	$kernel
	initrd ${real_dev_path_X}${initrd_x}"
	
	#!FIXME
	echo "$Nline$Red Do you wish add below lines to:$SmoothBlue /boot/grub/menu.lst:$Reset$Nline$Cyan $grub_menu_lst $Reset$Nline"
	if [[ "No" == $(r_ask_select "$Green Add abowe lines to /boot/grub/menu.lst?,$Orange Please select - " "2") ]]; then
		echo "$Nline$Orange Skipped.$Reset$Nline"
		MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped add belowe lines to /boot/grub/menu.lst:$Nline $grub_menu_lst $Nline $Reset"
	else
		echo "$grub_menu_lst" >> "/boot/grub/menu.lst"
		echo "$Nline$Orange ok add $Reset$Nline"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Add belowe lines to /boot/grub/menu.lst:$Nline $grub_menu_lst $Nline $Reset"
	fi
	
	fi
	# end Old Grub
	
	# New Grub
	command1=$(whereis -b grub-mkconfig|awk '{print $2}')
	command2=$(whereis -b grub2-mkconfig|awk '{print $2}')
	if [[ -f $command1 ]] || [[ -f $command2 ]] ;then
	if [[ "$iso_command_x" = "memdisk" ]];then g2_linux="linux16 ${real_dev_path_X}/memdisk ${append_x}" g2_initrd="initrd16"; initrd_x="/$file_name_x"; else iso_command="$iso_command_x"; g2_linux="linux ${real_dev_path_X}${kernel_x} ${iso_command}${real_dev_path_X}"/"${file_name_x} ${append_x}" g2_initrd="initrd"; fi
	
	# Grub 2 "/etc/grub.d/40_custom"
	grub_40_custom+="

menuentry '$file_name_x ${add_menu_label_x}' --class dvd_boot {
	set gfxpayload="keep"
	search --file --no-floppy --set=root ${real_dev_path_X}"/"${file_name_x}
	${g2_linux}
	${g2_initrd} ${real_dev_path_X}${initrd_x}
	}"
	
	#!FIXME
	echo "$Nline$Red Do you wish add below lines to:$SmoothBlue /etc/grub.d/40_custom:$Reset$Nline$Cyan $grub_40_custom $Reset$Nline"
	if [[ "No" == $(r_ask_select "$Green Add abowe lines to /etc/grub.d/40_custom and grub-mkconfig -o /boot/grub/grub.cfg?,$Orange Please select - " "2") ]]; then
		echo "$Nline$Orange Skipped.$Reset$Nline"
		MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped add belowe lines to /etc/grub.d/40_custom:$Nline $grub_40_custom $Nline $Reset"
	else
		echo "$grub_40_custom" >> "/etc/grub.d/40_custom"
		echo "$Nline$Orange ok add $Reset$Nline"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Add belowe lines to /etc/grub.d/40_custom:$Nline $grub_40_custom $Nline $Reset"
		grub_mkconfig="yes"
	fi
	fi
	# end New Grub
fi

}

add_to_boot_menu ()
{
gen_boot_menus

if [[ $grub_mkconfig = "yes" ]]; then
	command1=$(whereis -b grub-mkconfig|awk '{print $2}')
	command2=$(whereis -b grub2-mkconfig|awk '{print $2}')
	if [[ -f $command1 ]] || [[ -f $command2 ]] ;then
		if [[ -f $command1 ]] ;then
			grub-mkconfig -o /boot/grub/grub.cfg
		elif [[ -f $command2 ]] ;then
			grub2-mkconfig -o /boot/grub2/grub.cfg
		fi
	fi
fi
}

##################

gen_vdd_sh_script ()
{
echo "$Nline$Green Write $Cream"vdd.sh"$Green in: $SmoothBlue"$(pwd)"$Reset"

read -r -d '' FILECONTENT <<'ENDFILECONTENT'
#!/bin/bash
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
Licence=$(cat <<-EOF
	by Leszek Ostachowski® (©2017) @GPL V2
	To jest wolne oprogramowanie: masz prawo je zmieniać i rozpowszechniać.
	Autorzy nie dają ŻADNYCH GWARANCJI w granicach Nakazywanych jakimś prawem.
	Poniewarz jak się odwrócisz, to prawo staje się lewo i coś się zmiena, a
	oprócz tego, że prawa to zakazy najcześciej przybierajace posatć nakazów$Blink.$Reset
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
Get_View_port_position () { echo -n "$Black$Report";read -sdR Position; echo -n ""$'\033['$((${#Position} + 2 ))'D'""; VPosition=${Position#*[} CPosition=${VPosition#*;} RPosition=${VPosition%;*} ;}
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
if [[ $TERM != *xterm* ]]
then :

        Yellow=""$'\033[0;93m'""
        LYellow=""$'\033[01;93m'""

# fix               "$Yellow"        "$LMagenta"
	Orange=""$'\033[0;33m'"" Cream=""$'\033[0;95m'""
	# Yellow="LYellow"
	Yellow=""$'\033[0;93m'""
else :               # LYellow           "$Bold$Yellow"
	Yellow=""$'\033[0;93m'"" LYellow=""$'\033[01;93m'""
	Orange=$LRed
fi
}
Fix
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
			#echo -n ""$'\033[6n'""; read -sdR CURPOS; CURPOS=${CURPOS#*[}; Charsbk 9
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
	echo -n "$EraseR$Nline$EraseR Starting in $loop_time_out seconds... "; echo -n "${VPosition}"
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

ENDFILECONTENT
echo "$FILECONTENT" > "vdd.sh" && MESSAGE+="$Nline$Green $(( mn+=1 )). Write $Cream"vdd.sh"$Green in: $SmoothBlue"$(pwd)" $Nline $Reset"
chmod +x vdd.sh

}

Begin "$@"

if [ -e ./vdd.sh ]
then :
	/bin/bash ./vdd.sh export
fi

/bin/bash
