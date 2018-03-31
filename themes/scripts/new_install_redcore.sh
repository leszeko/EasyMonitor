#!/bin/bash
# new_install_redcore.sh
# Highly flexibly specialized dynamic arrayed relational database crouched in the bashingizm on school board at style free
# Script for download and install packages or Linux live distro iso to add to GRUB boot menu - Test beta script V1.2
# by Leszek Ostachowski® (©2017) @GPL V2
# http://distrowatch.com/search.php?category=Live+Medium

Begin ()
{
Traps "$@"
Color_terminal_variables
Prepare_check_environment
Info_data
Print_info
Run_as_root "$@"
Test_dependencies
Install_missing
Prepare_check_environment

get_parameters
ask_for_install
get_download_parameters
download_distro
check_sum_downloaded_files
extract_from_iso
download_memdisk
#extract_from_tar
#extract_from_zip
#extract_from_gzip
install_package
add_to_boot_menu
end_message
}

comment=

get_parameters () {
##################
# Parameters to change
#
total_free_space="X GB"
vendor_keyring="vendors.gpg"
MESSAGE=''
##################
#!FIXME ### --- New Item ------ ###
X=1 # Nr. pos
comment[X]=$(cat<<-EOF
Redcore Linux
Last Update: 2017-08-28 17:24 UTC

[Redcore Linux]

    OS Type: Linux
    Based on: Gentoo
    Origin: Romania
    Architecture: x86_64
    Desktop: LXQt
    Category: Desktop, Live Medium, Source-based
    Status: Active
    Popularity: 136 (64 hits per day) 

Redcore Linux explores the idea of bringing the power of Gentoo Linux to the masses. It aims to be a very quick way to install a pure Gentoo Linux system without spending hours or days compiling from source code, and reading documentation. To achieve this goal, Redcore provides a repository with pre-built binary packages which receives continuous updates, following a rolling release model.

Popularity (hits per day): 12 months: 246 (32), 6 months: 136 (64), 3 months: 82 (130), 4 weeks: 52 (211), 1 week: 13 (657)

Average visitor rating: 7.82/10 from 11 review(s).


Redcore Summary
Distribution 	Redcore Linux
Home Page 	https://redcorelinux.org/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://wiki.redcorelinux.org/doku.php
Screenshots 	--
Screencasts 	
Download Mirrors 	http://mirror.math.princeton.edu/pub/redcorelinux/iso/ •
Bug Tracker 	https://bugs.redcorelinux.org/
Related Websites 	https://gentoo.org/support/documentation/
Reviews 	17x: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-08-28: Distribution Release: Redcore Linux 1708
 • More Redcore releases...
EOF
)
#
home_page[X]="https://redcorelinux.org/"
#
distro[X]="Redcore."							# fitst distro[X] = null end array of distros/packages..
version[X]="Linux.1708."
desktop[X]="LXQT."
arch[X]="amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.sha256sum" 						# file with sum to download or sum
sum_file[X]="${sum[X]}"								# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirror.math.princeton.edu/pub/redcorelinux/iso/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.5 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[1] () {
X=1
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
	echo "$Cyan Get data for - distro[$X] ${distro[X]}$Reset"
	# echo "Mirrors \"${mirrors[X]}\", file \"${file_name[X]}\""
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
	)
	# echo "File size \"$file_Size_to_download\""
	! [ -z "$file_Size_to_download" ] \
	&& \
	{
		echo "$Green ok$Reset"
		echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Green of - „$file_name_x” $Reset"
	} \
	|| \
	{
		echo "$Nline$Red Error: Get file size of - $Cyan„${file_name[distro_x]}”$Green to download ,$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	}
	
	echo "$Nline$Green Take the snap of homepage from: $Cyan${home_page[X]}$Nline$Green to file: $Cyan${file_name[X]%.*}.html : $Reset$Nline"
	_snp_command "${file_name[X]%.*}.html" "${home_page[X]}"
	
elif ! [ $? = 0 ]
then :
	# echo "$Nline$Cyan No internet connection go offline$Reset"
	url_to_download="Off_line_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[1] () {
X=1
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz"
iso_command_x="isoboot="
append_x="rd.live.image root=CDLABEL=REDCORE rootfstype=auto vconsole.keymap=us rd.locale.LANG=en_US.utf8 modprobe.blacklist=vboxvideo loglevel=1 console=tty0 rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 splash quiet -- "
initrd_x="/boot/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[1] () {
X=1
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="$SmoothBlue
To remove gpg keys:
gpg --keyring vendors.gpg --delete-key <key>

Exaple to write iso on dvd from terminal:
$Reset
--- $Cream
growisofs -dvd-compat -Z /dev/dvd=${file_name[X]} $Reset
---
$SmoothBlue
You can write image to your USB stick.
Make sure the USB card/stick is inserted but not mounted.
Be absolutely certain that you know the correct drive name (ex: /dev/sdb)!
The data on this device will be destroyed and $Red overwritten!!!$Green
You can find it bay:
sudo fdisk -l
$SmoothBlue
Execute this below example in a terminal:
In this example the $Cream„${file_name[X]}”$SmoothBlue is iso image, so you can change it$Yellow
and /dev/sd<x> should be a USB card/stick!$Reset
you will need pv and dd commands ( If you write on USB then after writing wait a while for sync. )
$Reset
--- $Cream
vdd ${file_name[X]} /dev/sd<x> $Reset
---
$Magenta
change passwor for root: sudo su && passwd
$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}
$Blink
Live ISO passwords
-> root - root
-> redcore - redcore
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="https://redcorelinux.org/"
#
distro[X]="Redcore.Linux.1710.R1.LXQT.amd64"							# fitst distro[X] = null end array of distros/packages..
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.sha256sum" 						# file with sum to download or sum
sum_file[X]="${sum[X]}"								# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirror.math.princeton.edu/pub/redcorelinux/iso/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.6 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[2] () {
X=2
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
	echo "$Cyan Get data for - distro[$X] ${distro[X]}$Reset"
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
	)
	! [ -z "$file_Size_to_download" ] \
	&& \
	{
		echo "$Green ok$Reset"
		echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Green of - „$file_name_x” $Reset"
	} \
	|| \
	{
		echo "$Nline$Red Error: Get file size of - $Cyan„${file_name[distro_x]}”$Green to download ,$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	}
	
	echo "$Nline$Green Take the snap of homepage from: $Cyan${home_page[X]}$Nline$Green to file: $Cyan${file_name[X]%.*}.html : $Reset$Nline"
	_snp_command "${file_name[X]%.*}.html" "${home_page[X]}"
	
elif ! [ $? = 0 ]
then :
	# echo "$Nline$Cyan No internet connection go offline$Reset"
	url_to_download="Off_line_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[2] () {
X=2
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz"
iso_command_x="isoboot="
append_x="rd.live.image root=CDLABEL=REDCORE rootfstype=auto vconsole.keymap=${bootkeymap} rd.locale.LANG=${bootlang} modprobe.blacklist=vboxvideo loglevel=1 console=tty0 rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 splash quiet ${vesa_opt} ${modeset_opt} ${acpi_opt} -- "
initrd_x="/boot/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[2] () {
X=2
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}
Live ISO passwords
-> root - root
-> redcore - redcore
"
#
#!FIXME ### --- New Item ------ ###

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
