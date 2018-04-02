#!/bin/bash
# new_create_floopy.sh
# by Leszek Ostachowski (C2016) GPL V2
# mkfs.vfat -C "floppy.img" 1440
# In order to create floppy disk images, you'll need a dosfstools installed.
# sudo mount -o loop,uid=$UID -t vfat floppy.img /mnt/floppy
# Note that the mount command must either be run as root or using sudo;
# the uid argument makes the mount point owned by the current user rather so that you have permission to copy files into it.

Begin () {

Get_Parameters
Setup_environment
Create_floopy_image
Mount_Floopy

}

Get_Parameters () {

IMG="/mnt/fd0.img"
FORMAT="vfat"
BYTES="1440"
MOUNT_POINT="/mnt/floopy"
SYSTEM_DEVICE="/dev/loop0"
################# Variables for color terminal
Color_terminal_variables() {
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[01;34m'"" Magenta=""$'\033[00;35m'""
LGreen=""$'\033[01;32m'"" LRed=""$'\033[01;31m'"" LWhite=""$'\033[01;37m'"" LYellow=""$'\033[01;33m'"" LCyan=""$'\033[01;36m'"" LBlue=""$'\033[00;34m'"" LMagenta=""$'\033[01;35m'""
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[0;38;5;225m'"";Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[01;38;5;111m'"";LCream=""$'\033[1;38;5;225m'"";LOrange=""$'\033[1;38;5;202m'"";Blink=""$'\033[5m'""
if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
fi
Nline=""$'\n'"" Reset=""$'\033[0;0m'"" EraseR=""$'\033[K'"" Back=""$'\b'"" Creturn=""$'\033[\r'"" Ctabh=""$'\033[\t'"" Ctabv=""$'\033[\v'"" SaveP=""$'\033[s'"" RestoreP=""$'\033[u'""
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
}
Color_terminal_variables
#################
  if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This script must be run with root privileges.$Reset$Nline";exit 1;fi
  echo "$Nline$Orange This script create a new floopy image $IMG with file system $FORMAT, or setup the image for system in test purpose.$Nline$Reset"

}

Setup_environment () {

  # Load loopback module if necessary
  if [ ! -e $SYSTEM_DEVICE ]; then modprobe loop;fi
  sleep 2

  MKFS_FORMAT=$(which mkfs.${FORMAT} 2>/dev/null)
  MOUNT_COMMAND=$(which mount 2>/dev/null)
  MISSING=''
  [ ! -e "$MKFS_FORMAT" ] && MISSING+="mkfs.$FORMAT, "
  [ ! -e "$MOUNT_COMMAND" ] && MISSING+="mount, "
  if [ -n "$MISSING" ]; then
   echo "Error: cannot find the following commands: ${MISSING%%, }"
   exit 1
  fi

  mkdir -p "$MOUNT_POINT"
  if ! [ $? = 0 ]; then echo "Error: cannot create mount point: $MOUNT_POINT";fi

  if [ -f "$IMG" ]; then
    echo -n "$Nline$Orange file $Yellow${IMG}$Orange exist,$LRed Delete and create new$Green or Mount it? ,$Red "; read -p "If you are SURE Please answer D or$Green M?:$Yellow " start;
    if [ "$start" = "M" ] || [ "$start" = "m" ]; then echo "$Nline$Green ok mount$Reset"
      Mount_Floopy
      exit 0
    fi
    if [ "$start" = "D" ] || [ "$start" = "d" ]; then echo "$Nline$Green ok$LRed Delete and create new$Reset"
    else
    echo "$Nline$Green skipped$Reset"
    exit 0
    fi
  fi

  if [ -b "$SYSTEM_DEVICE" ]; then
    echo "$Nline$Green umount "$MOUNT_POINT"$Reset"
    umount "$MOUNT_POINT"
    echo "$Nline$Green losetup -d "$SYSTEM_DEVICE"$Reset$Nline"
    losetup -d "$SYSTEM_DEVICE"
  fi

  if [ -f "$IMG" ]; then rm -v "$IMG";echo ;fi

}

Create_floopy_image () {

  echo "$Green $MKFS_FORMAT -C "$IMG" "$BYTES"$Nline$Reset"
  $MKFS_FORMAT -C "$IMG" "$BYTES"
  chmod 666 "$IMG"

}

Mount_Floopy () {

  echo "$Nline$Green $MOUNT_COMMAND -o loop,uid=$UID -t "$FORMAT" "$IMG" "$MOUNT_POINT"$Nline$Reset"
  $MOUNT_COMMAND -o loop,uid=$UID -t "$FORMAT" "$IMG" "$MOUNT_POINT"
  echo "$Nline$Green Done$Nline$Reset"
}

Begin