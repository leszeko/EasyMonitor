#!/bin/bash
# top_info.sh script
# # !!! ###  NOTE: play FIXME! script ###
echo " Read or edit it !"
echo " To edit multiple documents is good to use KATE’S TAB BAR PLUGINS"
echo " For global change in all themes is good to use kfilereplace"
echo " Tilde is a very nice text editor for the console/terminal"
# Call this script with at least 10 parameters, for example
# ./scriptname 1 2 3 4 5 6 7 8 9 test
# . ./top_info.sh 1 2 3 4 5 6 7 8 9 test (source)
# bash ./top_info.sh 1 2 3 4 5 6 7 8 9 test
#!/bin/bash -vx
# bash -x <scriptname>
# Graphical debugger for bash
# http://sourceforge.net/projects/basheclipse/
# https://sourceforge.net/projects/bashdb/
# http://www.rodericksmith.plus.com/outlines/manuals/bashdbOutline.html
# http://www.kdbg.org/
# https://www.gnu.org/software/ddd/
# ddd --debugger /usr/bin/bashdb -- {script name} {parameters}
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
# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
# http://invisible-island.net/xterm/ctlseqs/ctlseqs.html
# https://github.com/lhunath/scripts/tree/master/bashlib
# https://www.gnu.org/software/screen/manual/html_node/Virtual-Terminal.html#Virtual-Terminal
# http://bjh21.me.uk/all-escapes/all-escapes.txt
# https://unix.stackexchange.com/questions/8414/how-to-have-tail-f-show-colored-output
# abs-guide.pdf
comment=<<EOF
https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start
# What is the exact difference between a 'terminal', a 'shell', a 'tty' and a 'console'?
Quoted from Wikipedia

A computer terminal is an electronic or electromechanical hardware device that 
is used for entering data into, and displaying data from, a computer or a 
computing system. Early terminals were inexpensive devices but very slow 
compared to punched cards or paper tape for input, but as the technology 
improved and video displays were introduced, terminals pushed these older forms 
of interaction from the industry. A related development was timesharing systems, 
which evolved in parallel and made up for any inefficiencies of the user's 
typing ability with the ability to support multiple users on the same machine, 
each at their own terminal.
Quoted from wikipedia

A virtual console (VC) – also known as a virtual terminal (VT) – is a conceptual 
combination of the keyboard and display for a computer user interface. It is a 
feature of some operating systems such as UnixWare, Linux, and BSD, in which the 
system console of the computer can be used to switch between multiple virtual 
consoles to access unrelated user interfaces. Virtual consoles date back at 
least to Xenix in the 1980s.

From further discussion on the two articles, is it true that either of them can 
be divided into text terminal and graphical terminal?
As I understand from the articles, Terminal emulator and virtual 
console/terminal are different. Virtual console is a broader concept, including 
both text terminal and graphical terminal. Terminal emulator is just some 
emulator of text terminal running under graphical terminal?
#---------------
A (display) terminal is a piece of hardware which has a keyboard and display, 
and communicates with a host computer. The terminal is itself a small computer; 
an embedded system.

A terminal emulator is software running on a general-purpose machine which 
implements the behavior of some terminal.

Terminal emulators are not all graphical. They can be based on a text display 
mode. An example of this is the console in the Linux kernel.

Terminal emulators can also use terminal emulation themselves. An example of 
this is the GNU Screen program. It requires a terminal, but provides terminal 
emulation to programs running under it.

Terminal emulators can run in a host computer in order to provide a virtual 
terminal to access that host computer itself. The piece of software running no 
the host looks to that same host as an attached remote terminal. But terminal 
emulators can also be used to simply use the computer as a terminal to access 
some remote host. An example of this is, say, using an IBM 3270 emulator running 
under Windows on a PC to access a mainframe. It's an emulator because you're 
using a piece of software under Windows and not an actual 3270 on your desk. But 
you're not using that to access the Windows command line. Another example of 
this kind of terminal emulator is a serial communication package like Minicom, 
Hyper Terminal and so forth. Also, the popular PuTTY SSH client.
#
A. Under FreeBSD, Linux, or UNIX the virtual console (VC) allows a user to have 
multiple logins without using X windows GUI system. It is also known as virtual 
terminal (VT)

Usually in Linux, the first six virtual consoles provide a text terminal with a 
login prompt to a unix shell. The graphical X Window System starts in the 
seventh virtual console. To access 6 terminal press and hold [CTRL] + 
[ALT]+F{1,2,3,4,5,6}. For example press CTRL+Alt+F1 (or ALT+F1) to access the 
virtual console number 1.

Access X GUI system

To access X GUI system press CTRL+ALT+F7.


EOF
echo „” "#!1 ### ########## ###" #!FIXME ### ########## ###
	trap 'EXIT_S' EXIT # 0
	trap 'SIGHUP_S' SIGHUP # 1
	trap 'CTL_C' SIGINT # 2
	trap 'SIGQUIT_S' SIGQUIT # 3
	trap 'SIGTERM_S' SIGTERM # 15
	trap 'ERR_S ${LINENO} ${?}' ERR
	trap 'SIGWINCH_S' SIGWINCH
	#trap 'RETURN_S ${LINENO} ${$?}' RETURN
	#trap ':' SIGCHLD
	
	SIGWINCH_S ()
	{
	Get_View_port_size
	[ $Vcolumns -lt 80 ] && Terminal_size $Vlines 80
	sleep 0.1
	}
	
function ERR_S ()
{
        Script="${0##*/}"    # equals to script name
        Last_line="$1"       # argument 1: last line of error occurence
        Last_error="$2"      # argument 2: error code of last command
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

function RETURN_S ()
{
        Script="${0##*/}"    # equals to script name
        Last_line="$1"       # argument 1: last line of error occurence
        Last_error="$2"      # argument 2: error code of last command
# BASH_LINENO
# An array variable whose members are the line numbers in source files where
# each corresponding member of FUNCNAME was invoked. ${BASH_LINENO[$i]}
# is the line number in the source file (${BASH_SOURCE[$i+1]})
# where ${FUNCNAME[$i]} was called (or ${BASH_LINENO[$i-1]}
# if referenced within another shell function).
# Use LINENO to obtain the current line number.
echo "$Magenta
 Script                    : "${Script}"
 Last command              : "$BASH_COMMAND"
 BASH LINE NO              : "${BASH_LINENO[*]}"
 LINE NO                   : "${Last_line}"
 RETURN status of Last err : "${Last_error}"
"
# do additional processing: send email or SNMP trap, write result to database, etc.
}

Trace ()
	{
	echo "Press CTRL+C to proceed."
	trap "pkill -f 'sleep 1h'" INT
	trap "set +x ; sleep 1h ; set -x" DEBUG
	set -x
	}
	
function trap_variable ()
{
declare -t VARIABLE=value

trap "echo VARIABLE is being used here." DEBUG

# rest of the script
}

function mouse_signals ()
{
# If you just want to run bash command in xterm on mouse click (or wheel event)
# you can try this example:
echo -e "\e[?1000h"
while read -n 6; do echo hellowworld; done
}

function trap_signals ()
{
# Use trap to capture signals like this:
i=-1;while((++i<33));
do
    trap "echo $i >> log.txt" $i;
done
# And close the terminal by force.
# The content in log.txt
# You can also disable eof generally in bash:
# set -o ignoreeof
# So export IGNOREEOF=42 and you'll have to press Ctrl+D forty-two times before
# it actually quits your shell.
}

comment=<<EOF
Linux Signals are:
trap [-lp] [[arg] sigspec]
trap -l It's the same output you can obtain running the kill -l command:

We set a trap to catch the SIGINT signal: it will just display the "SIGINT 
caught" message onscreen when given signal will be received by the shell. If we 
now use trap with the -p option, it will display the trap we just defined:

Signal Name	Number	Description

SIGHUP	1	Hangup (POSIX)

This signal indicates that someone has killed the controlling terminal. For 
instance, lets say our program runs in xterm or in gnome-terminal. When someone 
kills the terminal program, without killing applications running inside of 
terminal window, operating system sends SIGHUP to the program. Default handler 
for this signal will terminate your program.
Thanks to Mark Pettit for the tip.

SIGINT	2	Terminal interrupt (ANSI)
This is the signal that being sent to your application when it is running in a 
foreground in a terminal and someone presses CTRL-C. Default handler of this 
signal will quietly terminate your program.

SIGQUIT	3	Terminal quit (POSIX)
Again, according to documentation, this signal means “Quit from keyboard”. In 
reality I couldn’t find who sends this signal. I.e. you can only send it 
explicitly.

SIGILL	4	Illegal instruction (ANSI)
Illegal instruction signal. This is a exception signal, sent to your application 
by the operating system when it encounters an illegal instruction inside of your 
program. Something like this may happen when executable file of your program has 
been corrupted. Another option is when your program loads dynamic library that 
has been corrupted. Consider this as an exception of a kind, but the one that is 
very unlikely to happen.

SIGTRAP	5	Trace trap (POSIX)
Program received signal SIGTRAP, Trace/breakpoint trap.
Program received signal SIGTRAP, Trace/breakpoint trap.

SIGIOT	6	IOT Trap (4.2 BSD)
6) SIGABRT
Abort signal means you used used abort() API inside of your program. It is yet 
another method to terminate your program. abort() issues SIGABRT signal which in 
its term terminates your program (unless handled by your custom handler). It is 
up to you to decide whether you want to use abort() or not.

SIGBUS	7	BUS error (4.2 BSD)

SIGFPE	8	Floating point exception (ANSI)
Floating point exception. This is another exception signal, issued by operating 
system when your application caused an exception.

SIGKILL	9	Kill(can't be caught or ignored) (POSIX)

SIGUSR1	10	User defined signal 1 (POSIX)
Finally, SIGUSR1 and SIGUSR2 are two signals that have no predefined meaning and 
are left for your consideration. You may use these signals to synchronise your 
program with some other program or to communicate with it.

SIGSEGV	11	Invalid memory segment access (ANSI)
This is an exception signal as well. Operating system sends a program this 
signal when it tries to access memory that does not belong to it.

SIGUSR2	12	User defined signal 2 (POSIX)

SIGPIPE	13	Write on a pipe with no reader, Broken pipe (POSIX)
Broken pipe. As documentation states, this signal sent to your program when you 
try to write into pipe (another IPC) with no readers on the other side.

SIGALRM	14	Alarm clock (POSIX)
Alarm signal. Sent to your program using alarm() system call. The alarm() system 
call is basically a timer that allows you to receive SIGALRM in preconfigured 
number of seconds. This can be handy, although there are more accurate timer API 
out there.

SIGTERM	15	Termination (ANSI) - software termination signal
This signal tells your program to terminate itself. Consider this as a signal to 
cleanly shut down while SIGKILL is an abnormal termination signal.


SIGSTKFLT	16	Stack fault

SIGCHLD	17	Child process has stopped or exited, changed (POSIX)
Tells you that a child process of your program has stopped or terminated. This 
is handy when you wish to synchronize your process with a process with its 
child.

SIGCONT	18	Continue executing, if stopped (POSIX)
SIGSTOP	19	Stop executing(can't be caught or ignored) (POSIX)
SIGTSTP	20	Terminal stop signal (POSIX)
SIGTTIN	21	Background process trying to read, from TTY (POSIX)
SIGTTOU	22	Background process trying to write, to TTY (POSIX)
SIGURG	23	Urgent condition on socket (4.2 BSD)
SIGXCPU	24	CPU limit exceeded (4.2 BSD)
SIGXFSZ	25	File size limit exceeded (4.2 BSD)
SIGVTALRM	26	Virtual alarm clock (4.2 BSD)
SIGPROF	27	Profiling alarm clock (4.2 BSD)
SIGWINCH	28	Window size change (4.3 BSD, Sun)
SIGIO	29	I/O now possible (4.2 BSD)
SIGPWR	30	Power failure restart (System V)

man 7 signal will show you a complete table with a brief summary of the meaning
of each signal

##############
Pseudo-signals

Trap can be set not only for signals which allows 
the script to respond but also to what we can call "pseudo-signals". They are 
not technically signals, but correspond to certain situations that can be 
specified:

EXIT
When EXIT is specified in a trap, the command of the trap will be execute on 
exit from the shell.

ERR
This will cause the argument of the trap to be executed when a command returns a 
non-zero exit status, with some exceptions (the same of the shell errexit 
option): the command must not be part of a while or until loop; it must not be 
part of an if construct, nor part of a && or || list, and its value must not be 
inverted by using the ! operator.

DEBUG
This will cause the argument of the trap to be executed before every simple 
command, for, case or select commands, and before the first command in shell 
functions

RETURN
The argument of the trap is executed after a function or a script sourced
by using source or the . command.

##############
Real-time signals

Linux supports real-time signals as originally defined in the POSIX.1b real-time 
extensions (and now included in POSIX.1-2001). The range of supported real-time 
signals is defined by the macros SIGRTMIN and SIGRTMAX. POSIX.1-2001 requires 
that an implementation support at least POSIX_RTSIG_MAX(8) real-time signals.

The Linux kernel supports a range of 32 different real-time signals, numbered 33 
to 64. However, the glibc POSIX threads implementation internally uses two (for 
NPTL) or three (for LinuxThreads) real-time signals (see pthreads(7)), and 
adjusts the value of SIGRTMIN suitably (to 34 or 35). Because the range of 
available real-time signals varies according to the glibc threading 
implementation (and this variation can occur at run time according to the 
available kernel and glibc), and indeed the range of real-time signals varies 
across UNIX systems, programs should never refer to real-time signals using 
hard-coded numbers, but instead should always refer to real-time signals using 
the notation SIGRTMIN+n, and include suitable (run-time) checks that SIGRTMIN+n 
does not exceed SIGRTMAX.

The POSIX specification defines so called real-time signals and Linux supports 
it. They are to be used by the programmer and have no predefined meaning. Two 
macros are available: SIGRTMIN and SIGRTMAX that tells the range of these 
signals. You can use one using SIGRTMIN+n where n is some number. Never hard 
code their numbers, real time signals are used by threading library (both 
LinuxThreads and NTPL), so they adjust SIGRTMIN at run time.
Whats the difference between RT signals and standard signals? There are couple:
More than one RT signal can be queued for the process if it has the signal 
blocked while someone sends it. In standard signals only one of a given type is 
queued, the rest is ignored.
Order of delivery of RT signal is guaranteed to be the same as the sending 
order.
PID and UID of sending process is written to si_pid and si_uid fields of 
siginfo_t. For more information see section about Real time signals in 
signal(7).
EOF

# kill -l
# cat /usr/include/sys/signal.h|more
comment=<<EOF
{
I had a slightly different use case, and wanted to leave the solution here
, as Google led me to this topic.
You can keep running a command, and allow the user to restart it with one CTRL+C
and kill it with double CTRL+C in the following manner:

trap_ctrlC() {
    echo "Press CTRL-C again to kill. Restarting in 2 second"
    sleep 2 || exit 1
}

trap trap_ctrlC SIGINT SIGTERM
while true; do
    ... your stuff here ...
done
EOF

#    "rgb"   : "256   -color pallette – 6*6*6 RGB subset"
#    "gray"  : "256   -color pallette – gray scale subset"
#    "sys"   : "256   -color pallette – ansi color subset"
#    "iso"   : "ISO 8 -color pallette - *intense "
 ### "iso"   : "ISO 16-color pallette - *intensity (not widely supported)
#    "rgb888": "True-color RGB mode"
comment=<<EOF
echo " Font Effects"
echo "$Stop_wrap"
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
echo "$Start_wrap"

# alter the default colors to make them a bit prettier
# https://terminal.sexy
if [ "$TERM" = "linux" ]
then : # pallet almost "orginal #brown altered to orange"
	             #black     #red       #green     #brown     #blue      #magenta   #cyan     #(S) white
	echo -ne "\e]P0000000\e]P17F0000\e]P2008000\e]P3FF4600\e]P40000E0\e]P5BF00BF\e]P600CDCD\e]P7A0A0A0"
	             #L black   #L red     #L green   #L yellow  #L blue    #L magenta #L cyan    #L white
	echo -ne "\e]P8404040\e]P9C41414\e]PA3CFF00\e]PBE2E200\e]PC4141FF\e]PDFF00FF\e]PE00FFFF\e]PFFFFFFF"
	# clear #for background artifacting
	clear
	
fi

# set the default text color. this only works in tty (eg $TERM == "linux"), not pts (eg $TERM == "xterm")
setterm -background black -foreground green -store

EOF

comment=<<EOF
##############
Just for imformation.

Font setings effects !
https://en.wikipedia.org/wiki/Linux_console


Apperantly the nvidia 340xx driver does not support KMS 
Using HOOK for loading v86d (framebuffer) before consolefont did not work either
to use the dirty trick to set the font every time at shell startup
and to make setfont not complain about that is not a TTY I had
to do a check if it is on TTY like that :

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
	Lat2-Terminus16
fi

setfont Lat2-Terminus16

If the fonts seems to not change on boot, or change only temporarily
it is most likely that they got reset when graphics driver was initialized
and console was switched to framebuffer.
To avoid this, load your graphics driver earlier.
See for example KMS#Early_KMS_start or other ways to setup your
framebuffer before /etc/vconsole.conf gets applied.
https://wiki.archlinux.org/index.php/Fonts#Examples_2
https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start

https://alexandre.deverteuil.net/pages/consolefonts/

Followed your recommendation, and added MODULES="i915"
to my /etc/mkinitcpio.conf file...  it works perfectly now.
&
mkinitrd

https://wiki.archlinux.org/index.php/Fbterm
https://wiki.archlinux.org/index.php/KMSCON

CONSOLEFONT="ter-v12n"

This is a small font but still readable :)

Therefore you need to emerge media-fonts/terminus-font ...

#############
Just for imformation.
After restore

KDE Hangup... lodading!
How do I restore my KDE desktop to default?

mv ~/.kde ~/.kde.old

.kde doesn’t exist. there is

mv ~/.kde4 ~/.kde4.old
or
mv ~/.kde4/share/config ~/.kde4/share/config.old

.kde4 (contain a lot of different config for apps, etc)
.config/plasma-org.kde.plasma.desktop-appletsrc
(for all panel, widget etc)
.config/plasmarc (for theme and wallpaper settings)
.config/plasmashellrc (for some other settings)

and maybe also some other config file in .config.
(for dolphin, and all other apps)
deleting those file like as @gohlip said will reset to default plasma settings 
(so not the default manjaro plasma)
to have the default manjaro plasma settings, it need to install the 
manjaro-kde-settings package and to copy the different desired config file from 
/etc/skel to the home directory

Your user have a wrong persion in config files...

chmod -R $user /home/$user

Clen temp directories...

/tmp
/var/temp

EOF

################## Variables for color terminal
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
Set_origin_to_absoluteEsc=""$'\033[?6l'""
Stop_wrap=""$'\033[?7l'""
Start_wrap=""$'\033[?7h'""

# line is truncated to window size and last char is printed at end
# setterm --linewrap [on|off]
# setterm --resize
# --resize
#              Reset terminal size by assessing maximum row and column.  This
#              is useful when actual geometry and kernel terminal driver are
#              not in sync.  Most notable use case is with serial consoles,
#              that do not use ioctl(3) but just byte streams and breaks.

# You might also use xterm control sequences, but seems to not all terminals programs relocate the terminal window.

# printf '\e[8;24;80t' # resize to 80x24
# printf '\e[3;0;0t' # move to top left corner
# printf '\e[9;1t' # maximize
# printf '\e[9;2t' # maximize vertically
# printf '\e[9;3t' # maximize horizontally
# But with other terminal emulator programs..
# Place a short and wide terminal window on upper left-hand side of the display:
# xfce4-terminal --geometry 140x20+50+50
# gnome-terminal --geometry 130x30+30+42
# terminator --geometry 1400x800+300+200
# xterm -geometry 93x31+100+350
# https://docs.kde.org/stable5/en/applications/konsole/index.html
# qdbus org.kde.konsole $KONSOLE_DBUS_WINDOW 
# will display methods for controlling the current window.
# konsole --help-kde but + --nofork --geometry is in pixel coordinates
# --geometry <XxY+XPos+YPos>
# konsole --nofork --geometry=280x325-0+220
# konsole --nofork --geometry=380x200+100+20
# konsole --nofork --geometry +300+200
# konsole --new-tab 

# If you are using bash, you can try this. checkwinsize attribute
# If set, Bash checks the window size after each command and, if necessary
# updates the values of LINES and COLUMNS."
# shopt -s checkwinsize - set new size after resizing window -s Enable -u Disable
# LINES Used by the select command to determine the column length for printing selection lists.
# echo $LINES $COLUMNS - to get size
# resize &>/dev/null; resize -s  - no work with konsole program
# read height width < <(stty size)
# stty columns 20 - shrinks or extend the area of input?
# echo -e "\e[8;2;20t" shrinks or extend the used area of the terminal-window 
# correctly, but leaves the window-size unchanged.
# so seems that you can print line beyond of window margins

# read height width < <(stty size)
# cal | while read line ; do printf "%${width}s" "$line" ; done
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
	if [[ ! -d "$workdir" ]]; then workdir="$PWD"; fi
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
	
	# tilde nice terminal text editor
}

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

# Color       #define       Value       RGB
# black     COLOR_BLACK       0     0, 0, 0
# red       COLOR_RED         1     max,0,0
# green     COLOR_GREEN       2     0,max,0
# yellow    COLOR_YELLOW      3     max,max,0
# blue      COLOR_BLUE        4     0,0,max
# magenta   COLOR_MAGENTA     5     max,0,max
# cyan      COLOR_CYAN        6     0,max,max
# white     COLOR_WHITE       7     max,max,max
# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes/269195
# https://ttssh2.osdn.jp/manual/en/about/ctrlseq.html


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
)
printf '\e[48;5;%dm ' {0..255}; printf '\e[0m \n'

for r in {200..255..5}; do fb=4;g=1;b=1;printf '\e[0;%s8;2;%s;%s;%sm   ' "$fb" "$r" "$g" "$b"; done; echo

Fix ()
{
if [[ "$TERM" != *xterm* ]]
then :
	# "ISO 8-color pallette
	#       "$Bold$Yellow"                "$Bold$Blue"             "$$Bold$Magenta"
	 Orange=""$'\033[1;31m'""  SmoothBlue=""$'\033[1;34m'""  Cream=""$'\033[1;35m'""
	LOrange=""$'\033[1;31m'"" LSmoothBlue=""$'\033[1;34m'"" LCream=""$'\033[1;35m'""
	     # $Bold
	LRed=""$'\033[1;31m'""    LGreen=""$'\033[1;32m'"" Yellow=""$'\033[1;33m'""
	LBlue=""$'\033[1;34m'"" LMagenta=""$'\033[1;35m'""  LCyan=""$'\033[1;36m'""
	LYellow=""$'\033[1;33m'""
	Blink=""
	echo -n "$Cursor_r_block"
else :	       # Yellow="LYellow"        "$Bold$Yellow"
	Yellow=""$'\033[0;93m'"" LYellow=""$'\033[1;93m'""
	LRed=""$'\033[1;38;5;196m'""
	echo -n "$Cursor_r_block"
fi
}

Fix

Nline=""$'\n'"" Beep=""$'\a'"" Back=""$'\b'"" Creturn=""$'\r'"" Ctabh=""$'\t'"" Ctabv=""$'\v'"" Formfeed=""$'\f'""

EraseR=""$'\033[K'"" EraseL=""$'\033[1K'"" ClearL=""$'\033[2K'"" ReturnClear=""$'\033[G\033[2K'""
EraseD=""$'\033[J'"" EraseU=""$'\033[1J'"" ClearS=""$'\033[2J'"" HomeClear=""$'\033[H\033[2J'"" # move to 0,0

SavePv=""$'\0337'"" RestorePv=""$'\0338'"" Reset_term=""$'\033c'""   Visual_Bell=""$'\033g'""
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

# Terminals, PS1 prompts.. can override cursor appearance settings

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

# printf '\033[17;127?c' (the first parameter 17 gives you the software cursor
# without a hardware cursor, and the second parameter set to 127 makes it
# essentially inverse video). See above regarding terminal resets.

 # The cursor appearance is controlled by a "\033[?1;2;3c" escape sequence
# where 1, 2 and 3 are parameters described below. If you omit any of them,
# they will default to zeroes.
# Parameter 1 specifies cursor size

# (0=default, 1=invisible, 2=underline, ..., # 8=full block)
# + 16 if you want the software cursor to be applied
# + 32 if you want to always change the background color
# + 64 if you dislike having the background the same as the foreground.
# Highlights are ignored for the last two flags.
# https://linuxgazette.net/137/anonymous.html

# CSI ? 2004 h Turn on bracketed paste mode. Text pasted into the terminal will 
# be surrounded by ESC [200~ and ESC [201~, and characters in it should not be 
# treated as commands (for example in Vim).[14] From Unix terminal emulators.
# CSI ? 2004 l	Turn off bracketed paste mode.

Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}
Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk () { echo -n ""$'\033['$1'D'"" ;}
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
# Cursor movement will be bounded by the current viewport into the buffer.
# Scrolling (if available) will not occur.

# -- New scrolling lines after save position can mix save position
# Direct Cursor Addressing
Left_dn_start=""$'\033[E'"" # CNL Cursor Next Line. Cursor down to beginning of [<n>E th line in the viewport
Left_up_start=""$'\033[F'"" # CPL Cursor Previous Line. Cursor up to beginning of [<n>F th line in the viewport
Horizontal_position () { echo -n ""$'\033['$1'G'"" ;} # CHA Cursor Horizontal Absolute . Cursor moves to <n>th position horizontally in the current line
 Character_position () { echo -n ""$'\033['$1'`'"" ;} # HPA Horizontal Position Absolute [column] (default = [row,1])  Move cursor to indicated column in current row.
  Vertical_position () { echo -n ""$'\033['$1'd'"" ;} # VPA Vertical Position Absolute. Cursor moves to the <n>th position vertically in the current column

    Line_pos () { echo -n ""$'\033['$1'H'"" ;}      # CUP Cursor Position. Moves the cursor to row n, column m. The values are 1-based, and default to 1 (top left corner) if omitted.
    Position () { echo -n ""$'\033['$1';'$2'H'"" ;} # ESC [ <y> ; <x> H CUP Cursor Position
   Positionf () { echo -n ""$'\033['$1';'$2'f'"" ;} # ESC [ <y> ; <x> f HVP Cursor Position

# CHA  Cursor Horizontal Absolute      Esc [ Pn G                   1         EdF
# HPA  Horizontal Position Absolute    Esc [ Pn `                   1         FE
# HPR  Horizontal Position Relative    Esc [ Pn a                   1         FE

# VPA  Vert Position Absolute        Esc [ Pn d                   1         FE
# VPR  Vert Position Relative        Esc [ Pn e                   1         FE

# CHT  Cursor Horizontal Tab         Esc [ Pn I                   1         EdF
# HTS  Horizontal Tab Set            Esc H                                  FE

# HTJ  Horizontal Tab w/Justification  Esc I                                  FE
# VTS  Vertical Tabulation Set        Esc J                                  FE

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
Echo_# () { Get_View_port_position >&2; echo -ne "\033[${1};${2}H""$3" >&2; View_port_position ${RPosition} ${CPosition} >&2 ;}
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

Matrix ()
{
LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"
}

Log_watch ()
{
tput cup ${LINES} 0 	# End of terminal
tail -f a.log | while read line
do :
  tput sc # Save cursor
  printf "\033[1;$(( LINES - 1 ))r\033[$(( LINES - 1 ));${COLUMNS}f"
    # Set top scroll margin at line 1 and bottom at lines -1; pos last line 
  echo; echo ${line}
  printf "\e[1;${LINES}r" && tput rc # Load cursor
done
}


}; Color_terminal_variables

Another ()
{
# Another option is to use shell variables:

`
red () { tput setaf 1 >&2 ;}
green='`tput setaf 2 >&2`'
reset=(`tput sgr0 >&2`)
echo "${red}red text ${green}green text${reset}"
 ###
bold()          { ansi 1 "$@"; }
italic()        { ansi 3 "$@"; }
underline()     { ansi 4 "$@"; }
strikethrough() { ansi 9 "$@"; }
red()           { ansi 31 "$@"; }
ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }

`
# tput produces character sequences that are interpreted by the terminal
# as having a special meaning. They will not be shown themselves.
# Note that they can still be saved into files or processed as input by programs
# other than the terminal.

}


# The reason for the behavior is because bash believes the prompt is longer then 
# it actually is. As a simple example, if one use:

# PS1="\033[0;34m$"
#        1 2345678
# The prompt is believed to be 8 characters and not 1. As such if terminal window 
# is 20 columns, after typing 12 characters, it is believed to be 20 and wraps 
# around. This is also evident if one then try to do backspace or Ctrl+u. It stops 
# at column 9.

# However it also does not start new line unless one are on last column, as a 
# result the first line is overwritten.

# If one keep typing the line should wrap to next line after 32 characters.
# Non-printable sequences should be enclosed in \[ and \]. Looking at your PS1 
# it has a unenclosed sequence after \W. But, the second entry is redundant as 
# well as it repeats the previous statement "1;34".
Fixx ()
{

PS1="\[\033[01;32m\]\u:\[\033[01;34m\] \W\033[01;34m \$\[\033[00m\]"
#                      |_____________|               |_|
#                             |                       |
#                             +--- Let this apply to this as well.
# As such this should have intended coloring:

PS1="\[\033[1;32m\]\u:\[\033[1;34m\] \W \$\[\033[0m\]"
#                                   |_____|
#                                      |
#                                      +---- Bold blue.
# Keeping the "original" this should also work:

PS1="\[\033[1;32m\]\u:\[\033[1;34m\] \W\[\033[1;34m\] \$\[\033[0m\]"
#                                      |_|         |_|
#                                       |           |
#                                       +-----------+-- Enclose in \[ \]
`
export PS1='\[\033[5;36m\] \W \[\033[0;31m\] 〉\033[00m\]'

`
# The important thing is 00m at the end of line

echo "
Using the command env -i bash --norc fixes it. The $COLUMNS and $LINES match. 
Does that mean that there's something funny with my .bashrc?

--noprofile
          Do  not  read either the system-wide startup file /etc/profile or any 
of the personal initializa‐
          tion files ~/.bash_profile, ~/.bash_login, or ~/.profile.  By default, 
 bash  reads  these  files
          when it is invoked as a login shell (see INVOCATION below).

--norc Do  not  read  and  execute the system wide initialization file 
/etc/bash.bashrc and the personal
          initialization file ~/.bashrc if the shell is interactive.  This 
option is on by default  if  the
          shell is invoked as sh.
"
}
commennt=("
* Bold : The effect is not as dramatic as shown it basically makes the prompt a 
little brighter.
* Blink on: Warning people find this extremely obnoxious. Don't do it on a 
public machine.
* Black Outline: This is so faint you really have to look to be able to see it 
It does not show up like you see in the image. Also it only works with colored 
backgrounds. 
* Non display: The official definition is this: The 8m invisible video sequence 
does not change the background color. In the ANSI.sys driver, this escape 
sequence sets the foreground to black and the background to black. In ANSIPLUS, 
the current foreground is set to whatever the current background is, making text 
invisible on a potentially colored background. Okay but I can't get it to work 
right for me. If you come up with a cool prompt that can show this let me know 
here.
* Strikethrough : The table shows what it is suppose to do. I have not been able 
to get the effect to work. Let me know if you are able to here.
* Bold off: Turns off bold if you don't want it to go through your whole prompt.
* Italics off: This turns off italics so it doesn't go through your whole 
prompt.
* Underline off: Turns off the underline feature so it doesn't go through your 
whole prompt.
* Blink off: Turns off the blink feature so your whole prompt doesn't blink.
Inverse off: Turns off inverse colors so your whole prompt isn't reversed.
* Strikethrough off: Ends the strikethrough line so your whole prompt doesn't 
have a line through it. At least that is the idea Hell I couldn't get the line 
in the first place.
")
# Example 4-5. Positional Parameters

MINPARAMS=10

echo

echo "The name of this script is \"$0\"."
# $_     - last argument of an executed command
# ${!#}  - this is an *indirect reference* to the $# variable.
# Adds ./ for current directory

echo "The name of this script is \"`basename $0`\". $_ ${!#}"
# Strips out path name info (see 'basename')

echo

if [ -n "$1" ]              # Tested variable is quoted.
then
 echo "Parameter #1 is $1"  # Need quotes to escape #
fi 

if [ -n "$2" ]
then
 echo "Parameter #2 is $2"
fi

if [ -n "$3" ]
then
 echo "Parameter #3 is $3"
fi

#

echo "Parameter #10 is $10"
if [ -n "${10}" ]  # Parameters > $9 must be enclosed in {brackets}.
then
 echo "Parameter #10 is ${10}"
fi

echo "-----------------------------------"
echo "All the command-line parameters are: "$*""

if [ $# -lt "$MINPARAMS" ]
then
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!"
fi

echo

echo "$Green # top_info.sh script # $Reset"
echo "$LRed$blink # is empty :) # $Reset"
echo "$LGreen$Blink # Done # $Reset"
# *** BEGIN DEBUG BLOCK ***
last_cmd_arg=$_  # Save it.
echo "At line number $LINENO, variable \"\$1\" = $1"
echo "Last command argument processed = $last_cmd_arg"
# *** END DEBUG BLOCK ***
break
return
exit $?
exit

#!FIXME ### ########## ###
# SHELL SPECIAL VARIABLES
$*, $@, $#, $$, $!, $?, $-, $_.
$*           - expanded to "$ 1 $ 2 ..."
$@           - expandable to "$ 1" "$ 2" ...
$#           - number of position arguments
$1,…,$9      - parameters passed to the script - can be modified
${10},…,${N} - these are positional parameters. After “9″ you must use the ${k} syntax.
$0           - name of the current script or shell, basename ${0##*/}
$-           - shell options with set command)
$?           - return code of the last command executed
$_           - last argument of an executed command
$$           - PID of the current shell process
$!           - PID of the last batch task

!# last=${!#}  - this is an *indirect reference* to the $# variable.
if [ ! -t 0 ]; then # script is executed outside the terminal?
$IFS           List of fields separators
IFS=$' \t\n'   Standard list of fields separators
$BASH          The path to the Bash binary itself
$BASH_ENV      An environmental variable pointing to a Bash startup file to be read when a script is invoked
$BASH_SUBSHELL A variable indicating the subshell level. This is a new addition to Bash, version 3.
$BASHPID       Process ID of the current instance of Bash. This is not the same as the $$ variable, but it often gives the same result.
$BASH_VERSION  The version of Bash installed on the system
$BASH_SOURCE
$REPLY         The default value when a variable is not supplied to read. Also applicable to select menus, but only supplies the item number of the variable chosen, not the value of the variable itself.
$LINENO        This variable is the line number of the shell script in which this variable appears. It has significance only within the script in which it appears, and is chiefly useful for debugging purposes.
$PWD           Working directory (directory you are in at the time)
$OLDPWD        Old working directory ("OLD-Print-Working-Directory", previous directory you were in).
$OSTYPE
################
#  Is there any difference between /... and //... ?
	# A pathname consisting of a single slash shall resolve to the root directory
	# Why is this? Is there any difference between /... and //... ?
	# For the most part, repeated slahes in a path are equivalent to a single slash.
	# The exception is that “a pathname that begins with two successive slashes
	# may be interpreted in an implementation-defined manner”
	# (but ///foo is equivalent to /foo).
	# Linux doing anything special with //: it's bash's current directory
	# The double slash (//) at the start also means root / directory but it still
	# shows your CWD as // when you run pwd.
	
# filename=$(basename "$fullfile")
	# extension="${filename##*.}"
	# filename="${filename%.*}"
	# and avoid calling an extra basename
	# Alternatively, you can focus on the last '/' of the path instead of the '.'
	# which should work even if you have unpredictable file extensions:
	# filename="${fullfile##*/}"
	
# Path_to_file=$(dirname "$Path_file")
	# Path_to_file="${Path_file%/*}"
################
Setting_Default_Values ()
{

_mkdir ()
{
        local d="$1"        # get dir name
        local p=${2:-0755}  # get permission, or set default to 0755
        [ $# -eq 0 ] && { echo "$0: dirname"; return; }
        [ ! -d "$d" ] && mkdir -m $p -p "$d"
}

var=${parameter:-defaultValue}

# Tip: ${var:-defaultValue} vs ${var:=defaultValue}
# Please note that it will not work with positional parameter arguments:

var=${1:=defaultValue} ### FAIL with an error cannot assign in this way
var=${1:-defaultValue} ### Perfect

${varName?Error varName is not defined}
${varName:?Error varName is not defined or is empty}

${1:?"mkjail: Missing operand"}
MESSAGE="Usage: mkjail.sh domainname IPv4" ### define error message
_domain=${2?"Error: ${MESSAGE}"}           ### you can use $MESSAGE too

}

 function Byte_string_length () ( expr "${@}" : '.*' )
 function Char_string_length () ( string="${@}"; echo ${#string} )
 Byte_string_length €€€
 Char_string_length €€€

UTF-8_string_length ()
(
# TF-8 string length
# In addition to fedorqui's correct answer, I would like to show the difference
# between string length and byte length:

my_var='Généralités'
char_length=${#my_var}
Old_LANG=$LANG Old_Lc_All=$LC_ALL
LANG=C LC_ALL=C
byte_length=${#my_var}
printf -v my_real "%q" "$my_var"
LANG=$Old_LANG LC_ALL=$Old_Lc_All
printf "%s has %d chars, %d bytes: (%s).\n" "${my_var}" $char_length $byte_length "$my_real"

# will answer:
# Généralités has 11 chars, 14 bytes: ($'G\303\251n\303\251ralit\303\251s').
)


# Strip excess padding from the right
test_pading=('

(
Bar="[>---------------------<]";
String="STRING"
echo "$Bar"
echo -n "${Bar:0:-${#String}}"; echo "$String"
String="STR"
echo -n "${Bar:0:-${#String}}"; echo "$String"

String="STRING"
echo -n "${Bar:0:-${#String}}"; echo  -n "$String"; echo -n "${Bar:-${#String}}:0"; echo
String="STR"
echo -n "${Bar:0:-${#String}}"; echo  -n "$String"; echo -n "${Bar:0:-${#String}}"; echo
)

(
Bar="[>                     <]";
String="1234567890"
echo -n "${Bar:0:-${#String}}"; echo -n "$String"; echo
String="123"
echo -n "${Bar:0:-${#String}}"; echo -n "$String"; echo
)

Bar="[>                     <]";

echo -n "${Bar:0:-${#String}}"; echo "$String"
echo -n "${Bar:0:-${#String}}"; echo "$String"

#echo -n "${Bar:0:-${#String}}"; echo -n "${Bar:${#String}}";echo -n "${Bar:${#String}}"; echo  "$String"

# Strip excess padding from the left
#
B="A very long header"; echo "${A:${#B}} $B"
B="shrt hdr"          ; echo "${A:${#B}} $B"
Produces

-----<] A very long header
---------------<] shrt hdr
'
)

}

coment ()
{
comment= <<-EOF
This command will give you a list of available keyboard shortcuts according to stty.
echo -e "Terminal shortcut keys\n" && sed -e 's/\^/Ctrl+/g;s/M-/Shift+/g' <(stty -a 2>&1| sed -e 's/;/\n/g' | grep "\^" | tr -d ' ')
stty sane # reset
Tell the kernel that the terminal has N columns.
Resizing a terminal
Unlike ssh, serial connection does not have a mechanism to transfer something 
like SIGWINCH when a terminal is resized. This will cause weird problem with 
some full-screen programs (e.g. less) when you resized your terminal emulator's 
window.

Resize the terminal via stty is a workaround:

stty rows $lines cols $columns

owrap 

fold -w 80 -s text.txt
-w tells the width of the text, where 80 is standard.
-s tells to break at spaces, and not in words.

fmt -w 80 <text.txt

less -S -E


shopt  | grep checkwinsize
shopt -s checkwinsize

#############

if [ -n "$REDIRECT" ]
then
  REDIRECT="outfile"
  exec >> $REDIRECT
fi
#############
# Seek for terminal size and, if needed, set default size
  rc_lc () {
      if test -n "$REDIRECT" ; then
          set -- $(stty size < "$REDIRECT"  2> /dev/null || echo 0 0)
      else
          set -- $(stty size 2> /dev/null || echo 0 0)
      fi
      LINES=$1
      COLUMNS=$2
      test $LINES   -eq 0 && LINES=24
      test $COLUMNS -eq 0 && COLUMNS=80
      export LINES COLUMNS
  }
  trap 'rc_lc' SIGWINCH
  rc_lc

----
if tty -s; then
  echo "is this visible?"
else
  echo "is this visible?" >& /dev/null
fi
 Exit status:

     0 if standard input is a terminal
     1 if standard input is not a terminal
     2 if given incorrect arguments
     3 if a write error occurs
----
Line discipline
From Wikipedia, the free encyclopedia
Not to be confused with Lines (punishment).
A line discipline (LDISC) is a layer in the terminal subsystem in some Unix-like 
systems.[1] The terminal subsystem consists of three layers: the upper layer to 
provide the character device interface, the lower hardware driver to communicate 
with the hardware or pseudo terminal, and the middle line discipline to specify 
a policy for the driver.

The line discipline glues the low level device driver code with the high level 
generic interface routines (such as read(2), write(2) and ioctl(2)), and is 
responsible for implementing the semantics associated with the device.[2] The 
policy is separated from the device driver so that the same serial hardware 
driver can be used by devices that require different data handling.

For example, the standard line discipline processes the data it receives from 
the hardware driver and from applications writing to the device according to the 
requirements of a terminal on a Unix-like system. On input, it handles special 
characters such as the interrupt character (typically Control-C) and the erase 
and kill characters (typically backspace or delete, and Control-U, respectively) 
and, on output, it replaces all the LF characters with a CR/LF sequence.

A serial port could also be used for a dial-up Internet connection using a 
serial modem and PPP. In this case, a PPP line discipline would be used; it 
would accumulate input data from the serial line into PPP input packets, 
delivering them to the networking stack rather than to the character device, and 
would transmit packets delivered to it by the networking stack on the serial 
line.

Some Unix-like systems use STREAMS to implement line disciplines.

G=$(stty -g);stty rows $((${LINES:-50}/2));top -n1; stty $G;unset G


Run TOP in Color, split 4 ways for x seconds - the ultimate ps command. Great 
for init scripts
One of my favorite ways to impress newbies (and old hats) to the power of the 
shell, is to give them an incredibly colorful and amazing version of the top 
command that runs once upon login, just like running fortune on login. It's 
pretty sweet believe me, just add this one-liner to your ~/.bash_profile -- and 
of course you can set the height to be anything, from 1 line to 1000!

G=$(stty -g);stty rows $((${LINES:-50}/2));top -n1; stty $G;unset G

Doesn't take more than the below toprc file I've added below, and you get all 4 
top windows showing output at the same time.. each with a different color 
scheme, and each showing different info. Each window would normally take up 
1/4th of your screen when run like that - TOP is designed as a full screen 
program. But here's where you might learn something new today on this great 
site.. By using the stty command to change the terminals internal understanding 
of the size of your terminal window, you force top to also think that way as 
well.
# save the correct settings to G var.
G=$(stty -g)
# change the number of rows to half the actual amount, or 50 otherwise
stty rows $((${LINES:-50}/2))
# run top non-interactively for 1 second, the output stays on the screen (half 
at least)
top -n1
# reset the terminal back to the correct values, and clean up after yourself
stty $G;unset G
This trick from my [ 
http://www.askapache.com/linux-unix/bash_profile-functions-advanced-shell.html 
bash_profile ], though the online version will be updated soon. Just think what 
else you could run like this!
Note 1: I had to edit the toprc file out due to this site can't handle that 
(uploads/including code). So you can grab it from [ 
http://www.askapache.com/linux-unix/bash-power-prompt.html my site ]
Note 2: I had to come back and edit again because the links weren't being 
correctly parsed

save_state=$(stty -g)
echo -n "Password: "
stty -echo;read password
stty "$save_state";echo ""
echo "You inserted $password as password"

Hiding password while reading it from keyboard
Allow to read password in a script without showing the password inserted by the 
user

 ###
[[ $LANG =~ UTF-8$ ]] && echo "Uses UTF-8 encoding.."
echo -e '\u2620'
set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
codepoints () { printf 'U+%04x\n' ${@/#/\'} ; } ; codepoints

 ###
* tput colors That will only inform how many colors your terminal is reporting
to the environment via TERM, not how many colors it can actually support given
an appropriate TERM - export TERM=xterm-256color


"Dim", "Bright", and "Reverse" attributes could actually say what these are suppose to do.

For instance, what is suppose to happen when setting both "Dim" and "Bright"?
Or, does "Reverse" apply to both the foreground and background colors?
Does "Reverse" mean to exchange the foreground and background colors?
Or to set some kind of "complement" color to each of the foreground and background?

The value of $TERM does not give much information about the number of supported
colors. Many terminals advertise themselves as xterm, and might support
any number of colors (2, 8, 16, 88 and 256 are common values).

You can query the value of each color with the

OSC 4 ; c ; ? BEL control sequence.

If the color number c is supported
and if the terminal understands this control sequence
the terminal will answer back with the value of the color.

If the color number is not supported or if the terminal doesn't understand
this control sequence, the terminal answers nothing.

Here's a bash/zsh snippet to query whether color 42 is supported
(redirect to/from the terminal if necessary):

`
printf '\e]4;%d;?\a' 42
if read -d $'\a' -s -t 1; then …
`
# color 42 is supported
Among popular terminals, xterm and terminals based on the VTE library
(Gnome-terminal, Terminator, Xfce4-terminal, …)

support this control sequence; rxvt, konsole, screen and tmux don't.

I don't know of a more direct way.

Your pipe obviously has nothing to do with the terminal.

You need to print to the terminal (printf … >/dev/tty)
and then read from the terminal (read … </dev/tty).

Xterm responds to the OSC 4; …; ? BEL sequence by injecting keystrokes.

– Gilles Feb 24 '12 at 15:01


BEL	7	007	0x07	\a	^G	Terminal bell
BS	8	010	0x08	\b	^H	Backspace
HT	9	011	0x09	\t	^I	Horizontal TAB
LF	10	012	0x0A	\n	^J	Linefeed (newline)
VT	11	013	0x0B	\v	^K	Vertical TAB
FF	12	014	0x0C	\f	^L	Formfeed (also: New page NP)
CR	13	015	0x0D	\r	^M	Carriage return
ESC	27	033	0x1B	<none>	^[	Escape character
DEL	127	177	0x7F	<none>	<none>	Delete character
EOF
# ESC [ <n> '[E'	CN
# Cursor Next Line	Cursor down to beginning of <n>th line in the viewport
# '[F'  # End # CPL
# Cursor Previous Line	Cursor up to beginning of <n>th line in the viewport
# '[G': # Left end
# Cursor Horizontal Absolute
# Cursor moves to <n>th position horizontally in the current line
# '[H': # Home Pos1 # \033[<L>;<C>H
#  Or # \033[<L>;<C>f
# puts the cursor at line L and column C.
#
# ESC M	RI	
# Reverse Index – Performs the reverse operation of \n, moves cursor up one line
# , maintains horizontal position, scrolls buffer if necessary*

# ESC 7	DECSC	Save Cursor Position in Memory**
# ESC 8	DECSR	Restore Cursor Position from Memory**

# Note
# * If there are scroll margins set, RI inside the margins will scroll only
# the contents of the margins, and leave the viewport unchanged.
# (See Scrolling Margins)

# ** There will be no value saved in memory until the first use of the save command.

# The only way to access the saved value is with the restore command.

# Note
# For all parameters, the following rules apply unless otherwise noted:

# <n> represents the distance to move and is an optional parameter
# If <n> is omitted or equals 0, it will be treated as a 1
# <n> cannot be larger than 32,767 (maximum short value)
# <n> cannot be negative

# All commands in this section are generally equivalent to calling the SetConsoleCursorPosition console API.

# Cursor movement will be bounded by the current viewport into the buffer.

# Scrolling (if available) will not occur.

# *<x> and <y> parameters have the same limitations as <n> above.

# If <x> and <y> are omitted, they will be set to 1;1.
}
#!FIXME ### ########## ###
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

#!FIXME ### ########## ###

count_from_to ()
{ for i; do echo -en "\r$i"; done ;} # i=$1..?
count_from_to {1..100000}
echo
'
When you use things like
for i in $(...) or
for i in {1..N}
you are generating all elements before iterating, that`s very inefficient
for large inputs. You can either take advantage of pipes:
seq 1 100000 | while read i; do ...; ; done
or use the bash c-style for loop:
for ((i=0;;i++)); do ...; ; done
 '| :
echo
count_from_to () { for (( x="$1", y="$2"; x<"$2", y>"$1"-"$2"; x++, y-- )); do echo -en "\r$x $y"; done ;}
count_from_to 1 100000


#################

Full_patch="$(pwd)"
Work_dir_name="${PWD##*/}"

Path=/etc/ ; File=fstab.bak
Path_file=$Path$File

Path_to_file="${Path_file%/*}"; echo „$Path_to_file”
Path_to_file=$(dirname "$Path_file"); echo „$Path_to_file”

File="$(basename "$Path_file")"; echo „$File”

Base_file=${File%.*}; echo „$Base_file”
Postfix_file=${File##*.}; echo „$Postfix_file”
#################
Globbing
Bash performs filename expansion on unquoted command-line arguments.
echo *
echo t*
echo {*.iso,}
echo {,*.iso}
echo {"list iso and txt:",*.iso,*.txt}
#################
# front-end match
(
x=hello1hello2hello3
echo $x
#                  ^
                   s=${x##*hello}; echo $s # =3
#      ^
       s=${x#*hello}; echo $s # =1hello2hello3
# back-end match
x=hello1hello2hello3
#             ^
              s=${x%hello*}; echo $s # =hello1hello2
#       ^
        s=${x%%hello2*}; echo $s # =hello1
)
#################

# digit_postfix
s=/122//AbZ1234/
echo "$s"
v=${s##*[!0-9]};echo postfix = $v
v=${s##*[![:digit:]]};echo postfix = $v
a=${s%$v*};echo prefix = $a

v=${s##*[[:alpha:]]};echo postfix = $v
a=${s%$v*};echo prefix = $a
#################
# digit_prefix
v=${s%%[!0-9]*};echo prefix = $v
v=${s%%[![:digit:]]*};echo prefix = $v
a=${s#*$v};echo postfix = $a

v=${s%%[[:alpha:]]*};echo prefix = $v
a=${s#*$v};echo postfix = $a
#################
echo "$PATH"

echo "$PATH" | sed 's/:/ /g'
sed 's/:/ /g' <<<"$PATH"

# bash replacement construct.

# all occurrence:
echo "${PATH//:/ }"

# only the first occurrence:
echo "${PATH/:/ }"

# replace first not [0-9] only
s=12AbZ1234
v=${s/[!0-9]/;};echo v = $v
# replace all not [0-9] only
v=${s//[!0-9]/;};echo v = $v
#################
# replace first [:digit:] only
s=12AbZ1234
a=${s/[0-9]/;};echo a = $a
# replace all [:digit:] only
a=${s//[0-9]/;};echo a = $a
#################
s="  "
# replace first blank only
a=${s/ /.};echo a = $a
# replace all blanks
a=${s// /.};echo a = $a
#################
# replace front-end match blank
a=${s/# /.};echo a = $a
# replace back-end match blank
a=${s/% /.};echo a = $a
#################
upper="ABCZ"
lower=$(tr '[:upper:]' '[:lower:]' <<<$upper)
echo "Upper $upper Lower $lower"

upper="BcZ"
declare -l lower="${upper}"
echo "Upper $upper Lower $lower"

upper="CdZ"
lower=${upper,,}
echo "Upper $upper Lower $lower"
#################
read -p "Continue? (Y/N): " confirm && [[ ${confirm^^} == 'Y' || ${confirm^^} == 'YES' ]] || exit 1
#################
(
s=" 1 3 "
# first column
a=${s/# /''};echo a =\"$a\";a=${a%%[[:space:]]*};echo a =\"$a\"
# last column
a=${s/% /''};echo a =\"$a\";a=${a##*[[:space:]]};echo a =\"$a\"
)

(
s="  1 3  "
# first column
a=${s/# /''};echo a =\"$a\";a=${a%%[[:space:]]*};echo a =\"$a\"
# last column
a=${s/% /''};echo a =\"$a\";a=${a##*[[:space:]]};echo a =\"$a\"
)


false | true | echo foo;echo ${PIPESTATUS[0]} ${PIPESTATUS[1]} ${PIPESTATUS[2]}

pathchk: Check file name validity and portability

As I found startup functions that dirtied the namespace with names like:

  path ()
  {
      command -p ${1+"$@"}
  }
 ---
#################
()

( list )
Placing a list of commands between parentheses causes a subshell environment to 
be created, and each of the commands in list to be executed in that subshell. 
Since the list is executed in a subshell, variable assignments do not remain in 
effect after the subshell completes.
{}

{ list; }
Placing a list of commands between curly braces causes the list to be executed 
in the current shell context. No subshell is created. The semicolon (or newline) 
following list is required.
If you want the side-effects of the command list to affect your current shell, 
use {...}
If you want to discard any side-effects, use (...)

For example, I might use a subshell if I:

want to alter $IFS for a few commands, but I don't' want to alter $IFS globally 
for the current shell
cd somewhere, but I don't' want to change the $PWD for the current shell
It's' worthwhile to note that parentheses can be used in a function definition:

normal usage: braces: function body executes in current shell; side-effects 
remain after function completes
---
count_tmp() { cd /tmp; files=(*); echo "${#files[@]}"; }
pwd; count_tmp; pwd
---
/home/jackman
11
/tmp
---
echo "${#files[@]}"
11
---

unusual usage: parentheses: function body executes in a subshell; side-effects 
disappear when subshell exits
---
cd ; unset files
$ count_tmp() (cd /tmp; files=(*); echo "${#files[@]}")
$ pwd; count_tmp; pwd
---
/home/jackman
11
/home/jackman
---
echo "${#files[@]}"
0
---
#################

The command:

find ./ -size 0 -exec rm -i {} \;
means: find in the current directory (note that the / is useless here, . cannot 
be but a directory anyway) anything that has a size of 0 and for each object 
found, run the command rm -i name, i.e. interactively prompt for each file if 
you want to remove it. {} is replaced by each file name found in the executed 
command. One nice feature is that this file name is strictly a single argument, 
whatever the file name (even containing embedded spaces, tabs, line feeds, and 
whatever characters). This wouldn't be the case with xargs, unless non portable 
hacks are used. The final ; is there to end the -exec clause. The reason why its 
end needs to be delimited is that other find clauses might follow the -exec one, 
although it is rarely done.

One issue with this command is that it won't ignore non plain files, so might 
prompt the user to delete sockets, block and character devices, pipes, and 
directories. It will always fail with the latter even if you answer yes.

Another issue, although not really critical here, is that rm will be called for 
each file that has a zero size. If you substitute the -exec ending from /; to +, 
find will optimize the sub-process creation by only calling rm the minimal 
possible number of times, often just once.

Here is then how I would modify this command:

find . -type f -size 0 -exec rm -i {} +

{} has absolutely no meaning to bash, so is passed unmodified as an argument to 
the command executed, here find.
On the other hand, ; has a specific meaning to bash. It is normally used to 
separate sequential commands when they are on the same command line. Here the 
backslash in \; is precisely used to prevent the semicolon to be interpreted as 
a command separator by bash and then allow it to be passed as a parameter to the 
underlying command, find. Quoting the semicolon, i.e. ";" or ';', could have 
been an alternate way to have it stayed unprocessed.
#################
Don't do such thing by operating directly on {}.

You have used inline sh, so pass {} as argument to it, and also you don't need 
to use basename at all:

find "$R" -name "*.cpp" -type f -exec sh -c '
  for f do
    mv -- "$f" "${f%.*}.cc"
  done
' sh {} +
Note that you have to double quote $R, otherwise, it lead to security 
vulnerable.

shareimprove this answer
edited Apr 13 '17 at 12:36

Community♦
1
answered Oct 30 '16 at 16:05

cuonglm
88.6k18161253
  	 	
Thank you cuonglm, thank you you have helped me. I have learnt that sh -c means 
commands' arguments are pass into the srting fully-quoted with ''. I have learnt 
it is important to partially quote all variables because of splitting and 
globbing. Two doubts: Why did you add -- next to the mv command? I have tried 
and without them it works equal. Also Why do I need to put sh {} + after the 
string which feeds the first sh -c with args, it is harsh to understand this 
aproach. – enoy Nov 2 '16 at 19:10 
  	 	
@enoy: The -- marks the end of command options, actually, it isn't necessary in 
this case, but I put there for general. the first argument passed to inline sh 
will be the named of inline sh process. Try something sh -c 'does not exist' foo 
and sh -c'does not exist' bar. – cuonglm Nov 3 '16 at 2:26
#################
_complete_func() {
    __private_func
}
There's nothing special about it. It's just a convention, like using camel case 
for Java methods and starting class names with an uppercase letter
I looked over the bash man page and the POSIX shell standard, but was not able 
to locate anything regarding this naming convention. That said, there is the use 
of the underscore for indicating reserved or internal names in C. To quote the 
libc manual on reserved names:

In addition to the names documented in this manual, reserved names include all 
external identifiers (global functions and variables) that begin with an 
underscore (‘_’) and all identifiers regardless of use that begin with either 
two underscores or an underscore followed by a capital letter are reserved names
The main logic for this naming convention is:

so that the library and header files can define functions, variables, and macros 
for internal purposes without risk of conflict with names in user programs
It also would have the benefit of being able to grep between "private" and 
"public" functions (which I put in quotes because a user can call either form 
regardless of naming) easily.

#################
# *** BEGIN DEBUG BLOCK ***
last_cmd_arg=$_  # Save it.
echo "At line number $LINENO, variable \"v1\" = $v1"
echo "Last command argument processed = $last_cmd_arg"
# *** END DEBUG BLOCK ***
#################
chroot "$new_root" /bin/env -i HOME=/root TERM=$TERM /bin/bash -i
chroot "$new_root" /bin/env -i HOME=/root TERM=$TERM /bin/bash -c "ls;/bin/bash -i"
chroot "$new_root" /bin/env -i HOME=/root TERM=$TERM /bin/bash -c "source /etc/profile; env-update; /bin/bash -i"
konsole -e 'bash -c "ls; exec bash"'

Environment:
env

Display, set, or remove environment variables, Run a command in a modified environment.

Syntax
     env [OPTION]... [NAME=VALUE]... [COMMAND [ARGS]...]

Options

  -u NAME
  --unset=NAME
       Remove variable NAME from the environment, if it was in the
       environment.

  -
  -i
  --ignore-environment
       Start with an empty environment, ignoring the inherited
       environment.
Arguments of the form `VARIABLE=VALUE' set the environment variable VARIABLE to value VALUE. 

VALUE can be empty (`VARIABLE=').
Setting a variable to an empty value is different from unsetting it.
The first remaining argument specifies the program name to invoke;
it is searched for according to the `PATH' environment variable.
Any remaining arguments are passed as arguments to that program.
If no command name is specified following the environment specifications,the
resulting environment is printed. This is like specifying a command name of `printenv'.

"It isn't the pollution that is harming the environment, it's the impurities in the air and water" ~ Dan Quayle
Polluted is what we think is contaminated   for some reason, because otherwise it is as it is.

/bin/env -i
/bin/env -i bash

env - run a program in a modified environment
[Obviously, this still assumes a particular path for env, but there are only
very few systems where it lives in /bin, so this is generally safe.
The location of env is a lot more standardized than the location of an
executable or even worse something like python or ruby or spidermonkey.]

Lends you some flexibility on different systems
Will interpret your $PATH, and find executable in any directory in your $PATH.
#!/usr/bin/env does have downsides. It's more flexible than specifying
an absolute path but still requires knowing the interpreter name.
Occasionally you might want to run an interpreter that isn`t in the $PATH,
for example in a location relative to the script. In such cases,
you can often make a polyglot script that can be interpreted both by
the standard shell and by your desired interpreter.For example,to make a
Python 2 script portable both to systems where python is Python 3 and python2
is Python 2, and to systems where python is Python 2 and python2 doesn`t exist:
(
#!/bin/sh
''':'
if type python2 >/dev/null 2>/dev/null; then
  exec python2 "$0" "$@"
else
  exec python "$0" "$@"
fi
'''
# real Python script starts here
def …
)

'
#!/bin/sh
''':'
exec YourProg -some_options "$0" "$@"
'''
# The above shell shabang trick is more portable than /usr/bin/env
'

##
It`s possible to hack around this by using another awk script inside the shebang:

#!/usr/bin/gawk {system("/usr/bin/gawk --re-interval -f " FILENAME); exit}
This will execute {system("/usr/bin/gawk --re-interval -f " FILENAME); exit} in awk.
And this will execute /usr/bin/gawk --re-interval -f path/to/your/script.awk in your systems shell.
##

This is not just about Linux. It is about running a script under different UNIX like oses.
/bin/bash
gives you explicit control on a given system of what executable is called
In some situations, the first may be preferred
(like running python scripts with multiple versions of python, without having
to rework the executable line). But in situations where security is the focus,
the latter would be preferred, as it limits code injection possibilities.

#################
ARG1 -eq ARG2 is equal
ARG1 -ne ARG2 not-equa
ARG1 -lt ARG2 less-than
ARG1 -le ARG2 less-than-or-equal
ARG1 -gt ARG2 greater-than
ARG1 -ge ARG2 greater-than-or-equal

#################
# String went to breeding
multiplay ()
{
(
unset s
 s="  1 3  "
 echo String = \"$s\"
 echo "
  First = \"${s[0]}\"
 Second = \"${s[1]}\"
    All = \"${s[*]}\"
 Length = \"${#s[@]}\"
 "
 echo "OLD_IFS=\"\$IFS\"; IFS=\$' '; s=( \$s ); IFS=\"\$OLD_IFS\"\""
 OLD_IFS="$IFS"; IFS=$' '; s=( $s ); IFS="$OLD_IFS"
 echo String = \"$s\" \${String[*]} = \"${s[*]}\"
 echo "
  First = \"${s[0]}\"
 Second = \"${s[1]}\"
    All = \"${s[*]}\"
 Length = \"${#s[@]}\"
 "
 )
}; multiplay
 # | copy paste (..) ; {..};..
#################
# Remove color
dir_list=$(ls -d --color ./*/ 2>/dev/null)
echo ${dir_list[@]}
for string in ${dir_list[@]}
do
	echo "$string"
	list=${string#*;*m} list=${list%%$'\033'[*}
	echo "$list"
done


#################

http://www.catonmat.net/blog/bash-one-liners-explained-part-one
http://www.catonmat.net/blog/bash-one-liners-explained-part-two
# cut -f<$x>
-f FIELD-LIST
--fields=FIELD-LIST
     Select for printing only the fields listed in FIELD-LIST.  Fields
     are separated by a TAB character by default.  Also print any line
     that contains no delimiter character, unless the
     --only-delimited (-s) option is specified.

     Note awk supports more sophisticated field processing, and by
     default will use (and discard) runs of blank characters to
     separate fields, and ignore leading and trailing blanks.
          awk '{print $2}'    # print the second field
          awk '{print $NF-1}' # print the penultimate field
          awk '{print $2,$1}' # reorder the first two fields

     In the unlikely event that awk is unavailable, one can use the
     join command, to process blank characters as awk does above.
          join -a1 -o 1.2     - /dev/null # print the second field
          join -a1 -o 1.2,1.1 - /dev/null # reorder the first two fields

# You can even say something more complex. For example:
# I want those lines containing either XXX or YYY, but not ZZZ:
awk '(/XXX/ || /YYY/) && !/ZZZ/' file
grep "word1" | grep -v "word2"

# To find all occurrences of the pattern ‘.Pp’ at the beginning of a line:
grep '^\.Pp' myfile
# The apostrophes ensure the entire expression is evaluated by grep instead of by the user s shell.
# The caret ‘^’ matches the null string at the beginning of a line, and the ‘\’ escapes the ‘.’, which would otherwise match any character.

# To find all lines in a file which do not contain the words ‘foo’ or ‘bar’:
grep -v -e 'foo' -e 'bar' myfile

# To find all lines in a file which do not contain the words ‘foo’ or ‘bar’:
grep -v -e 'foo' -e 'bar' myfile

# A simple example of an extended regular expression:
grep '19|20|25' calendar
# Peruses the file ‘calendar’ looking for either 19, 20, or 25.

# Remove old 'from=' cheatcode:
sed -r 's/from=([^\ ]*.)//' -i "$extlinux_conf"
# Inject new 'from=' cheat:
sed -e s^initrd.xz\ ^initrd.xz\ from=$PTH\ ^g -i "$extlinux_conf"
# Update 'changes=' cheat:
sed -e s^changes=/porteus^changes=$PTH/porteus^g -i "$extlinux_conf"

If you really really want to use just bash, then the following can work:

while read a ; do echo ${a//abc/XYZ} ; done < /tmp/file.txt > /tmp/file.txt.t ; mv /tmp/file.txt{.t,}

This loops over each line, doing a substitution, and writing to a temporary file
( don\'t want to clobber the input) .
The move at the end just moves temporary to the original name.

To replaced the first occurrence of a string (regular expression actually), use ${string/regexp/replacement}:

#!/bin/bash
original_string='I love Suzy and Mary'
string_to_replace_Suzy_with='Sara'
result_string="${original_string/Suzy/$string_to_replace_Suzy_with}"
To replace all matches of $pattern with $replacement, double the first slash:

string="The secret code is 12345"
pattern="[0-9]"
echo ${string//$pattern/X}  # The secret code is XXXXX
Make sure the script is executed with bash. Other shells (e.g. sh) may return "Bad substitution"

# vim -d file1 file2
#################
Bash's printf command has a feature that'll quote/escape/whatever a string,
so as long as both the parent and subshell are actually bash, this should work:

quoted_args="$(printf " %q" "$@")" # Note: this will have a leading space before the first arg
# echo "Quoted args:$quoted_args" # Uncomment this to see what it's doing
bash -c "other_tool -a -b$quoted_args"
Note that you can also do it in a single line: bash -c "other_tool -a -b$(printf " %q" "$@")"
#################
"""foo ain't "bad" so there!"""

#################
# Disks list fdisk
disks=$(sudo fdisk -l 2>/dev/null |grep -e ': '|grep -e ' /'|grep -e ' /dev/')
if [ "$disks" = '' ]; then echo "$LRed Erorr: fdisk get disk list$Reset$Nline"; fi
OLDIFS="$IFS"
Type=${disks%% *} disks_list=${disks//$Type /}
IFS=$'\n' disks_list=($disks_list)

echo "$Type 1 = ${disks_list[0]}
$Type():
${disks_list[*]}
"
IFS="$OLDIFS"

# Volumes list fdisk
volumes=$(sudo fdisk -l 2>/dev/null  | grep '^/'|awk '{ sub(/ /,": "); print }')
if [ "$volumes" = '' ]; then echo "$LRed Erorr: fdisk get volumes list$Reset$Nline"; fi
OLDIFS="$IFS"
IFS=$'\n' volumes_list=($volumes)

echo "First volume = ${volumes_list[0]}
All volumes :
${volumes_list[*]}
"
IFS="$OLDIFS"

#

lsblk
(
disks=$( lsblk -l -p -a --output NAME,TRAN,SIZE,MODEL,TYPE 2>/dev/null|grep -e 'disk' )
OLDIFS="$IFS"
IFS=$'\n'; disks_list=($disks)
echo "First disk = ;${disks_list[0]};"
echo "All disks : 
;${disks_list[*]}; "
IFS="$OLDIFS"
) | cat

(
volumes=$( lsblk -l -p -a --output NAME,LABEL,FSTYPE,SIZE,TYPE,TRAN 2>/dev/null|grep -e 'part' )
OLDIFS="$IFS"
IFS=$'\n' volumes_list=($volumes)
echo "First volume = ${volumes_list[0]}
All volumes :
${volumes_list[*]}
"
IFS="$OLDIFS"

)

(
OLDIFS="$IFS"; View_size=$(stty size); IFS=' ' View_size=($View_size); IFS="$OLDIFS"
echo ${View_size[0]}
echo ${View_size[1]}
)

#################

parted -l

cat /proc/partitions
hwinfo --block --short
blkid  -c /dev/null -o list
blkid "$file" -o value -s LABEL
volumes_list=$(blkid -o device)
disks=$(ls /sys/block | gawk '{ print "/dev/"$NF" " }'|grep -v -e "sr0" -e "loop" -e "ram"|sort -rnt+ -k2|tr -d '\n@')
disks=$( $(command -v lsscsi) -is | gawk -F' /' '{ print "/"$NF";" }'|grep -v -e "sr0" -e "loop" -e "ram"|sort -rnt+ -k2|tr -d '\n')

#################
rsync --info=progress2 source dest
rsync -aP --progress sourceDirectory destinationDirectory
rsync -aPvh --progress sourceDirectory destinationDirectory
rsync -aP --stats --progress sourceDirectory destinationDirectory
rsync --force --progress ./test ./progres/
rsync --progress file1 file2
rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /* /path/to/backup/folder
#################
curl -O -C - file:///path/to/some/file


From man curl:

   -C, --continue-at <offset>
          Continue/Resume  a  previous  file transfer at the given offset.
          Use  "-C  -" to tell curl to automatically find out where/how to
          resume the transfer
   -O, --remote-name
          Write  output to a local file named like the remote file we get.
#################

pv sourcefile > destfile

pv -c < /dev/zero | pv -c | pv -c | pv -c | pv -c > /dev/null

dd bs=51200 if="$fromfile" 2>&1 |  | dd of="$tofile"

#################

dd_progress ()
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

source_size=$(du -BK --apparent-size -s "$source" | awk '{ print $1 }')
echo "Write: $source $source_size to: $destination"

dd bs=4096 if="$source" 2>/dev/null | dd bs=4096 of="$destination" >"$Progress" 2>&1 & dd_pid=$!
sleep 1

while kill -USR1 $dd_pid >/dev/null 2>&1
do
	progres_bar=$(tail -1 "$Progress")
	echo -ne "${progres_bar}\r"; sleep 1
done
progres_bar=$(tail -1 "$Progress")
echo -e "${progres_bar}"
cleanup
}
#
dd_progress "$source" "$destination"

#################


#################


pv $FILE.tgz | tar xzf - -C $DEST_DIR

SRC="/source/folder"; TRG="/target/folder/"
tar cpf - "$SRC" | pv -s $(du -sb "$SRC" | cut -f1) | tar xpf - -C "$TRG"

cpv ()
{
if (($#<2)); then
	echo "usage:"
	echo -e "\t$0 SRC DST"
	exit 1
else
	for (( i=1; i < $#; i++ ))
	do
		pv "${@:${i}:1}" > "${!#}/${@:${i}:1}"
	done
fi

 }

cpstat ()
{
Source="${1}"
Destination="${2}"
trap cleanup EXIT
trap cleanup RETURN
function cleanup
 {
 	if [ -f "$Errors" ]
 	then :
 		echo "Removing temp working files $Errors"
 		rm -f "$Errors"
 		sleep 3
 	fi
 }

size=$(du -BK --apparent-size -s "${Source}" | awk '{ print $1 }')
free_space=$(df -BK "${Destination}" | awk 'NR==2 {print $4}')
echo "Source size: $size Destination free space: $free_space"
if [ "$size" \< "$free_space" ]
then :
	Errors=$(mktemp) || return 1
	
	if [ -d "${Source}" ] && [ -d "${Destination}" ]
	then :
		( cd "${Source}" && cd .. && tar cp f - "$1" 2>"$Errors" ) | pv -s "${size}" | ( cd "${Destination}" && tar xp f - )
	elif [ -f "${Source}" ] && [ -d "${Destination}" ]
	then :
		( tar cp f - "${Source}" 2>"$Errors" ) | pv -s "${size}" | ( cd "${Destination}" && tar xp f - )
	fi
	cat "$Errors"
else :

fi
}

# You call it like this
# cpstat source destinationDirectory
# --checkpoint-action=echo="#%u: %T" main.c

cpstat ./stali.iso ./progres/stali.iso


function cpstat () {
echo "${@: 1: $#-1}"; echo "$( du -cs -BK --apparent-size "${@: 1: $#-1}")"
    tar -cf - "${@: 1: $#-1}" | pv -s "$( du -cs -BK --apparent-size "${@: 1: $#-1}" | tail -n 1 | cut -d "$(echo -e "\t")" -f 1)" | ( cd "${@: $#}"; tar -xf - )

}



#################
function cpstat()
{
  local pid="${1:-$(pgrep -xn cp)}" src dst
  [[ "$pid" ]] || return
  while [[ -f "/proc/$pid/fd/3" ]]; do
  sleep 1
    read src dst < <(stat -L --printf '%s ' "/proc/$pid/fd/"{3,4})
    (( src )) || break
    printf 'cp %d%%\r' $((dst*100/src))
  done
  echo
}
cp a b & cpstat

#################
#!/bin/bash
# Author : Teddy Skarin

# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
	let _progress=(${1}*100/${2}*100)/100
	let _done=(${_progress}*4)/10
	let _left=40-$_done
# Build progressbar string lengths
	_done=$(printf "%${_done}s")
	_left=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_done// /#}${_left// /-}] ${_progress}%%"

}

# Variables
_start=1

# This accounts as the "totalState" variable for the ProgressBar function
_end=100

# Proof of concept
for number in $(seq ${_start} ${_end})
do
	sleep 0.1
	ProgressBar ${number} ${_end}
done
printf '\nFinished!\n'
ProgressBar 50 100

#################
progress-bar() {
  local duration=${1}


    already_done() { printf "Progres: ["; for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "] %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 0.1
      clean_line
  done
  clean_line
}
progress-bar 100
#################
Run X programs under root privilages

dbus-launch dolphin %i -caption "%c" "%u"
#export $(dbus-launch) >/dev/null 2>&1
#export XAUTHORITY=/home/$user/.Xauthority
#DISPLAY=:0.0 ; export DISPLAY
#xhost +si:localuser:your_username
su
export $(dbus-launch) >/dev/null 2>&1
kate
#################
read -e -i "text"

history

history | tac | less

touch /etc/hello
touch: cannot touch `/etc/hello: Permission denied
sudo !!
sudo touch /etc/hello
[sudo] password for demouser:

#################
#!/usr/bin/env bash

password=''
while IFS= read -r -n1 -s char
do
  [[ -z $char ]] && { printf '\n'; break; } # ENTER pressed; output \n and break.
  if [[ $char == $'\x7f' ]]
  then : # backspace was pressed
         # Remove last char from output variable.
         [[ -n $password ]] && password=${password%?}
         # Erase '*' to the left.
         printf '\b \b'
  else : # Add typed char to output variable.
        password+=$char
        # Print '*' in its stead.
        printf '*'
  fi
done

Note:

    As for why pressing backspace records character code 0x7f: "In modern systems,
    the backspace key is often mapped to the delete character (0x7f in ASCII or Unicode)"
    https://en.wikipedia.org/wiki/Backspace
    \b \b is needed to give the appearance of deleting the character to the left;
    just using \b moves the cursor to the left, but leaves the character intact (nondestructive backspace).
    By printing a space and moving back again, the character appears to have been erased
    (thanks, The "backspace" escape character '\b' in C, unexpected behavior?).

In a POSIX-only shell (e.g., sh on Debian and Ubuntu, where sh is dash), 
use the stty -echo approach (which is suboptimal, because it prints nothing),
because the read builtin will not support the -s and -n options.


Debug ()
{
		echo
		echo -n "/${#char}/HEX=$EraseR"; echo "$char" | hexdump -C
		echo -n "/${#char}/HEX=$EraseR"; echo "$char" | hexdump -c
}

(
r_suggest ()
{
	# Before call fill
	# ${suggests[]};
	local info="$1" char= rest= suggest= lengt=
	suggest=${#suggests[@]}
	#echo "${suggests[@]} ${#suggests}"
	
	answer="${suggests[$suggest]}"
	printf "\r$EraseR$info$Reset ${answer}$Yellow *$SaveP$Magenta ["$suggest"-"${#suggests[@]}"]$RestoreP"
	while IFS= read -r -s -N1 char
	do
	
	if [ "$char" == $'\x0a' ]
	then :	# ENTER pressed
		# printf "\n${answer}\n"
		break
	fi
	
	if [ "$char" == $'\033' ]
	then :	# Esc pressed # Read rest sequence
		IFS= read -r -N2 rest
		char+="$rest" lengt="${#suggests[@]}"
		
		if [ "$char" == $'\033[A' ]
		then :	# Up pressed
			(( suggest+=1 ))
			#(( var0 = var1<98?9:21 ))
		if [ "$suggest" -gt "$lengt" ];then suggest="0";fi
		fi
		if [ "$char" == $'\033[B' ]
		then :	# Up down
			(( suggest-=1 ))
			if [ "$suggest" -lt "0" ];then suggest="$lengt";fi
		fi
		answer="${suggests[$suggest]}" char=''
		
	fi
	
	if [ "$char" == $'\x7f' ]
	then :  # Backspace was pressed; # Remove last char from output variable.
		[[ -n "$answer" ]] && answer="${answer%?}"
		
	else :  # Add typed char to output variable.
		answer+="$char"
		
	fi
	printf "\r$EraseR$info$Reset ${answer}$Blink$Yellow$SaveP $Magenta["$suggest"-"${#suggests[@]}"]$Yellow$RestoreP"
	done
	unset suggests
}

)

cat <<-'EOF'
read -p "Continue? (Y/N): " confirm && confirm=${confirm,,} && [[ $confirm == [y] || $confirm == [y][eE][s] ]] || exit 1
`read'
          read [-ers] 
          [-a ANAME] [-d DELIM] [-i TEXT] [-n NCHARS] [-N NCHARS] [-p PROMPT] [-t TIMEOUT] [-u FD] [NAME ...]
     One line is read from the standard input, or from the file
     descriptor FD supplied as an argument to the `-u' option, and the
     first word is assigned to the first NAME, the second word to the
     second NAME, and so on, with leftover words and their intervening
     separators assigned to the last NAME.  If there are fewer words
     read from the input stream than names, the remaining names are
     assigned empty values.  The characters in the value of the `IFS'
     variable are used to split the line into words.  The backslash
     character `\' may be used to remove any special meaning for the
     next character read and for line continuation.  If no names are
     supplied, the line read is assigned to the variable `REPLY'.  The
     return code is zero, unless end-of-file is encountered, `read'
     times out (in which case the return code is greater than 128), or
     an invalid file descriptor is supplied as the argument to `-u'.

     Options, if supplied, have the following meanings:

    `-a ANAME'
          The words are assigned to sequential indices of the array
          variable ANAME, starting at 0.  All elements are removed from
          ANAME before the assignment.  Other NAME arguments are
          ignored.

    `-d DELIM'
          The first character of DELIM is used to terminate the input
          line, rather than newline.

    `-e'
          Readline (*note Command Line Editing::) is used to obtain the
          line.  Readline uses the current (or default, if line editing
          was not previously active) editing settings.

    `-i TEXT'
          If Readline is being used to read the line, TEXT is placed
          into the editing buffer before editing begins.

    `-n NCHARS'
          `read' returns after reading NCHARS characters rather than
          waiting for a complete line of input, but honor a delimiter
          if fewer than NCHARS characters are read before the delimiter.

    `-N NCHARS'
          `read' returns after reading exactly NCHARS characters rather
          than waiting for a complete line of input, unless EOF is
          encountered or `read' times out.  Delimiter characters
          encountered in the input are not treated specially and do not
          cause `read' to return until NCHARS characters are read.

    `-p PROMPT'
          Display PROMPT, without a trailing newline, before attempting
          to read any input.  The prompt is displayed only if input is
          coming from a terminal.

    `-r'
          If this option is given, backslash does not act as an escape
          character.  The backslash is considered to be part of the
          line.  In particular, a backslash-newline pair may not be
          used as a line continuation.

    `-s'
          Silent mode.  If input is coming from a terminal, characters
          are not echoed.

    `-t TIMEOUT'
          Cause `read' to time out and return failure if a complete
          line of input is not read within TIMEOUT seconds.  TIMEOUT
          may be a decimal number with a fractional portion following
          the decimal point.  This option is only effective if `read'
          is reading input from a terminal, pipe, or other special
          file; it has no effect when reading from regular files.  If
          TIMEOUT is 0, `read' returns success if input is available on
          the specified file descriptor, failure otherwise.  The exit
          status is greater than 128 if the timeout is exceeded.

    `-u FD'
          Read input from file descriptor FD.
#################
EOF

It's common in Linux to pipe a series of simple, single purpose commands 
together to create a larger solution tailored to our exact needs. The ability to 
do this is one of the real strenghs of Linux. It turns out that we can easily 
accommodate this mechanism with our scripts also. By doing so we can create 
scripts that act as filters to modify data in specific ways for us.

Bash accomodates piping and redirection by way of special files. Each process 
gets it's own set of files (one for STDIN, STDOUT and STDERR respectively) and 
they are linked when piping or redirection is invoked. Each process gets the 
following files:

STDIN - /proc/<processID>/fd/0
STDOUT - /proc/<processID>/fd/1
STDERR - /proc/<processID>/fd/2
To make life more convenient the system creates some shortcuts for us:

STDIN - /dev/stdin or /proc/self/fd/0
STDOUT - /dev/stdout or /proc/self/fd/1
STDERR - /dev/stderr or /proc/self/fd/2
fd in the paths above stands for file descriptor.

#################
function r_ask()
{
read -p "$1 {Y}es or {N}o: " -N1
echo "This function is done now" >&2
case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
     y|yes) echo "yes";;
         *) echo "no" ;;
esac
}
###
if [[ "no" == $(r_ask "$LGreen ... Please answer or Enter for skip$Red") || "no" == $(r_ask "$LBlue Are you$LOrange *really*$Orange sure?$Red") ]]
 then echo "$Nline$Orange Skipped ...$Reset$Nline"
 else echo "$Reset Dooo"
fi
#################
while true; do
	read -p "Please answer Y or N? " -n1 yn
	case $yn in
	[Yy]* ) echo;echo "Yes";echo "Dooo"; break;;
	
	[Nn]* ) echo;echo "No"; break;;
	
	* ) echo;echo "Please answer Y or N.";;
	esac
done
###
read -p "Last chance to abort - are you sure to you want to fix $1 [y/N]? " check
case "$check" in
	y|Y|yes|Yes|YES) ;;
	*)	echo "Aborting."
		exit ;;
esac

#################
#!/bin/bash
IFS=' '
PS3="Your choice: "
select y in X Y Z Quit
do

  case $y in
    "X")	echo "Wybrałeś X" ;;
    "Y")	echo "Wybrałeś Y" ;;
    "Z")	echo "Wybrałeś Z" ;;
    "Quit")	echo "Quit" ;;
     *) 	echo "Nic nie wybrałeś";;
  esac

  break

done

#################
title="Select example"
prompt="Pick an option:"
options=("A" "B" "C")

echo "$title"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do 

    case "$REPLY" in

    "1" ) echo "You picked $opt which is option $REPLY";;
    "2" ) echo "You picked $opt which is option $REPLY";;
    "3" ) echo "You picked $opt which is option $REPLY";;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done

#################
IFS=' '
echo -e "Press [ENTER] to start Configuration..."
for (( i=10; i>0; i--)); do

printf "\rStarting in $i seconds..."
read -s -N1 -t1 key

if [ "$key" == $'\033' ]; then
        echo -e "\n [ESC] Pressed"
        break
elif [ "$key" == $'\x0a' ] ;then
        echo -e "\n [Enter] Pressed"
        break
fi

done

#################
part="  /dev/sda12  "
part=$(echo $part | xargs)
echo $part

#################

[[ is bash's improvement to the [ command.
It has several enhancements that make it a better choice if you write scripts
that target bash. My favorites are:

It is a syntactical feature of the shell, so it has some special behavior
that [ doesn't have. You no longer have to quote variables like mad
because [[ handles empty strings and strings with whitespace more intuitively.
For example, with [ you have to write

if [ -f "$FILE" ]
to correctly handle empty strings or file names with spaces in them.
With [[ the quotes are unnecessary:
if [[ -f $FILE ]]
Because it is a syntactical feature, it lets you use && and || operators
for boolean tests and < and > for string comparisons.
[ cannot do this because it is a regular command and &&,  ||, <, and >
are not passed to regular commands as command-line arguments.
It has a wonderful =~ operator for doing regular expression matches.
With [ you might write

if [ "$ANSWER" = y -o "$ANSWER" = yes ]
With [[ you can write this as

if [[ $ANSWER =~ ^y(es)?$ ]]
It even lets you access the captured groups which it stores in BASH_REMATCH.
For instance, ${BASH_REMATCH[1]} would be "es" if you typed a full "yes" above.
You get pattern matching aka globbing for free.
Maybe you're less strict about how to type yes.
Maybe you're okay if the user types y-anything.
Got you covered:
if [[ $ANSWER = y* ]]
Keep in mind that it is a bash extension, so if you are writing sh-compatible
scripts then you need to stick with [.
Make sure you have the
#!/bin/bash shebang line for your script if you use double brackets.
# using POSIX class [:space:] to find space in the filename
if [[ "$file" = *[[:space:]]* ]]; then
# to find substring
if [[ "$system_device" = *"/dev/sda"* ]]
#################
<<;   is known as here-document structure.
<<< is known as here-string - bc <<< 5*4
result=$($your_command)
result=$( ( $your_command ) 2>&1)
Here is one way to remember this construct
(although it is not entirely accurate): at first, 2>1 may look like a good way
to redirect stderr to stdout.
However, it will actually be interpreted as "redirect stderr to a file named 1".
& indicates that what follows is a file descriptor and not a filename.
So the construct becomes: 2>&1.

2>/dev/null             # Redirect stderr to /dev/null
>&2 			# Redirect to stderr and screen
>/dev/null 2>&1 	# Redirect stderr and stdout to /dev/null
>&"$X"			# Redirect stdout to variable

IFS= read -r -s -t1 sleep1 # redirect keyboard to $sleep1 for -t1

comment=<<comment
# redirect the output to a file but keep it on stdout
exec > >(tee log)
exec 2>&1
# Remove color codes (special characters) with sed
./somescript | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|G|K]//g"
comment
comment ()
{
# redirect the output to a file but keep it on stdout
exec > >(tee log)
exec 2>&1
# Remove color codes (special characters) with sed
./somescript | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|G|K]//g"
string=$(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" <<<$somescript}
}

########Chapter 20. I/O Redirection

Table of Contents
20.1. Using exec
20.2. Redirecting Code Blocks
20.3. Applications

There are always three default files
[1] open, stdin (the keyboard), stdout (the screen),
and stderr (error messages output to the screen).
These, and any other open files, can be redirected. Redirection simply
means capturing output from a file, command, program, script,
or even code block within a script (see Example 3-1 and Example 3-2)
and sending it as input to another file, command, program, or script.

Each open file gets assigned a file descriptor.
[2] The file descriptors for stdin, stdout, and stderr are 0, 1, and 2,
respectively. For opening additional files, there remain descriptors 3 to 9.
It is sometimes useful to assign one of these additional file descriptors
to stdin, stdout, or stderr as a temporary duplicate link.
[3] This simplifies restoration to normal after complex redirection
and reshuffling (see Example 20-1).

   COMMAND_OUTPUT >
      # Redirect stdout to a file.
      # Creates the file if not present, otherwise overwrites it.

      ls -lR > dir-tree.list
      # Creates a file containing a listing of the directory tree.

   : > filename
      # The > truncates file "filename" to zero length.
      # If file not present, creates zero-length file (same effect as 'touch').
      # The : serves as a dummy placeholder, producing no output.

   > filename    
      # The > truncates file "filename" to zero length.
      # If file not present, creates zero-length file (same effect as 'touch').
      # (Same result as ": >", above, but this does not work with some shells.)

   COMMAND_OUTPUT >>
      # Redirect stdout to a file.
      # Creates the file if not present, otherwise appends to it.


      # Single-line redirection commands (affect only the line they are on):
      # --------------------------------------------------------------------

   1>filename
      # Redirect stdout to file "filename."
   1>>filename
      # Redirect and append stdout to file "filename."
   2>filename
      # Redirect stderr to file "filename."
   2>>filename
      # Redirect and append stderr to file "filename."
   &>filename
      # Redirect both stdout and stderr to file "filename."
      # This operator is now functional, as of Bash 4, final release.

   M>N
     # "M" is a file descriptor, which defaults to 1, if not explicitly set.
     # "N" is a filename.
     # File descriptor "M" is redirect to file "N."
   M>&N
     # "M" is a file descriptor, which defaults to 1, if not set.
     # "N" is another file descriptor.

     #=======================================================================

      # Redirecting stdout, one line at a time.
      LOGFILE=script.log

      echo "This statement is sent to the log file, \"$LOGFILE\"." 1>$LOGFILE
      echo "This statement is appended to \"$LOGFILE\"." 1>>$LOGFILE
      echo "This statement is also appended to \"$LOGFILE\"." 1>>$LOGFILE
      echo "This statement is echoed to stdout, and will not appear in \"$LOGFILE\"."
      # These redirection commands automatically "reset" after each line.



      # Redirecting stderr, one line at a time.
      ERRORFILE=script.errors

      bad_command1 2>$ERRORFILE       #  Error message sent to $ERRORFILE.
      bad_command2 2>>$ERRORFILE      #  Error message appended to $ERRORFILE.
      bad_command3                    #  Error message echoed to stderr,
                                      #+ and does not appear in $ERRORFILE.
      # These redirection commands also automatically "reset" after each line.
      #=======================================================================

   2>&1
      # Redirects stderr to stdout.
      # Error messages get sent to same place as standard output.
        >>filename 2>&1
            bad_command >>filename 2>&1
            # Appends both stdout and stderr to the file "filename" ...
        2>&1 | [command(s)]
            bad_command 2>&1 | awk '{print $5}'   # found
            # Sends stderr through a pipe.
            # |& was added to Bash 4 as an abbreviation for 2>&1 |.

   i>&j
      # Redirects file descriptor i to j.
      # All output of file pointed to by i gets sent to file pointed to by j.

   >&j
      # Redirects, by default, file descriptor 1 (stdout) to j.
      # All stdout gets sent to file pointed to by j.

   0< FILENAME
    < FILENAME
      # Accept input from a file.
      # Companion command to ">", and often used in combination with it.
      #
      # grep search-word <filename


   [j]<>filename
      #  Open file "filename" for reading and writing,
      #+ and assign file descriptor "j" to it.
      #  If "filename" does not exist, create it.
      #  If file descriptor "j" is not specified, default to fd 0, stdin.
      #
      #  An application of this is writing at a specified place in a file. 
      echo 1234567890 > File    # Write string to "File".
      exec 3<> File             # Open "File" and assign fd 3 to it.
      read -n 4 <&3             # Read only 4 characters.
      echo -n . >&3             # Write a decimal point there.
      exec 3>&-                 # Close fd 3.
      cat File                  # ==> 1234.67890
      #  Random access, by golly.



   |
      # Pipe.
      # General purpose process and command chaining tool.
      # Similar to ">", but more general in effect.
      # Useful for chaining commands, scripts, files, and programs together.
      cat *.txt | sort | uniq > result-file
      # Sorts the output of all the .txt files and deletes duplicate lines,
      # finally saves results to "result-file".

Multiple instances of input and output redirection and/or pipes can be combined in a single command line.

command < input-file > output-file
# Or the equivalent:
< input-file command > output-file   # Although this is non-standard.

command1 | command2 | command3 > output-file

See Example 16-31 and Example A-14.

Multiple output streams may be redirected to one file.

ls -yz >> command.log 2>&1
#  Capture result of illegal options "yz" in file "command.log."
#  Because stderr is redirected to the file,
#+ any error messages will also be there.

#  Note, however, that the following does *not* give the same result.
ls -yz 2>&1 >> command.log
#  Outputs an error message, but does not write to file.
#  More precisely, the command output (in this case, null)
#+ writes to the file, but the error message goes only to stdout.

#  If redirecting both stdout and stderr,
#+ the order of the commands makes a difference.

Closing File Descriptors

n<&-

    Close input file descriptor n.
0<&-, <&-

    Close stdin.
n>&-

    Close output file descriptor n.
1>&-, >&-

    Close stdout.

Child processes inherit open file descriptors. This is why pipes work.
To prevent an fd from being inherited, close it.

# Redirecting only stderr to a pipe.

exec 3>&1                            # Save current "value" of stdout.
ls -l 2>&1 >&3 3>&- | grep bad 3>&-  # Close fd 3 for 'grep' (but not 'ls').
#              ^^^^   ^^^^
exec 3>&-                        # Now close it for the remainder of the script.

# Thanks, S.C.
#########
"
$ date | cat
Thu Jul 21 12:39:18 EEST 2011
This is a pointless example but it shows that cat accepted the output
of date on STDIN and spit it back out.
The same results can be achieved by process substitution:

$ cat <(date)
Thu Jul 21 12:40:53 EEST 2011
However what just happened behind the scenes was different.
Instead of being given a STDIN stream, cat was actually
passed the name of a file that it needed to go open and read.
You can see this step by using echo instead of cat.

$ echo <(date)
/proc/self/fd/11
When cat received the file name, it read the file's content for us.
On the other hand, echo just showed us the file's name that it was passed.
This difference becomes more obvious if you add more substitutions:

$ cat <(date) <(date) <(date)
Thu Jul 21 12:44:45 EEST 2011
Thu Jul 21 12:44:45 EEST 2011
Thu Jul 21 12:44:45 EEST 2011

$ echo <(date) <(date) <(date)
/proc/self/fd/11 /proc/self/fd/12 /proc/self/fd/13
It is possible to combine process substitution (which generates a file)
and input redirection (which connects a file to STDIN):

$ cat < <(date)
Thu Jul 21 12:46:22 EEST 2011
It looks pretty much the same but this time cat was passed
STDIN stream instead of a file name.
You can see this by trying it with echo:

$ echo < <(date)
<blank>
Since echo doesn't read STDIN and no argument was passed, we get nothing.

In other words, and from a practical point of view
you can use an expression like the following

<(commands)
as a file name for other commands requiring a file as a parameter.
Or you can use redirection for such a file:

while read line; do something; done < <(commands)
Turning back to your question, it seems to me that process substitution
and pipes have not much in common.

If you want to pipe in sequence the output of multiple commands
you can use one of the following forms:

(command1; command2) | command3
{ command1; command2; } | command3
but you can also use redirection on process substitution

command3 < <(command1; command2)
finally, if command3 accepts a file parameter (in substitution of stdin)

command3 <(command1; command2)
"
http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_03
"
Command substitution allows the output of a command to be substituted
in place of the command name itself.
Command substitution shall occur when the command is enclosed as follows:

$(command)

or (backquoted version):

`command`

The shell shall expand the command substitution by executing command
in a subshell environment (see Shell Execution Environment)
and replacing the command substitution (the text of command plus the enclosing
"$()" or backquotes) with the standard output of the command
removing sequences of one or more <newline> characters at the end of
the substitution.
Embedded <newline> characters before the end of the output shall not be removed;
however, they may be treated as field delimiters and eliminated during
field splitting, depending on the value of IFS and quoting that is in effect.
If the output contains any null bytes, the behavior is unspecified.

eval "my-command-string"

`my-command-string`

(my-command-string)

sh -c "$string"

alias evaled="$string";evaled

# The most direct way to do it is:
eval "$string"

# the command is evaluated twice—that's once more than normal—and the one time
is usually more than enough for most people to wind up at this web site.

function eval_command() { "$@";}

my_cmd() { ;};my_cmd

"
#################
grep -al 'Illegal variable name' /bin/*
#################
#!/bin/bash
# This /bin/bash script will locate and replace spaces
# in the filenames
DIR="."
# Controlling a loop with /bin/bash read command by redirecting STDOUT as
# a STDIN to while loop
# find will not truncate filenames containing spaces
find $DIR -type f | while read file; do
# using POSIX class [:space:] to find space in the filename
if [[ "$file" = *[[:space:]]* ]]; then
# to find substring
if [[ "$system_device" = *"/dev/sda"* ]]
# substitute space with "_" character and consequently rename the file
mv "$file" `echo $file | tr ' ' '_'`
fi;
# end of while loop
done

#################
# Interface=$(whereis -b route|awk '{print $2}');$Interface -n|grep 'UG'|awk '{print $8}'|head -n1|cut -c -15
# interface=$(ip route | head -n1 | awk '{print $5}')

# Command=(lsb_release)
# echo "$Nline$LGreen # Command: ${Command[@]} # $Reset$Nline";COMMAND=($(whereis -b ${Command[0]}));if [[ -x ${COMMAND[1]} ]];then whatis ${Command[@]};echo -n "${Command[@]} = ";${Command[@]};else echo "No Command: $Command";fi

you_user_login="$(whoami)"
echo "$LGreen Your user login name is $LMagenta $you_user_login $LGreen
And belong to group: $LMagenta "$(whoami| groups )""$Reset""

# Add user to sudo,users,wheel.. by adduser command
# adduser $you_user_login sudo,users,wheel

# Add user to o sudo,users,wheel.. by usermod command
# usermod -G sudo,users,wheel $you_user_login

# Create and add user to o sudo,users,wheel.. by useradd command
# useradd -m -G sudo,users,wheel -s /bin/bash $you_user_login

# Or you can use graphical su commands, for example - 
'xdg-su -c "usermod -a -G sudo,users,wheel -s /bin/bash $you_user_login"'
#
# ----------	0000	no permissions
# ---x--x--x	0111	execute
# --w--w--w-	0222	write
# --wx-wx-wx	0333	write & execute
# -r--r--r--	0444	read
# -r-xr-xr-x	0555	read & execute
# -rw-rw-rw-	0666	read & write
# -rwxrwxrwx	0777	read, write, & execute
chmod 0777 $file
#################
# Safe way to edit as user files with root permission under user environment
bak_dir="/bak"
tmp_dir_1=$(dirname $files_with_root_permission)

su -c "mkdir -p $bak_dir$tmp_dir_1;\
if ! [ -f $1 ]; then echo \"$Nline$Orange file $1 do not exist, create !$Reset$Nline\"; fi; if ! [ -f $bak_dir$1.org ]; then cp -fax $1 $bak_dir$1.org; fi; if [ -f $1 ]; then cp -fax $1 $bak_dir$1.bak; fi; cat $1 > $bak_dir$1.edit; chmod 666 $bak_dir$1.edit"

echo "$Nline$Green Oginal copy will be $Yellow$bak_dir$*$Magenta.org$Green and copy before this edit session is in $Yellow$bak_dir$*$Magenta.bak$Reset$Nline"
kate -b $bak_dir$1.edit >/dev/null 2>&1

echo "$Nline$Red Give administration password to write file $Cyan$bak_dir$1.edit$Reset to $Yellow$1$Reset$Nline"
su -c "cat $bak_dir$1.edit > $1; rm -f $bak_dir$1.edit"
echo "Done"
#################

#command <&- &
echo $(ls $TMPDIR/EasyMonitor-$USER/destination_backup/$DESTINATION_BACKUP_DIR/*$FILE_TYPE | xargs -n 1 basename)

Start_time=`date +%s`
sleep 0.7
Elapsed_time=$((`date +%s` - $Start_time))
echo "Finished in $(($Elapsed_time/60)) min $(($Elapsed_time%60)) sec"



LSB_RELASE_COMMAND=`which lsb_release`
LSB_RELASE_COMMAND=$(which lsb_release)
$(which lsb_release)
COMMAND=`whereis -b lsb_release|awk '{print $2}'`;echo $COMMAND
COMMAND=$(whereis -b lsb_release|awk '{print $2}'); echo $COMMAND
$(whereis -b lsb_release|awk '{print $2}')

Command=(lsb_release)
echo "$Nline$LGreen # Command: ${Command[@]} # $Reset$Nline";COMMAND=($(whereis -b ${Command[0]}));if [[ -x ${COMMAND[1]} ]];then whatis ${Command[@]};echo -n "${Command[@]} = ";${Command[@]};else echo "No Command: $Command";fi
#################
#!bin/bash
#A gauge Box example with dialog
(
c=10
while [ $c -ne 110 ]
do
    echo $c
    echo "###"
    echo "$c %"
    echo "###"
    ((c+=10))
    sleep 1
done
) |
dialog --title "A Test Gauge With dialog" --gauge "Please wait ...." 10 60 0
#################
onclick="xdg-open $HOME/.superkaramba/EasyMonitor/; exit 0"
onclick="xdg-open $HOME"

############################
# Resetting the root account password on Debian (or any account password)

# This has been tested and is known to work with Debian versions 6, 7, and 8.
# It can also be used to change any account password.
# Method 1
# Boot into grub, select single user but do not press enter.
# Press e to go into edit mode.
# Scroll down to the kernel line, it starts with "linux /boot/vmlinuz-2.6……."
# Scroll to the end of that line and press space key once and type init=/bin/bash
# Press Ctrl X to boot
# Remount / as Read/Write
mount -rw -o remount /

# Change the root account password with
passwd

# Change any other account password with
passwd username

# type new password, confirm and hit enter and then reboot.
# Method 2
# Boot from another installation of Debian. (One can use a LiveCD to get access to the "/" partition.)
# Then, mount the partition where you have Debian's "/" (root directory), then change directory to /mnt/etc
# Used vim / nano as an editor to edit the file shadow.
# Find the line starting with root: (or another username)
# Delete everything between the first and second colons (:), and the line will now look like:
# root::$6$fsdsdgdsg74.:14862:0:99999:7:::
# Reboot and login as root (or another username as used above) without a password.
# At the end use passwd to set a new password for the root account (or passwd username to change any account password).
# Reboot and login as root with the new root password.

############################
# Source: ifconfig sucks
# ifconfig vs ip
# net-tools			iproute2
# ifconfig			ip addr, ip link
# ifconfig (interface stats)	ip -s link
# route				ip route
# arp				ip neigh
# netstat			ss
# netstat -M			conntrack -L
# netstat -g			ip maddr
# netstat -i			ip -s link
# netstat -r			ip route
# iptunnel			ip tunnel
# ipmaddr			ip maddr
# tunctl			ip tuntap (since iproute-2.6.34)
# (none) for interface rename	ip link set dev OLDNAME name NEWNAME
# brctl				bridge (since iproute-3.5.0)
############################
# iw vs iwconfig
# iw							wireless_tools					Description
# iw dev wlan0 link					iwconfig wlan0					Getting link status.
# iw dev wlan0 scan					iwlist wlan0 scan				Scanning for available access points.
# iw dev wlan0 set type ibss				iwconfig wlan0 mode ad-hoc			Setting the operation mode to ad-hoc.
# iw dev wlan0 connect your_essid			iwconfig wlan0 essid your_essid			Connecting to open network.
# iw dev wlan0 connect your_essid 2432			iwconfig wlan0 essid your_essid freq 2432M	Connecting to open network specifying channel.
# iw dev wlan0 connect your_essid key 0:your_key	iwconfig wlan0 essid your_essid key your_key	Connecting to WEP encrypted network using hexadecimal key.
# iw dev wlan0 connect your_essid key 0:your_key	iwconfig wlan0 essid your_essid key s:your_key	Connecting to WEP encrypted network using ASCII key.
# iw dev wlan0 set power_save on			iwconfig wlan0 power on				Enabling power save.
#################
#define ESC "\x1b"
#define CSI "\x1b["
#################
# Escape  HEX
# \a	07	Alarm (Beep, Bell)
# \b	08	Backspace
# \f	0C	Formfeed
# \n	0A	Newline (Line Feed); see notes below
# \r	0D	Carriage Return
# \t	09	Horizontal Tab
# \v	0B	Vertical Tab
# \\	5C	Backslash
# \'	27	Single quotation mark
# \"	22	Double quotation mark
# \?	3F	Question mark
# \nnn	any	The character whose numerical value is given by nnn interpreted as an octal number
# \xhh	any	The character whose numerical value is given by hh interpreted as a hexadecimal number
############################
# ANSI Escape sequences (ANSI Escape codes)
# ANSI Escape sequences	 |  VT100 / VT52 ANSI escape sequences|VT100 User Guide
#
# These sequences define functions that change display graphics,
# control cursor movement, and reassign keys.
# ANSI escape sequence is a sequence of ASCII characters,
# the first two of which are the ASCII "Escape" character 27 (1Bh)
# and the left-bracket character " [ " (5Bh).
# The character or characters following the escape and left-bracket characters
# specify an alphanumeric code that controls a keyboard or display function.
# ANSI escape sequences distinguish between uppercase and lowercase letters.
# Information is also available on VT100 / VT52 ANSI escape sequences.
#
############################

# Cursor Position: Esc[Line;ColumnH; Esc[Line;Columnf
# echo -ne "\033[$L;"$C"H"; # echo -ne "\033["$L";"$C"f"
# Moves the cursor to the specified position (coordinates $L;$C).
# If you do not specify a position, the cursor moves to the home position
# at the upper-left corner of the screen (line 0, column 0).
# This escape sequence works the same way as the following
# Cursor Position escape sequence.
#
# Cursor Up: Esc[ValueA # - echo -ne "\033["$N"A"
# Moves the cursor up by the specified number "$N" of lines
# without changing columns. If the cursor is already on the top line,
# ANSI.SYS ignores this sequence.
#
# Cursor Down: Esc[ValueB # - echo -ne "\033["$N"B"
# Moves the cursor down by the specified number "$N" of lines
# without changing columns. If the cursor is already on the bottom line,
# ANSI.SYS ignores this sequence.

# Cursor Forward: Esc["$N"C
# Moves the cursor forward by the specified number $N of columns
# without changing lines.
# If the cursor is already in the rightmost column,
# ANSI.SYS ignores this sequence.
#
# Cursor Backward: Esc["$N"D
# Moves the cursor back by the specified number $N of columns
# without changing lines.
# If the cursor is already in the leftmost column,
# ANSI.SYS ignores this sequence.

# Save Cursor Position: Esc[s
# Saves the current cursor position.
# You can move the cursor to the saved cursor position
# by using the Restore Cursor Position sequence.
#
# Restore Cursor Position: Esc[u
# Returns the cursor to the position stored by the Save Cursor Position sequence.
#

# Set Graphics Mode: Esc[Value;...;Valuem
# Calls the graphics functions specified by the following values.
# These specified functions remain active until
# the next occurrence of this escape sequence.
# Graphics mode changes the colors and attributes of text
# (such as bold and underline) displayed on the screen.

############################
# Parameters 30 through 47 meet the ISO 6429 standard.
#define ESC "\x1b"
#define CSI "\x1b["
# Esc[=Valueh	Set Mode:
# Changes the screen width or type to the mode specified
# by one of the following values:
#
# Screen resolution
# 0	40 x 25 monochrome (text)
# 1	40 x 25 color (text)
# 2	80 x 25 monochrome (text)
# 3	80 x 25 color (text)
# 4	320 x 200 4-color (graphics)
# 5	320 x 200 monochrome (graphics)
# 6	640 x 200 monochrome (graphics)
# 7	Enables line wrapping
# 13	320 x 200 color (graphics)
# 14	640 x 200 color (16-color graphics)
# 15	640 x 350 monochrome (2-color graphics)
# 16	640 x 350 color (16-color graphics)
# 17	640 x 480 monochrome (2-color graphics)
# 18	640 x 480 color (16-color graphics)
# 19	320 x 200 color (256-color graphics)
############################
# Esc[=Valuel	Reset Mode:
# Resets the mode by using the same values that Set Mode uses
# except for 7, which disables line wrapping
# (the last character in this escape sequence is a lowercase L).
############################

############################
# Esc[Code;String;...p	Set Keyboard Strings:
# Redefines a keyboard key to a specified string.
# The parameters for this escape sequence are defined as follows:
# Code is one or more of the values listed in the following table.
# These values represent keyboard keys and key combinations.
# When using these values in a command, you must type the semicolons shown
# in this table in addition to the semicolons required by the escape sequence.
# The codes in parentheses are not available on some keyboards.
# ANSI.SYS will not interpret the codes in parentheses for those keyboards
# unless you specify the /X switch in the DEVICE command for ANSI.SYS.
# String is either the ASCII code for a single character or a string
# contained in quotation marks. For example, both 65 and "A"
# can be used to represent an uppercase A.
# IMPORTANT: Some of the values in the following table are not valid
# for all computers.
# Check your computer's documentation for values that are different.
#
# Key	Code	SHIFT+code	CTRL+code	ALT+code
# F1	0;59	0;84	0;94	0;104
# F2	0;60	0;85	0;95	0;105
# F3	0;61	0;86	0;96	0;106
# F4	0;62	0;87	0;97	0;107
# F5	0;63	0;88	0;98	0;108
# F6	0;64	0;89	0;99	0;109
# F7	0;65	0;90	0;100	0;110
# F8	0;66	0;91	0;101	0;111
# F9	0;67	0;92	0;102	0;112
# F10	0;68	0;93	0;103	0;113
# F11	0;133	0;135	0;137	0;139
# F12	0;134	0;136	0;138	0;140
# HOME (num keypad)	0;71	55	0;119	--
# UP ARROW (num keypad)	0;72	56	(0;141)	--
# PAGE UP (num keypad)	0;73	57	0;132	--
# LEFT ARROW (num keypad)	0;75	52	0;115	--
# RIGHT ARROW (num keypad)	0;77	54	0;116	--
# END (num keypad)	0;79	49	0;117	--
# DOWN ARROW (num keypad)	0;80	50	(0;145)	--
# PAGE DOWN (num keypad)	0;81	51	0;118	--
# INSERT (num keypad)	0;82	48	(0;146)	--
# DELETE	(num keypad)	0;83	46	(0;147)	--
# HOME	(224;71)	(224;71)	(224;119)	(224;151)
# UP ARROW	(224;72)	(224;72)	(224;141)	(224;152)
# PAGE UP	(224;73)	(224;73)	(224;132)	(224;153)
# LEFT ARROW	(224;75)	(224;75)	(224;115)	(224;155)
# RIGHT ARROW	(224;77)	(224;77)	(224;116)	(224;157)
# END	(224;79)	(224;79)	(224;117)	(224;159)
# DOWN ARROW	(224;80)	(224;80)	(224;145)	(224;154)
# PAGE DOWN	(224;81)	(224;81)	(224;118)	(224;161)
# INSERT	(224;82)	(224;82)	(224;146)	(224;162)
# DELETE	(224;83)	(224;83)	(224;147)	(224;163)
# PRINT SCREEN	--	--	0;114	--
# PAUSE/BREAK	--	--	0;0	--
# BACKSPACE	8	8	127	(0)
# ENTER	13	--	10	(0
# TAB	9	0;15	(0;148)	(0;165)
# NULL	0;3	--	--	--
# A	97	65	1	0;30
# B	98	66	2	0;48
# C	99	66	3	0;46
# D	100	68	4	0;32
# E	101	69	5	0;18
# F	102	70	6	0;33
# G	103	71	7	0;34
# H	104	72	8	0;35
# I	105	73	9	0;23
# J	106	74	10	0;36
# K	107	75	11	0;37
# L	108	76	12	0;38
# M	109	77	13	0;50
# N	110	78	14	0;49
# O	111	79	15	0;24
# P	112	80	16	0;25
# Q	113	81	17	0;16
# R	114	82	18	0;19
# S	115	83	19	0;31
# T	116	84	20	0;20
# U	117	85	21	0;22
# V	118	86	22	0;47
# W	119	87	23	0;17
# X	120	88	24	0;45
# Y	121	89	25	0;21
# Z	122	90	26	0;44
# 1	49	33	--	0;120
# 2	50	64	0	0;121
# 3	51	35	--	0;122
# 4	52	36	--	0;123
# 5	53	37	--	0;124
# 6	54	94	30	0;125
# 7	55	38	--	0;126
# 8	56	42	--	0;126
# 9	57	40	--	0;127
# 0	48	41	--	0;129
# -	45	95	31	0;130
# =	61	43	---	0;131
# [	91	123	27	0;26
# ]	93	125	29	0;27
# 92	124	28	0;43
# ;	59	58	--	0;39
# '	39	34	--	0;40
# ,	44	60	--	0;51
# .	46	62	--	0;52
# /	47	63	--	0;53
# `	96	126	--	(0;41)
# ENTER (keypad)	13	--	10	(0;166)
# / (keypad)	47	47	(0;142)	(0;74)
# * (keypad)	42	(0;144)	(0;78)	--
# - (keypad)	45	45	(0;149)	(0;164)
# + (keypad)	43	43	(0;150)	(0;55)
# 5 (keypad)	(0;76)	53	(0;143)	--

#################

RegexBuddy—Better than a regular expression tutorial!
POSIX Bracket Expressions

POSIX bracket expressions are a special kind of character classes.
POSIX bracket expressions match one character out of a set of characters
just like regular character classes.
They use the same syntax with square brackets.
A hyphen creates a range, and a caret at the start negates the bracket expression.

One key syntactic difference is that the backslash is NOT a metacharacter
in a POSIX bracket expression.
So in POSIX, the regular expression [\d] matches a \ or a d. To match a ],
put it as the first character after the opening [ or the negating ^.
To match a -, put it right before the closing ].
To match a ^, put it before the final literal - or the closing ].
Put together, []\d^-] matches ], \, d, ^ or -.

The main purpose of bracket expressions is that they adapt
to the user's' or application's' locale.
A locale is a collection of rules and settings that describe language
and cultural conventions, like sort order, date format, etc.
The POSIX standard defines these locales.

Generally, only POSIX-compliant regular expression engines have proper
and full support for POSIX bracket expressions.
Some non-POSIX regex engines support POSIX character classes, but usually don't'
support collating sequences and character equivalents.
Regular expression engines that support Unicode use Unicode properties
and scripts to provide functionality similar to POSIX bracket expressions.
In Unicode regex engines, shorthand character classes like \w normally match
all relevant Unicode characters, alleviating the need to use locales.
 
Character Classes

Don't' confuse the POSIX term "character class" with what is normally called
a regular expression character class.
[x-z0-9] is an example of what this tutorial calls a "character class"
and what POSIX calls a "bracket expression".
[:digit:] is a POSIX character class, used inside a bracket expression
like [x-z[:digit:]].
The POSIX character class names must be written all lowercase.

When used on ASCII strings, these two regular expressions find exactly
the same matches: a single character that is either x, y, z, or a digit.
When used on strings with non-ASCII characters, the [:digit:] class
may include digits in other scripts, depending on the locale.

The POSIX standard defines 12 character classes. The table below lists all 12,
plus the [:ascii:] and [:word:] classes that some regex flavors also support.
The table also shows equivalent character classes that you can use in ASCII
and Unicode regular expressions if the POSIX classes are unavailable.
The ASCII equivalents correspond exactly what is defined in the POSIX standard.
The Unicode equivalents correspond to what most Unicode regex engines match.
The POSIX standard does not define a Unicode locale. Some classes also have
Perl-style shorthand equivalents.

Java does not support POSIX bracket expressions, but does support
POSIX character classes using the \p operator.
Though the \p syntax is borrowed from the syntax for Unicode properties,
the POSIX classes in Java only match ASCII characters as indicated below.
The class names are case sensitive. Unlike the POSIX syntax which can only be
used inside a bracket expression, Java s \p can be used inside
and outside bracket expressions.

The JGsoft flavor supports both the POSIX and Java syntax.
Originally it matched Unicode characters using either syntax.
As of JGsoft V2, it matches only ASCII characters when using the POSIX syntax,
and Unicode characters when using the Java syntax.

POSIX	Description	ASCII	Unicode	Shorthand	Java
[:alnum:]	Alphanumeric characters	[a-zA-Z0-9]	[\p{L}\p{Nl}
 \p{Nd}]		\p{Alnum}
[:alpha:]	Alphabetic characters	[a-zA-Z]	\p{L}\p{Nl}		\p{Alpha}
[:ascii:]	ASCII characters	[\x00-\x7F]	\p{InBasicLatin}		\p{ASCII}
[:blank:]	Space and tab	[ \t]	[\p{Zs}\t]	\h	\p{Blank}
[:cntrl:]	Control characters	[\x00-\x1F\x7F]	\p{Cc}		\p{Cntrl}
[:digit:]	Digits	[0-9]	\p{Nd}	\d	\p{Digit}
[:graph:]	Visible characters (anything except spaces and control characters)	[\x21-\x7E]	[^\p{Z}\p{C}]		\p{Graph}
[:lower:]	Lowercase letters	[a-z]	\p{Ll}	\l	\p{Lower}
[:print:]	Visible characters and spaces (anything except control characters)	[\x20-\x7E]	\P{C}		\p{Print}
[:punct:]	Punctuation and symbols.	[!"\#$%&'()*+,
\-./:;<=>?@\[
\\\]^_`{|}~]	\p{P}		\p{Punct}
[:space:]	All whitespace characters, including line breaks	[ \t\r\n\v\f]	[\p{Z}\t\r\n\v\f]	\s	\p{Space}
[:upper:]	Uppercase letters	[A-Z]	\p{Lu}	\u	\p{Upper}
[:word:]	Word characters (letters, numbers and underscores)	[A-Za-z0-9_]	[\p{L}\p{Nl}
 \p{Nd}\p{Pc}]	\w	
[:xdigit:]	Hexadecimal digits	[A-Fa-f0-9]	[A-Fa-f0-9]		\p{XDigit}

 [[:alnum:]]  - [A-Za-z0-9]     Alphanumeric characters
 [[:alpha:]]  - [A-Za-z]        Alphabetic characters
 [[:blank:]]  - [ \x09]         Space or tab characters only
 [[:cntrl:]]  - [\x00-\x19\x7F] Control characters
 [[:digit:]]  - [0-9]           Numeric characters
 [[:graph:]]  - [!-~]           Printable and visible characters
 [[:lower:]]  - [a-z]           Lower-case alphabetic characters
 [[:print:]]  - [ -~]           Printable (non-Control) characters
 [[:punct:]]  - [!-/:-@[-`{-~]  Punctuation characters`
 [[:space:]]  - [ \t\v\f]       All whitespace chars
 [[:upper:]]  - [A-Z]           Upper-case alphabetic characters
 [[:xdigit:]] - [0-9a-fA-F]     Hexadecimal digit characters
##########################
Size suffixes
               Suffix    Units                   Byte Equivalent
               b         Blocks                  SIZE x 512
               B         Kilobytes               SIZE x 1024
               c         Bytes                   SIZE
               G         Gigabytes               SIZE x 1024^3
               K         Kilobytes               SIZE x 1024
               k         Kilobytes               SIZE x 1024
               M         Megabytes               SIZE x 1024^2
               P         Petabytes               SIZE x 1024^5
               T         Terabytes               SIZE x 1024^4
               w         Words                   SIZE x 2


comment ()
{
#################
# Variables for terminal requests.
[[ -t 2 && $TERM != dumb ]] && {
    COLUMNS=$({ tput cols   || tput co;} 2>&3) # Columns in a line
    LINES=$({   tput lines  || tput li;} 2>&3) # Lines on screen
    alt=$(      tput smcup  || tput ti      ) # Start alt display
    ealt=$(     tput rmcup  || tput te      ) # End   alt display
    hide=$(     tput civis  || tput vi      ) # Hide cursor
    show=$(     tput cnorm  || tput ve      ) # Show cursor
    save=$(     tput sc                     ) # Save cursor
    load=$(     tput rc                     ) # Load cursor
    dim=$(      tput dim    || tput mh      ) # Start dim
    bold=$(     tput bold   || tput md      ) # Start bold
    stout=$(    tput smso   || tput so      ) # Start stand-out
    estout=$(   tput rmso   || tput se      ) # End stand-out
    under=$(    tput smul   || tput us      ) # Start underline
    eunder=$(   tput rmul   || tput ue      ) # End   underline
    reset=$(    tput sgr0   || tput me      ) # Reset cursor
    blink=$(    tput blink  || tput mb      ) # Start blinking
    italic=$(   tput sitm   || tput ZH      ) # Start italic
    eitalic=$(  tput ritm   || tput ZR      ) # End   italic
[[ $TERM != *-m ]] && {
    red=$(      tput setaf 1|| tput AF 1    )
    green=$(    tput setaf 2|| tput AF 2    )
    yellow=$(   tput setaf 3|| tput AF 3    )
    blue=$(     tput setaf 4|| tput AF 4    )
    magenta=$(  tput setaf 5|| tput AF 5    )
    cyan=$(     tput setaf 6|| tput AF 6    )
}
    black=$(    tput setaf 0|| tput AF 0    )
    white=$(    tput setaf 7|| tput AF 7    )
    default=$(  tput op                     )
    eed=$(      tput ed     || tput cd      )   # Erase to end of display
    eel=$(      tput el     || tput ce      )   # Erase to end of line
    ebl=$(      tput el1    || tput cb      )   # Erase to beginning of line
    ewl=$eel$ebl                                # Erase whole line
    draw=$(     tput -S <<< '   enacs
                                smacs
                                acsc
                                rmacs' || { \
                tput eA; tput as;
                tput ac; tput ae;         } )   # Drawing characters
    back=$'\b'
} 3>&2 2>/dev/null ||:

# Variables for color terminal requests
[[ -t 2 ]] &&/
{
	alt=$(tput smcup||tput ti)	ealt=$(tput rmcup||tput te)	hide=$(tput civis||tput vi)	show=$(tput cnorm||tput ve)
	# Start alt display		# End alt display		# Hide cursor			# Show cursor
	save=$(tput sc)			load=$(tput rc)			stout=$(tput smso||tput so)	estout=$(tput rmso||tput se)
	# Save cursor			# Load cursor			# Start stand-out		# End stand-out
	under=$(tput smul||tput us)	eunder=$(tput rmul||tput ue)	italic=$(tput sitm||tput ZH)	eitalic=$(tput ritm||tput ZR)	
	# Start underline		# End underline			# Start italic	 		# End italic
	bold=$(tput bold||tput md)	blink=$(tput blink||tput mb)	reset=$(tput sgr0||tput me)	n=""$'\n'""
	# Start bold			# Start blinking		# Reset cursor 			# New line LF
[[ $TERM != *-m ]] &&/
	{
	Red=$( (tput setaf 1||tput AF 1) ) 		Green=$(tput setaf 2||tput AF 2)	Yellow=$(tput setaf 3&&tput bold|| tput AF 3)
	Orange=$(tput setaf 3||tput AF 3)	Blue=$(tput setaf 4||tput AF 4)		Magenta=$(tput setaf 5|| tput AF 5)
	Cyan=$(tput setaf 6||tput AF 6);};	White=$(tput setaf 7||tput AF 7)	Default=$(tput op)

	eed=$(tput ed||tput cd)		eel=$(tput el||tput ce)		ebl=$(tput el1||tput cb)	ewl=$eel$ebl
	# Erase to end of display	# Erase to end of line		# Erase to beginning of line	# Erase whole line
	draw=$(tput -S <<< 'enacs smacs acsc rmacs' || { \ tput eA; tput as; tput ac; tput ae; } )	back=""$'\b'""
	# Drawing characters;
} 2>/dev/null ||:

comment= <<-EOF
Notes on portability of tput
First time tput(1) source code was uploaded in September 1986
tput(1) has been available in X/Open curses semantics in 1990s 
(1997 standard has the semantics mentioned below).
So, it's (quite) ubiquitous.

There are also non-ANSI versions of the colour setting functions
(setb instead of setab, and setf instead of setaf)
which use different numbers, not given here.

Foreground & background colour commands

tput setab [1-7] # Set the background colour using ANSI escape
tput setaf [1-7] # Set the foreground colour using ANSI escape
Colours are as follows:

Num  Colour    #define         R G B

0    black     COLOR_BLACK     0,0,0
1    red       COLOR_RED       1,0,0
2    green     COLOR_GREEN     0,1,0
3    yellow    COLOR_YELLOW    1,1,0
4    blue      COLOR_BLUE      0,0,1
5    magenta   COLOR_MAGENTA   1,0,1
6    cyan      COLOR_CYAN      0,1,1
7    white     COLOR_WHITE     1,1,1

Text mode commands
tput bold    # Select bold mode
tput dim     # Select dim (half-bright) mode
tput smul    # Enable underline mode
tput rmul    # Disable underline mode
tput rev     # Turn on reverse video mode
tput smso    # Enter standout (bold) mode
tput rmso    # Exit standout mode

Cursor movement commands
tput cup Y X # Move cursor to screen postion X,Y (top left is 0,0)
tput cuf N   # Move N characters forward (right)
tput cub N   # Move N characters back (left)
tput cuu N   # Move N lines up
tput ll      # Move to last line, first column (if no cup)
tput sc      # Save the cursor position
tput rc      # Restore the cursor position
tput lines   # Output the number of lines of the terminal
tput cols    # Output the number of columns of the terminal

Clear and insert commands
tput ech N   # Erase N characters
tput clear   # Clear screen and move the cursor to 0,0
tput el 1    # Clear to beginning of line
tput el      # Clear to end of line
tput ed      # Clear to end of screen
tput ich N   # Insert N characters (moves rest of line forward!)
tput il N    # Insert N lines

Other commands
tput sgr0    # Reset text format to the terminal's default
tput bel     # Play a bell

##################################
Console Virtual Terminal Sequences

Rich Turner
Craig Loewen
Matt Wojciakowski
Michael Niksa

Virtual terminal sequences are control character sequences that can control
cursor movement, color/font mode, and other operations when written to the
output stream. Sequences may also be received on the input stream in response to
an output stream query information sequence or as an encoding of user input when
the appropriate mode is set.

You can use GetConsoleMode and SetConsoleMode flags to configure this behavior.

A sample of the suggested way to enable virtual terminal behaviors is included
at the end of this document.

The behavior of the following sequences is based on the VT100 and derived
terminal emulator technologies, most specifically the xterm terminal emulator.

More information about terminal sequences can be found at http://vt100.net and
at http://invisible-island.net/xterm/ctlseqs/ctlseqs.html.

Output Sequences
The following terminal sequences are intercepted by the console host when
written into the output stream, if the ENABLE_VIRTUAL_TERMINAL_PROCESSING flag
is set on the screen buffer handle using the SetConsoleMode flag. Note that the
DISABLE_NEWLINE_AUTO_RETURN flag may also be useful in emulating the cursor
positioning and scrolling behavior of other terminal emulators in relation to
characters written to the final column in any row.

Simple Cursor Positioning
In all of the following descriptions, ESC is always the hexadecimal value 0x1B.

No spaces are to be included in terminal sequences. For an example of how these
sequences are used in practice, please see the example at the end of this topic
The following table describes simple escape sequences with a single action
command directly after the ESC character. These sequences have no parameters and
take effect immediately.

All commands in this table are generally equivalent to calling the.
SetConsoleCursorPosition console API to place the cursor.
Cursor movement will be bounded by the current viewport into the buffer.
Scrolling (if available) will not occur.

Sequence	Shorthand	Behavior
ESC A	CUU	Cursor Up by 1
ESC B	CUD	Cursor Down by 1
ESC C	CUF	Cursor Forward (Right) by 1
ESC D	CUB	Cursor Backward (Left) by 1
ESC M	RI	Reverse Index – Performs the reverse operation of \n, moves
		cursor up one line, maintains horizontal position, scrolls
		buffer if necessary*
ESC 7	DECSC	Save Cursor Position in Memory**
ESC 8	DECSR	Restore Cursor Position from Memory**

Note
* If there are scroll margins set, RI inside the margins will scroll only the
contents of the margins, and leave the viewport unchanged. (See Scrolling
Margins)
**There will be no value saved in memory until the first use of the save
command. The only way to access the saved value is with the restore command.

Cursor Positioning

The following tables encompass Control Sequence Introducer (CSI) type sequences.

All CSI sequences start with ESC (0x1B) followed by [ (left bracket, 0x5B) and
may contain parameters of variable length to specify more information for each
operation. This will be represented by the shorthand <n>. Each table below is
grouped by functionality with notes below each table explaining how the group
works.

For all parameters, the following rules apply unless otherwise noted:

<n> represents the distance to move and is an optional parameter
If <n> is omitted or equals 0, it will be treated as a 1
<n> cannot be larger than 32,767 (maximum short value)
<n> cannot be negative
All commands in this section are generally equivalent to calling the
SetConsoleCursorPosition console API.

Cursor movement will be bounded by the current viewport into the buffer.
Scrolling (if available) will not occur.

Sequence	Code	Description	Behavior
ESC [ <n> A	CUU	Cursor Up	Cursor up by <n>
ESC [ <n> B	CUD	Cursor Down	Cursor down by <n>
ESC [ <n> C	CUF	Cursor Forward	Cursor forward (Right) by <n>
ESC [ <n> D	CUB	Cursor Backward	Cursor backward (Left) by <n>
ESC [ <n> E	CNL	Cursor Next Line
			Cursor down to beginning of <n>th line in the viewport
ESC [ <n> F	CPL	Cursor Previous Line
			Cursor up to beginning of <n>th line in the viewport
ESC [ <n> G	CHA	Cursor Horizontal Absolute Cursor moves to
			<n>th position horizontally in the current line
ESC [ <n> d	VPA	Vertical Line Position AbsoluteCursor moves to the
			<n>th position vertically in the current column
ESC [ <y> ; <x> H	CUP Cursor Position *Cursor moves to
			<x>; <y> coordinate within the viewport
			, where <x> is the column of the <y> line
ESC [ <y> ; <x> f	HVP Horizontal Vertical Position
			*Cursor moves to <x>; <y> coordinate within the viewport
			, where <x> is the column of the <y> line
ESC [ s	ANSISYSSC	Save Cursor – Ansi.sys emulation **With no parameters,
			performs a save cursor operation like DECSC
ESC [ u	ANSISYSSC	Restore Cursor – Ansi.sys emulation **With no parameters
			, performs a restore cursor operation like DECRC
Note
*<x> and <y> parameters have the same limitations as <n> above.
If <x> and <y> are omitted, they will be set to 1;1.

**ANSI.sys historical documentation can be found at
https://msdn.microsoft.com/library/cc722862.aspx
and is implemented for convenience/compatibility.

Cursor Visibility

The following commands control the visibility of the cursor and it’s blinking
state.

The DECTCEM sequences are generally equivalent to calling SetConsoleCursorInfo
console API to toggle cursor visibility.

Sequence	Code	Description	Behavior
ESC [ ? 12 h	ATT160	Text Cursor Enable Blinking    Start the cursor blinking
ESC [ ? 12 l	ATT160	Text Cursor Enable Blinking    Stop blinking the cursor
ESC [ ? 25 h	DECTCEM	Text Cursor Enable Mode Show   Show the cursor
ESC [ ? 25 l	DECTCEM	Text Cursor Enable Mode Hide   Hide the cursor

Viewport Positioning

All commands in this section are generally equivalent to calling
ScrollConsoleScreenBuffer console API to move the contents of the console
buffer.

Caution The command names are misleading. Scroll refers to which direction the
text moves during the operation, not which way the viewport would seem to move.

Sequence	Code	Description	Behavior
ESC [ <n> S	SU	Scroll Up	Scroll text up by <n>. Also known as pan
					down, new lines fill in from the bottom
					of the screen
ESC [ <n> T	SD	Scroll Down	Scroll down by <n>. Also known as
					pan up, new lines fill in from
					the top of the screen

The text is moved starting with the line the cursor is on. If the cursor is on
the middle row of the viewport, then scroll up would move the bottom half of the
viewport, and insert blank lines at the bottom.

Scroll down would move the top half of the viewport’s rows, and insert new lines
at the top.

Also important to note is scroll up and down are also affected by the scrolling
margins.

Scroll up and down won’t affect any lines outside the scrolling margins.

The default value for <n> is 1, and the value can be optionally omitted.

Text Modification

All commands in this section are generally equivalent to calling
FillConsoleOutputCharacter, FillConsoleOutputAttribute, and
ScrollConsoleScreenBuffer console APIs to modify the text buffer contents.

Sequence	Code	Description	Behavior
ESC [ <n> @	ICH	Insert Character	Insert <n> spaces at the current
cursor position, shifting all existing text to the right.

Text exiting the screen to the right is removed.

ESC [ <n> P	DCH	Delete Character	Delete <n> characters at the
current cursor position, shifting in space characters
from the right edge of the screen.

ESC [ <n> X	ECH	Erase Character	Erase <n> characters from the current
cursor position by overwriting them with a space character.

ESC [ <n> L	IL	Insert Line	Inserts <n> lines into the buffer at the
cursor position. The line the cursor is on, and lines below it, will be shifted
downwards.

ESC [ <n> M	DL	Delete Line	Deletes <n> lines from the buffer
starting with the row the cursor is on.

Note
For IL and DL, only the lines in the scrolling margins (see Scrolling Margins)
are affected.

If no margins are set, the default margin borders are the current
viewport.

If lines would be shifted below the margins, they are discarded.

When lines are deleted, blank lines are inserted at the bottom of the margins
lines from outside the viewport are never affected.

For each of the sequences, the default value for <n> if it is omitted is 1.

For the following commands, the parameter <n> has 3 valid values:

0 erases from the beginning of the line/display up to and including the current
cursor position
1 erases from the current cursor position (inclusive) to the end of the
line/display
2 erases the entire line/display

Sequence	Code	Description	Behavior
ESC [ <n> J	ED	Erase in Display Replace all text in the current
viewport/screen specified by <n> with space characters

ESC [ <n> K	EL	Erase in Line Replace all text on the line with the
cursor specified by <n> with space characters

Text Formatting

All commands in this section are generally equivalent to calling
SetConsoleTextAttribute console APIs to adjust the formatting of all future
writes to the console output text buffer.

This command is special in that the <n> position below can accept between 0 and
16 parameters separated by semicolons.

When no parameters are specified, it is treated the same as a single 0
parameter.

Sequence	Code	Description	Behavior
ESC [ <n> m	SGR	Set Graphics Rendition
Set the format of the screen and text as specified by <n>

The following table of values can be used in <n> to represent different
formatting modes.

Formatting modes are applied from left to right. Applying competing formatting
options will result in the right-most option taking precedence.

For options that specify colors, the colors will be used as defined in the
console color table which can be modified using the SetConsoleScreenBufferInfoEx
API.

If the table is modified to make the “blue” position in the table display
an RGB shade of red, then all calls to Foreground Blue will display that red
color until otherwise changed.

Value	Description	Behavior
0	Default	Returns all attributes to the default state prior to modification
1	Bold/Bright	Applies brightness/intensity flag to foreground color
4	Underline	Adds underline
24	No underline	Removes underline
7	Negative	Swaps foreground and background colors
27	Positive (No negative)	Returns foreground/background to normal
30	Foreground Black	Applies non-bold/bright black to foreground
31	Foreground Red	Applies non-bold/bright red to foreground
32	Foreground Green	Applies non-bold/bright green to foreground
33	Foreground Yellow	Applies non-bold/bright yellow to foreground
34	Foreground Blue	Applies non-bold/bright blue to foreground
35	Foreground Magenta	Applies non-bold/bright magenta to foreground
36	Foreground Cyan	Applies non-bold/bright cyan to foreground
37	Foreground White	Applies non-bold/bright white to foreground
38	Foreground Extended	Applies extended color value to the foreground (see details below)
39	Foreground Default	Applies only the foreground portion of the defaults (see 0)
40	Background Black	Applies non-bold/bright black to background
41	Background Red	Applies non-bold/bright red to background
42	Background Green	Applies non-bold/bright green to background
43	Background Yellow	Applies non-bold/bright yellow to background
44	Background Blue	Applies non-bold/bright blue to background
45	Background Magenta	Applies non-bold/bright magenta to background
46	Background Cyan	Applies non-bold/bright cyan to background
47	Background White	Applies non-bold/bright white to background
48	Background Extended	Applies extended color value to the background (see details below)
49	Background Default	Applies only the background portion of the defaults (see 0)
90	Bright Foreground Black	Applies bold/bright black to foreground
91	Bright Foreground Red	Applies bold/bright red to foreground
92	Bright Foreground Green	Applies bold/bright green to foreground
93	Bright Foreground Yellow	Applies bold/bright yellow to foreground
94	Bright Foreground Blue	Applies bold/bright blue to foreground
95	Bright Foreground Magenta	Applies bold/bright magenta to foreground
96	Bright Foreground Cyan	Applies bold/bright cyan to foreground
97	Bright Foreground White	Applies bold/bright white to foreground
100	Bright Background Black	Applies bold/bright black to background
101	Bright Background Red	Applies bold/bright red to background
102	Bright Background Green	Applies bold/bright green to background
103	Bright Background Yellow	Applies bold/bright yellow to background
104	Bright Background Blue	Applies bold/bright blue to background
105	Bright Background Magenta	Applies bold/bright magenta to background
106	Bright Background Cyan	Applies bold/bright cyan to background
107	Bright Background White	Applies bold/bright white to background

Extended Colors

Some virtual terminal emulators support a palette of colors greater than the 16
colors provided by the Windows Console.

For these extended colors, the Windows Console will choose the nearest
appropriate color from the existing 16 color table for display.

Unlike typical SGR values above, the extended values will consume additional
parameters after the initial indicator according to the table below.

SGR Subsequence	Description
38 ; 2 ; <r> ; <g> ; <b>	Set foreground color to RGB value specified
48 ; 2 ; <r> ; <g> ; <b>	Set background color to RGB value specified

38 ; 5 ; <s>	Set foreground color to <s> index in 88 or 256 color table*
48 ; 5 ; <s>	Set background color to <s> index in 88 or 256 color table*

*The 88 and 256 color palettes maintained internally for comparison are based
from the xterm terminal emulator.

The comparison/rounding tables cannot be modified at this time.

Mode Changes

These are sequences that control the input modes.

There are two different sets of input modes,
the Cursor Keys Mode and the Keypad Keys Mode.

The Cursor Keys Mode controls the sequences that are emitted by the arrow keys
as well as Home and End, while the Keypad Keys Mode controls the sequences
emitted by the keys on the numpad primarily, as well as the function keys.

Each of these modes are simple boolean settings – the Cursor Keys Mode is either
Normal (default) or Application,
and the Keypad Keys Mode is either Numeric (default) or Application.

See the Cursor Keys and Numpad & Function Keys sections for the sequences
emitted in these modes.

Sequence	Code	Description	Behavior
ESC =	DECKPAM	Enable Keypad Application Mode	Keypad keys will emit their
Application Mode sequences.

ESC >	DECKPNM	Enable Keypad Numeric Mode	Keypad keys will emit their
Numeric Mode sequences.

ESC [ ? 1 h	DECCKM	Enable Cursor Keys Application Mode	Keypad keys will
emit their Application Mode sequences.

ESC [ ? 1 l	DECCKM	Disable Cursor Keys Application Mode (use Normal Mode)	
Keypad keys will emit their Numeric Mode sequences.

Query State

All commands in this section are generally equivalent to calling Get* console
APIs to retrieve status information about the current console buffer state

Note These queries will emit their responses into the console input stream
immediately after being recognized on the output stream while
ENABLE_VIRTUAL_TERMINAL_PROCESSING is set.

The ENABLE_VIRTUAL_TERMINAL_INPUT flag does not apply to query commands
as it is assumed that an application making the query will always want
to receive the reply.

Sequence	Code	Description	Behavior
ESC [ 6 n	DECXCPR	Report Cursor Position	Emit the cursor position as
: ESC [ <r> ; <c> R Where <r> = cursor row and <c> = cursor column

ESC [ 0 c	DA	Device Attributes	Report the terminal identity.

Will emit “\x1b[?1;0c”, indicating "VT101 with No Options".

Tabs

While the windows console traditionally expects tabs to be exclusively eight
characters wide, *nix applications utilizing certain sequences can manipulate
where the tab stops are within the console windows to optimize cursor movement
by the application.

The following sequences allow an application to set the tab stop locations
within the console window, remove them, and navigate between them.

Sequence	Code	Description	Behavior

ESC H	HTS	Horizontal Tab Set	Sets a tab stop in the current column
the cursor is in.

ESC [ <n> I	CHT	Cursor Horizontal (Forward) Tab	Advance the cursor to
the next column (in the same row) with a tab stop. If there are no more tab
stops, move to the last column in the row.

If the cursor is in the last column,
move to the first column of the next row.

ESC [ <n> Z	CBT	Cursor Backwards Tab	Move the cursor to the previous
column (in the same row) with a tab stop.

If there are no more tab stops, moves the cursor to the first column.

If the cursor is in the first column, doesn’t move the cursor.

ESC [ 0 g	TBC	Tab Clear (current column)	Clears the tab stop in
the current column, if there is one.

Otherwise does nothing.

ESC [ 3 g	TBC	Tab Clear (all columns)	Clears all currently set tab
stops.

For both CHT and CBT, <n> is an optional parameter that (default=1) indicating
how many times to advance the cursor in the specified direction.

If there are no tab stops set via HTS, CHT and CBT will treat the first and last
columns of the window as the only two tab stops.

Using HTS to set a tab stop will also cause the console to navigate to the next
tab stop on the output of a TAB (0x09, ‘\t’) character, in the same manner as
CHT.

Designate Character Set

The following sequences allow a program to change the active character set
mapping.

This allows a program to emit 7-bit ASCII characters, but have them
displayed as other glyphs on the terminal screen itself. Currently, the only two
supported character sets are ASCII (default) and the DEC Special Graphics
Character Set.

See http://vt100.net/docs/vt220-rm/table2-4.html for a listing of all of the
characters represented by the DEC Special Graphics Character Set.

Sequence	Description	Behavior
ESC ( 0	Designate Character Set – DEC Line Drawing Enables DEC Line Drawing Mode
ESC ( B	Designate Character Set – US ASCII Enables ASCII Mode (Default)

Notably, the DEC Line Drawing mode is used for drawing borders in console
applications.

The following table shows what ASCII character maps to which line
drawing character.

Hex	ASCII	DEC Line Drawing
0x6a	j	┘
0x6b	k	┐
0x6c	l	┌
0x6d	m	└
0x6e	n	┼
0x71	q	─
0x74	t	├
0x75	u	┤
0x76	v	┴
0x77	w	┬
0x78	x	│


Scrolling Margins

The following sequences allow a program to configure the “scrolling region” of
the screen that is affected by scrolling operations.

This is a subset of the rows that are adjusted when the screen would otherwise
scroll, for example, on a ‘\n’ or RI.

These margins also affect the rows modified by Insert Line (IL) and Delete Line
(DL), Scroll Up (SU) and Scroll Down (SD).

The scrolling margins can be especially useful for having a portion of the
screen that doesn’t scroll when the rest of the screen is filled,
such as having a title bar at the top or a status bar
at the bottom of your application.

For DECSTBM, there are two optional parameters, <t> and <b>,
which are used to specify the rows that represent the top and bottom lines
of the scroll region, inclusive.

If the parameters are omitted, <t> defaults to 1 and <b> defaults to the current
viewport height.

Scrolling margins are per-buffer, so importantly, the Alternate Buffer and Main
Buffer maintain separate scrolling margins settings

(so a full screen application in the alternate buffer
will not poison the main buffer’s margins)

Sequence	Code	Description	Behavior
ESC [ <t> ; <b> r	DECSTBM	Set Scrolling Region
Sets the VT scrolling margins of the viewport.

Window Title

The following commands allows the application to set the title of the console
window to the given <string> parameter.

The string must be less than 255 characters to be accepted.

This is equivalent to calling SetConsoleTitle with the given string.

Note that these sequences are OSC “Operating system command” sequences, and not
a CSI like many of the other sequences listed, and as such starts with “\x1b]”,
not “\x1b[”.

Sequence	Description	Behavior
ESC ] 0 ; <string> BEL	Set Icon and Window Title
ESC ] 2 ; <string> BEL	Set Window Title

The terminating character here is the “Bell” character, ‘\x07’

Alternate Screen Buffer

*Nix style applications often utilize an alternate screen buffer,
so that they can modify the entire contents of the buffer,
without affecting the application that started them.

The alternate buffer is exactly the dimensions of the window,
without any scrollback region.

For an example of this behavior, consider when vim is launched from bash.

Vim uses the entirety of the screen to edit the file,
then returning to bash leaves the original buffer unchanged.

Sequence	Description	Behavior
ESC [ ? 1 0 4 9 h Use Alternate Screen Buffer
Switches to a new alternate screen buffer.

ESC [ ? 1 0 4 9 l Use Alternate Screen Buffer
Switches to the main buffer.

Window Width

The following sequences can be used to control the width of the console window.

They are roughly equivalent to the calling the SetConsoleScreenBufferInfoEx
console API to set the window width.

Sequence	Code	Description	Behavior
ESC [ ? 3 h	DECCOLM	Set Number of Columns to 132
ESC [ ? 3 l	DECCOLM	Set Number of Columns to 80

Soft Reset

The following sequence can be used to reset certain properties to their default
values.

The following properties are reset to the following default values
(also listed are the sequences that control those properties):

Cursor visibility: visible (DECTEM)
Numeric Keypad: Numeric Mode (DECNKM)
Cursor Keys Mode: Normal Mode (DECCKM)

Top and Bottom Margins: Top=1
Bottom=Console height (DECSTBM) Character Set: US ASCII

Graphics Rendition: Default/Off (SGR)
Save cursor state: Home position (0,0) (DECSC)

Sequence	Code	Description	Behavior

ESC [ ! p	DECSTR	Soft Reset
Reset certain terminal settings to their defaults.

Input Sequences

The following terminal sequences are emitted by the console host on the input
stream if the ENABLE_VIRTUAL_TERMINAL_INPUT flag is set on the input buffer
handle using the SetConsoleMode flag.

There are two internal modes that control which sequences are emitted for the
given input keys, the Cursor Keys Mode and the Keypad Keys Mode.

These are described in the Mode Changes section.

Cursor Keys

Key	Normal Mode	Application Mode
Up Arrow	ESC [ A	ESC O A
Down Arrow	ESC [ B	ESC O B
Right Arrow	ESC [ C	ESC O C
Left Arrow	ESC [ D	ESC O D
Home	ESC [ H	ESC O H
End	ESC [ F	ESC O F

Additionally, if Ctrl is pressed with any of these keys, the following sequences
are emitted instead, regardless of the Cursor Keys Mode:

Key	Any Mode
Ctrl + Up Arrow	ESC [ 1 ; 5 A
Ctrl + Down Arrow	ESC [ 1 ; 5 B
Ctrl + Right Arrow	ESC [ 1 ; 5 C
Ctrl + Left Arrow	ESC [ 1 ; 5 D
Numpad & Function Keys

Key	Sequence
Backspace	0x7f (DEL)
Pause	0x1a (SUB)
Escape	0x1b (ESC)
Insert	ESC [ 2 ~
Delete	ESC [ 3 ~
Page Up	ESC [ 5 ~
Page Down	ESC [ 6 ~
F1	ESC O P
F2	ESC O Q
F3	ESC O R
F4	ESC O S
F5	ESC [ 1 5 ~
F6	ESC [ 1 7 ~
F7	ESC [ 1 8 ~
F8	ESC [ 1 9 ~
F9	ESC [ 2 0 ~
F10	ESC [ 2 1 ~
F11	ESC [ 2 3 ~
F12	ESC [ 2 4 ~

Modifiers

Alt is treated by prefixing the sequence with an escape: ESC <c> where <c> is
the character passed by the operating system.

Alt+Ctrl is handled the same way
except that the operating system will have pre-shifted the <c> key to the
appropriate control character which will be relayed to the application.

Ctrl is generally passed through exactly as received from the system.

This is typically a single character shifted down into the control character
reserved space (0x0-0x1f).

For example, Ctrl+@ (0x40) becomes NUL (0x00), Ctrl+[ (0x5b) becomes ESC (0x1b)
etc.

A few Ctrl key combinations are treated specially according to the following
table:

Key	Sequence
Ctrl + Space	0x00 (NUL)
Ctrl + Up Arrow	ESC [ 1 ; 5 A
Ctrl + Down Arrow	ESC [ 1 ; 5 B
Ctrl + Right Arrow	ESC [ 1 ; 5 C
Ctrl + Left Arrow	ESC [ 1 ; 5 D

Note Left Ctrl + Right Alt is treated as AltGr.

When both are seen together, they will be stripped and the Unicode value
of the character presented by the system will be passed into the target.

The system will pre-translate AltGr values according
to the current system input settings.
`
############################

Summary of ANSI standards for ASCII terminals		Joe Smith, 18-May-84

Contents:
  1.  Overview and Definitions
  2.  General rules for interpreting an ESCape Sequence
  3.  General rules for interpreting a Control Sequence
  4.  C0 and C1 control codes in numeric order
  5.  Two and three-character ESCape Sequences in numeric order
  6.  Control Sequences in numeric order
  7.  VT100 emulation requirements

The VT100 USER GUIDE and ANSI standard X3.64-1979 both list the ANSI ESCape
sequences in alphabetic order by mnemonic, but do not have a have a cross
reference in order by ASCII code.  This paper lists the combination of all
definitions from the three ANSI standards in numeric order.  For a description
of the advantages of using these standards, see the article "Toward
Standardized Video Terminals" in the April-1984 issue of BYTE magazine.

ANSI X3.4-1977 defines the 7-bit ASCII character set (C0 and G0).  It was
written in 1968, revised in 1977, and explains the decisions made in laying out
the ASCII code.  In particular, it explains why ANSI chose to make ASCII
incompatible with EBCDIC in order to make it self-consistant.

ANSI X3.41-1974 introduces the idea of an 8-bit ASCII character set (C1 and G1
in addition to the existing C0 and G0).  It describes how to use the 8-bit
features in a 7-bit environment.  X3.41 defines the format of all ESCape
sequences, but defines only the 3-character ones with a parameter character
in the middle.  These instruct the terminal how to interpret the C0, G0, C1,
and G1 characters (such as by selecting different character-set ROMs).

  Note: NAPLPS does videotex graphics by redefining the C1 set and
        selecting alternate G0, G1, G2, and G3 sets.
  See the February 1983 issue of BYTE magazine for details.

ANSI X3.64-1979 defines the remaining ESCape sequences.  It defines all the C1
control characters, and specifies that certain two-character ESCape sequences
in the 7-bit environment are to act exactly like the 8-bit C1 control set.
X3.64 introduces the idea of a Control-Sequence, which starts with CSI
character, has an indefinite length, and is terminated by an alphabetic
character.  The VT100 was one of the first terminals to implement this
standard.

Definitions:

  Control Character - A single character with an ASCII code with the range
  of 000 to 037 and 200 to 237 octal, 00 to 1F and 80 to 9F hex.

  Escape Sequence - A two or three character string staring with ESCape.
  (Four or more character strings are allowed but not defined.)

  Control Sequence - A string starting with CSI (233 octal, 9B hex) or
  with ESCape Left-Bracket, and terminated by an alphabetic character.
  Any number of parameter characters (digits 0 to 9, semicolon, and
  question mark) may appear within the Control Sequence.  The terminating
  character may be preceded by an intermediate character (such as space).
Character classifications:

C0 Control	000-037 octal, 00-1F hex  (G0 is 041-176 octal, 21-7E hex)
SPACE		040+240 octal, 20+A0 hex  Always and everywhere a blank space
Intermediate	040-057 octal, 20-2F hex   !"#$%&'()*+,-./
Parameters	060-077 octal, 30-3F hex  0123456789:;<=>?
Uppercase	100-137 octal, 40-5F hex  @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
Lowercase	140-176 octal, 60-7E hex  `abcdefghijlkmnopqrstuvwxyz{|}~
Alphabetic	100-176 octal, 40-7E hex  (all of upper and lower case)
Delete		    177 octal,    7F hex  Always and everywhere ignored
C1 Control	200-237 octal, 80-9F hex  32 additional control characters
G1 Displayable	241-376 octal, A1-FE hex  94 additional displayable characters
Special		240+377 octal, A0+FF hex  Same as SPACE and DELETE

Note that in this paper, the terms uppercase, lowercase, and alphabetics
include more characters than just A to Z.

------------------------------------------------------------------------------

General rules for interpreting an ESCape Sequence:

  An ESCape Sequence starts with the ESC character (033 octal, 1B hex).
The length of the ESCape Sequence depends on the character that immediately
follows the ESCape.

If the next character is
   C0 control:	 Interpret it first, then resume processing ESCape sequence.
     Example:  CR, LF, XON, and XOFF work as normal within an ESCape sequence.
   Intermediate: Expect zero or more intermediates, a parameter terminates
     a private function, an alphabetic terminates a standard sequence.
     Example:  ESC ( A defines standard character set, ESC ( 0 a DEC set.
   Parameter:	 End of a private 2-character escape sequence.
     Example:  ESC = sets special keypad mode, ESC > clears it.
   Uppercase:	 Translate it into a C1 control character and act on it.
     Example:  ESC D does indexes down, ESC M indexes up.  (CSI is special)
   Lowercase:	 End of a standard 2-character escape sequence.
     Example:  ESC c resets the terminal.
   Delete:	 Ignore it, and continue interpreting the ESCape sequence
   C1 and G1:	 Treat the same as their 7-bit counterparts

  Note that CSI is the two-character sequence ESCape left-bracket or the 8-bit
C1 code of 233 octal, 9B hex.  CSI introduces a Control Sequence, which
continues until an alphabetic character is received.

General rules for interpreting a Control Sequence:

1) It starts with CSI, the Control Sequence Introducer.
2) It contains any number of parameter characters (0123456789:;<=>?).
3) It terminates with an alphabetic character.
4) Intermediate characters (if any) immediately precede the terminator.

If the first character after CSI is one of "<=>?" (074-077 octal, 3C-3F hex),
then Control Sequence is to be interpreted according to private standards (such
as setting and resetting modes not defined by ANSI).  The terminal should
expect any number of numeric parameters, separated by semicolons (073 octal,
3B hex).  Only after the terminating alphabetic character is received should
the terminal act on the Control Sequence.

=============================================================================
    C0 set of 7-bit control characters (from ANSI X3.4-1977).

Oct Hex Name *	(* marks function used in DEC VT series or LA series terminals)
--- -- - --- -	--------------------------------------------------------------
000 00 @ NUL *	Null filler, terminal should ignore this character
001 01 A SOH	Start of Header
002 02 B STX	Start of Text, implied end of header
003 03 C ETX	End of Text, causes some terminal to respond with ACK or NAK
004 04 D EOT	End of Transmission
005 05 E ENQ *	Enquiry, causes terminal to send ANSWER-BACK ID
006 06 F ACK	Acknowledge, usually sent by terminal in response to ETX
007 07 G BEL *	Bell, triggers the bell, buzzer, or beeper on the terminal
010 08 H BS  *	Backspace, can be used to define overstruck characters
011 09 I HT  *	Horizontal Tabulation, move to next predetermined position
012 0A J LF  *	Linefeed, move to same position on next line (see also NL)
013 0B K VT  *	Vertical Tabulation, move to next predetermined line
014 0C L FF  *	Form Feed, move to next form or page
015 0D M CR  *	Carriage Return, move to first character of current line
016 0E N SO  *	Shift Out, switch to G1 (other half of character set)
017 0F O SI  *	Shift In, switch to G0 (normal half of character set)
020 10 P DLE	Data Link Escape, interpret next control character specially
021 11 Q XON *	(DC1) Terminal is allowed to resume transmitting
022 12 R DC2	Device Control 2, causes ASR-33 to activate paper-tape reader
023 13 S XOFF*	(DC2) Terminal must pause and refrain from transmitting
024 14 T DC4	Device Control 4, causes ASR-33 to deactivate paper-tape reader
025 15 U NAK	Negative Acknowledge, used sometimes with ETX and ACK
026 16 V SYN	Synchronous Idle, used to maintain timing in Sync communication
027 17 W ETB	End of Transmission block
030 18 X CAN *	Cancel (makes VT100 abort current escape sequence if any)
031 19 Y EM	End of Medium
032 1A Z SUB *	Substitute (VT100 uses this to display parity errors)
033 1B [ ESC *	Prefix to an ESCape sequence
034 1C \ FS	File Separator
035 1D ] GS	Group Separator
036 1E ^ RS  *	Record Separator (sent by VT132 in block-transfer mode)
037 1F _ US	Unit Separator

040 20	 SP  *	Space (should never be defined to be otherwise)
177 7F	 DEL *	Delete, should be ignored by terminal

==============================================================================
    C1 set of 8-bit control characters (from ANSI X3.64-1979)

Oct Hex Name *	(* marks function used in DEC VT series or LA series terminals)
--- -- - --- -	--------------------------------------------------------------
200 80 @	Reserved for future standardization
201 81 A	Reserved
202 82 B	Reserved
203 83 C	Reserved
204 84 D IND *	Index, moves down one line same column regardless of NL
205 85 E NEL *	NEw Line, moves done one line and to first column (CR+LF)
206 86 F SSA	Start of Selected Area to be sent to auxiliary output device
207 87 G ESA	End of Selected Area to be sent to auxiliary output device
210 88 H HTS *	Horizontal Tabulation Set at current position
211 89 I HTJ	Hor Tab Justify, moves string to next tab position
212 8A J VTS	Vertical Tabulation Set at current line
213 8B K PLD	Partial Line Down (subscript)
214 8C L PLU	Partial Line Up (superscript)
215 8D M RI  *	Reverse Index, go up one line, reverse scroll if necessary
216 8E N SS2 *	Single Shift to G2
217 8F O SS3 *	Single Shift to G3 (VT100 uses this for sending PF keys)
220 90 P DCS *	Device Control String, terminated by ST (VT125 enters graphics)
221 91 Q PU1	Private Use 1
222 92 R PU2	Private Use 2
223 93 S STS	Set Transmit State
224 94 T CCH	Cancel CHaracter, ignore previous character
225 95 U MW	Message Waiting, turns on an indicator on the terminal
226 96 V SPA	Start of Protected Area
227 97 W EPA	End of Protected Area
230 98 X	Reserved for for future standard
231 99 Y	Reserved
232 9A Z     *	Reserved, but causes DEC terminals to respond with DA codes
233 9B [ CSI *	Control Sequence Introducer (described in a seperate table)
234 9C \ ST  *	String Terminator (VT125 exits graphics)
235 9D ] OSC	Operating System Command (reprograms intelligent terminal)
236 9E ^ PM	Privacy Message (password verification), terminated by ST
237 9F _ APC	Application Program Command (to word processor), term by ST

==============================================================================
    Character set selection sequences (from ANSI X3.41-1974)
    All are 3 characters long (including the ESCape).  Alphabetic characters
    as 3rd character are defined by ANSI, parameter characters as 3rd character
    may be interpreted differently by each terminal manufacturer.

Oct Hex   *	(* marks function used in DEC VT series or LA series terminals)
--- -- -- - ------------------------------------------------------------------
040 20	    ANNOUNCER - Determines whether to use 7-bit or 8-bit ASCII
	A   G0 only will be used.  Ignore SI, SO, and G1.
	B   G0 and G1 used internally.  SI and SO affect G0, G1 is ignored.
	C   G0 and G1 in an 8-bit only environment.  SI and SO are ignored.
	D   G0 and G1 are used, SI and SO affect G0.
	E
	F * 7-bit transmission, VT240/PRO350 sends CSI as two characters ESC [
	G * 8-bit transmission, VT240/PRO350 sends CSI as single 8-bit character
041 21 !    Select C0 control set (choice of 63 standard, 16 private)
042 22 "    Select C1 control set (choice of 63 standard, 16 private)
043 23 #    Translate next character to a special single character
       #3 * DECDHL1 - Double height line, top half
       #4 * DECDHL2 - Double height line, bottom half
       #5 * DECSWL - Single width line
       #6 * DECDWL - Double width line
       #7 * DECHCP - Make a hardcopy of the graphics screen (GIGI,VT125,VT241)
       #8 * DECALN - Alignment display, fill screen with "E" to adjust focus
044 24 $    MULTIBYTE CHARACTERS - Displayable characters require 2-bytes each
045 25 %    SPECIAL INTERPRETATION - Such as 9-bit data
046 26 &    Reserved for future standardization
047 27 '    Reserved for future standardization
050 28 (  * SCS - Select G0 character set (choice of 63 standard, 16 private)
       (0 * DEC VT100 line drawing set (affects lowercase characters)
       (1 * DEC Alternate character ROM set (RAM set on GIGI and VT220)
       (2 * DEC Alternate character ROM set with line drawing
       (5 * DEC Finnish on LA100
       (6 * DEC Norwegian/Danish on LA100
       (7 * DEC Swedish on LA100
       (9 * DEC French Canadian
       (< * DEC supplemental graphics (everything not in USASCII)
       (A * UKASCII (British pound sign)
       (B * USASCII (American pound sign)
       (C * ISO Finnish on LA120
       (E * ISO Norwegian/Danish on LA120
       (H * ISO Swedish on LA120
       (K * ISO German on LA100,LA120
       (R * ISO French on LA100,LA120
       (Y * ISO Italian on LA100
       (Z * ISO Spanish on LA100
051 29 )  * SCS - Select G1 character set (choice of 63 standard, 16 private)
          * (same character sets as listed under G0)
052 2A *  * SCS - Select G2 character set
          * (same character sets as listed under G0)
053 2B +  * SCS - Select G3 character set
          * (same character sets as listed under G0)
054 2C ,    SCS - Select G0 character set (additional 63+16 sets)
055 2D -    SCS - Select G1 character set (additional 63+16 sets)
056 2E .    SCS - Select G2 character set
057 2F /    SCS - Select G3 character set

==============================================================================
    Private two-character escape sequences (allowed by ANSI X3.41-1974)
    These can be defined differently by each terminal manufacturer.

Oct Hex  *	(* marks function used in DEC VT series or LA series terminals)
--- -- - - ------------------------------------------------------------------
060 30 0
061 31 1   DECGON graphics on for VT105, DECHTS horiz tab set for LA34/LA120
062 32 2   DECGOFF graphics off VT105, DECCAHT clear all horz tabs LA34/LA120
063 33 3   DECVTS  - set vertical tab for LA34/LA120
064 34 4   DECCAVT - clear all vertical tabs for LA34/LA120
065 35 5 * DECXMT  - Host requests that VT132 transmit as if ENTER were pressed
066 36 6
067 37 7 * DECSC   - Save cursor position and character attributes
070 38 8 * DECRC   - Restore cursor and attributes to previously saved position
071 39 9
072 3A :
073 3B ;
074 3C < * DECANSI - Switch from VT52 mode to VT100 mode
075 3D = * DECKPAM - Set keypad to applications mode (ESCape instead of digits)
076 3E > * DECKPNM - Set keypad to numeric mode (digits intead of ESCape seq)
077 3F ?

    DCS Device Control Strings used by DEC terminals (ends with ST)

Pp = Start ReGIS graphics (VT125, GIGI, VT240, PRO350)
Pq = Start SIXEL graphics (screen dump to LA34, LA100, screen load to VT125)
Pr = SET-UP data for GIGI, $PrVC0$\ disables both visible cursors.
Ps = Reprogram keys on the GIGI, $P0sDIR<CR>$\ makes keypad 0 send "DIR<CR>"
	0-9=digits on keypad, 10=ENTER, 11=minus, 12=comma, 13=period,
	14-17=PF1-PF4, 18-21=cursor keys.  Enabled by $[?23h (PK1).
Pt = Start VT105 graphics on a VT125

==============================================================================

    Standard two-character escape sequences (defined by ANSI X3.64-1979)

100 40 @ See description of C1 control characters
	 An ESCape followed by one of these uppercase characters is translated
	 to an 8-bit C1 control character before being interpreted.
220 90 P DCS - Device Control String, terminated by ST - see table above.
133 5B [ CSI - Control Sequence Introducer - see table below.
137 5F _ See description of C1 control characters

==============================================================================

    Indepenent control functions (from Appendix E of X3.64-1977).
    These four controls have the same meaning regardless of the current
    definition of the C0 and C1 control sets.  Each control is a two-character
    ESCape sequence, the 2nd character is lowercase.

Oct Hex  *  	(* marks function used in DEC VT series or LA series terminals)
--- -- - - --------------------------------------------------------------------
140 60 `   DMI - Disable Manual Input
141 61 a   INT - INTerrupt the terminal and do special action
142 62 b   EMI - Enable Manual Input
143 63 c * RIS - Reset to Initial State (VT100 does a power-on reset)
  ...            The remaining lowercase characters are reserved by ANSI.
153 6B k   NAPLPS lock-shift G1 to GR
154 6C l   NAPLPS lock-shift G2 to GR
155 6D m   NAPLPS lock-shift G3 to GR
156 6E n * LS2 - Shift G2 to GL (extension of SI) VT240,NAPLPS
157 6F o * LS3 - Shift G3 to GL (extension of SO) VT240,NAPLPS
  ...            The remaining lowercase characters are reserved by ANSI.
174 7C | * LS3R - VT240 lock-shift G3 to GR
175 7D } * LS2R - VT240 lock-shift G2 to GR
176 7E ~ * LS1R - VT240 lock-shift G1 to GR

==============================================================================
    Control Sequences (defined by ANSI X3.64-1979)

Control Sequences are started by either ESC [ or CSI and are terminated by an
"alphabetic" character (100 to 176 octal, 40 to 7E hex).  Intermediate
characters are space through slash (40 to 57 octal, 20 to 2F hex) and parameter
characters are zero through question mark (60 to 77 octal, 30 to 3F hex,
including digits and semicolon).  Parameters consist of zero or more decimal
numbers separated by semicolons.  Leading zeros are optional, leading blanks
are not allowed.  If no digits precede the final character, the default
parameter is used.  Many functions treat a parameter of 0 as if it were 1.

Oct Hex  *  	(* marks function used in DEC VT series or LA series terminals)
--- -- - - --------------------------------------------------------------------
100 40 @   ICH - Insert CHaracter
		[10@ = Make room for 10 characters at current position
101 41 A * CUU - CUrsor Up
	 *	[A = Move up one line, stop at top of screen, [9A = move up 9
102 42 B * CUD - CUrsor Down
	 *	[B = Move down one line, stop at bottom of screen
103 43 C * CUF - CUrsor Forward
	 *	[C = Move forward one position, stop at right edge of screen
104 44 D * CUB - CUrsor Backward
	 *	[D = Same as BackSpace, stop at left edge of screen
105 45 E   CNL - Cursor to Next Line
		[5E = Move to first position of 5th line down
106 46 F   CPL - Cursor to Previous Line
		[5F = Move to first position of 5th line previous
107 47 G   CHA - Cursor Horizontal position Absolute
		[40G = Move to column 40 of current line
110 48 H * CUP - CUrsor Position
	 *	[H = Home, [24;80H = Row 24, Column 80
111 49 I   CHT - Cursor Horizontal Tabulation
		[I = Same as HT (Control-I), [3I = Go forward 3 tabs
112 4A J * ED  - Erase in Display (cursor does not move)
	 *	[J = [0J = Erase from current position to end (inclusive)
	 *	[1J = Erase from beginning to current position (inclusive)
	 *	[2J = Erase entire display
	 *	[?0J = Selective erase in display ([?1J, [?2J similar)
113 4B K * EL  - Erase in Line (cursor does not move)
	 *	[K = [0K = Erase from current position to end (inclusive)
	 *	[1K = Erase from beginning to current position
	 *	[2K = Erase entire current line
	 *	[?0K = Selective erase to end of line ([?1K, [?2K similar)
114 4C L * IL  - Insert Line, current line moves down (VT102 series)
		[3L = Insert 3 lines if currently in scrolling region
115 4D M * DL  - Delete Line, lines below current move up (VT102 series)
		[2M = Delete 2 lines if currently in scrolling region
116 4E N   EF  - Erase in Field (as bounded by protected fields)
		[0N, [1N, [2N act like [L but within currend field
117 4F O   EA  - Erase in qualified Area (defined by DAQ)
		[0O, [1O, [2O act like [J but within current area
120 50 P * DCH - Delete Character, from current position to end of field
		[4P = Delete 4 characters, VT102 series
121 51 Q   SEM - Set Editing extent Mode (limits ICH and DCH)
		[0Q = [Q = Insert/delete character affects rest of display
		[1Q = ICH/DCH affect the current line only
		[2Q = ICH/DCH affect current field (between tab stops) only
		[3Q = ICH/DCH affect qualified area (between protected fields)
122 52 R * CPR - Cursor Position Report (from terminal to host)
	 *	[24;80R = Cursor is positioned at line 24 column 80
123 53 S   SU  - Scroll up, entire display is moved up, new lines at bottom
		[3S = Move everything up 3 lines, bring in 3 new lines
124 54 T   SD  - Scroll down, new lines inserted at top of screen
		[4T = Scroll down 4, bring previous lines back into view
125 55 U   NP  - Next Page (if terminal has more than 1 page of memory)
		[2U = Scroll forward 2 pages
126 56 V   PP  - Previous Page (if terminal remembers lines scrolled off top)
		[1V = Scroll backward 1 page
127 57 W   CTC - Cursor Tabulation Control
		[0W = Set horizontal tab for current line at current position
		[1W = Set vertical tab stop for current line of current page
		[2W = Clear horiz tab stop at current position of current line
		[3W = Clear vert tab stop at current line of current page
		[4W = Clear all horiz tab stops on current line only
		[5W = Clear all horiz tab stops for the entire terminal
		[6W = Clear all vert tabs stops for the entire terminal
130 58 X   ECH - Erase CHaracter
		[4X = Change next 4 characters to "erased" state
131 59 Y   CVT - Cursor Vertical Tab
		[2Y = Move forward to 2nd following vertical tab stop
132 5A Z   CBT - Cursor Back Tab
		[3Z = Move backwards to 3rd previous horizontal tab stop
133 5B [	Reserved for future standardization     left bracket
134 5C \	Reserved                                reverse slant
135 5D ]	Reserved                                right bracket
136 5E ^	Reserved                                circumflex
137 5F _	Reserved                                underscore
140 60 ` * HPA - Horizontal Position Absolute (depends on PUM)
		[720` = Move to 720 decipoints (1 inch) from left margin
	 *	[80` = Move to column 80 on LA120
141 61 a * HPR - Horizontal Position Relative (depends on PUM)
		[360a = Move 360 decipoints (1/2 inch) from current position
	 *	[40a = Move 40 columns to right of current position on LA120
142 62 b   REP - REPeat previous displayable character
		[80b = Repeat character 80 times
143 63 c * DA  - Device Attributes
	 *	[c = Terminal will identify itself
	 *	[?1;2c = Terminal is saying it is a VT100 with AVO
	 *	[>0c = Secondary DA request (distinguishes VT240 from VT220)
144 64 d * VPA - Vertical Position Absolute (depends on PUM)
		[90d = Move to 90 decipoints (1/8 inch) from top margin
	 *	[10d = Move to line 10 if before that else line 10 next page
145 65 e * VPR - Vertical Position Relative (depends on PUM)
		[720e = Move 720 decipoints (1 inch) down from current position
	 *	[6e = Advance 6 lines forward on LA120
146 66 f * HVP - Horizontal and Vertical Position (depends on PUM)
		[720,1440f = Move to 1 inch down and 2 inches over (decipoints)
	 *	[24;80f = Move to row 24 column 80 if PUM is set to character
147 67 g * TBC - Tabulation Clear
	 *	[0g = Clear horizontal tab stop at current position
	 *	[1g = Clear vertical tab stop at current line (LA120)
	 *	[2g = Clear all horizontal tab stops on current line only LA120
	 *	[3g = Clear all horizontal tab stops in the terminal
150 68 h * SM  - Set Mode (. means permanently set on VT100)
		[0h = Error, this command is ignored
	 *	[1h = GATM - Guarded Area Transmit Mode, send all (VT132)
		[2h = KAM - Keyboard Action Mode, disable keyboard input
		[3h = CRM - Control Representation Mode, show all control chars
	 *	[4h = IRM - Insertion/Replacement Mode, set insert mode (VT102)
		[5h = SRTM - Status Report Transfer Mode, report after DCS
	 *	[6h = ERM - ERasure Mode, erase protected and unprotected
		[7h = VEM - Vertical Editing Mode, IL/DL affect previous lines
		[8h, [9h are reserved
		[10h = HEM - Horizontal Editing mode, ICH/DCH/IRM go backwards
		[11h = PUM - Positioning Unit Mode, use decipoints for HVP/etc
	 .	[12h = SRM - Send Receive Mode, transmit without local echo
		[13h = FEAM - Format Effector Action Mode, FE's are stored
		[14h = FETM - Format Effector Transfer Mode, send only if stored
		[15h = MATM - Multiple Area Transfer Mode, send all areas
	 *	[16h = TTM - Transmit Termination Mode, send scrolling region
		[17h = SATM - Send Area Transmit Mode, send entire buffer
		[18h = TSM - Tabulation Stop Mode, lines are independent
		[19h = EBM - Editing Boundry Mode, all of memory affected
	 *	[20h = LNM - Linefeed Newline Mode, LF interpreted as CR LF
	 *	[?1h = DECCKM - Cursor Keys Mode, send ESC O A for cursor up
	 *	[?2h = DECANM - ANSI Mode, use ESC < to switch VT52 to ANSI
	 *	[?3h = DECCOLM - COLumn mode, 132 characters per line
	 *	[?4h = DECSCLM - SCrolL Mode, smooth scrolling
	 *	[?5h = DECSCNM - SCreeN Mode, black on white background
	 *	[?6h = DECOM - Origin Mode, line 1 is relative to scroll region
	 *	[?7h = DECAWM - AutoWrap Mode, start newline after column 80
	 *	[?8h = DECARM - Auto Repeat Mode, key will autorepeat
	 *	[?9h = DECINLM - INterLace Mode, interlaced for taking photos
	 *	[?10h = DECEDM - EDit Mode, VT132 is in EDIT mode
	 *	[?11h = DECLTM - Line Transmit Mode, ignore TTM, send line
		[?12h = ?
	 *	[?13h = DECSCFDM - Space Compression/Field Delimiting on,
	 *	[?14h = DECTEM - Transmit Execution Mode, transmit on ENTER
		[?15h = ?
	 *	[?16h = DECEKEM - Edit Key Execution Mode, EDIT key is local
		[?17h = ?
	 *	[?18h = DECPFF - Print FormFeed mode, send FF after printscreen
	 *	[?19h = DECPEXT - Print Extent mode, print entire screen
	 *	[?20h = OV1 - Overstrike, overlay characters on GIGI
	 *	[?21h = BA1 - Local BASIC, GIGI to keyboard and screen
	 *	[?22h = BA2 - Host BASIC, GIGI to host computer
	 *	[?23h = PK1 - GIGI numeric keypad sends reprogrammable sequences
	 *	[?24h = AH1 - Autohardcopy before erasing or rolling GIGI screen
	 *	[?29h =     - Use only the proper pitch for the LA100 font
	 *	[?38h = DECTEK - TEKtronix mode graphics
151 69 i * MC  - Media Copy (printer port on VT102)
	 *	[0i = Send contents of text screen to printer
		[1i = Fill screen from auxiliary input (printer's keyboard)
		[2i = Send screen to secondary output device
		[3i = Fill screen from secondary input device
	 *	[4i = Turn on copying received data to primary output (VT125)
	 *	[4i = Received data goes to VT102 screen, not to its printer
	 *	[5i = Turn off copying received data to primary output (VT125)
	 *	[5i = Received data goes to VT102's printer, not its screen
	 *	[6i = Turn off copying received data to secondary output (VT125)
	 *	[7i = Turn on copying received data to secondary output (VT125)
	 *	[?0i = Graphics screen dump goes to graphics printer VT125,VT240
	 *	[?1i = Print cursor line, terminated by CR LF
	 *	[?2i = Graphics screen dump goes to host computer VT125,VT240
	 *	[?4i = Disable auto print
	 *	[?5i = Auto print, send a line at a time when linefeed received
152 6A j	Reserved for future standardization
153 6B k	Reserved for future standardization
154 6C l * RM  - Reset Mode (. means permanently reset on VT100)
	 *	[1l = GATM - Transmit only unprotected characters (VT132)
	 .	[2l = KAM - Enable input from keyboard
	 .	[3l = CRM - Control characters are not displayable characters
	 *	[4l = IRM - Reset to replacement mode (VT102)
	 .	[5l = SRTM - Report only on command (DSR)
	 *	[6l = ERM - Erase only unprotected fields
	 .	[7l = VEM - IL/DL affect lines after current line
		[8l, [9l are reserved
	 .	[10l = HEM - ICH and IRM shove characters forward, DCH pulls
	 .	[11l = PUM - Use character positions for HPA/HPR/VPA/VPR/HVP
		[12l = SRM - Local echo - input from keyboard sent to screen
	 .	[13l = FEAM - HPA/VPA/SGR/etc are acted upon when received
	 .	[14l = FETM - Format Effectors are sent to the printer
		[15l = MATM - Send only current area if SATM is reset
	 *	[16l = TTM - Transmit partial page, up to cursor position
		[17l = SATM - Transmit areas bounded by SSA/ESA/DAQ
	 .	[18l = TSM - Setting a tab stop on one line affects all lines
	 .	[19l = EBM - Insert does not overflow to next page
	 *	[20l = LNM - Linefeed does not change horizontal position
	 *	[?1l = DECCKM - Cursor keys send ANSI cursor position commands
	 *	[?2l = DECANM - Use VT52 emulation instead of ANSI mode
	 *	[?3l = DECCOLM - 80 characters per line (erases screen)
	 *	[?4l = DECSCLM - Jump scrolling
	 *	[?5l = DECSCNM - Normal screen (white on black background)
	 *	[?6l = DECOM - Line numbers are independent of scrolling region
	 *	[?7l = DECAWM - Cursor remains at end of line after column 80
	 *	[?8l = DECARM - Keys do not repeat when held down
	 *	[?9l = DECINLM - Display is not interlaced to avoid flicker
	 *	[?10l = DECEDM - VT132 transmits all key presses
	 *	[?11l = DECLTM - Send page or partial page depending on TTM
		[?12l = ?
	 *	[?13l = DECSCFDM - Don't suppress trailing spaces on transmit
	 *	[?14l = DECTEM - ENTER sends ESC S (STS) a request to send
		[?15l = ?
	 *	[?16l = DECEKEM - EDIT key transmits either $[10h or $[10l
		[?17l = ?
	 *	[?18l = DECPFF - Don't send a formfeed after printing screen
	 *	[?19l = DECPEXT - Print only the lines within the scroll region
	 *	[?20l = OV0 - Space is destructive, replace not overstrike, GIGI
	 *	[?21l = BA0 - No BASIC, GIGI is On-Line or Local
	 *	[?22l = BA0 - No BASIC, GIGI is On-Line or Local
	 *	[?23l = PK0 - Ignore reprogramming on GIGI keypad and cursors
	 *	[?24l = AH0 - No auto-hardcopy when GIGI screen erased
	 *	[?29l = Allow all character pitches on the LA100
	 *	[?38l = DECTEK - Ignore TEKtronix graphics commands
155 6D m * SGR - Set Graphics Rendition (affects character attributes)
	 *	[0m = Clear all special attributes
	 *	[1m = Bold or increased intensity
	 *	[2m = Dim or secondary color on GIGI  (superscript on XXXXXX)
		[3m = Italic                          (subscript on XXXXXX)
	 *	[4m = Underscore, [0;4m = Clear, then set underline only
	 *	[5m = Slow blink
		[6m = Fast blink                      (overscore on XXXXXX)
	 *	[7m = Negative image, [0;1;7m = Bold + Inverse
		[8m = Concealed (do not display character echoed locally)
		[9m = Reserved for future standardization
	 *	[10m = Select primary font (LA100)
	 *	[11m - [19m = Selete alternate font (LA100 has 11 thru 14)
		[20m = FRAKTUR (whatever that means)
	 *	[22m = Cancel bold or dim attribute only (VT220)
	 *	[24m = Cancel underline attribute only (VT220)
	 *	[25m = Cancel fast or slow blink attribute only (VT220)
	 *	[27m = Cancel negative image attribute only (VT220)
	 *	[30m = Write with black,   [40m = Set background to black (GIGI)
	 *	[31m = Write with red,     [41m = Set background to red
	 *	[32m = Write with green,   [42m = Set background to green
	 *	[33m = Write with yellow,  [43m = Set background to yellow
	 *	[34m = Write with blue,    [44m = Set background to blue
	 *	[35m = Write with magenta, [45m = Set background to magenta
	 *	[36m = Write with cyan,    [46m = Set background to cyan
	 *	[37m = Write with white,   [47m = Set background to white
		[38m, [39m, [48m, [49m are reserved
156 6E n * DSR - Device Status Report
	 *	[0n = Terminal is ready, no malfunctions detected
		[1n = Terminal is busy, retry later
		[2n = Terminal is busy, it will send DSR when ready
	 *	[3n = Malfunction, please try again
		[4n = Malfunction, terminal will send DSR when ready
	 *	[5n = Command to terminal to report its status
	 *	[6n = Command to terminal requesting cursor position (CPR)
	 *	[?15n = Command to terminal requesting printer status, returns
		        [?10n = OK, [?11n = not OK, [?13n = no printer.
	 *	[?25n = "Are User Defined Keys Locked?" (VT220)
157 6F o   DAQ - Define Area Qualification starting at current position
		[0o = Accept all input, transmit on request
		[1o = Protected and guarded, accept no input, do not transmit
		[2o = Accept any printing character in this field
		[3o = Numeric only field
		[4o = Alphabetic (A-Z and a-z) only
		[5o = Right justify in area
		[3;6o = Zero fill in area
		[7o = Set horizontal tab stop, this is the start of the field
		[8o = Protected and unguarded, accept no input, do transmit
		[9o = Space fill in area

==============================================================================

    Private Control Sequences (allowed by ANSI X3.41-1974).
    These take parameter strings and terminate with the last half of lowercase.

Oct Hex  *  	(* marks function used in DEC VT series or LA series terminals)
--- -- - - --------------------------------------------------------------------
160 70 p * DECSTR - Soft Terminal Reset
		[!p = Soft Terminal Reset
161 71 q * DECLL - Load LEDs
		[0q = Turn off all, [?1;4q turns on L1 and L4, etc
		[154;155;157q = VT100 goes bonkers
		[2;23!q = Partial screen dump from GIGI to graphics printer
		[0"q = DECSCA Select Character Attributes off
		[1"q = DECSCA - designate set as non-erasable
		[2"q = DECSCA - designate set as erasable
162 72 r * DECSTBM - Set top and bottom margins (scroll region on VT100)
		[4;20r = Set top margin at line 4 and bottom at line 20
163 73 s * DECSTRM - Set left and right margins on LA100,LA120
		[5;130s = Set left margin at column 5 and right at column 130
164 74 t * DECSLPP - Set physical lines per page
		[66t = Paper has 66 lines (11 inches at 6 per inch)
165 75 u * DECSHTS - Set many horizontal tab stops at once on LA100
		[9;17;25;33;41;49;57;65;73;81u = Set standard tab stops
166 76 v * DECSVTS - Set many vertical tab stops at once on LA100
		[1;16;31;45v = Set vert tabs every 15 lines
167 77 w * DECSHORP - Set horizontal pitch on LAxxx printers
		[1w = 10 characters per inch, [2w = 12 characters per inch
		[0w=10, [3w=13.2, [4w=16.5, [5w=5, [6w=6, [7w=6.6, [8w=8.25
170 78 x * DECREQTPARM - Request terminal parameters
		[3;5;2;64;64;1;0x = Report, 7 bit Even, 1200 baud, 1200 baud
171 79 y * DECTST - Invoke confidence test
		[2;1y = Power-up test on VT100 series (and VT100 part of VT125)
		[3;1y = Power-up test on GIGI (VK100)
		[4;1y = Power-up test on graphics portion of VT125
172 7A z * DECVERP - Set vertical pitch on LA100
		[1z = 6 lines per inch, [2z = 8 lines per inch
		[0z=6, [3z=12, [4z=3, [5z=3, [6z=4
173 7B {   Private
174 7C | * DECTTC - Transmit Termination Character
		[0| = No extra characters, [1| = terminate with FF
175 7D } * DECPRO - Define protected field on VT132
		[0} = No protection, [1;4;5;7} = Any attribute is protected
		[254} = Characters with no attributes are protected
176 7E ~ * DECKEYS - Sent by special function keys
		[1~=FIND, [2~=INSERT, [3~=REMOVE, [4~=SELECT, [5~=PREV, [6~=NEXT
		[17~=F6...[34~=F20 ([23~=ESC,[24~=BS,[25~=LF,[28~=HELP,[29~=DO)
177 7F DELETE is always ignored

==============================================================================
    Control Sequences with intermediate characters (from ANSI X3.64-1979).
    Note that there is a SPACE character before the terminating alphabetic.

Oct Hex  *  	(* marks function used in DEC VT series or LA series terminals)
--- -- - - --------------------------------------------------------------------
100 40 @   SL  - Scroll Left
		[4 @ = Move everything over 4 columns, 4 new columns at right
101 41 A   SR  - Scroll Right
		[2 A = Move everything over 2 columns, 2 new columns at left
102 42 B   GSM - Graphic Size Modification
		[110;50 B = Make 110% high, 50% wide
103 43 C   GSS - Graphic Size Selection
		[120 C = Make characters 120 decipoints (1/6 inch) high
104 44 D   FNT - FoNT selection (used by SGR, [10m thru [19m)
		[0;23 D = Make primary font be registered font #23
105 45 E   TSS - Thin Space Specification
		[36 E = Define a thin space to be 36 decipoints (1/20 inch)
106 46 F   JFY - JustiFY, done by the terminal/printer
		[0 E = No justification
		[1 E = Fill, bringing words up from next line if necessary
		[2 E = Interword spacing, adjust spaces between words
		[3 E = Letter spacing, adjust width of each letter
		[4 E = Use hyphenation
		[5 E = Flush left margin
		[6 E = Center following text between margins (until [0 E)
		[7 E = Flush right margin
		[8 E = Italian form (underscore instead of hyphen)
107 47 G   SPI - SPacing Increment (in decipoints)
		[120;72 G = 6 per inch vertical, 10 per inch horizontal
110 48 H   QUAD- Do quadding on current line of text (typography)
		[0 H = Flush left,  [1 H = Flush left and fill with leader
		[2 H = Center,      [3 H = Center and fill with leader
		[4 H = Flush right, [5 H = Flush right and fill with leader
111 49 I   Reserved for future standardization
157 67 o   Reserved for future standardization
160 70 p   Private use
  ...		May be defined by the printer manufacturer
176 7E ~   Private use
177 7F DELETE is always ignored

==============================================================================
Minimum requirements for VT100 emulation:

1) To act as a passive display, implement the 4 cursor commands, the 2 erase
   commands, direct cursor addressing, and at least inverse characters.
   The software should be capable of handling strings with 16 numeric parameters
   with values in the range of 0 to 255.

  [A      Move cursor up one row, stop if a top of screen
  [B      Move cursor down one row, stop if at bottom of screen
  [C      Move cursor forward one column, stop if at right edge of screen
  [D      Move cursor backward one column, stop if at left edge of screen
  [H      Home to row 1 column 1 (also [1;1H)
  [J      Clear from current position to bottom of screen
  [K      Clear from current position to end of line
  [24;80H Position to line 24 column 80 (any line 1 to 24, any column 1 to 132)
  [0m     Clear attributes to normal characters
  [7m     Add the inverse video attribute to succeeding characters
  [0;7m   Set character attributes to inverse video only

2) To enter data in VT100 mode, implement the 4 cursor keys and the 4 PF keys.
   It must be possible to enter ESC, TAB, BS, DEL, and LF from the keyboard.

  [A       Sent by the up-cursor key (alternately ESC O A)
  [B       Sent by the down-cursor key (alternately ESC O B)
  [C       Sent by the right-cursor key (alternately ESC O C)
  [D       Sent by the left-cursor key (alternately ESC O D)
  OP       PF1 key sends ESC O P
  OQ       PF2 key sends ESC O Q
  OR       PF3 key sends ESC O R
  OS       PF3 key sends ESC O S
  [c       Request for the terminal to identify itself
  [?1;0c   VT100 with memory for 24 by 80, inverse video character attribute
  [?1;2c   VT100 capable of 132 column mode, with bold+blink+underline+inverse

3) When doing full-screen editing on a VT100, implement directed erase, the
   numeric keypad in applications mode, and the limited scrolling region.
   The latter is needed to do insert/delete line functions without rewriting
   the screen.

  [0J     Erase from current position to bottom of screen inclusive
  [1J     Erase from top of screen to current position inclusive
  [2J     Erase entire screen (without moving the cursor)
  [0K     Erase from current position to end of line inclusive
  [1K     Erase from beginning of line to current position inclusive
  [2K     Erase entire line (without moving cursor)
  [12;24r   Set scrolling region to lines 12 thru 24.  If a linefeed or an
            INDex is received while on line 24, the former line 12 is deleted
            and rows 13-24 move up.  If a RI (reverse Index) is received while
            on line 12, a blank line is inserted there as rows 12-13 move down.
            All VT100 compatible terminals (except GIGI) have this feature.
  ESC =   Set numeric keypad to applications mode
  ESC >   Set numeric keypad to numbers mode
  OA      Up-cursor key    sends ESC O A after ESC = ESC [ ? 1 h
  OB      Down-cursor key  sends ESC O B    "      "         "
  OC      Right-cursor key sends ESC O B    "      "         "
  OB      Left-cursor key  sends ESC O B    "      "         "
  OM      ENTER key        sends ESC O M after ESC =
  Ol      COMMA on keypad  sends ESC O l    "      "   (that's lowercase L)
  Om      MINUS on keypad  sends ESC O m    "      "
  Op      ZERO on keypad   sends ESC O p    "      "
  Oq      ONE on keypad    sends ESC O q    "      "
  Or      TWO on keypad    sends ESC O r    "      "
  Os      THREE on keypad  sends ESC O s    "      "
  Ot      FOUR on keypad   sends ESC O t    "      "
  Ou      FIVE on keypad   sends ESC O u    "      "
  Ov      SIX on keypad    sends ESC O v    "      "
  Ow      SEVEN on keypad  sends ESC O w    "      "
  Ox      EIGHT on keypad  sends ESC O x    "      "
  Oy      NINE on keypad   sends ESC O y    "      "

4) If the hardware is capable of double width/double height:

  #3     Top half of a double-width double-height line
  #4     Bottom half of a double-width double-height line
  #5     Make line single-width (lines are set this way when cleared by ESC [ J)
  #6     Make line double-width normal height (40 or 66 characters)

5) If the terminal emulator is capable of insert/delete characters,
insert/delete lines, insert/replace mode, and can do a full-screen dump to
the printer (in text mode), then it should identify itself as a VT102

  [c     Request for the terminal to identify itself
  [?6c   VT102 (printer port, 132 column mode, and ins/del standard)
  [1@    Insert a blank character position (shift line to the right)
  [1P    Delete a character position (shift line to the left)
  [1L    Insert blank line at current row (shift screen down)
  [1M    Delete the current line (shift screen up)
  [4h    Set insert mode, new characters shove existing ones to the right
  [4l    Reset insert mode, new characters replace existing ones
  [0i    Print screen (all 24 lines) to the printer
  [4i    All received data goes to the printer (nothing to the screen)
  [5i    All received data goes to the screen (nothing to the printer)


[End of ANSICODE.TXT]

$$$$$$$$$$$$$

Linux console controls

This section describes all the control characters and escape sequences that 
invoke special functions (i.e., anything other than writing a glyph at the 
current cursor location) on the Linux console.
Control characters

A character is a control character if (before transformation according to the 
mapping table) it has one of the 14 codes 00 (NUL), 07 (BEL), 08 (BS), 09 (HT), 
0a (LF), 0b (VT), 0c (FF), 0d (CR), 0e (SO), 0f (SI), 18 (CAN), 1a (SUB), 1b 
(ESC), 7f (DEL). One can set a "display control characters" mode (see below), 
and allow 07, 09, 0b, 18, 1a, 7f to be displayed as glyphs. On the other hand, 
in UTF-8 mode all codes 00-1f are regarded as control characters, regardless of 
any "display control characters" mode.

If we have a control character, it is acted upon immediately and then discarded 
(even in the middle of an escape sequence) and the escape sequence continues 
with the next character. (However, ESC starts a new escape sequence, possibly 
aborting a previous unfinished one, and CAN and SUB abort any escape sequence.) 
The recognized control characters are BEL, BS, HT, LF, VT, FF, CR, SO, SI, CAN, 
SUB, ESC, DEL, CSI. They do what one would expect:

BEL (0x07, ^G) beeps;
BS (0x08, ^H) backspaces one column (but not past the beginning of the line);
HT (0x09, ^I) goes to the next tab stop or to the end of the line if there is no earlier tab stop;
LF (0x0A, ^J), VT (0x0B, ^K) and FF (0x0C, ^L) all give a linefeed, and if LF/NL (new-line mode) is set also a carriage return;
CR (0x0D, ^M) gives a carriage return;
SO (0x0E, ^N) activates the G1 character set;
SI (0x0F, ^O) activates the G0 character set;
CAN (0x18, ^X) and SUB (0x1A, ^Z) interrupt escape sequences;
ESC (0x1B, ^[) starts an escape sequence;
DEL (0x7F) is ignored;
CSI (0x9B) is equivalent to ESC [.
ESC- but not CSI-sequences

ESC c	RIS	Reset.
ESC D	IND	Linefeed.
ESC E	NEL	Newline.
ESC H	HTS	Set tab stop at current column.
ESC M	RI	Reverse linefeed.
ESC Z	DECID	DEC private identification. The kernel returns the string ESC [ ? 6 c, claiming that it is a VT102. 
ESC 7	DECSC	Save current state (cursor coordinates, attributes, character sets pointed at by G0, G1). 
ESC 8	DECRC	Restore state most recently saved by ESC 7.
ESC [	CSI	Control sequence introducer
ESC %		Start sequence selecting character set
ESC % @		   Select default (ISO 646 / ISO 8859-1)
ESC % G		   Select UTF-8
ESC % 8		   Select UTF-8 (obsolete)
ESC # 8	DECALN	DEC screen alignment test - fill screen with E's.
ESC (		Start sequence defining G0 character set
ESC ( B		   Select default (ISO 8859-1 mapping)
ESC ( 0		   Select VT100 graphics mapping
ESC ( U		   Select null mapping - straight to character ROM
ESC ( K		   Select user mapping - the map that is loaded by
   the utility mapscrn(8).
ESC )		Start sequence defining G1
(followed by one of B, 0, U, K, as above).
ESC >	DECPNM	Set numeric keypad mode
ESC =	DECPAM	Set application keypad mode
ESC ]	OSC	(Should be: Operating system command) ESC ] P nrrggbb: set palette, with parameter given in 7 hexadecimal digits after the final P :-(. Here n is the color (0-15), and rrggbb indicates the red/green/blue values (0-255). ESC ] R: reset palette
ECMA-48 CSI sequences

CSI (or ESC [) is followed by a sequence of parameters, at most NPAR (16), that are decimal numbers separated by semicolons. An empty or absent parameter is taken to be 0. The sequence of parameters may be preceded by a single question mark.

However, after CSI [ (or ESC [ [) a single character is read and this entire sequence is ignored. (The idea is to ignore an echoed function key.)

The action of a CSI sequence is determined by its final character.

@	ICH	Insert the indicated # of blank characters.
A	CUU	Move cursor up the indicated # of rows.
B	CUD	Move cursor down the indicated # of rows.
C	CUF	Move cursor right the indicated # of columns.
D	CUB	Move cursor left the indicated # of columns.
E	CNL	Move cursor down the indicated # of rows, to column 1.
F	CPL	Move cursor up the indicated # of rows, to column 1.
G	CHA	Move cursor to indicated column in current row.
H	CUP	Move cursor to the indicated row, column (origin at 1,1).
J	ED	Erase display (default: from cursor to end of display).
ESC [ 1 J: erase from start to cursor.
ESC [ 2 J: erase whole display.
ESC [ 3 J: erase whole display including scroll-back
buffer (since Linux 3.0).
K	EL	Erase line (default: from cursor to end of line).
ESC [ 1 K: erase from start of line to cursor.
ESC [ 2 K: erase whole line.
L	IL	Insert the indicated # of blank lines.
M	DL	Delete the indicated # of lines.
P	DCH	Delete the indicated # of characters on current line.
X	ECH	Erase the indicated # of characters on current line.
a	HPR	Move cursor right the indicated # of columns.
c	DA	Answer ESC [ ? 6 c: "I am a VT102".
d	VPA	Move cursor to the indicated row, current column.
e	VPR	Move cursor down the indicated # of rows.
f	HVP	Move cursor to the indicated row, column.
g	TBC	Without parameter: clear tab stop at current position.
ESC [ 3 g: delete all tab stops.
h	SM	Set Mode (see below).
l	RM	Reset Mode (see below).
m	SGR	Set attributes (see below).
n	DSR	Status report (see below).
q	DECLL	Set keyboard LEDs.
ESC [ 0 q: clear all LEDs
ESC [ 1 q: set Scroll Lock LED
ESC [ 2 q: set Num Lock LED
ESC [ 3 q: set Caps Lock LED
r	DECSTBM	Set scrolling region; parameters are top and bottom row.
s	?	Save cursor location.
u	?	Restore cursor location.
`	HPA	Move cursor to indicated column in current row.
ECMA-48 Set Graphics Rendition

The ECMA-48 SGR sequence ESC [ parameters m sets display attributes. Several attributes can be set in the same sequence, separated by semicolons. An empty parameter (between semicolons or string initiator or terminator) is interpreted as a zero.

param	result
0	reset all attributes to their defaults
1	set bold
2	set half-bright (simulated with color on a color display)
4	set underscore (simulated with color on a color display) (the colors used to simulate dim or underline are set using ESC ] ...) 
5	set blink
7	set reverse video
10	reset selected mapping, display control flag, and toggle meta flag (ECMA-48 says "primary font"). 
11	select null mapping, set display control flag, reset toggle meta flag (ECMA-48 says "first alternate font"). 
12	select null mapping, set display control flag, set toggle meta flag (ECMA-48 says "second alternate font"). The toggle meta flag causes the high bit of a byte to be toggled before the mapping table translation is done. 
21	set normal intensity (ECMA-48 says "doubly underlined")
22	set normal intensity
24	underline off
25	blink off
27	reverse video off
30	set black foreground
31	set red foreground
32	set green foreground
33	set brown foreground
34	set blue foreground
35	set magenta foreground
36	set cyan foreground
37	set white foreground
38	set underscore on, set default foreground color
39	set underscore off, set default foreground color
40	set black background
41	set red background
42	set green background
43	set brown background
44	set blue background
45	set magenta background
46	set cyan background
47	set white background
49	set default background color
ECMA-48 Mode Switches

ESC [ 3 h
DECCRM (default off): Display control chars.
ESC [ 4 h
DECIM (default off): Set insert mode.
ESC [ 20 h
LF/NL (default off): Automatically follow echo of LF, VT or FF with CR.
ECMA-48 Status Report Commands

ESC [ 5 n
Device status report (DSR): Answer is ESC [ 0 n (Terminal OK).
ESC [ 6 n
Cursor position report (CPR): Answer is ESC [ y ; x R, where x,y is the cursor location.
DEC Private Mode (DECSET/DECRST) sequences

These are not described in ECMA-48. We list the Set Mode sequences; the Reset Mode sequences are obtained by replacing the final 'h' by 'l'.

ESC [ ? 1 h
DECCKM (default off): When set, the cursor keys send an ESC O prefix, rather than ESC [.
ESC [ ? 3 h
DECCOLM (default off = 80 columns): 80/132 col mode switch. The driver sources note that this alone does not suffice; some user-mode utility such as resizecons(8) has to change the hardware registers on the console video card.
ESC [ ? 5 h
DECSCNM (default off): Set reverse-video mode.
ESC [ ? 6 h
DECOM (default off): When set, cursor addressing is relative to the upper left corner of the scrolling region.
ESC [ ? 7 h
DECAWM (default on): Set autowrap on. In this mode, a graphic character emitted after column 80 (or column 132 of DECCOLM is on) forces a wrap to the beginning of the following line first.
ESC [ ? 8 h
DECARM (default on): Set keyboard autorepeat on.
ESC [ ? 9 h
X10 Mouse Reporting (default off): Set reporting mode to 1 (or reset to 0)---see below.
ESC [ ? 25 h
DECTECM (default on): Make cursor visible.
ESC [ ? 1000 h
X11 Mouse Reporting (default off): Set reporting mode to 2 (or reset to 0)---see below.
Linux Console Private CSI Sequences

The following sequences are neither ECMA-48 nor native VT102. They are native to the Linux console driver. Colors are in SGR parameters: 0 = black, 1 = red, 2 = green, 3 = brown, 4 = blue, 5 = magenta, 6 = cyan, 7 = white.

ESC [ 1 ; n ]	Set color n as the underline color
ESC [ 2 ; n ]	Set color n as the dim color
ESC [ 8 ]	Make the current color pair the default attributes.
ESC [ 9 ; n ]	Set screen blank timeout to n minutes.
ESC [ 10 ; n ]	Set bell frequency in Hz.
ESC [ 11 ; n ]	Set bell duration in msec.
ESC [ 12 ; n ]	Bring specified console to the front.
ESC [ 13 ]	Unblank the screen.
ESC [ 14 ; n ]	Set the VESA powerdown interval in minutes.
 
Character sets

The kernel knows about 4 translations of bytes into console-screen symbols. The four tables are: a) Latin1 -> PC, b) VT100 graphics -> PC, c) PC -> PC, d) user-defined.
There are two character sets, called G0 and G1, and one of them is the current character set. (Initially G0.) Typing ^N causes G1 to become current, ^O causes G0 to become current.

These variables G0 and G1 point at a translation table, and can be changed by the user. Initially they point at tables a) and b), respectively. The sequences ESC ( B and ESC ( 0 and ESC ( U and ESC ( K cause G0 to point at translation table a), b), c) and d), respectively. The sequences ESC ) B and ESC ) 0 and ESC ) U and ESC ) K cause G1 to point at translation table a), b), c) and d), respectively.

The sequence ESC c causes a terminal reset, which is what you want if the screen is all garbled. The oft-advised "echo ^V^O" will make only G0 current, but there is no guarantee that G0 points at table a). In some distributions there is a program reset(1) that just does "echo ^[c". If your terminfo entry for the console is correct (and has an entry rs1=\Ec), then "tput reset" will also work.

The user-defined mapping table can be set using mapscrn(8). The result of the mapping is that if a symbol c is printed, the symbol s = map[c] is sent to the video memory. The bitmap that corresponds to s is found in the character ROM, and can be changed using setfont(8).  

Mouse tracking

The mouse tracking facility is intended to return xterm(1)-compatible mouse status reports. Because the console driver has no way to know the device or type of the mouse, these reports are returned in the console input stream only when the virtual terminal driver receives a mouse update ioctl. These ioctls must be generated by a mouse-aware user-mode application such as the gpm(8) daemon.
The mouse tracking escape sequences generated by xterm(1) encode numeric parameters in a single character as value+040. For example, '!' is 1. The screen coordinate system is 1-based.

The X10 compatibility mode sends an escape sequence on button press encoding the location and the mouse button pressed. It is enabled by sending ESC [ ? 9 h and disabled with ESC [ ? 9 l. On button press, xterm(1) sends ESC [ M bxy (6 characters). Here b is button-1, and x and y are the x and y coordinates of the mouse when the button was pressed. This is the same code the kernel also produces.

Normal tracking mode (not implemented in Linux 2.0.24) sends an escape sequence on both button press and release. Modifier information is also sent. It is enabled by sending ESC [ ? 1000 h and disabled with ESC [ ? 1000 l. On button press or release, xterm(1) sends ESC [ M bxy. The low two bits of b encode button information: 0=MB1 pressed, 1=MB2 pressed, 2=MB3 pressed, 3=release. The upper bits encode what modifiers were down when the button was pressed and are added together: 4=Shift, 8=Meta, 16=Control. Again x and y are the x and y coordinates of the mouse event. The upper left corner is (1,1).  

Comparisons with other terminals

Many different terminal types are described, like the Linux console, as being "VT100-compatible". Here we discuss differences between the Linux console and the two most important others, the DEC VT102 and xterm(1).
Control-character handling

The VT102 also recognized the following control characters:

NUL (0x00) was ignored;
ENQ (0x05) triggered an answerback message;
DC1 (0x11, ^Q, XON) resumed transmission;
DC3 (0x13, ^S, XOFF) caused VT100 to ignore (and stop transmitting) all codes except XOFF and XON.
VT100-like DC1/DC3 processing may be enabled by the terminal driver.

The xterm(1) program (in VT100 mode) recognizes the control characters BEL, BS, HT, LF, VT, FF, CR, SO, SI, ESC.

Escape sequences

VT100 console sequences not implemented on the Linux console:

ESC N	SS2	Single shift 2. (Select G2 character set for the next
character only.)
ESC O	SS3	Single shift 3. (Select G3 character set for the next
character only.)
ESC P	DCS	Device control string (ended by ESC \)
ESC X	SOS	Start of string.
ESC ^	PM	Privacy message (ended by ESC \)
ESC \ST	String terminator	
ESC * ...		Designate G2 character set
ESC + ...		Designate G3 character set
The program
xterm(1) (in VT100 mode) recognizes ESC c, ESC # 8, ESC >, ESC =, ESC D, ESC E, ESC H, ESC M, ESC N, ESC O, ESC P ... ESC \, ESC Z (it answers ESC [ ? 1 ; 2 c, "I am a VT100 with advanced video option") and ESC ^ ... ESC \ with the same meanings as indicated above. It accepts ESC (, ESC ), ESC *, ESC + followed by 0, A, B for the DEC special character and line drawing set, UK, and US-ASCII, respectively.

The user can configure xterm(1) to respond to VT220-specific control sequences, and it will identify itself as a VT52, VT100, and up depending on the way it is configured and initialized.

It accepts ESC ] (OSC) for the setting of certain resources. In addition to the ECMA-48 string terminator (ST), xterm(1) accepts a BEL to terminate an OSC string. These are a few of the OSC control sequences recognized by xterm(1):

ESC ] 0 ; txt ST	Set icon name and window title to txt.
ESC ] 1 ; txt ST	Set icon name to txt.
ESC ] 2 ; txt ST	Set window title to txt.
ESC ] 4 ; num; txt ST	Set ANSI color num to txt.
ESC ] 10 ; txt ST	Set dynamic text color to txt.
ESC ] 4 6 ; name ST	Change log file to name (normally disabled
by a compile-time option)
ESC ] 5 0 ; fn ST	Set font to fn.
It recognizes the following with slightly modified meaning (saving more state, behaving closer to VT100/VT220):

ESC 7 DECSC	Save cursor	
ESC 8 DECRC	Restore cursor	
It also recognizes

ESC F		Cursor to lower left corner of screen (if enabled by
xterm(1)'s hpLowerleftBugCompat resource)
ESC l		Memory lock (per HP terminals).
Locks memory above the cursor.
ESC m		Memory unlock (per HP terminals).
ESC n	LS2	Invoke the G2 character set.
ESC o	LS3	Invoke the G3 character set.
ESC |	LS3R	Invoke the G3 character set as GR.
ESC }	LS2R	Invoke the G2 character set as GR.
ESC ~	LS1R	Invoke the G1 character set as GR.
It also recognizes ESC % and provides a more complete UTF-8 implementation than Linux console.

CSI Sequences

Old versions of xterm(1), for example, from X11R5, interpret the blink SGR as a bold SGR. Later versions which implemented ANSI colors, for example, XFree86 3.1.2A in 1995, improved this by allowing the blink attribute to be displayed as a color. Modern versions of xterm implement blink SGR as blinking text and still allow colored text as an alternate rendering of SGRs. Stock X11R6 versions did not recognize the color-setting SGRs until the X11R6.8 release, which incorporated XFree86 xterm. All ECMA-48 CSI sequences recognized by Linux are also recognized by xterm, however xterm(1) implements several ECMA-48 and DEC control sequences not recognized by Linux.

The xterm(1) program recognizes all of the DEC Private Mode sequences listed above, but none of the Linux private-mode sequences. For discussion of xterm(1)'s own private-mode sequences, refer to the Xterm Control Sequences document by Edward Moy, Stephen Gildea, and Thomas E. Dickey available with the X distribution. That document, though terse, is much longer than this manual page. For a chronological overview,

details changes to xterm.

The vttest program

demonstrates many of these control sequences. The xterm(1) source distribution also contains sample scripts which exercise other features.  

NOTES

ESC 8 (DECRC) is not able to restore the character set changed with ESC %.  
BUGS

In 2.0.23, CSI is broken, and NUL is not ignored inside escape sequences.
Some older kernel versions (after 2.0) interpret 8-bit control sequences. These "C1 controls" use codes between 128 and 159 to replace ESC [, ESC ] and similar two-byte control sequence initiators. There are fragments of that in modern kernels (either overlooked or broken by changes to support UTF-8), but the implementation is incomplete and should be regarded as unreliable.

Linux "private mode" sequences do not follow the rules in ECMA-48 for private mode control sequences. In particular, those ending with ] do not use a standard terminating character. The OSC (set palette) sequence is a greater problem, since xterm(1) may interpret this as a control sequence which requires a string terminator (ST). Unlike the setterm(1) sequences which will be ignored (since they are invalid control sequences), the palette sequence will make xterm(1) appear to hang (though pressing the return-key will fix that). To accommodate applications which have been hardcoded to use Linux control sequences, set the xterm(1) resource brokenLinuxOSC to true.

An older version of this document implied that Linux recognizes the ECMA-48 control sequence for invisible text. It is ignored.  

#--------------------

VT100 escape codes

This document describes how to control a VT100 terminal. The entries are of the 
form "name, description, escape code".

The name isn't important, and the description is just to help you find what 
you're looking for. What you have to do is send the "escape code" to the screen. 
These codes are often several characters long, but they all begin with ^[. This 
isn't the two characters ^ and [, but rather a representation of the ASCII code 
ESC (which is why these are called escape codes).

ESC has the decimal value 27 and should be sent before the rest of the code, 
which is simply an ASCII string.

As an example of how to use this information, here's how to clear the screen in 
C, using the VT100 escape codes:

    #define ASCII_ESC 27
    printf( "%c[2J", ASCII_ESC );

   or

    puts( "\033[2J" );

Name                  Description                            Esc Code
setnl LMN             Set new line mode                      ^[[20h
setappl DECCKM        Set cursor key to application          ^[[?1h
setansi DECANM        Set ANSI (versus VT52)                 none
setcol DECCOLM        Set number of columns to 132           ^[[?3h
setsmooth DECSCLM     Set smooth scrolling                   ^[[?4h
setrevscrn DECSCNM    Set reverse video on screen            ^[[?5h
setorgrel DECOM       Set origin to relative                 ^[[?6h
setwrap DECAWM        Set auto-wrap mode                     ^[[?7h
setrep DECARM         Set auto-repeat mode                   ^[[?8h
setinter DECINLM      Set interlacing mode                   ^[[?9h

setlf LMN             Set line feed mode                     ^[[20l
setcursor DECCKM      Set cursor key to cursor               ^[[?1l
setvt52 DECANM        Set VT52 (versus ANSI)                 ^[[?2l
resetcol DECCOLM      Set number of columns to 80            ^[[?3l
setjump DECSCLM       Set jump scrolling                     ^[[?4l
setnormscrn DECSCNM   Set normal video on screen             ^[[?5l
setorgabs DECOM       Set origin to absolute                 ^[[?6l
resetwrap DECAWM      Reset auto-wrap mode                   ^[[?7l
resetrep DECARM       Reset auto-repeat mode                 ^[[?8l
resetinter DECINLM    Reset interlacing mode                 ^[[?9l

altkeypad DECKPAM     Set alternate keypad mode              ^[=
numkeypad DECKPNM     Set numeric keypad mode                ^[>

setukg0               Set United Kingdom G0 character set    ^[(A
setukg1               Set United Kingdom G1 character set    ^[)A
setusg0               Set United States G0 character set     ^[(B
setusg1               Set United States G1 character set     ^[)B
setspecg0             Set G0 special chars. & line set       ^[(0
setspecg1             Set G1 special chars. & line set       ^[)0
setaltg0              Set G0 alternate character ROM         ^[(1
setaltg1              Set G1 alternate character ROM         ^[)1
setaltspecg0          Set G0 alt char ROM and spec. graphics ^[(2
setaltspecg1          Set G1 alt char ROM and spec. graphics ^[)2

setss2 SS2            Set single shift 2                     ^[N
setss3 SS3            Set single shift 3                     ^[O

modesoff SGR0         Turn off character attributes          ^[[m
modesoff SGR0         Turn off character attributes          ^[[0m
bold SGR1             Turn bold mode on                      ^[[1m
lowint SGR2           Turn low intensity mode on             ^[[2m
underline SGR4        Turn underline mode on                 ^[[4m
blink SGR5            Turn blinking mode on                  ^[[5m
reverse SGR7          Turn reverse video on                  ^[[7m
invisible SGR8        Turn invisible text mode on            ^[[8m

setwin DECSTBM        Set top and bottom line#s of a window  ^[[<v>;<v>r

cursorup(n) CUU       Move cursor up n lines                 ^[[<n>A
cursordn(n) CUD       Move cursor down n lines               ^[[<n>B
cursorrt(n) CUF       Move cursor right n lines              ^[[<n>C
cursorlf(n) CUB       Move cursor left n lines               ^[[<n>D
cursorhome            Move cursor to upper left corner       ^[[H
cursorhome            Move cursor to upper left corner       ^[[;H
cursorpos(v,h) CUP    Move cursor to screen location v,h     ^[[<v>;<h>H
hvhome                Move cursor to upper left corner       ^[[f
hvhome                Move cursor to upper left corner       ^[[;f
hvpos(v,h) CUP        Move cursor to screen location v,h     ^[[<v>;<h>f
index IND             Move/scroll window up one line         ^[D
revindex RI           Move/scroll window down one line       ^[M
nextline NEL          Move to next line                      ^[E
savecursor DECSC      Save cursor position and attributes    ^[7
restorecursor DECSC   Restore cursor position and attributes ^[8

tabset HTS            Set a tab at the current column        ^[H
tabclr TBC            Clear a tab at the current column      ^[[g
tabclr TBC            Clear a tab at the current column      ^[[0g
tabclrall TBC         Clear all tabs                         ^[[3g

dhtop DECDHL          Double-height letters, top half        ^[#3
dhbot DECDHL          Double-height letters, bottom half     ^[#4
swsh DECSWL           Single width, single height letters    ^[#5
dwsh DECDWL           Double width, single height letters    ^[#6

cleareol EL0          Clear line from cursor right           ^[[K
cleareol EL0          Clear line from cursor right           ^[[0K
clearbol EL1          Clear line from cursor left            ^[[1K
clearline EL2         Clear entire line                      ^[[2K

cleareos ED0          Clear screen from cursor down          ^[[J
cleareos ED0          Clear screen from cursor down          ^[[0J
clearbos ED1          Clear screen from cursor up            ^[[1J
clearscreen ED2       Clear entire screen                    ^[[2J

devstat DSR           Device status report                   ^[5n
termok DSR               Response: terminal is OK            ^[0n
termnok DSR              Response: terminal is not OK        ^[3n

getcursor DSR         Get cursor position                    ^[6n
cursorpos CPR            Response: cursor is at v,h          ^[<v>;<h>R

ident DA              Identify what terminal type            ^[[c
ident DA              Identify what terminal type (another)  ^[[0c
gettype DA               Response: terminal type code n      ^[[?1;<n>0c

reset RIS             Reset terminal to initial state        ^[c

align DECALN          Screen alignment display               ^[#8
testpu DECTST         Confidence power up test               ^[[2;1y
testlb DECTST         Confidence loopback test               ^[[2;2y
testpurep DECTST      Repeat power up test                   ^[[2;9y
testlbrep DECTST      Repeat loopback test                   ^[[2;10y

ledsoff DECLL0        Turn off all four leds                 ^[[0q
led1 DECLL1           Turn on LED #1                         ^[[1q
led2 DECLL2           Turn on LED #2                         ^[[2q
led3 DECLL3           Turn on LED #3                         ^[[3q
led4 DECLL4           Turn on LED #4                         ^[[4q

#
#  All codes below are for use in VT52 compatibility mode.
#

setansi               Enter/exit ANSI mode (VT52)            ^[<

altkeypad             Enter alternate keypad mode            ^[=
numkeypad             Exit alternate keypad mode             ^[>

setgr                 Use special graphics character set     ^[F
resetgr               Use normal US/UK character set         ^[G

cursorup              Move cursor up one line                ^[A
cursordn              Move cursor down one line              ^[B
cursorrt              Move cursor right one char             ^[C
cursorlf              Move cursor left one char              ^[D
cursorhome            Move cursor to upper left corner       ^[H
cursorpos(v,h)        Move cursor to v,h location            ^[<v><h>
revindex              Generate a reverse line-feed           ^[I

cleareol              Erase to end of current line           ^[K
cleareos              Erase to end of screen                 ^[J

ident                 Identify what the terminal is          ^[Z
identresp             Correct response to ident              ^[/Z

<hr>

#
# VT100 Special Key Codes
#
# These are sent from the terminal back to the computer when the
# particular key is pressed.  Note that the numeric keypad keys
# send different codes in numeric mode than in alternate mode.
# See escape codes above to change keypad mode.
#

# Function Keys:

PF1     ^[OP
PF2     ^[OQ
PF3     ^[OR
PF4     ^[OS


# Arrow Keys:
        Reset    Set
        -----    ---
up      ^[A ^[OA
down        ^[B ^[OB
right       ^[C ^[OC
left        ^[D ^[OD


# Numeric Keypad Keys:

        Keypad Mode
        -----------------
Keypad Key  Numeric Alternate
----------  ------- ---------
0       0   ^[Op
1       1   ^[Oq
2       2   ^[Or
3       3   ^[Os
4       4   ^[Ot
5       5   ^[Ou
6       6   ^[Ov
7       7   ^[Ow
8       8   ^[Ox
9       9   ^[Oy
- (minus)   -   ^[Om
, (comma)   ,   ^[Ol
. (period)  .   ^[On
ENTER       ^M  ^[OM
C	27, 033, 0x1b
English	27 decimal, 33 octal, 1b hexadecimal
