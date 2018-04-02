#!/bin/bash
# new_qemu_react_os.sh script
# Test Install Install React OS qemu hard disk image
get_parameters () {
##################
# Parameters to change
install_folder="$HOME/ReactOS"

qemu_command="qemu-system-i386"
hdd_image_size=1G
qemu_memory="-m 768"
qemu_vga="-vga std"
# -vga cirrus # -vga std # -vga vmware # -vga virtio
qemu_net="-net nic,model=rtl8139 -net user"
# Windows XP -net nic,model=rtl8139 -net user
# -netdev user,id=mynet0 net=192.168.0.0/24,dhcpstart=192.168.0.9
# You can use -net nic,model=? to get a list of valid network devices that you can pass to the -net nic option.
# -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9
# -net user,hostname=vm_os,smb=$HOME
# Then, in the guest, you will be able to access the shared directory on the host 10.0.2.4 with the share name "qemu".
# For example, in Windows Explorer you would go to \\10.0.2.4\qemu.
qemu_soundhw=""
# For 32 bit Windows 7 a sound driver for the Intel 82801AA AC97 exists.
# For 64 bit Windows 7 Intel HDA is available as an option (QEMU option: -soundhw hda)
# -soundhw ac97 # sb16,adlib # es1370 # ac97 # hda # all
qemu_usb=""
# USB 2.0 pass through can be configured from host to guest with variations of: -usb -device usb-ehci,id=ehci -device usb-host,bus=ehci.0,vendorid=1452
# For Windows 8.1 USB tablet is available only with USB 2.0 pass through (QEMU option: -device usb-ehci,id=ehci -device usb-tablet,bus=ehci.0

hdd_qcow2_image="ReactOS-qcow2.img"
backing_img="ReactOS_backing.img"
mount_point_image="/mnt/image"

: ${mirrors_1="https://sourceforge.net/projects/reactos/files/ReactOS/0.4.4/"}; file_name_1="ReactOS-0.4.4-live.zip"
# https://www.reactos.org/
# http://tenet.dl.sourceforge.net/project/reactos/ReactOS/
# wiki.qemu.org

: ${mirrors_2="http://ftp.sleepgate.ru/drivers/NET/virtio-win/ https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.102/"}; file_name_2="virtio-win-0.1.102.iso"
: ${mirrors_3="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.102/"}; file_name_3="virtio-win-0.1.102_x86.vfd"

# https://fedoraproject.org/wiki/Windows_Virtio_Drivers#Direct_download

}
##################
# advanced parameters to change

Begin () {
get_parameters
prepare_check_environment
ask_for_install
download
# extract_from_iso
# extract_from_tar
extract_from_zip
create_qemu_hdd_image
run_install
create_qemu_hdd_image_backing_file
run_reactos
end_message
}

##################


prepare_check_environment () {

################## Variables for color terminal
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

	if [ ! -t 0 ]; then # script is executed outside the terminal
	# execute the script inside a terminal window
	konsole --hold -e "/bin/bash \"$0\" $*"
	exit 0
	fi
	
	#if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This script must be run with root privileges.$Reset$Nline"
	#su -c "/bin/bash \"$0\" $*"
	#exit 0
	#fi

	
	echo "$Nline$Green Install React OS into qemu $hdd_image_size hard disk image,$Orange Test beta script$Reset"
	echo "$Green # by Leszek Ostachowski (C2016) GPL V2$Reset$Nline"
	
	# Gathering informations about dowload program
	if command -v wget >/dev/null 2>&1; then
		_get_command() { wget --tries=3 --timeout=85 -c "$@" ; }
	elif command -v curl >/dev/null 2>&1; then
		_get_command() { curl -f --speed-time 1 -L -O -C - "$@" ; }
	else
		echo "$Red Eroor: This script needs curl or wget, exit$Reset$Nline" >&2
		exit 2
	fi
	
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	
	
}

function r_ask() {

	read -p "$1$Red {y}es$SmoothBlue or$Green *{N}o$Orange$Blink ?:$Reset$Yellow *$MoveL$SaveP" -n 1 -r
	
	case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
	    y|yes) echo -n "$RestoreP$EraseR"Yes"$Reset" >&2; echo -n "yes" ;;
	    *)     echo -n "$RestoreP$EraseR"No"$Reset" >&2;  echo -n "no" ;;
	esac
}

ask_for_install () {
	
	if [[ "no" == $(r_ask "$Green You are going to download from $mirrors_1$Nline install iso file of React OS „$file_name_1”$Nline Create qemu hard disk image and install React OS into this image$Nline Finaly after installation create qemu hdd backing file$Nline$Cyan ( you need $hdd_image_size free space left on root of $install_folder folder),$Orange Please answer:") ]]; then
	echo "$Nline$Orange ok, next time$Reset$Nline"; exit 0
	fi
	echo "$Reset$Nline"
	
	
}

get_it () {
	
	# Build download command, mirror and path
	local mirror= mirrors="$1" file="$2"
	shift
	for try in 1 2 3 4 5; do
	echo "$Red try nr. $try$Reset$Nline"
	for mirror in $mirrors; do
		_get_command "$mirror$file" && return 0
	done
	done
	return 1
}


download() {
	
	mkdir -p "$install_folder"
	if ! [ $? = 0 ]; then
		echo "Error: Cannot create folder $install_folder"
		exit 1
	fi
	cd "$install_folder"
	
	
	if [ -f $file_name_1 ]; then
		echo " file $file_name_1 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again,$Orange Please answer:") ]]; then
			echo "$Nline$Green Redownload "$mirrors_1" "$file_name_1" : $Reset$Nline"
			get_it "$mirrors_1" "$file_name_1"
			if ! [ $? = 0 ]; then echo "error"; exit 1; else echo "ok"; fi
		fi
		echo "$Reset$Nline"
	else
		echo "$Nline$Green Download "$mirrors_1" "$file_name_1" : $Reset$Nline"
		get_it "$mirrors_1" "$file_name_1"
		if ! [ $? = 0 ]; then echo "error"; exit 1; else echo "ok"; fi
		
	fi
	
	if [ -f $file_name_2 ]; then
		echo " file $file_name_2 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again,$Orange Please answer:") ]]; then
			echo "$Nline$Green Redownload "$mirrors_2" "$file_name_2" : $Reset$Nline"
			get_it "$mirrors_2" "$file_name_2"
			if ! [ $? = 0 ]; then echo "error"; exit 1; else echo "ok"; fi
		fi
		echo "$Reset$Nline"
	else
		echo "$Nline$Green Download "$mirrors_2" "$file_name_2" : $Reset$Nline"
		get_it "$mirrors_2" "$file_name_2"
		if ! [ $? = 0 ]; then echo "error"; exit 1; else echo "ok"; fi
		
	fi
	
	if [ -f $file_name_3 ]; then
		echo " file $file_name_3 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again,$Orange Please answer:") ]]; then
			echo "$Nline$Green Redownload "$mirrors_3" "$file_name_3" : $Reset$Nline"
			get_it "$mirrors_3" "$file_name_3"
			if ! [ $? = 0 ]; then echo "error"; exit 1; else echo "ok"; fi
		fi
		echo "$Reset$Nline"
	else
		echo "$Nline$Green Download "$mirrors_3" "$file_name_3" : $Reset$Nline"
		get_it "$mirrors_3" "$file_name_3"
		if ! [ $? = 0 ]; then echo "error"; exit 1; else echo "ok"; fi
		
	fi
	
}

extract_from_iso() {

	mkdir -p "/mnt/$file_name_1"
	mount -o loop "$install_folder/$file_name_1" "/mnt/$file_name_1"
	cp -fr "/mnt/$file_name_1/" "$install_folder/"
	umount "/mnt/$file_name_1"
	cd "/mnt/"
	rm -df "$file_name_1"
	cd "$install_folder"

}

extract_from_tar() {

	echo "$Nline$Green Extract from $memdisk_folder/$file_name_2 memdisk: $Reset$Nline"
	tar -xvf $memdisk_folder/$file_name_2 syslinux-6.03/bios/memdisk/memdisk
	mv syslinux-6.03/bios/memdisk/memdisk $memdisk_folder/
	rm -fr syslinux-6.03

}

extract_from_zip() {

	echo "$Nline$Green Extract from $file_name_1 : $Reset$Nline"
	unzip $file_name_1
	
}

create_qemu_hdd_image () {

	echo "$Nline$Green qemu-img create -f qcow2 $hdd_qcow2_image $hdd_image_size $Reset$Nline"
	qemu-img create -f qcow2 $hdd_qcow2_image $hdd_image_size

}

run_install () {

	echo "$Nline$Nline$Orange After two reboots quit from qemu, then script will create backing image and run again qemu for driver installation $Reset$Nline"
	echo "$Nline$Green $qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda $hdd_qcow2_image -cdrom ${file_name_1%.*}.iso -boot d $Reset$Nline"
	$qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda $hdd_qcow2_image -cdrom ${file_name_1%.*}.iso -boot d

}

create_qemu_hdd_image_backing_file () {

	echo "$Nline$Green qemu-img create -f qcow2 -o backing_file=$hdd_qcow2_image $backing_img $Reset$Nline"
	qemu-img create -f qcow2 -o backing_file=$hdd_qcow2_image $backing_img 

	cat <<-EOF
	$Nline$Cyan
	# To start a new disposable environment based on a known good image
	# invoke the qemu-img command with the backing_file option and tell it what image to base its copy on.
	# When you run QEMU using the disposable environment, all writes to the virtual disc will go to this disposable image, not the base copy.$Reset
	EOF

}

run_reactos () {

	echo "$Nline$Green $qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda $backing_img -cdrom virtio-win-0.1.102.iso -boot c $Reset$Nline"
	$qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda $backing_img -cdrom virtio-win-0.1.102.iso -boot c

}

mount_hdd_qcow2_image () {

	echo "$Nline$Green modprobe nbd max_part=16 $Reset$Nline"
	modprobe nbd max_part=16
	
	echo "$Nline$Green qemu-nbd -c /dev/nbd0 $hdd_qcow2_image $Reset$Nline"
	qemu-nbd -c /dev/nbd0 $hdd_qcow2_image
	
	echo "$Nline$Green partprobe /dev/nbd0 $Reset$Nline"
	partprobe /dev/nbd0
	
	echo "$Nline$Green mkdir -p $mount_point_image $Reset$Nline"
	mkdir -p $mount_point_image
	
	echo "$Nline$Green mount /dev/nbd0p1 $mount_point_image $Reset$Nline"
	mount /dev/nbd0p1 $mount_point_image
	
}

umount_hdd_qcow2_image () {

	umount $mount_point_image
	qemu-nbd -d /dev/nbd0
	vgchange -an VolGroupName
	killall qemu-nbd

}

end_message() {
	
	cat <<-EOF
		$Green
		Hi,
		You has successfully install  ReactOS-0.4.0
		$Orange
		Exaple to run: $qemu_command -vga std -m 256 -hda $backing_img # -m - size of memory for quemu
		$Magenta
		If you had 2 operating systems installed on 2 different partitions (dual booting)
		you could use qemu to boot one of them inside the other,
		but you must never ever ever boot the same OS twice (unless it's a read-only OS like a live CD image for instance)
		
		https://wiki.gentoo.org/wiki/QEMU/Options
		http://wiki.qemu.org/Testing
		https://en.wikibooks.org/wiki/QEMU/Images
		$Reset$Nline
	EOF
}
##################
Begin

# The qemu-img convert command can do conversion between multiple formats, including raw, qcow2, VDI (VirtualBox), VMDK (VMWare) and VHD (Hyper-V). Table 7.1. qemu-img format strings

# **Image format**    **Argument to qemu-img**
# raw                     raw
# qcow2                   qcow2
# VDI (VirtualBox)        vdi
# VMDK (VMWare)           vmdk
# VHD (Hyper-V)           vpc


# qemu-img info test.vmdk
# qemu-img convert -O raw diskimage.qcow2 diskimage.raw

# mount
# modprobe nbd max_part=16
# qemu-nbd -c /dev/nbd0 ReactOS-qcow2.img
# partprobe /dev/nbd0
# mount /dev/nbd0p1 $mount_point_image

# umount $mount_point_image
# qemu-nbd -d /dev/nbd0
# vgchange -an VolGroupName
# killall qemu-nbd

# To use a VDI image from kvm without converting it, vdfuse may be used again.

# vdfuse -f test.vdi ~/some-dir
# kvm -hda ~/some-dir/EntireDisk ...
