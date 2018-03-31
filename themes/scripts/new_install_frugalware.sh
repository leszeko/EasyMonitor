#!/bin/bash
# new_install_frugalware.sh
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

comment=cat<<-EOF

EOF

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
Frugalware Linux
Last Update: 2017-10-31 01:20 UTC

[Frugalware Linux]

    OS Type: Linux
    Based on: Independent
    Origin: Hungary
    Architecture: x86_64
    Desktop: Fluxbox, GNOME, KDE Plasma, Openbox, Razor-qt
    Category: Desktop
    Status: Active
    Popularity: 189 (38 hits per day) 

Frugalware Linux is an independently developed general purpose desktop Linux distribution designed for intermediate users. It follows simple Slackware-like design concepts and includes the "pacman" package management utility from Arch Linux.

Popularity (hits per day): 12 months: 191 (42), 6 months: 189 (38), 3 months: 186 (37), 4 weeks: 160 (38), 1 week: 161 (43)

Average visitor rating: 8/10 from 1 review(s).
Distribution 	Frugalware Linux
Home Page 	http://frugalware.org/
Mailing Lists 	http://frugalware.org/mailman/listinfo
User Forums 	http://forums.frugalware.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://wiki.frugalware.org/
Screenshots 	http://frugalware.org/screenshots • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://frugalware.org/download
Bug Tracker 	http://bugs.frugalware.org/
Related Websites 	Wikipedia
Reviews 	0.x: Polishlinux • Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)

fvbe-2.1-basic-x86_64.iso	534726 KB 	04.09.2016 	00:00:00
Plik:fvbe-2.1-basic-x86_64.iso.ls-Ral	37 KB 	04.09.2016 	00:00:00
Plik:fvbe-2.1-gnome-x86_64.iso	937642 KB 	04.09.2016 	00:00:00
Plik:fvbe-2.1-gnome-x86_64.iso.ls-Ral	70 KB 	04.09.2016 	00:00:00
Plik:fvbe-2.1-kde5-x86_64.iso	1063410 KB 	04.09.2016 	00:00:00
Plik:fvbe-2.1-kde5-x86_64.iso.ls-Ral	79 KB 	04.09.2016 	00:00:00
Plik:Makefile	1 KB 	15.02.2015 	00:00:00
Plik:SHA1SUMS	1 KB 	04.09.2016 	00:00:00
EOF
)
#
home_page[X]="http://frugalware.org/"
#
distro[X]="fvbe"								# fitst distro[X] = null end array of distros/packages..
version[X]="-2.1"
desktop[X]="-gnome"
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
#sum[X]="md5sum.txt" 				# file with sum to download or sum
#sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA1SUMS"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 ftp://ftp5.frugalware.org/mirror/ftp.frugalware.org/pub/frugalware/frugalware-stable-iso/
 ftp://ftp12.frugalware.org/mirrors/ftp.frugalware.org/pub/frugalware/frugalware-stable-iso/

 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1 GB"
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
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}' '${unit}'",result}'
	)
	echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download}$Green of - „$file_name_x” $Reset"
	
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
iso_command_x="findiso="
append_x="root=live:CDLABEL=FVBE quiet locale.LANG=$locale vconsole.keymap=$layout vconsole.font=ter-v16b $video"
initrd_x="/boot/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(Live - ram)"
append_x="root=live:CDLABEL=FVBE quiet locale.LANG=$locale vconsole.keymap=$layout vconsole.font=ter-v16b $video rd.live.ram=1"
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
$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="http://frugalware.org/"
#
distro[X]="fvbe"								# fitst distro[X] = null end array of distros/packages..
version[X]="-2.1"
desktop[X]="-kde5"
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
#sum[X]="md5sum.txt" 				# file with sum to download or sum
#sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA1SUMS"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 ftp://ftp5.frugalware.org/mirror/ftp.frugalware.org/pub/frugalware/frugalware-stable-iso/
 ftp://ftp12.frugalware.org/mirrors/ftp.frugalware.org/pub/frugalware/frugalware-stable-iso/

 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1 GB"
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
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}' '${unit}'",result}'
	)
	echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download}$Green of - „$file_name_x” $Reset"
	
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
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live components quiet username=adminq"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[2] () {
X=2
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}"
#
#!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]=""
#
distro[X]=""								# fitst distro[X] = null end array of distros/packages..
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="md5sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="

 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[3] () {
X=3
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
	echo "$Cyan Get data for - distro[$X] ${distro[X]}$Reset"
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}' '${unit}'",result}'
	)
	echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download}$Green of - „$file_name_x” $Reset"
	
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
gen_boot_menus[3] () {
X=3
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live components quiet username=adminq"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[3] () {
X=3
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
