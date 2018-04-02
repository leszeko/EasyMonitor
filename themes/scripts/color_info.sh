#!/bin/bash
# color_info.sh script
# https://en.wikipedia.org/wiki/ANSI_escape_code

Begin ()
{
reset
Traps "$@"
Color_terminal_variables
#Info_data
Prepare_check_environment "$@"
#Print_info
#Run_as_root "$@"
#Test_dependencies
#Install_missing
Some_test
Escape_sequences
Unicode_characters
True_color
colorgrid
Daniel_Crisman
Color.bsh
colortools-system
print_colors
another_test
ansi-test
Mandelbrot

Elapsed_time=$((`date +%s` - $Start_time))
echo "$Green # Done color_info # $LWhite- Finished in $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec"
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

Color_terminal_variables ()
{
Esc=""$'\033'"" ESC=""$'\033'""
CSI=""$'\033['""
ansi ()  { echo -en "\033[${1}m" >&2; echo -en "${*:2}"; echo -en "\033[0m">&2; }
# red () { ansi 31 "$@"; }; red "red"
function f_date { date +%Y-%m-%d_%H-%M-%S ;}
Escape () { echo -en "\033[$1" >&2 ;}

Window_it ()  { echo -n ""$'\033]0;'$1'\007'"" >&2 ;} # Set Icon and Window Title <string>
Window_t ()   { echo -n ""$'\033]2;'$1'\007'"" >&2 ;} # Set Window Title <string>
Columns132 () { echo -n ""$'\033[?3h'"" ;} # DECCOLM	Set Number of Columns to 132
Columns80 ()  { echo -n ""$'\033[?3l'"" ;} # DECCOLM	Set Number of Columns to 80
Terminal_size () { echo -n ""$'\033[8;'$1';'$2't'"" >&2 ;} # Terminal_size $LINES $XXX - shrinks/extends line length
Stop_wrap=""$'\033[?7l'""
Start_wrap=""$'\033[?7h'""
# setterm --linewrap [on|off]
comment=<<EOF
#------------------------
For the default foreground and background colors the control sequences are OSC 10 ; spec BEL and OSC 11 ; spec BEL, respectively. For example:

echo -en "\e]10;red\a"
echo -en "\e]11;green\a"
Those can be reset with OSC 110 BEL and OSC 111 BEL respectively:

echo -en "\e]110\a"
echo -en "\e]111\a"
#------------------------
These control sequences can be sent by simply printing them with echo:

echo -en "\e]4;COLOR;SPEC\a"
echo -en "\e]4;COLOR;SPEC\a"
For example, in order to set color number 5 (usually some shade of magenta) to red, either of these should work:

echo -en "\e]4;5;red\a"
echo -en "\e]4;5;#ff0000\e\\"
echo -en "\033]4;5;rgb:ff/00/00\007"
Those colors can be reset to their (configured) default with one of the control sequences

OSC 104 ; c BEL
OSC 104 ; c ST
So the following loop will reset all colors from 0 to 255 to their configured or default value:

for c in {0..255}; do
  echo -en "\e]104;$c\a"
done
#------------------------
The command chvt N makes /dev/ttyN the foreground terminal.
(The corresponding screen is created if it did not exist yet.
To get rid of unused VTs, use deallocvt )
The key combination (Ctrl-)LeftAlt-FN (with N in the range 1-12) usually has a similar effect.
You can find the virtual terminal you're currently on via the fgconsole command. This too requires sudo privileges to run.

	setterm
       --blink [on|off]
              Turns blink mode on or off.   (virtual consoles only)e,
              --blink off turns off all attributes (bold, half-brightness,
              blink, reverse).
       --bold [on|off]
              Turns bold (extra bright) mode on or off.   (virtual consoles only)
              console, --bold off turns off all attributes (bold, half-
              brightness, blink, reverse).
       --hbcolor 16-color
              Sets the color for bold characters.
       --half-bright [on|off]
              Turns dim (half-brightness) mode on or off.   (virtual consoles only),
       --half-bright off turns off all attributes
              (bold, half-brightness, blink, reverse).
       --underline [on|off]
              Turns underline mode on or off.
       --ulcolor 16-color  (virtual consoles only)
              Sets the color for underlined characters.
       --resize
              Reset terminal size by assessing maximum row and column.  This
              is useful when actual geometry and kernel terminal driver are
              not in sync.  Most notable use case is with serial consoles,
              that do not use ioctl(3) but just byte streams and breaks.
       --background black  --foreground green -store

# set the default text color. this only works in tty (eg $TERM == "linux"), not pts (eg $TERM == "xterm")
# terminals often load initial parameters at start and change all other ones.
# for Name in `find /usr/share/terminfo -type f -printf '%f '`;do echo "$Name" |grep "color";done
#------------------------
#    "rgb"   : "256-color pallette – 6*6*6 RGB subset"
#    "gray"  : "256-color pallette – gray scale subset"
#    "sys"   : "256-color pallette – ansi color subset"
#    "iso"   : "ISO 8-color pallette - *3 intense "
#    "rgb888": "True-color RGB mode"
#------------------------
# https://en.wikipedia.org/wiki/X11_color_names#Clashes_between_web_and_X11_colors_in_the_CSS_color_scheme
# https://jonasjacek.github.io/colors/
# http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
# https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences

# First 16 colors registers #    "sys"   : "– ansi color subset"

0 #000000  1 #800000  2 #008000  3 #808000  4 #000080  5 #800080  6 #008080  7 #c0c0c0
8 #808080  9 #ff0000 10 #00ff00 11 #ffff00 12 #0000ff 13 #ff00ff 14 #00ffff 15 #ffffff

# "256-color pallette – 6*6*6 RGB subset"

 16 #000000  17 #00005f  18 #000087  19 #0000af  20 #0000d7  21 #0000ff
 22 #005f00  23 #005f5f  24 #005f87  25 #005faf  26 #005fd7  27 #005fff
 28 #008700  29 #00875f  30 #008787  31 #0087af  32 #0087d7  33 #0087ff
 34 #00af00  35 #00af5f  36 #00af87  37 #00afaf  38 #00afd7  39 #00afff
 40 #00d700  41 #00d75f  42 #00d787  43 #00d7af  44 #00d7d7  45 #00d7ff
 46 #00ff00  47 #00ff5f  48 #00ff87  49 #00ffaf  50 #00ffd7  51 #00ffff
 52 #5f0000  53 #5f005f  54 #5f0087  55 #5f00af  56 #5f00d7  57 #5f00ff
 58 #5f5f00  59 #5f5f5f  60 #5f5f87  61 #5f5faf  62 #5f5fd7  63 #5f5fff
 64 #5f8700  65 #5f875f  66 #5f8787  67 #5f87af  68 #5f87d7  69 #5f87ff
 70 #5faf00  71 #5faf5f  72 #5faf87  73 #5fafaf  74 #5fafd7  75 #5fafff
 76 #5fd700  77 #5fd75f  78 #5fd787  79 #5fd7af  80 #5fd7d7  81 #5fd7ff
 82 #5fff00  83 #5fff5f  84 #5fff87  85 #5fffaf  86 #5fffd7  87 #5fffff
 88 #870000  89 #87005f  90 #870087  91 #8700af  92 #8700d7  93 #8700ff
 94 #875f00  95 #875f5f  96 #875f87  97 #875faf  98 #875fd7  99 #875fff
100 #878700 101 #87875f 102 #878787 103 #8787af 104 #8787d7 105 #8787ff
106 #87af00 107 #87af5f 108 #87af87 109 #87afaf 110 #87afd7 111 #87afff
112 #87d700 113 #87d75f 114 #87d787 115 #87d7af 116 #87d7d7 117 #87d7ff
118 #87ff00 119 #87ff5f 120 #87ff87 121 #87ffaf 122 #87ffd7 123 #87ffff
124 #af0000 125 #af005f 126 #af0087 127 #af00af 128 #af00d7 129 #af00ff
130 #af5f00 131 #af5f5f 132 #af5f87 133 #af5faf 134 #af5fd7 135 #af5fff
136 #af8700 137 #af875f 138 #af8787 139 #af87af 140 #af87d7 141 #af87ff
142 #afaf00 143 #afaf5f 144 #afaf87 145 #afafaf 146 #afafd7 147 #afafff
148 #afd700 149 #afd75f 150 #afd787 151 #afd7af 152 #afd7d7 153 #afd7ff
154 #afff00 155 #afff5f 156 #afff87 157 #afffaf 158 #afffd7 159 #afffff
160 #d70000 161 #d7005f 162 #d70087 163 #d700af 164 #d700d7 165 #d700ff
166 #d75f00 167 #d75f5f 168 #d75f87 169 #d75faf 170 #d75fd7 171 #d75fff
172 #d78700 173 #d7875f 174 #d78787 175 #d787af 176 #d787d7 177 #d787ff
178 #d7af00 179 #d7af5f 180 #d7af87 181 #d7afaf 182 #d7afd7 183 #d7afff
184 #d7d700 185 #d7d75f 186 #d7d787 187 #d7d7af 188 #d7d7d7 189 #d7d7ff
190 #d7ff00 191 #d7ff5f 192 #d7ff87 193 #d7ffaf 194 #d7ffd7 195 #d7ffff
196 #ff0000 197 #ff005f 198 #ff0087 199 #ff00af 200 #ff00d7 201 #ff00ff
202 #ff5f00 203 #ff5f5f 204 #ff5f87 205 #ff5faf 206 #ff5fd7 207 #ff5fff
208 #ff8700 209 #ff875f 210 #ff8787 211 #ff87af 212 #ff87d7 213 #ff87ff
214 #ffaf00 215 #ffaf5f 216 #ffaf87 217 #ffafaf 218 #ffafd7 219 #ffafff
220 #ffd700 221 #ffd75f 222 #ffd787 223 #ffd7af 224 #ffd7d7 225 #ffd7ff
226 #ffff00 227 #ffff5f 228 #ffff87 229 #ffffaf 230 #ffffd7 231 #ffffff

"gray"  : "256-color pallette – gray scale subset"

232 #080808 233 #121212 234 #1c1c1c 235 #262626 236 #303030 237 #3a3a3a
238 #444444 239 #4e4e4e 240 #585858 241 #606060 242 #666666 243 #767676
244 #808080 245 #8a8a8a 246 #949494 247 #9e9e9e 248 #a8a8a8 249 #b2b2b2
250 #bcbcbc 251 #c6c6c6 252 #d0d0d0 253 #dadada 254 #e4e4e4 255 #eeeeee

# Underline.. - decortion may conflict with bold..
# first set color/bold procedure after decotation?

| Value    | Color  |
| -------- | ------ |
| \033[4;30m | Black  |
| \033[4;31m | Red    |
| \033[4;32m | Green  |
| \033[4;33m | Yellow |
| \033[4;34m | Blue   |
| \033[4;35m | Purple |
| \033[4;36m | Cyan   |
| \033[4;37m | White  |

# Reset

| Value | Color  |
| ----- | ------ |
| \033[0m | Reset  |

#--------------

              infocmp xterm linux

and you will see a number of differences.

One aspect of the "bright colors" is not apparent in the terminal description: 
the Linux console displays bold text as brighter text. Some people are confused 
by this, and refer to the bold+color combinations as additional colors (they are 
not, because the application asked for bold, which is a video attribute such as 
underlining — which some devices may also render as a color).

xterm has control sequences for manipulating 16 colors as such; the Linux 
console does not. The variations of TERM which were tried were not specified, 
but supposing that one tried xterm-16color, then that would produce escape 
sequences for "colors 8-15" which are not recognized by the Linux console, and 
would produce the white-on-black (uncolored) which was described.

If you run a program which makes bold text on some other type of terminal, you 
are just as likely to get bold rendered in in a different way (like this).

:runtime syntax/colortest.vim
if [ "$TERM" == "xterm" ]; then
    # No it isn't, it's gnome-terminal
    export TERM=xterm-256color
fi
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }

To get 16 background colors in a linux framebuffer console to achieve an 
appearance like in a 16 color xterm, place the following in your vimrc (you have 
to use a real escape character instead of <Esc>, try something like 
<Ctrl-V><Esc>):

if &term =~ "linux"
  if has("terminfo")
    set t_Co=16
    " We use the blink attribute for bright background (console_codes(4)) and the
    " bold attribute for bright foreground. The redefinition of t_AF is necessary
    " for bright "Normal" highlighting to not influence the rest.
    set t_AB=<Esc>[%?%p1%{7}%>%t5%p1%{8}%-%e25%p1%;m<Esc>[4%dm
    set t_AF=<Esc>[%?%p1%{7}%>%t1%p1%{8}%-%e22%p1%;m<Esc>[3%dm
  endif
endif
Pseudo code for the terminfo entry:

if bgcol > 7
  blink = on (<Esc>[5m)
  bgcolor = bgcol - 8 (<Esc>[4...m)
else
  blink = off (<Esc>[25m)
  bgcolor = bgcol
end

if fgcol > 7
  bold = on (<Esc>[1m)
  fgcolor = fgcol - 8 (<Esc>[3...m)
else
  bold = off (<Esc>[22m)
  fgcolor = fgcol
end

EOF
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
	
	
if [ "$TERM" = "linux" ]
then : # palet
comment=<<EOF
	# terminal.sexy - Terminal Color Scheme Designer # https://jonasjacek.github.io/colors/
	# https://github.com/stayradiated/terminal.sexy # https://github.com/EvanPurkhiser/linux-vt-setcolors
	# http://ciembor.github.io/4bit/
	
	# pallet almost "orginal #brown altered to orange"
	             #black     #red       #green     #brown     #blue      #magenta   #cyan     #(S) white
	echo -ne "\e]P0000000\e]P17F0000\e]P2008000\e]P3FF4600\e]P40000F0\e]P5BF00BF\e]P600CDCD\e]P7A0A0A0"
	             #L black   #L red     #L green   #L yellow  #L blue    #L magenta #L cyan    #L white
	echo -ne "\e]P8404040\e]P9C41414\e]PA3CFF00\e]PBE2E200\e]PC4141FF\e]PDFF00FF\e]PE00FFFF\e]PFFFFFFF"
	# clear #for background artifacting
	# clear To reset the color palette, use "\e]R".
	

Kernel parameters
Linux exposes the default console palette setters as part of the parameters that
can be passed to it at boot, therefore appending the following line to your
bootloader will have the effect of changing colors from the very beginning and
for all tty's, and is as effective as #hard-coding colors at compilation time.
The format is
vt.default_red=[color_0_red_component]  ,[color_1_red_component],...,  [color_15_red_component]
vt.default_grn=[color_0_green_component],[color_1_green_component],...,[color_15_green_component]
vt.default_blu=[color_0_blue_component] ,[color_1_blue_component],..., [color_15_blue_component]

For a completely blank screen:

vt.default_red=0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
vt.default_grn=0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
vt.default_blu=0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
For my palete :
               #bla,#red,#gre,#bro,#blu,#mag,#cya,#(w),Lbla,Lred,Lgre,Lyel,Lblu,Cre ,Sblu,Lwhi

vt.default_red=0x00,0x7F,0x00,0xFF,0x10,0xBF,0x00,0xA0,0x40,0xC4,0x3C,0xE2,0x41,0xFF,0x96,0xFF \
vt.default_grn=0x00,0x00,0x80,0x46,0x10,0x00,0xCD,0xA0,0x40,0x14,0xFF,0xE2,0x41,0xC8,0x96,0xFF \
vt.default_blu=0x00,0x00,0x00,0x00,0xFF,0xBF,0xCD,0xA0,0x40,0x14,0x00,0x00,0xFF,0xC8,0xFF,0xFF

hwinfo --framebuffer

#  FRAMEBUFFER RESOLUTION SETTINGS
#     +-------------------------------------------------+
#          | 640x480    800x600    1024x768   1280x1024
#      ----+--------------------------------------------
#      256 | 0x301=769  0x303=771  0x305=773   0x307=775
#      32K | 0x310=784  0x313=787  0x316=790   0x319=793
#      64K | 0x311=785  0x314=788  0x317=791   0x31A=794
#      16M | 0x312=786  0x315=789  0x318=792   0x31B=795
#     +-------------------------------------------------+
#  for more details and different resolutions see
#  https://wiki.archlinux.org/index.php/GRUB#Framebuffer_resolution

#vga=775

https://wiki.archlinux.org/index.php/kernel_mode_setting
video=<conn>:<xres>x<yres>[M][R][-<bpp>][@<refresh>][i][m][eDd]
video=DVI-I-1:1024x768@85 video=TV-1:d
fbset - show and modify frame buffer device settings 
http://projects.meuh.org/fbgetty/docs/

Newer kernels use KMS by default, so you should move away from appending vga= to
your grub line as it will conflict with the native resolution of KMS. However,
it depends upon the video driver you are using: the proprietary Nvidia driver
doesn't support KMS, but you can work around it.

You should be able to get full resolution in the framebuffer by editing your
/etc/default/grub and making sure that the GFXMODE is set correctly, and then
adding a GFXPAYLOAD entry like so:


GRUB_GFXMODE=1680x1050x24
# Hack to force higher framebuffer resolution
GRUB_GFXPAYLOAD_LINUX=1680x1050

https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start
https://wiki.archlinux.org/index.php/Fonts#Console_fonts
EOF

UTF_8=""$'\033%G'""           # Select UTF-8

Cursor_blink=""$'\033[?12h'"" # ATT160	 Start blinking the cursor
Cursor_solid=""$'\033[?12l'"" # ATT160	 Stop blinking the cursor # standard control sequence
 Cursor_show=""$'\033[?25h'"" # DECTCEM	 Show the cursor
 Cursor_hide=""$'\033[?25l'"" # DECTCEM	 Hide the cursor

cursor_style_default=0 # hardware cursor (blinking)
cursor_style_invisible=1 # hardware cursor (blinking)
cursor_style_underscore=2 # hardware cursor (blinking)
cursor_style_lower_third=3 # hardware cursor (blinking)
cursor_style_lower_half=4 # hardware cursor (blinking)
cursor_style_two_thirds=5 # hardware cursor (blinking)
cursor_style_full_block_blinking=6 # hardware cursor (blinking)
cursor_style_full_block=16 # software cursor (non-blinking)

cursor_background_black=0 # same color 0-15 and 128-infinity
cursor_background_blue=16 # same color 16-31
cursor_background_green=32 # same color 32-47
cursor_background_cyan=48 # same color 48-63
cursor_background_red=64 # same color 64-79
cursor_background_magenta=80 # same color 80-95
cursor_background_yellow=96 # same color 96-111
cursor_background_white=112 # same color 112-127

cursor_foreground_default=0 # same color as the other terminal text
cursor_foreground_cyan=1
cursor_foreground_black=2
cursor_foreground_grey=3
cursor_foreground_lightyellow=4
cursor_foreground_white=5
cursor_foreground_lightred=6
cursor_foreground_magenta=7
cursor_foreground_green=8
cursor_foreground_darkgreen=9
cursor_foreground_darkblue=10
cursor_foreground_purple=11
cursor_foreground_yellow=12
cursor_foreground_white=13
cursor_foreground_red=14
cursor_foreground_pink=15
# only seems to work in tty
# Terminals, PS1 prompts.. can override cursor appearance settings
cursor_styles="\e[?${cursor_style_full_block};${cursor_foreground_black};${cursor_background_green};c"

 Cursor_blink_underline=""$'\033[?2;c'"" # normal blinking underline
 Cursor_w_block=""$'\033[?17;86;32;c'""  # white non-blinking block
 Cursor_r_block=""$'\033[?17;0;64;c'""   # red non-blinking block
 Cursor_g_block=""$'\033[?17;0;32;c'""   # green non-blinking block
 Cursor_y_block=""$'\033[?17;14;224;c'   # yellow non-blinking block
 Cursor_b_block=""$'\033[?17;0;144;c'""  # blue non-blinking block

echo -e "\033[?47h"
	             #black     #red       #green     #Orange    #blue      #magenta   #cyan     #(S) white
	echo -ne "\e]P0000000\e]P17F0000\e]P2008000\e]P3FF4600\e]P41010FF\e]P5BF00BF\e]P600CDCD\e]P7A0A0A0"
	             #L black   #L red     #L green   #L yellow  #L blue    #L Cream   #S Blue    #L white
	echo -ne "\e]P8404040\e]P9C41414\e]PA3CFF00\e]PBE2E200\e]PC4141FF\e]PDFFC8C8\e]PE9696FF\e]PFFFFFFF"
	# get rid of artifacts
	#clear
echo -e "\033[?47l"

fi
	# setterm --ulcolor yellow
	Blink=''
	Cursor_w_block=""$'\033[?17;86;32;c'""  # white non-blinking block
	echo -n "$Cursor_w_block"
	setfont Lat2-Terminus16 -m 8859-2
	# echo -n "$UTF_8"
else :	       # Yellow="LYellow"        "$Bold$Yellow"
	Yellow=""$'\033[0;93m'"" LYellow=""$'\033[1;93m'""
	LRed=""$'\033[1;38;5;196m'""
	echo -n "$Cursor_w_block"
	
fi

}

Nline=""$'\n'"" Beep=""$'\a'"" Back=""$'\b'"" Creturn=""$'\r'"" Ctabh=""$'\t'"" Ctabv=""$'\v'"" Formfeed=""$'\f'""
EraseR=""$'\033[K'"" EraseL=""$'\033[1K'"" ClearL=""$'\033[2K'"" ReturnClear=""$'\033[G\033[2K'""
EraseD=""$'\033[J'"" EraseU=""$'\033[1J'"" ClearS=""$'\033[2J'"" HomeClear=""$'\033[H\033[2J'"" # move to 0,0

SaveP=""$'\033[s'"" RestoreP=""$'\033[u'"" Sbuffer=""$'\033[?47h'""  Mbuffer=""$'\033[?47l'""

# ("\033[?47h") # enable alternate buffer ("\033[?47l") # disable alternate buffer ( fool screen

Scroll_up () { echo -n ""$'\033['$1'S'"" ;}
# Scroll text up by <n>. Known as pan down, new lines fill in from the bottom
Scroll_dn () { echo -n ""$'\033['$1'T'"" ;}
# Scroll down by <n>. known as pan up, new lines fill in fromthe top

Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}
Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk () { echo -n ""$'\033['$1'D'"" ;}
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

Horizontal_position () { echo -n ""$'\033['$1'G'"" ;}; Line_pos () { echo -n ""$'\033['$1'H'"" ;}
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
	printf "\r$EraseD$SmoothBlue Preselected$Orange$Blink:$Reset$Green ${answer}$Yellow$Blink<:,$Orange Select $Magenta[$((suggest+1))-${#list[@]}]$Orange and {E}nter for confirm$Blink?:$Reset"
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

Some_test ()
{
echo "$LGreen # color_info.sh script # $Reset"
Ansi_16
echo "$Reset"
echo "$LGreen # color_info.sh script # $Reset"
echo "$White"White \"$Reset"$Black"Black$White\"$Reset
echo "$LWhite"LWhite"$Reset" "$LBlack"LBlack$Reset
echo "$Reset$Faint"
echo "N Faint:" "$FRed"Red "$FGreen"Green "$FYellow"Yellow "$FBlue"Blue "$FMagenta"Magenta "$FCyan"Cyan "$SmoothBlue$Faint"SmoothBlue "$Orange$Faint"Orange "$Cream$Faint"Cream$Reset$Faint
echo "L Faint:" "$FRed"Red "$FGreen"Green "$FYellow"Yellow "$Bold$FBlue"Blue "$FMagenta"Magenta "$FCyan"Cyan "$LSmoothBlue$Faint"SmoothBlue "$LOrange$Faint"Orange "$LCream$Faint"Cream$Reset

echo " Normal:" "$Red"Red "$Green"Green "$Yellow"Yellow "$Blue"Blue "$Magenta"Magenta "$Cyan"Cyan "$SmoothBlue"SmoothBlue "$Orange"Orange "$Cream"Cream$Reset
echo "  Light:" "$LRed"Red "$LGreen"Green "$LYellow"Yellow "$LBlue"Blue "$LMagenta"Magenta "$LCyan"Cyan "$LSmoothBlue"SmoothBlue "$LOrange"Orange "$LCream"Cream$Reset$Bold

echo "N  Bold:" "$Red$Bold"Red "$Green$Bold"Green "$Yellow$Bold"Yellow "$Blue$Bold"Blue "$Magenta$Bold"Magenta "$Cyan$Bold"Cyan "$SmoothBlue$Bold"SmoothBlue "$Orange$Bold"Orange "$Cream$Bold"Cream$Reset$Bold
echo "L  Bold:" "$LRed$Bold"Red "$LGreen$Bold"Green "$LYellow$Bold"Yellow "$LBlue$Bold"Blue "$LMagenta$Bold"Magenta "$LCyan$Bold"Cyan "$LSmoothBlue$Bold"SmoothBlue "$LOrange$Bold"Orange "$LCream$Bold"Cream$Reset
echo ""$'\033[0;91m'" LRed Orange RED ORANGE "$'\033[01;31m'" LRed Orange RED ORANGE "$'\033[00;33m'" Brown Yellow Orange"
echo
bar_color_table
tput_color_table
Some_color_test
color_16
	
	

echo "$Red"
	MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline Fix $Yellow ]"
	Bar "$MESSAGE"
echo "$Reset"
read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key

Fix
setterm --blink on
echo FIX
setterm --blink off

echo "$Reset"
echo "$LGreen # color_info.sh script # $Reset"
echo
echo "$Red" Red "$Green "Green "$Yellow "Yellow "$Blue "Blue "$Magenta "Magenta "$Cyan "Cyan "$SmoothBlue "SmoothBlue "$Orange" Orange "$Cream" Cream "$White" White "$Black" \"Black\"
echo "$LRed"LRed "$LGreen"LGreen "$LYellow"LYellow "$LBlue"LBlue "$LMagenta"LMagenta "$LCyan"LCyan "$LSmoothBlue"LSmoothBlue "$LOrange"LOrange "$LCream"LCream "$LWhite"LWhite "$LBlack"\"LBlack\"
color_16
echo "$White"White \""$Black"Black$White\"
echo "$LWhite"LWhite"$Reset" "$LBlack"LBlack$Reset
echo "$Reset$Faint"
echo "N Faint:" "$FRed"Red "$FGreen"Green "$FYellow"Yellow "$FBlue"Blue "$FMagenta"Magenta "$FCyan"Cyan "$FSmoothBlue"SmoothBlue "$Orange$Faint"Orange "$Cream$Faint"Cream$Reset$Bold
echo "L Faint:" "$FRed"Red "$FGreen"Green "$FYellow"Yellow "$Bold$FBlue"Blue "$FMagenta"Magenta "$FCyan"Cyan "$FSmoothBlue"SmoothBlue "$LOrange$Faint"Orange "$LCream$Faint"Cream$Reset

echo " Normal:" "$Red"Red "$Green"Green "$Yellow"Yellow "$Blue"Blue "$Magenta"Magenta "$Cyan"Cyan "$SmoothBlue"SmoothBlue "$Orange"Orange "$Cream"Cream$Reset
echo "  Light:" "$LRed"Red "$LGreen"Green "$LYellow"Yellow "$LBlue"Blue "$LMagenta"Magenta "$LCyan"Cyan "$LSmoothBlue"SmoothBlue "$LOrange"Orange "$LCream"Cream$Reset$Bold

echo "N  Bold:" "$Red$Bold"Red "$Green$Bold"Green "$Yellow$Bold"Yellow "$Blue$Bold"Blue "$Magenta$Bold"Magenta "$Cyan$Bold"Cyan "$SmoothBlue$Bold"SmoothBlue "$Orange$Bold"Orange "$Cream$Bold"Cream$Reset$Bold
echo "L  Bold:" "$LRed$Bold"Red "$LGreen$Bold"Green "$LYellow$Bold"Yellow "$LBlue$Bold"Blue "$LMagenta$Bold"Magenta "$LCyan$Bold"Cyan "$LSmoothBlue$Bold"SmoothBlue "$LOrange$Bold"Orange "$LCream$Bold"Cream$Reset
echo ""$'\033[0;91m'" LRed Orange RED ORANGE "$'\033[01;31m'" LRed Orange RED ORANGE "$'\033[00;33m'" Brown Yellow Orange"

read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key
Some_color_test

echo

echo "$LRed$Blink Blink $Reset"

echo "$Reset"
	echo "$Orange"
	MESSAGE="[ $(( Nr+=1 )). $Underline ccho$Reset$Orange ]"
	Bar "$MESSAGE"
echo "$Reset"
read -r -N1 -s -p "$Magenta ccho: Press key: continue $Reset" Sleep_key

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
};(
echo
( strace -s5000 -e write echo "Text${Red} Red text ${Green}Green text$Reset \n" 2>&2 2>&1 ) | tee -a /dev/stderr | grep -o '"[^"]*"'
echo ccho
ccho "Text${Red} Red text ${Green}Green text$Reset \n"|od -tx1
echo
ccho "ccho $Magenta [1-3]$Nline$Reset"
ccho "Text${Red} Red text ${Green}Green text$Reset \n"
ccho "$Magenta ccho hexdump$Reset$Nline"
ccho "Text${Red} Red text   ${Green}Green text$Reset" |hexdump -C
echo "$Magenta echo hexdump$Reset"
echo -n "Text${Red} Red text   ${Green}Green text$Reset" |hexdump -C

)

}
Some_color_test ()
{
echo "$LRed$Blink Blink $Reset"
echo " rgb888": "True-color RGB mode"
echo -e "\033[00;38;2;127;0;0m R \033[00;38;2;0;127;0m G \033[00;38;2;0;0;127m B"

echo -en "\033[0;38;2;127;000;000m RGB NN Red"
echo -en "\033[0;38;2;127;000;000;2m RGB NF Red"
echo -e  "\033[0;38;2;127;000;000;1m RGB NI Red"

echo -en "\033[1;38;2;127;000;000m RGB BN Red"
echo -en "\033[1;38;2;127;000;000;2m RGB BF Red"
echo -e  "\033[1;38;2;127;000;000;1m RGB BI Red"

echo -en "\033[0;38;2;196;000;000m RGB NN Red"
echo -en "\033[0;38;2;196;000;000;2m RGB NF Red"
echo -e  "\033[0;38;2;196;000;000;1m RGB NI Red"
echo
echo -en "\033[0;38;5;196m 256 NN Red"
echo -en "\033[0;38;5;196;2m 256 NF Red"
echo -e  "\033[0;38;5;196;1m 256 NI Red"
echo -en "\033[1;38;5;196m 256 BN Red"
echo -en "\033[1;38;5;196;2m 256 BF Red"
echo -e  "\033[1;38;5;196;1m 256 BI Red"

echo
echo -en "\033[0;38;2;255;95;000m RGB NN Orange"
echo -en "\033[0;38;2;255;95;000;2m RGB NF Orange"
echo -en "\033[0;38;2;255;95;000;1m RGB NI Orange"
echo
echo -en "\033[0;38;5;166m 256 NN Orange"
echo -en "\033[0;38;5;166;2m 256 NF Orange"
echo -e  "\033[0;38;5;166;1m 256 NL Orange"
echo
echo -en "\033[0;38;2;094;060;000m RGB NN Brown"
echo -en "\033[0;38;2;094;060;000;2m RGB NF Brown"
echo -en "\033[0;38;2;094;060;000;1m RGB NI Brown"
echo
echo -en "\033[0;38;5;94m 256 NN Brown"
echo -en "\033[0;38;5;94;2m 256 NF Brown"
echo -e  "\033[0;38;5;94;1m 256 NI Brown"
echo
echo -en "\033[0;38;2;255;255;000m RGB NN Yellow"
echo -en "\033[0;38;2;255;255;000;1m RGB NI Yellow"
echo
echo -en "\033[0;38;5;226m 256 NN Yellow"
echo -e  "\033[0;38;5;226;1m 256 NL Yellow"
echo
echo -en "\033[0;38;2;255;210;210m RGB NN Cream"
echo -e  "\033[0;38;2;255;210;210;1m RGB NI Cream"

echo -en "\033[0;38;2;135;175;255m RGB NN SmoothBlue"
echo -en "\033[0;38;2;135;175;255;1m RGB NI SmoothBlue"
echo
echo "$Red" Red "$Green "Green "$Yellow "Yellow "$Blue "Blue "$Magenta "Magenta "$Cyan "Cyan "$SmoothBlue "SmoothBlue "$Orange" Orange "$Cream" Cream "$White" White "$Black" \"Black\"
echo "$LRed"LRed "$LGreen"LGreen "$LYellow"LYellow "$LBlue"LBlue "$LMagenta"LMagenta "$LCyan"LCyan "$LSmoothBlue"LSmoothBlue "$LOrange"LOrange "$LCream"LCream "$LWhite"LWhite "$LBlack"\"LBlack\"
}
Escape_sequences ()
{
echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating the escape sequences $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
sleep_key
# GNOME Terminal 3.28 (VTE 0.52), to be released in March 2018, will add support
# for a few more styles, including curly and colored underlines as seen in Kitty,
# and overline as seen in Konsole
# These will also automatically work in any other VTE-based terminal emulator
# (e.g. Tilix, Terminator, Xfce4-terminal etc.), given that VTE is at least at
# version 0.52. For the impatient, these features are already available in git
# some sugest to use ":" insted of ";" for new features
echo -e ' \e[1m bold \e[22m '
echo -e ' \e[2m dim \e[22m '
echo -e ' \e[3m italic \e[23m '
echo -e ' \e[4m underline \e[24m '
echo -e
echo -e ' \e[4;1m this is also underline bold (new in 0.52) \e[4;0m '
echo -e
echo -e ' \e[21m double underline (new in 0.52) \e[24m '
echo -e
echo -e ' \e[4;2m this is also double underline (new in 0.52) \e[4;0m '
echo -e
echo -e ' \e[4;3m curly underline (new in 0.52) \e[4;0m '
echo -e
echo -e '\e[5m blink (new in 0.52) \e[25m '

echo -e ' \e[7m reverse  \e[27m '
echo -e ' \e[8m invisible \e[28m <- invisible (but copy-pasteable) '
echo -e
echo -e '\e[9m strikethrough \e[29m '
echo -e
echo -e ' \e[53m overline (new in 0.52) \e[55m '

echo -e ' \e[31m red \e[39m '
echo -e ' \e[91m bright red red\e[39m '
echo
echo -e ' \e[38;5;42m 256-color, de facto standard (commonly used) '
echo -e ' \e[38;2;240;143;104m truecolor, de facto standard (commonly used) '

echo -e ' \e[46m cyan background \e[49m '
echo -e ' \e[106m bright cyan background \e[49m '

echo -e ' \e[31m'
echo -e ' \e[48;2;240;143;104m truecolor background, de facto standard (commonly used) \e[49m '

echo -e ' \e[38;2;240;143;104m'
echo -e ' \e[58;5;4;2m  256-color underline (new in 0.52) \e[59m \e[24m '
echo
echo -e ' \e[4;3m \e[58;2;240;143;104m truecolor underline (new in 0.52)  \e[59m \e[4;0m'
echo

echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating the  Font Effects Table of escape sequences $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
sleep_key
echo "$Stop_wrap""$Faint"
echo " ╔══════════╦════════════════════════════════╦═════════════════════════════════════════════════════════════════════════╗"
echo " ║  Code    ║             Effect             ║                                   Note                                  ║"
echo " ╠══════════╬════════════════════════════════╬═════════════════════════════════════════════════════════════════════════╣"
echo " ║ 0        ║  Reset / Normal                ║  all attributes off                                                     ║"
echo " ║ 1        ║  Bold or increased intensity   ║  # in fact 8 next registers for colors in linux trminal                 ║"
echo " ║ 2        ║  Faint (decreased intensity)   ║  Not widely supported.                                                  ║"
echo " ║ 3        ║  Italic                        ║  Not widely supported. Sometimes treated as inverse.                    ║"
echo " ║ 4        ║  Underline                     ║                                                                         ║"
echo " ║ 5        ║  Slow Blink                    ║  less than 150 per minute                                               ║"
echo " ║ 6        ║  Rapid Blink                   ║  MS-DOS ANSI.SYS; 150+ per minute; not widely supported                 ║"
echo " ║ 7        ║  [[reverse video]]             ║  swap foreground and background colors                                  ║"
echo " ║ 8        ║  Conceal                       ║  Not widely supported.                                                  ║"
echo " ║ 9        ║  Crossed-out                   ║  Characters legible, but marked for deletion.  Not widely supported.    ║"
echo " ║ 10       ║  Primary(default) font         ║                                                                         ║"
echo " ║ 11–19    ║  Alternate font                ║  Select alternate font n-10                                             ║"
echo " ║ 20       ║  Fraktur                       ║  hardly ever supported                                                  ║"
echo " ║ 21       ║  Bold off or Double Underline  ║  Bold off not widely supported; double underline hardly ever supported. ║"
echo " ║ 22       ║  Normal color or intensity     ║  Neither bold nor faint                                                 ║"
echo " ║ 23       ║  Not italic, not Fraktur       ║                                                                         ║"
echo " ║ 24       ║  Underline off                 ║  Not singly or doubly underlined                                        ║"
echo " ║ 25       ║  Blink off                     ║                                                                         ║"
echo " ║ 27       ║  Inverse off                   ║                                                                         ║"
echo " ║ 28       ║  Reveal                        ║  conceal off                                                            ║"
echo " ║ 29       ║  Not crossed out               ║                                                                         ║"
echo " ║ 30–37    ║  Set foreground color          ║  See color table below                                                  ║"
echo " ║ 38       ║  Set foreground color          ║  Next arguments are 5;n or 2;r;g;b, see below                           ║"
echo " ║ 39       ║  Default foreground color      ║  implementation defined (according to standard)                         ║"
echo " ║ 40–47    ║  Set background color          ║  See color table below                                                  ║"
echo " ║ 48       ║  Set background color          ║  Next arguments are 5;n or 2;r;g;b, see below                           ║"
echo " ║ 49       ║  Default background color      ║  implementation defined (according to standard)                         ║"
echo " ║ 51       ║  Framed                        ║                                                                         ║"
echo " ║ 52       ║  Encircled                     ║                                                                         ║"
echo " ║ 53       ║  Overlined                     ║                                                                         ║"
echo " ║ 54       ║  Not framed or encircled       ║                                                                         ║"
echo " ║ 55       ║  Not overlined                 ║                                                                         ║"
echo " ║ 60       ║  ideogram underline            ║  hardly ever supported                                                  ║"
echo " ║ 61       ║  ideogram double underline     ║  hardly ever supported                                                  ║"
echo " ║ 62       ║  ideogram overline             ║  hardly ever supported                                                  ║"
echo " ║ 63       ║  ideogram double overline      ║  hardly ever supported                                                  ║"
echo " ║ 64       ║  ideogram stress marking       ║  hardly ever supported                                                  ║"
echo " ║ 65       ║  ideogram attributes off       ║  reset the effects of all of 60-64                                      ║"
echo " ║ 90–97    ║  Set bright foreground color   ║  aixterm (not in standard)                                              ║"
echo " ║ 100–107  ║  Set bright background color   ║  aixterm (not in standard)                                              ║"
echo " ╚══════════╩════════════════════════════════╩═════════════════════════════════════════════════════════════════════════╝"
echo "$Start_wrap""$N_Intensity"
echo -e '\e]8;;http://askubuntu.com\ahyperlink\e]8;;\a'
comment=<<'EOF'

# for i in 6a 6b 6c 6d 6e 71 74 75 76 77 78; do  printf "0x$i \x$i \x1b(0\x$i\x1b(B\n"; done

Using the print '%q' technique, we can run a loop to find out which characters are special:

special=$'`!@#$%^&*()-_+={}|[]\\;\':",.<>?/ '
for ((i=0; i < ${#special}; i++)); do
    char="${special:i:1}"
    printf -v q_char '%q' "$char"
    if [[ "$char" != "$q_char" ]]; then
        printf 'Yes - character %s needs to be escaped\n' "$char"
    else
        printf 'No - character %s does not need to be escaped\n' "$char"
    fi
done | sort

EOF
}
Ansi_16 () {
echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating Some concepts - GUI, TUI $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
cat <<'EOF'
List of some terminals programs:
  1| konsole --hold -e /bin/bash color_info.sh         |
  2| terminology --hold -e /bin/bash color_info.sh     |
  3| gnome-terminal -e color_info.sh                   |
  4| xfce4-terminal --hold -x /bin/bash color_info.sh  |
  5| mate-terminal -e color_info.sh                    |
  6| lxterminal -e /bin/bash color_info.sh             |
  7| terminator -e color_info.sh                       |
  8| guake -e color_info.sh                            |
  9| urxvt -hold -e /bin/bash color_info.sh            |
 10| tilix -e /bin/bash color_info.sh                  |
 11| sakura -e /bin/bash color_info.sh                 |
 12| qterminal -e /bin/bash color_info.sh              |
 13| gtkiterm -e /bin/bash color_info.sh               |
 14| roxterm -e /bin/bash color_info.sh                |
 15| Eterm -e /bin/bash color_info.sh                  |
 16| cool-retro-term -e /bin/bash color_info.sh        |
 17| fbterm /bin/bash color_info.sh                    |
 18| fbiterm /bin/bash color_info.sh                   |
 19| tilda -e /bin/bash color_info.sh                  |
 20| deepin-terminal -e /bin/bash color_info.sh        |
 21| xiterm -e color_info.sh                           |
 22| xterm -hold -e /bin/bash color_info.sh            |

Some concepts - GUI, TUI - graphic, text. is virtual names for concepts as
komputer world. Like hardware and software in fact it also is very "virtual".
Most not very virtual interface to the komputer virtual world for now are human
fingers //the language of the blind//:)

 Hardware    │                       Software
─────────────├────────────────────────────────────────────────────────┐  ┌─────┐
┌─────────┐  │┌─────────┐             Kernel                         ┌┼──┤ Prg │
│         │  ││ VGA     │                                            ▽│  └─────┘
│ Display ├◀─┼┤         ├─┐  ┌──────────┐  ┌────────────┐ ┌────────┐ ▲│  ┌─────┐
│         │  ││ driver  │ └◀─┤ Terminal │  │   Line     │ │  TTY   ├─┘│┌─┤ Prg │
└─────────┘  │└─────────┘    │          ├◀─┤            ├◀┤        ├►◀┼┘ └─────┘
┌─────────┐  │┌─────────┐    │          ├►─┤            ├►┤        ├►◀┼┐ ┌─────┐
│         │  ││ Keybord │ ┌►─┤ emulator │  │ discipline │ │ driver ├┐ │└─┤ Prg │
│ Keybord ├▶─┼┤         ├─┘  └──────────┘  └────────────┘ └────────┘└►┼┐ └─────┘
│         │  ││ driver  │                                             │△ ┌─────┐
└─────────┘  │└─────────┘                                             │└─┤ Prg │
             └────────────────────────────────────────────────────────┘  └─────┘
EOF

echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating Box-drawing_character $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
echo " https://en.wikipedia.org/wiki/Box-drawing_character"
echo "┌────┬────┬────┐ ╔════╦════╦════╗ ┌─┬┐  ╔═╦╗  ╓─╥╖  ╒═╤╕ ┌─────▹─────────────┐"
echo "│    │    │    │ ║    ║    ║    ║ │ ││  ║ ║║  ║ ║║  │ ││ │  ╔═══╗ Some Text  │▒"
echo "│    │    │    │ ║    ║    ║    ║ │ ││  ║ ║║  ║ ║║  │ ││ │  ╚═╦═╝ in the box │▒"
echo "│    │    │    │ ║    ║    ║    ║ │ ││  ║ ║║  ║ ║║  │ ││ ╞═╤══╩══╤═══════════╡▒"
echo "│    │    │    │ ║    ║    ║    ║ │ ││  ║ ║║  ║ ║║  │ ││ │ ├──┬──┤ ╭──╮╭──╮  │▒"
echo "├────┼────┼────┤ ╠════╬════╬════╣ ├─┼┤  ╠═╬╣  ╟─╫╢  ╞═╪╡ │ └──┴──┘ ╰──╯╰──╯  │▒"
echo "│    │    │    │ ║    ║    ║    ║ │ ││  ║ ║║  ║ ║║  │ ││ └───────────────────┘▒"
echo "└────┴────┴────┘ ╚════╩════╩════╝ └─┴┘  ╚═╩╝  ╙─╨╜  ╘═╧╛  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
echo "█ ▓ ▒ ░ ▄ ▀ ▐ ▌ ● ═ ║ ╔ ╦ ╗ ╚ ╩ ╝ ■ ▬ ▲ ▼ ◄ ►   │┃─ ━┌ ┐└ ┘┏ ┓┗ ┛┤├ ┼╭ ╮╯╰"
echo "┌┼└┼ (┌ ┼ and └ ┼) ─▶▷▸▹►▻─◀◁◂◃◄◅─▼▽▾▿▲△▴▵"
echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating Linux VT 16 color palet $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
sleep_key

vt_color_palet ()
{
    echo "# /sys/module/vt/parameters/"

    Color_names=""def_bla" "def_red" "def_gre" "def_yel" "def_blu" "def_mag" "def_cya" "def_whi""
    echo "$Color_names"
    Color_arr=("black--" "red----" "green--" "yellow-" "blue---" "magenta" "cyan---" "white--")
(
    tput setaf 4
    tput setab 7
    echo -e "                             Normal                            \033[0m"
        tput sgr0
        for m in 0 1 2 3 4 5 6 7
        do
            tput setaf $m
            echo -n ${Color_arr[$m]}" "
        done
    echo -e "\033[0m"

table=$(
    cat /sys/module/vt/parameters/default_red \
        /sys/module/vt/parameters/default_grn \
        /sys/module/vt/parameters/default_blu | tr "," "\t"
        )
     echo "$table" | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}'
)
(
    tput setaf 7
    tput setab 4
    echo -e "                             Bright                            \033[0m"


        tput bold
        for m in 0 1 2 3 4 5 6 7
        do
            tput setaf $m
            echo -n ${Color_arr[$m]}" "
        done
    echo -e "\033[0m"
table=$(
    tput sgr0
    cat /sys/module/vt/parameters/default_red \
        /sys/module/vt/parameters/default_grn \
        /sys/module/vt/parameters/default_blu | tr "," "\t"
        )
     echo "$table" | awk '{print $9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14"\t"$15"\t"$16}'
)

}
vt_color_palet
echo
cat << 'EOF'
So we have 16 basic registers for colors.
Named: red, green,,, ; bold red, bold green,,,
( I think more.. but for.. professionals make it for us as easy as trouble )
https://stackoverflow.com/questions/27159322/rgb-values-of-the-colors-in-the-ansi-extended-colors-index-17-255
In linux terminal/console "Bold" - works as bright/light, but in fact name of
color is only abstract address /as langages/ to register holds values for color
and they do not even have to be sub-branded.
#------------------------
Exaple of ansi escape sequences to set palet for linux vt:
First 16 - [0;30m - [1;37m
                                                     #brown
                                                     #yellow
	             #black     #red       #green     #Orange    #blue      #magenta   #cyan     #(S) white
	echo -ne "\e]P0000000\e]P17F0000\e]P2008000\e]P3FF4600\e]P41010FF\e]P5BF00BF\e]P600CDCD\e]P7A0A0A0"
	             #L black   #L red     #L green   #L yellow  #L blue    #L Cream   #S Blue    #L white
	echo -ne "\e]P8404040\e]P9C41414\e]PA3CFF00\e]PBE2E200\e]PC4141FF\e]PDFFC8C8\e]PE9696FF\e]PFFFFFFF"
	# get rid of artifacts
	clear
# Reset_palet () { echo -n '\033]R' ;}
#------------------------
# Regular #Yellow in linux konsole values is more like #Brown

"xterm"s - Next 16 - [0;90m - [1;97 
High Iintense - Bold High Iintense  - next palet

# The variations of TERMs and ANSI combinations... so standards become a lack of standard
# { "A" - Normal} { L - "B"old } { I - Intese } { F - Faint }-- H HL HI HF

# If you work with small fonts to have a plenty place.. is no room for extra
# Bold.. More bright color is actually more active pixels - "B"old due to the
# technique of creating colors on the screen.. ( rgb - no rgb/w/l...)
# The resulting mixture of red, green and blue is not only perceived by humans as white light...
# Of course, until the leds are lying side by side and they have dimensions that are meaningful to our senses
# In the konsole terminal program, we have a switch to draw in bold/light
# by bold font on a GUI
EOF

echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating Ansi 16 table color palet $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
sleep_key
Ansi_16_table ()
{
echo -e "┌─────────────────────────┬─────────────────────────┬────────────────┐"
echo -e "│   A   Regular Colors    │  B  Bold/Bright/Ligt    │     Sample     │"
echo -e "├────────────┬────────────┼────────────┬────────────┼────────────────┤"
echo -e "│   Code     │    Name    │   Code     │    Name    │ # A Value  # B │"
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;30m │   Black    │ \033[1;30m │   LBlack   │";echo -e '\033[0;30m 000000█\033[1;30m 000000█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;31m │   Red      │ \033[1;31m │   LRed     │";echo -e '\033[0;31m 7F0000█\033[1;31m C41414█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;32m │   Green    │ \033[1;32m │   LGreen   │";echo -e '\033[0;32m 008000█\033[1;32m 3CFF00█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;33m │   Yellow   │ \033[1;33m │   LYellow  │";echo -e '\033[0;33m FF4600█\033[1;33m E2E200█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;34m │   Blue     │ \033[1;34m │   LBlue    │";echo -e '\033[0;34m 1010FF█\033[1;34m 4141FF█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;35m │   Purple   │ \033[1;35m │   LPurple  │";echo -e '\033[0;35m BF00BF█\033[1;35m FFC8C8█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;36m │   Cyan     │ \033[1;36m │   LCyan    │";echo -e '\033[0;36m 00CDCD█\033[1;36m 9696FF█\033[0m│'
echo -e "├────────────┼────────────┼────────────┼────────────┼────────────────┤"
echo -n "│ \033[0;37m │   White    │ \033[1;37m │   LWhite   │";echo -e '\033[0;37m A0A0A0█\033[1;37m FFFFFF█\033[0m│'

echo -e "└────────────┴────────────┴────────────┴────────────┴────────────────┘"

echo -e "╔═════════════════════════╦═════════════════════════╦════════════════╗"
echo -e "║   HA   Regular Colors   ║  HB Bold/Bright/Ligt    ║     Sample     ║"
echo -e "╠════════════╦════════════╬════════════╦════════════╬════════════════╣"
echo -e "║   Code     ║    Name    ║   Code     ║    Name    ║ # A Value  # B ║"
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;90m ║   HBlack   ║ \033[1;90m ║   HLBlack  ║";echo -e '\033[0;90m 000000█\033[1;90m 000000█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;91m ║   HRed     ║ \033[1;91m ║   HLRed    ║";echo -e '\033[0;91m 7F0000█\033[1;91m C41414█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;92m ║   HGreen   ║ \033[1;92m ║   HLGreen  ║";echo -e '\033[0;92m 008000█\033[1;92m 3CFF00█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;93m ║   HYellow  ║ \033[1;93m ║   HLYellow ║";echo -e '\033[0;93m FF4600█\033[1;93m E2E200█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;94m ║   HBlue    ║ \033[1;94m ║   HLBlue   ║";echo -e '\033[0;94m 1010FF█\033[1;94m 4141FF█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;95m ║   HPurple  ║ \033[1;95m ║   HLPurple ║";echo -e '\033[0;95m BF00BF█\033[1;95m FFC8C8█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;96m ║   HCyan    ║ \033[1;96m ║   HLCyan   ║";echo -e '\033[0;96m 00CDCD█\033[1;96m 9696FF█\033[0m║'
echo -e "╠════════════╬════════════╬════════════╬════════════╬════════════════╣"
echo -n "║ \033[0;97m ║   HWhite   ║ \033[1;97m ║   HLWhite  ║";echo -e '\033[0;97m A0A0A0█\033[1;97m FFFFFF█\033[0m║'

echo -e "╚════════════╩════════════╩════════════╩════════════╩════════════════╝"

}
Ansi_16_table

echo "$Blue"
MESSAGE="$Green[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating ANSI color scheme script featuring Space Invaders $Reset$Green ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
sleep_key
# ANSI color scheme script featuring Space Invaders
#
# Original: http://crunchbang.org/forums/viewtopic.php?pid=126921%23p126921#p126921
# Modified by lolilolicon
#

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'

cat << EOF

 $f1  ▀▄   ▄▀     $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4  ▀▄   ▄▀     $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
 $f1 ▄█▀███▀█▄    $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4 ▄█▀███▀█▄    $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
 $f1█▀███████▀█   $f2▀▀███▀▀███▀▀   $f3▀█▀██▀█▀   $f4█▀███████▀█   $f5▀▀███▀▀███▀▀   $f6▀█▀██▀█▀$rst
 $f1▀ ▀▄▄ ▄▄▀ ▀   $f2 ▀█▄ ▀▀ ▄█▀    $f3▀▄    ▄▀   $f4▀ ▀▄▄ ▄▄▀ ▀   $f5 ▀█▄ ▀▀ ▄█▀    $f6▀▄    ▄▀$rst

 $bld$f1▄ ▀▄   ▄▀ ▄   $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4▄ ▀▄   ▄▀ ▄   $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
 $bld$f1█▄█▀███▀█▄█   $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4█▄█▀███▀█▄█   $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
 $bld$f1▀█████████▀   $f2▀▀▀██▀▀██▀▀▀   $f3▀▀█▀▀█▀▀   $f4▀█████████▀   $f5▀▀▀██▀▀██▀▀▀   $f6▀▀█▀▀█▀▀$rst
 $bld$f1 ▄▀     ▀▄    $f2▄▄▀▀ ▀▀ ▀▀▄▄   $f3▄▀▄▀▀▄▀▄   $f4 ▄▀     ▀▄    $f5▄▄▀▀ ▀▀ ▀▀▄▄   $f6▄▀▄▀▀▄▀▄$rst


                                     $f7▌$rst

                                   $f7▌$rst

                              $f7    ▄█▄    $rst
                              $f7▄█████████▄$rst
                              $f7▀▀▀▀▀▀▀▀▀▀▀$rst

EOF




}
color_16 () {
    # prints a color table of 8fg * 2 states (regular/bold)

    printf " Table A8 B8 for 16 - colors registers terminal escape$Reset sequences.$Reset\n"
	
	echo "╔══════╦══════════════════════════════════════════════════════════════════════════╗"
	printf "\033[0m""║   A F║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[0;${fg};2m [0;${fg};2m"
	done
	printf " ║\n\033[0m""║   A N║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[0;${fg}m [0;${fg}m  "
	done
	printf " ║\n\033[0m""║   B N║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[0;${fg};1m [0;${fg};1m"
	done
	printf " ║\n\033[0m""║   C N║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[0;${fg}m [0;${fg}m  "
	done
	printf " ║\n\033[0m""║   C F║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[0;${fg};2m [0;${fg};2m"
	done
	
	
	
	
	printf " ║\n\033[0m""║ B A F║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[1;${fg};2m [1;${fg};2m"
	done
	printf " ║\n\033[0m""║ B C F║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[1;${fg};2m [1;${fg};2m"
	done
	printf " ║\n\033[0m""║   B N║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[0;${fg};1m [0;${fg};1m"
	done
	printf " ║\n\033[0m""║ B A L║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[1;${fg};1m [1;${fg};1m"
	done	
	
	printf " ║\n\033[0m""║ B C L║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[1;${fg};1m [1;${fg};1m"
	done
	
	
	
	printf " ║\n\033[0m""║   C L║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[0;${fg};1m [0;${fg};1m"
	done
	
	
	
	
	
	
	
	
	
	echo -e "\033[0m ║"
	
	echo "╚══════╩══════════════════════════════════════════════════════════════════════════╝"
	echo -n  terminology?
	printf " ║\n\033[0m""║ B A F║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[1;${fg};2m [1;${fg};2m"
	done
	printf " ║\n\033[0m""║ B B F║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[1;${fg};2m [1;${fg};2m"
	done
	printf " ║\n\033[0m""║ B A L║ "
	for((fg=30;fg<=37;fg++))
	do
		printf "\033[1;${fg};1m [1;${fg};1m"
	done	
	printf " ║\n\033[0m""║ B B L║ "
	for((fg=90;fg<=97;fg++))
	do
		printf "\033[1;${fg};1m [1;${fg};1m"
	done
	echo -e "\033[0m ║"
	
	
}

Unicode_characters ()
{
echo "$Green"
MESSAGE="$Blue[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating the Unicode characters $Reset$Blue ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
sleep_key
fast_chr() {
    local __octal
    local __char
    printf -v __octal '%03o' $1
    printf -v __char \\$__octal
    REPLY=$__char
}

function unichr {
    local c=$1    # Ordinal of char
    local l=0    # Byte ctr
    local o=63    # Ceiling
    local p=128    # Accum. bits
    local s=''    # Output string

    (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

    while (( c > o )); do
        fast_chr $(( t = 0x80 | c & 0x3f ))
        s="$REPLY$s"
        (( c >>= 6, l++, p += o+1, o>>=1 ))
    done

    fast_chr $(( t = p | c ))
    echo -n "$REPLY$s"
}

## test harness
for (( i=0x2500; i<0x2600; i++ )); do
    unichr $i
done
}

bar_color_table ()
{
echo "$Green"
MESSAGE="$Blue[ $(( Nr+=1 )). $Red Bar color table $Reset$Blue ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
read -r -N1 -s -p "$Magenta Bar color table: Press key: continue $Reset" Sleep_key
echo

(
printf '\e[%s;2m██' {30..37} 0; echo
printf '\e[%sm██' {30..37} 0; echo
printf '\e[%s;1m██' {30..37} 0; echo
echo
printf '\e[%s;2m  ' {40..47} 0; echo
printf '\e[%sm  ' {40..47} 0; echo
printf '\e[%s;1m  ' {40..47} 0; echo
printf '\e[%s;1m  ' {40..47} 0; echo
echo
printf '\e[%s;2m██' {30..37} 0; echo
printf '\e[%sm██' {30..37} 0; echo
printf '\e[%s;1m██' {30..37} 0; echo
echo "$Reset"
)

}

tput_color_table ()
{
   tput setaf 0
   echo "$Bold"
   for i in $(seq 0 $(tput colors))
   do
     tput setab $i
     printf %4d $i
   done

   echo
   tput sgr0 # not always work? terminology?
   echo ": :$Reset"
 }


True_color ()
{

echo "$Green"
MESSAGE="$Blue[ $(( Nr+=1 )). $Red$Blink$Underline Demonstrating the True color test $Reset$Blue ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
read -r -N1 -s -p "$Magenta True_color test: Press key: continue $Reset" Sleep_key
echo

awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf " |\n";
}'

}

function colorgrid ()
{
echo "$Reset"
	echo "$Green"
	MESSAGE="[ $(( Nr+=1 )). Colorgrid {256} $Reset$Green ]"$Reset
	Bar "$MESSAGE"
echo "$Reset"
read -r -N1 -s -p "$Magenta Colorgrid {256} : Press key: continue $Reset" Sleep_key
echo "$Reset"
    iter=16
    while [ $iter -lt 52 ]
    do
        second=$[$iter+36]
        third=$[$second+36]
        four=$[$third+36]
        five=$[$four+36]
        six=$[$five+36]
        seven=$[$six+36]
        if [ $seven -gt 250 ];then seven=$[$seven-251]; fi

        echo -en "\033[38;5;$(echo $iter)m█ "
        printf "%03d" $iter
        echo -en "   \033[38;5;$(echo $second)m█ "
        printf "%03d" $second
        echo -en "   \033[38;5;$(echo $third)m█ "
        printf "%03d" $third
        echo -en "   \033[38;5;$(echo $four)m█ "
        printf "%03d" $four
        echo -en "   \033[38;5;$(echo $five)m█ "
        printf "%03d" $five
        echo -en "   \033[38;5;$(echo $six)m█ "
        printf "%03d" $six
        echo -en "   \033[38;5;$(echo $seven)m█ "
        printf "%03d" $seven

        iter=$[$iter+1]
        printf '\r\n'
    done
for i in $(seq 0 255)
do
    printf '\033[1;38;5;%dmC%d██' "$i" "$i"
done
}

Daniel_Crisman()
{
echo "$Yellow"
MESSAGE="[ $(( Nr+=1 )). $Blink$Underline ISO 8-color pallette - *3 intense $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"

read -r -N1 -s -p "$Magenta ISO 8-color pallette - *3 intense: Press key: continue $Reset" Sleep_key
echo

T='gYw'   # The test text

echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";

for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
           '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
           '  36m' '1;36m' '  37m' '1;37m';
  do FG=${FGs// /}
  echo -en " $FGs \033[$FG  $T  "
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
  done
  echo;
done
echo
}

Color.bsh ()
{
echo "$LRed"
MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline color.bsh $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"
read -r -N1 -s -p "$Magenta color.bsh test: Press key: continue $Reset" Sleep_key
echo

bash color.bsh
echo "text you want colored red" | bash color.bsh 196
}


# display ANSI colours and test bold/blink attributes
# orginates from Eterm distribution

colortools-system ()
{
echo "$LRed"
MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline colortools-system $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"

read -r -N1 -s -p "$Magenta colortools-system: Press key: continue $Reset" Sleep_key

ESC=$'\x1b'
CSI="${ESC}["
RST="${CSI}m"

echo ""; echo "${RST}"
echo "       40      41      42      43      44      45      46      47      49"
for fg in 30 31 32 33 34 35 36 37 39 90 91 92 93 94 95 96 97
do
    l1="$fg  ";
    l2="    ";
    for bg in 40 41 42 43 44 45 46 47 49
    do
	l1="${l1}${CSI}${fg};${bg}m Normal ${RST}"
	l2="${l2}${CSI}${fg};${bg};1m Bold   ${RST}"
    done
    echo "$l1"
    echo "$l2"
done
}

another_test ()
{
echo "$Yellow"
MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline another test $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"

read -r -N1 -s -p "$Magenta another test: Press key: continue $Reset" Sleep_key
echo

for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""
}

print_colors()
{
echo "$Yellow"
MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline print colors $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"

read -r -N1 -s -p "$Magenta print_colors: Press key: continue $Reset" Sleep_key
 echo
 # Print standard colors.
bolds=( 0 1 )
fgs=( 3{0..7} )
bgs=( 4{0..8} )

# Print vivid colors.
bolds=( 0 ) # Bold vivid is the same as bold normal.
fgs=( 9{0..7} )
bgs=( 10{0..8} )

# Print column headers.
  printf "%-4s  " '' ${bgs[@]}
  echo
  # Print rows.
  for bold in ${bolds[@]}; do
    for fg in ${fgs[@]}; do
      # Print row header
      printf "%s;%s  " $bold $fg
      # Print cells.
      for bg in ${bgs[@]}; do
        # Print cell.
        printf "\e[%s;%s;%sm%s\e[0m  " $bold $fg $bg "text"
      done
      echo
    done
  done

}


ansi-test()
{

echo "$Yellow"
MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline ansi-test $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"

read -r -N1 -s -p "$Magenta ansi-test: Press key: continue $Reset" Sleep_key

      echo; echo "ansi-test"
      for a in 0 1 4 5 7; do
              echo "a=$a "
              for (( f=0; f<=9; f++ )) ; do
                      for (( b=0; b<=9; b++ )) ; do
                              #echo -ne "f=$f b=$b" 
                              echo -ne "\e[${a};3${f};4${b}m"
                              echo -ne "\\\e[${a};3${f};4${b}m"
                              echo -ne "\e[0m "
                      done
              echo
              done
              echo
      read -r -N1 -s -p ": Press key: continue $Reset" Sleep_key
      done
      echo
}

Mandelbrot ()
{
#!/usr/bin/env ksh
echo "$Yellow"
MESSAGE="$Yellow[ $(( Nr+=1 )). $Blink$Underline Charles Cooke\'s 16-color Mandelbrot $Reset$Yellow ]$Reset"
Bar "$MESSAGE"
echo "$Reset"

read -r -N1 -s -p "$Magenta Mandelbrot: Press key: continue $Reset" Sleep_key
echo "# Charles Cooke's 16-color Mandelbrot"
# http://earth.gkhs.net/ccooke/shell.html
# Combined Bash/ksh93 flavors by Dan Douglas (ormaaj)

function doBash {
	typeset P Q X Y a b c i v x y 
	for ((P=10**8,Q=P/100,X=320*Q/cols,Y=210*Q/lines,y=-105*Q,v=-220*Q,x=v;y<105*Q;x=v,y+=Y)); do
		for ((;x<P;a=b=i=c=0,x+=X)); do
			for ((;a**2+b**2<4*P**2&&i++<99;a=((c=a)**2-b**2)/P+x,b=2*c*b/P+y)); do :
			done
			colorBox $((i<99?i%16:0))
		done
		echo
	done
}

function doKsh {
	integer i
	float a b c x=2.2 y=-1.05 X=3.2/cols Y=2.1/lines 
	while
		for ((a=b=i=0;(c=a)**2+b**2<=2&&i++<99&&(a=a**2-b**2+x,b=2*c*b+y);)); do :
		done
		. colorBox $((i<99?i%16:0))
		if ((x<1?!(x+=X):(y+=Y,x=-2.2))); then
			print
			((y<1.05)) 
		fi
		do :
	done
}

function colorBox {
	(($1==lastclr)) || printf %s "${colrs[lastclr=$1]:=$(tput setaf "$1")}"
	printf '\u2588'
}

unset -v lastclr
((cols=$(tput cols)-1, lines=$(tput lines)))
typeset -a colrs
trap 'tput sgr0; echo' EXIT
${KSH_VERSION+. doKsh} ${BASH_VERSION+doBash}
}

Prepare_check_environment ()
{
	#if [ ! -t 0 ]
	#then :
	# script is executed outside terminal
	# execute the script inside a terminal window
	# gathering informations about terminal program
	if [ "$Selected" = '' ]
	then :
	
	Nr=-1
	if [[ "$0" == '/bin/bash' ]]
	then ${0}=''
	fi
	
	if   command -v konsole >/dev/null 2>&1
	then :
		list[Nr+=1]="konsole --hold -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v terminology >/dev/null 2>&1
	then :
		list[Nr+=1]="terminology --hold -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v gnome-terminal >/dev/null 2>&1
	then :
		list[Nr+=1]="gnome-terminal -e $0 $@"
		#exit $?
	fi
	if command -v xfce4-terminal >/dev/null 2>&1
	then :
		list[Nr+=1]="xfce4-terminal --hold -x /bin/bash $0 $@"
		#exit $?
	fi
	if command -v mate-terminal >/dev/null 2>&1
	then :
		list[Nr+=1]="mate-terminal -e ./color_info.sh"
		#exit $?
	fi
	if command -v lxterminal >/dev/null 2>&1
	then :
		list[Nr+=1]="lxterminal -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v terminator >/dev/null 2>&1
	then :
		list[Nr+=1]="terminator -e ./color_info.sh"
		#exit $?
	fi
	if command -v guake >/dev/null 2>&1
	then :
		list[Nr+=1]="guake -e ./color_info.sh"
		#exit $?
	fi
	if command -v urxvt >/dev/null 2>&1
	then :
		list[Nr+=1]="urxvt -hold -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v tilix >/dev/null 2>&1
	then :
		list[Nr+=1]="tilix -e /bin/bash $0 $@"
		#exit $?
	fi
    if command -v sakura >/dev/null 2>&1
	then :
		list[Nr+=1]="sakura -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v qterminal >/dev/null 2>&1
	then :
		list[Nr+=1]="qterminal -e /bin/bash $0 $@"
		#exit $?
	fi
    if command -v gtkiterm >/dev/null 2>&1
	then :
		list[Nr+=1]="gtkiterm -e /bin/bash $0 $@"
		#exit $?
	fi
    if command -v cool-retro-term >/dev/null 2>&1
	then :
		list[Nr+=1]="cool-retro-term -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v fbterm >/dev/null 2>&1
	then :
		list[Nr+=1]="fbterm /bin/bash $0 $@"
		#exit $?
	fi
	if command -v fbiterm >/dev/null 2>&1
	then :
		list[Nr+=1]="fbiterm /bin/bash $0 $@"
		#exit $?
	fi
	if command -v tilda >/dev/null 2>&1
	then :
		list[Nr+=1]="tilda -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v roxterm >/dev/null 2>&1
	then :
		list[Nr+=1]="roxterm -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v Eterm >/dev/null 2>&1
	then :
		list[Nr+=1]="Eterm -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v deepin-terminal >/dev/null 2>&1
	then :
		list[Nr+=1]="deepin-terminal -e /bin/bash $0 $@"
		#exit $?
	fi
	if command -v xiterm >/dev/null 2>&1
	then :
		list[Nr+=1]="xiterm -e ./color_info.sh"
		#exit $?
	fi
	if command -v xterm >/dev/null 2>&1
	then :
		list[Nr+=1]="xterm -hold -e /bin/bash $@"
		#exit $?
	fi
	
	if [ "${#list[@]}" = 0 ]
	then :
		echo "$Red Error: This script "$0" needs terminal, exit 2$Reset" >&2
		exit 2
	fi
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; export TMPDIR; fi
	workdir="${BASH_SOURCE%/*}"
	if [[ ! -d "$workdir" ]]; then workdir="$PWD"; fi;
	cd "$workdir"
	
	Select_list "$Magenta Select terminal interface: ( empty current)$Reset"
	
	export Selected
	Command=${Selected}
	echo "$Command"
	if [ "$Command" != '' ]
	then :
	$Command
	exit
	fi
	
	fi
	
	
comment=<<EOF
The command chvt N makes /dev/ttyN the foreground terminal.
(The corresponding screen is created if it did not exist yet.
To get rid of unused VTs, use deallocvt )
The key combination (Ctrl-)LeftAlt-FN (with N in the range 1-12) usually has a similar effect.
You can find the virtual terminal you're currently on via the fgconsole command. This too requires sudo privileges to run.

EOF

}

Begin "$@"
