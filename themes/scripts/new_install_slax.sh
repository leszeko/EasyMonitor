#!/bin/bash
# new_install_slax.sh
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
##################

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
Slax
Last Update: 2016-07-01 04:14 UTC

[Slax]

    OS Type: Linux
    Based on: Slackware
    Origin: Czech Republic
    Architecture: i486, x86_64
    Desktop: Blackbox, KDE
    Category: Live Medium
    Release Model: Fixed
    Init: SysV
    Status: Dormant (defined)
    Popularity: Not ranked

Slax is a Slackware-based bootable CD containing a Linux operating system, designed with a modular approach. Despite its small size, Slax provides a wide collection of pre-installed software for daily use, including a well-organised graphical user interface and useful recovery tools for system administrators.

Average visitor rating: 8/10 from 2 review(s).


Slax Summary
Distribution 	Slax
Home Page 	http://www.slax.org/
Mailing Lists 	--
User Forums 	http://www.slax.org/forum.php
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.slax.org/documentation.php
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.slax.org/download.php • LinuxTracker.org
Bug Tracker 	--
Related Websites 	Wikipedia
Reviews 	7.x: Everyday Linux User • Blogspot • Linux Za Sve (Croatian)
6.x: Dedoimedo • Eric's Binary World • Linux.com • Blogspot
5.x: Tuxmachines • ABC Linuxu (Czech) • Linux.com • Tuxmachines • DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2013-03-15: Distribution Release: Slax 7.0.6"
 # List you can take from
# xdg-open 'http://ftp.linux.cz/pub/linux/slax/Slax-7.x/7.0.8/md5.txt'
# echo "iwconfig wlan0 power off" >> /etc/rc.d/rc.local
# slax salix slacky slackonly
EOF
)
#
home_page[X]="http://www.slax.org/"
#
distro[X]="slax"								# fitst distro[X] = null end array of distros/packages..
language[X]="-Polish"
version[X]="-7.0.8"
desktop[X]=""
arch[X]="-i486"
file_type[X]=".iso"
file_name[X]="${distro[X]}${language[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="md5.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${language[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://ftp.linux.cz/pub/linux/slax/Slax-7.x/7.0.8/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.6 GB"
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
# acp=off nohotplug from - (dir - from=/slax/) (iso from=file.iso) slax.flags=perch,xmode,toram,pxe
add_menu_label_x="[ persistent ]"
kernel_x="/slax/boot/vmlinuz"
iso_command_x="from=$distro_dir/slax/ "
append_x="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=perch,xmode"
initrd_x="/slax/boot/initrfs.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="[ persistent toram ]"
append_x="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=perch,xmode,toram"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[1] () {
X=1
# tar xvfz "$x"
# cd
# /bin/bash exit;
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
passwor for root - toor
startx
Change password in console - type su & passwd
If you have problems with wifi - iwconfig wlan0 power off
echo 'iwconfig wlan0 power off' >> /etc/rc.d/rc.local
you can install slapt-get gslapt
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]=""
#
distro[X]=""
desktop[X]=""
arch[X]=""
version[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}"
# sum_file[X]="${sum[X]}.sum"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="0 GB"
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
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="iso"
initrd_x=""
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
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]="$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}"
#

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
