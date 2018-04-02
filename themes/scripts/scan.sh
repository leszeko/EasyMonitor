#!/bin/bash
# scan.sh script

# Start X of scan-area, start Y of scan-area, move in _X, move in _Y, Resolution for skan in DPI
#---------------------------------------------------------------------------------------------------
MODE=color
X=0
Y=0
_X=215
_Y=297
DPI=150

# Format to convert image, Resize image to XxY, Quality to compres image.
#---------------------------------------------------------------------------------------------------
FORM=jpg
SIZE=1920x1200
QUALITY=75

# Destination path; base name for a scan file; postfix 
#---------------------------------------------------------------------------------------------------
DEST=$HOME/Scan/
NAME=tmp_scan
POSTFIX=_`date +%F`
SCAN_COMMAND=scanimage
CONVERT_COMMAND=mogrify
SHOW_COMMAND=gwenview
COUNT_COMMAND=bc

# Check for needed packages and scan
#----------------------------------------------

if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
mkdir -p $TMPDIR/EasyMonitor-$USER

P_SCAN=`which $SCAN_COMMAND`
P_CONVERT=`which $CONVERT_COMMAND`
P_SHOW=`which $SHOW_COMMAND`
P_COUNT=`which $COUNT_COMMAND`

if [ -x $P_SCAN -a $P_CONVERT -a $P_SHOW -a $P_COUNT ]
then
case $1 in
"") $P_SCAN -l $X -t $Y -x $_X -y $_Y --resolution $DPI --format pnm >$TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ;;
"color") $P_SCAN --mode color -l $X -t $Y -x $_X -y $_Y --resolution $DPI --format pnm >$TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ;;
"gray") $P_SCAN --mode gray -l $X -t $Y -x $_X -y $_Y --resolution $DPI --format pnm >$TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ;;
"lineart") $P_SCAN --mode lineart -l $X -t $Y -x $_X -y $_Y --resolution $DPI --format pnm >$TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ;;
esac

# Resize and convert scan image into format=FORM
#------------------------------------------------------------------------

if [ $? = 0 ] # If scanimage is success
then $P_CONVERT -format $FORM -resize $SIZE -quality $QUALITY $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX

else kdialog --title "Error" --msgbox "You have to check scanner connection and sane-utils configuration"
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ; fi
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ;fi
exit 0
fi

# Prepare destination directory
#------------------------------------------------------------------------

if [ -e "$DEST" -a  ! -d "$DEST" ] # If the file already exists and is not a directory
then kdialog --title "Error" --msgbox "The file $DEST already exists and is not a directory"
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ; fi
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ;fi
exit 0
fi

if [ ! -d "$DEST" ] # If any directory does not exist $DEST
then mkdir "$DEST"
if [ $? = 0 ] # If mkdir success
then kdialog --title "Info" --msgbox "$DEST directory has been created"

else kdialog --title "Error" --msgbox "$DEST directory cannot be created"
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ; fi
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ;fi
exit 0
fi

fi

# Count nuber of scaned images in destination directory 
#--------------------------------------------------------------------------

if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ]
then
Counter=0
Counter=$(ls $DEST/$NAME$POSTFIX* | wc -w  | cut -d\  -f 1)
Counter=$((Counter+1))
Counter=$(echo "scale=3;$Counter/1000" | bc | cut -b 2,3,4)
Counter=_$Counter

# Create name for scan image for copy to destination and show it
#--------------------------------------------------------------------------

cp $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM $DEST/$NAME$POSTFIX$Counter.$FORM

$P_SHOW $DEST/$NAME$POSTFIX$Counter.$FORM

fi

# Remove temp imagest 
#--------------------------------------------------------------------------

if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX ; fi
if [ -f $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ] ; then rm $TMPDIR/EasyMonitor-$USER/$NAME$POSTFIX.$FORM ;fi
exit 0


#-------------------------------------------------------------------------------------

else
kdialog --title "Error" --msgbox "You have to install sane-utils imagemagick gwenview bc. Exaple:  Ubuntu -'sudo apt-get install sane-utils' or OpenSuse -'yast2 --update sane-backends'"

# OpenSuse yast2
if [ -x /usr/bin/zypper ] ; then kdesu -c 'konsole --hold -e /usr/bin/zypper install -R sane-backends ImageMagick kim gwenview bc' ; exit 0 ; fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ; then kdesudo -c 'konsole --hold -e apt-get install sane-utils imagemagick kim gwenview bc' ; exit 0 ; fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ; then kdesudo -c 'konsole --hold -e apt-get install sane-utils imagemagick gwenview bc' ; exit 0 ; fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ; then kdesu -c 'konsole --hold -e sudo urpmi sane-backends imagemagick kim gwenview bc' ; exit 0 ; fi

# Arch pacman
if [ -x /usr/bin/pacman ] ; then konsole --hold -e sudo pacman -Syu --needed sane imagemagick kim4 gwenview bc ; exit 0 ; fi

# Fedora
if [ -x /usr/bin/yum ] ; then kdesu -c 'konsole --hold -e sudo yum install sane ImageMagick gwenview bc' ; exit 0 ; fi

# Sabayon
if [ -x /usr/bin/equo ] ; then kdesu -c 'konsole --hold -e equo install sane-backends imagemagick gwenview bc' ; exit 0 ; fi

fi
