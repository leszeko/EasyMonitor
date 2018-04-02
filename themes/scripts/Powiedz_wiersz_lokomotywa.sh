#!/bin/bash
# Powiedz_wiersz_lokomotywa.sh v1.1
# by Leszek Ostachowski® (©2017) @GPL V2
Begin ()
{
Traps "$@"
Color_terminal_variables
Prepare_check_environment "$@"
Info_data
Print_info
#Run_as_root "$@"
Test_dependencies
Install_missing

speak
}

Info_data ()
{
   Name="# Powiedz_wiersz_lokomotywa.sh"
Version="# V1.2,.. \"${White}B${LWhite}l${Red}a${Cyan}c${LRed}k$Magenta|$Orange: ${Yellow}Terminal${LGreen}\" ${LWhite}B$Magenta&"$Orange"C$Orange Test beta script$Reset"
 Author="# Leszek Ostachowski® (©2017) @GPL V2"
Purpose="# Test espeak"
Worning="# "
  Usage="# Usage: Clik on script"
Dependencies=( espeak )
Optional_dependences=( bb )
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
		# Umount_source_destination
		
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

Cursor_r_block=""$'\033[?17;0;64c'""
UTF_8=""$'\033%G'""           # Select UTF-8
Underline_c=""$'\033[1;31]'"" # Set color n as the underline color

Window_it () { echo -n ""$'\033]0;'$1$'\007'"" >&2 ;} # Set Icon and Window Title <string>
Window_t () { echo -n ""$'\033]2;'$1$'\007'"" >&2 ;} # Set Window Title <string>

## Font attributes ##
Nolrmal=""$'\033[0m'"" Bold=""$'\033[1m'"" Faint=""$'\033[2m'""
 Italic=""$'\033[3m'"" Underline=""$'\033[4m'""
  Blink=""$'\033[5m'"" Reverse=""$'\033[7m'"" Strike=""$'\033[9m'"" # (on monochrome display adapter only)

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

Cursor_blink=""$'\033[?12h'"" # ATT160	 Start blinking the cursor
Cursor_solid=""$'\033[?12l'"" # ATT160	 Stop blinking the cursor
 Cursor_show=""$'\033[?25h'"" # DECTCEM	 Show the cursor
 Cursor_hide=""$'\033[?25l'"" # DECTCEM	 Hide the cursor

Scroll_up () { echo -n ""$'\033['$1'S'"" ;}
# Scroll text up by <n>. Known as pan down, new lines fill in from the bottom
Scroll_dn () { echo -n ""$'\033['$1'T'"" ;}
# Scroll down by <n>. known as pan up, new lines fill in fromthe top

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
echo $Underline_c $UTF_8
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
	
	if [ "$1" ]
	then :	
		if [ "$1" = "-v" ]
		then :	
			Print_info
			ccho "$Nline$Green$Licence$Reset$Nline"
			No_log=yes
			exit 0
		fi
	fi

comment=<<EOF
aterm          - AfterStep terminal with transparency support
gnome-terminal - default terminal for GNOME
guake          - A dropdown terminal for GNOME
konsole        - default terminal for KDE
Kuake          - a dropdown terminal for KDE
mrxvt          - Multi-tabbed rxvt clone
rxvt           - for the X Window System (and, in the form of a Cygwin port, 
                 for Windows) 
rxvt-unicode   - rxvt clone with unicode support
xfce4-terminal - default terminal for Xfce desktop 
                 environment with dropdown support
Terminator     - is a GPL terminal emulator. It is available on
                 Microsoft Windows, Mac OS X, Linux and other Unix X11 systems.
Terminology    - enhanced terminal supportive of multimedia 
                 and text manipulation for X11 and Linux framebuffer
tilda          - A drop down terminal
wterm          - It is a fork of rxvt, designed to be lightweight, but still
                 full of features
xterm          - default terminal for the X Window System
Yakuake        - (Yet Another Kuake), a dropdown terminal for KDE
deepin-terminal - default terminal for Deepin
EOF

Locomotive=$(cat <<-EOF
And now we will recite the poem - „The Locomotive” by Julian Tuwim (1894-1953)".

A big locomotive has pulled into town,
Heavy, humungus, with sweat rolling down,
A plump jumbo olive.
Huffing and puffing and panting and smelly,
Fire belches forth from her fat cast iron belly.

Poof, how she's burning,
Oof, how she's boiling,
Puff, how she's churning,
Huff, how she's toiling.
She's fully exhausted and all out of breath,
Yet the coalman continues to stoke her to death.

Numerous wagons she tugs down the track:
Iron and steel monsters hitched up to her back,
All filled with people and other things too:
The first carries cattle, then horses not few;
The third car with corpulent people is filled,
Eating fat frankfurters all freshly grilled.
The fourth car is packed to the hilt with bananas,
The fifth has a cargo of six grand pi-an-as.
The sixth wagon carries a cannon of steel,
With heavy iron girders beneath every wheel.
The seventh has tables, oak cupboards with plates,
While an elephant, bear, two giraffes fill the eighth.
The ninth contains nothing but well-fattened swine,
In the tenth: bags and boxes, now isn't that fine?
/dev/sda2
There must be at least forty cars in a row,
And what they all carry, I simply don't know:

But if one thousand athletes, with muscles of steel,
Each ate one thousand cutlets in one giant meal,
And each one exerted as much as he could,
They'd never quite manage to lift such a load.

First a toot!
Then a hoot!
Steam is churning,
Wheels are turning!

More slowly - than turtles - with freight - on their - backs,
The drowsy - steam engine - sets off - down the tracks.
She chugs and she tugs at her wagons with strain,
As wheel after wheel slowly turns on the train.
She doubles her effort and quickens her pace,
And rambles and scrambles to keep up the race.
Oh whither, oh whither? go forward at will,
And chug along over the bridge, up the hill,
Through mountains and tunnels and meadows and woods,
Now hurry, now hurry, deliver your goods.
Keep up your tempo, now push along, push along,
Chug along, tug along, tug along, chug along
Lightly and sprightly she carries her freight
Like a ping-pong ball bouncing without any weight,
Not heavy equipment exhausted to death,
But a little tin toy, just a light puff of breath.
Oh whither, oh whither, you'll tell me, I trust,
What is it, what is it that gives you your thrust?
What gives you momentum to roll down the track?
It's hot steam that gives me my clickety-clack.
Hot steam from the boiler through tubes to the pistons,
The pistons then push at the wheels from short distance,
They drive and they push, and the train starts a-swooshin'
'Cuz steam on the pistons keeps pushin' and pushin';
The wheels start a rattlin', clatterin', chatterin'
Chug along, tug along, chug along, tug along! . . .
EOF
)

Lokomotywa=$(cat <<-EOF
A teraz zadeklamujemy państwu wierszyk - Julian Tuwim (1894-1953) „Lokomotywa”.

Stoi na stacji lokomotywa,
Ciężka, ogromna i pot z niej spływa -
Tłusta oliwa.
Stoi i sapie, dyszy i dmucha,
Żar z rozgrzanego jej brzucha bucha:
Buch - jak gorąco!
Uch - jak gorąco!
Puff - jak gorąco!
Uff - jak gorąco!
Już ledwo sapie, już ledwo zipie,
A jeszcze palacz węgiel w nią sypie.
Wagony do niej podoczepiali
Wielkie i ciężkie, z żelaza, stali,
I pełno ludzi w każdym wagonie,
A w jednym krowy, a w drugim konie,
A w trzecim siedzą same grubasy,
Siedzą i jedzą tłuste kiełbasy.
A czwarty wagon pełen bananów,
A w piątym stoi sześć fortepianów,
W szóstym armata, o! jaka wielka!
Pod każdym kołem żelazna belka!
W siódmym dębowe stoły i szafy,
W ósmym słoń, niedźwiedź i dwie żyrafy,
W dziewiątym - same tuczone świnie,
W dziesiątym - kufry, paki i skrzynie,
A tych wagonów jest ze czterdzieści,
Sam nie wiem, co się w nich jeszcze mieści.

Lecz choćby przyszło tysiąc atletów
I każdy zjadłby tysiąc kotletów,
I każdy nie wiem jak się natężał,
To nie udźwigną - taki to ciężar!

Nagle - gwizd!
Nagle - świst!
Para - buch!
Koła - w ruch!

Najpierw
powoli
jak żółw
ociężale
Ruszyła -- maszyna -- po szynach
ospale.
Szarpnęła wagony i ciągnie z mozołem,
I kręci się, kręci się koło za kołem,
I biegu przyspiesza, i gna coraz prędzej,
I dudni, i stuka, łomoce i pędzi.

A dokąd? A dokąd? A dokąd? Na wprost!
Po torze, po torze, po torze, przez most,
Przez góry, przez tunel, przez pola, przez las
I spieszy się, spieszy, by zdążyć na czas,
Do taktu turkoce i puka, i stuka to:
Tak to to, tak to to, tak to to, tak to to,
Gładko tak, lekko tak toczy się w dal,
Jak gdyby to była piłeczka, nie stal,
Nie ciężka maszyna zziajana, zdyszana,
Lecz raszka, igraszka, zabawka blaszana.

A skądże to, jakże to, czemu tak gna?
A co to to, co to to, kto to tak pcha?
Że pędzi, że wali, że bucha, buch-buch?
To para gorąca wprawiła to w ruch,
To para, co z kotła rurami do tłoków,
A tłoki kołami ruszają z dwóch boków
I gnają, i pchają, i pociąg się toczy,
Bo para te tłoki wciąż tłoczy i tłoczy,,
I koła turkocą, i puka, i stuka to:
Tak to to, tak to to, tak to to, tak to to!...
EOF
)


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
	
	for (( x=$(( ${#select_list[@]}+9 )); x>0; x--)); do echo "$EraseR"; done
	Linesup $(( ${#select_list[@]}+9 ))
	echo -n "$Reset$SaveP$EraseD"
	# Time out loop
	{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
	###
	# clear
	# Main loop
	while true
	do :	
	
	View_port_size=$(stty size); OLDIFS="$IFS"; IFS=' ' View_size=($View_port_size); IFS="$OLDIFS"; Vlines=${View_size[0]} Vcolumns=${View_size[1]}
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
	
	echo "$EraseD${Title_select}"
	echo "$RestoreP$Nline"
	echo "$Magenta Functions: $functions_list"
	echo "$RestoreP$Nline$Nline"
	echo "$Title_list"
	
	# Print list loop
	#list_lenght=$(( ${#select_list[@]} ))
	list_lenght=$(( ${#options[@]} ))
	if (( "$list_lenght">"$Vlines"-9  ))
	then :	
		(( list_lenght="$Vlines"-9 ))
	fi
	
	trim=$(( ${Vcolumns} - 4 ))
	for (( x="$list_lenght"; x>0; x-- ))
	do :	
		if [ "$[default]" = "$x" ]
		then :	# Change color; get cursor position
			echo -n ""$'\033[6n'""; read -sdR POS; CURPOS=${POS#*[}; echo -n ""$'\033['${#POS}'D'""
			printf "$Green$Blink%3s$Reset$Green)" " $x"
			printf "%.*s$Reset$EraseR\n" "$trim" " ${select_list[$x-1]}"
		else :
			printf "$Reset$EraseR%3s)" " $x"
			printf "%.*s$Reset$EraseR\n" "$trim" "  ${select_list[$x-1]}"
			
		fi
		
	done
	
	# and print Preselected
	echo -n "$EraseD$Nline"
	Message="$Orange Preselected$Yellow$Blink:$Green ${select_list[$default-1]%%:*}$Yellow$Blink<:,$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink?:$Reset"
	
	Get_View_port_position
	printf "%s" "$Message"
	View_port_position $RPosition $CPosition
	echo -n "$Nline$Reset$EraseD"
	# print time out and cursor position
	Message=$(printf "%*s" $Vcolumns)
        echo -n ${Message: 1 : $Vcolumns-1 }
	Message=" Starting in $loop_time_out seconds...; ${CURPOS}"
	printf "%.*s" "$(( $Vcolumns-1 ))" "$Message"
	
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
	   "$Procedure"
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
	
	# calculate result
	Selected="${select_list[default-1]##*$'!\b'}"
	Selected=${Selected[@]#*;*m}
	Selected=${Selected[@]%%$'\033'[*}
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

Get_file_list ()
{
	list=$(ls --sort=time *$File_Type)
	OLDIFS="$IFS"
	IFS=$'\n' #IFS=$' \t\n'
	list=( ${list} )
	IFS="$OLDIFS"
}

speak () {

while true
do :	
	###
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). r_ask_select  "1"  "{P}olski" "{E}nglish" "{N}o" ]$Reset"
	Bar "$MESSAGE"
	
	answer=$(r_ask_select "$Nline$Green Wiersz -$SmoothBlue Julian Tuwim $LCyan„Lokomotywa”,$Nline$Orange Please select : " "1"  "{P}olski" "{E}nglish" "{N}o")
	echo
	echo "Akcepted: $answer"
	[[ "$answer" == "Polski" ]] && { speak_it "$Lokomotywa" "espeak -v pl -s 160" ;}
	[[ "$answer" == "English" ]] && { speak_it "$Locomotive" "espeak -v en -s 160" ;}
	
	###
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). r_ask_select "2"  "{P}olski" "{E}nglish" "{N}o" ]$Reset"
	Bar "$MESSAGE"
	
	answer=$(r_ask_select "$Nline$Green Wiersz -$SmoothBlue Julian Tuwim $LCyan„Lokomotywa”,$Orange Please select : " "2"  "{P}olski" "{E}nglish" "{N}o")
	echo
	echo "Akcepted: $answer"
	[[ "$answer" == "Polski" ]] && { speak_it "$Lokomotywa" "espeak -v pl -s 160" ;}
	[[ "$answer" == "English" ]] && { speak_it "$Locomotive" "espeak -v en -s 160" ;}
	
	###
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). r_ask "1" "r_key" ]$Reset"
	Bar "$MESSAGE"
	
	if [[ "no" == $(r_ask "$SmoothBlue Continue -$Green [Y]es$SmoothBlue or$Orange [N]no$Red exit!$Orange : Please answer - " "1" "r_key" ) ]]
	then :	
		echo
		echo "Akcepted: no"
		echo "$Red - exit! $Reset"
		Finished="Yes"
		exit
	else :	
		echo
		echo "Akcepted: continue"
		echo "$Green - ok Continue $Reset"
	fi
	
	###
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). r_ask "2" ]$Reset"
	Bar "$MESSAGE"
	
	if [[ "no" == $(r_ask "$SmoothBlue Continue -$Green {Y}es$SmoothBlue or$Orange {N}$Red exit!$Orange : Please answer - " "2" ) ]]
	then :	
		echo
		echo "Entered: no"
		echo "$Red - exit! $Reset"
		Finished="Yes"
		exit
	else :	
		echo
		echo "Entered: continue"
		echo "$Green - ok Continue $Reset"
	fi
	
	###
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). r_ask_select \"\" ]$Reset"
	Bar "$MESSAGE"
	
	if [[ "no" == $(r_ask_select "$SmoothBlue Continue -$Green {*y} $SmoothBlue"or"$Orange {*n}$Red exit!,$Orange Please select : ") ]]
	then :	
		echo
		echo "Akcepted: no"
		echo "$Red - exit! $Reset"
		Finished="Yes"
		exit
	else :	
		echo
		echo "Akcepted: continue"
		echo "$Green - ok Continue $Reset"
	fi
done
}

speak_it ()
{
	tmp_dir=$(mktemp -d)
	mkfifo "$tmp_dir/pipe"
	
	cat  "$tmp_dir/pipe" & pid1=$!
	echo;echo
	echo "pid cat "$tmp_dir/pipe"	 : $pid1"
	
	{ while read line; do echo "$line"; sleep 2.2 ; done <<<"$1" | tee "$tmp_dir/pipe" ;} | $2 2>/dev/null \
	& 
	{ pid2=$!
	echo "pid $2		 : $pid2"
	echo
	sleep 2
	sleep 2
	wait $pid2
	kill $pid1 2>/dev/null
	echo "$Nline$SmoothBlue kill $pid1 & rm -rf $tmp_dir$Reset"; rm -rf "$tmp_dir"
	}
	


 ###
 ###
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). r_askk ]$Reset"
	Bar "$MESSAGE"

r_askk ()
{

read -p "$Nline$Green Wiersz -$SmoothBlue Julian Tuwim $LCyan„Lokomotywa”,$Orange Please answer: $Green*{P}olski  $Red{E}nglish$SmoothBlue or $Cream{N}o$Orange$Blink ?:$Reset$Yellow *$MoveL$SaveP" REPLY;  echo -n "$Reset"
REPLY=$(tr '[A-Z]' '[a-z]' <<<"$REPLY")

if   [[ "$REPLY" = "n" ]] || [[ "$REPLY" = "no" ]]
then :
	echo "$RestoreP$Cream"Skip"$Reset"
	
elif [[ "$REPLY" = "e" ]] || [[ "$REPLY" = "english" ]]
then :
	echo "$RestoreP$Red"English"$Reset"
else :
	echo "$RestoreP$Green"Polski"$Reset"
fi
}; r_askk

if [[ "$REPLY" = "e" ]] || [[ "$REPLY" = "english" ]]
then :
	speak_it "$Locomotive" "espeak -v en -s 160"
	
elif [[ "$REPLY" = "n" ]] || [[ "$REPLY" = "no" ]]
then :
	exit
	
else :
	speak_it "$Lokomotywa" "espeak -v pl -s 160"
fi
Finished="Yes"
}

# ps -ef | grep defunct
# parents_of_dead_kids=$(ps -ef | grep [d]efunct | awk '{print $3}' | sort | uniq | egrep -v '^1$'); echo "$parents_of_dead_kids" | xargs kill

# Named pipes

# The most basic and portable method is to use named pipes. The downside is that you need to find a writable directory, create the pipes, and clean up afterwards.

# tmp_dir=$(mktemp -d)
# mkfifo "$tmp_dir/f1" "$tmp_dir/f2"
# command1 <"$tmp_dir/f1" & pid1=$!
# command2 <"$tmp_dir/f2" & pid2=$!
# tee "$tmp_dir/f1" "$tmp_dir/f2" | command3
# rm -rf "$tmp_dir"
# wait $pid1 $pid2

## https://linux.die.net/man/1/tpipe

# !/bin/bash
# exec 3<"$1"
# while IFS='' read -r -u 3 line || [ -n "$line" ]; do
#    read -p "> $line (Press Enter to continue)"
# done
#
# !/bin/bash
# while IFS='' read -r line || [ -n "$line" ]; do
#    echo "Text read from file: $line"
# done < "$1"
#
# filename=$1
# IFS=$'\n'
# for next in `cat $filename`
# do
#    echo "$next read from $filename"
# done
# exit 0
## Add IFS= so that read won't trim leading and trailing whitespace from each line.
## Add -r to read to prevent from backslashes from being interpreted as escape sequences.

# When a program writes to /path/to/pipe (i.e. echo "" > /path/to/pipe), /path/to/program will be executed.

# mkfifo /path/to/pipe
# sh -c 'while true; do cat /path/to/pipe >/dev/null; /path/to/program; done' &

# This script can be extended to do more complex things of course, like have the "while" loop take
# different actions depending on what you write to /path/to/pipe, but the point is, pipe activation isn't hard to come by.


# http://stackoverflow.com/questions/13107783/pipe-output-to-two-different-commands
# https://unix.stackexchange.com/questions/28503/how-can-i-send-stdout-to-multiple-commands

# https://askubuntu.com/questions/201303/what-is-a-defunct-process-and-why-doesnt-it-get-killed
# http://stackoverflow.com/questions/690415/in-what-order-should-i-send-signals-to-gracefully-shutdown-processes/690631#690631

# http://www.catonmat.net/blog/bash-one-liners-explained-part-one/
# http://www.catonmat.net/blog/bash-one-liners-explained-part-two/
# http://www.catonmat.net/blog/bash-one-liners-explained-part-three/
# http://www.catonmat.net/blog/bash-one-liners-explained-part-four/
# http://www.catonmat.net/blog/bash-one-liners-explained-part-five/
# http://www.catonmat.net/blog/bash-one-liners-explained-part-six/
# http://www.catonmat.net/blog/sed-one-liners-explained-part-one/
# http://www.catonmat.net/blog/awk-one-liners-explained-part-one/
# http://www.catonmat.net/blog/awk-one-liners-explained-part-two/
# http://cfajohnson.com/shell/?2013-01-08_bash_array_manipulation
# abs-guide.pdf

Begin "$@"
