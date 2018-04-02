#!/bin/bash
# new_install_greenie.sh
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
Greenie Linux
Last Update: 2017-02-18 00:57 UTC

[Greenie Linux]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: Slovakia
    Architecture: i386
    Desktop: Fluxbox, LXDE
    Category: Desktop, Live Medium
    Release Model: Fixed
    Status: Active
    Popularity: 218 (38 hits per day) 

Greenie Linux is a Slovak desktop distribution based on Ubuntu and optimised for users in Slovakia and the Czech Republic. Created as an operating system designed for every-day use and focusing on the needs of book readers and writers, Greenie Linux combines a set of applications for home use, out-of-the-box functionality and Ubuntu repositories. It also includes a set of tools for reading, writing and modifying books and documents. The goal of the distribution is to create a user-friendly desktop system and a useful live CD.

Popularity (hits per day): 12 months: 231 (35), 6 months: 218 (38), 3 months: 198 (45), 4 weeks: 130 (75), 1 week: 37 (315)

No vistor rating given yet. Rate this project.


Greenie Summary
Distribution 	Greenie Linux
Home Page 	http://sourceforge.net/projects/greenie/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://sourceforge.net/projects/greenie/files/ •
Bug Tracker 	--
Related Websites 	Greenie Blog • Wikipedia
Reviews 	8: LinuxON (Slovak)
6: Ghacks
5: Pc.sk (Slovak)
4: Linux EXPRESS (Czech)
Where To Buy 	OSDisc.com (sponsored link)

Looking for the latest version? Download greenie-16.04-beta2.iso (1.2 GB)
Home
Name 	Modified 	Size 	Downloads / Week 	Status
wesnoth 	2014-12-26 		33 weekly downloads 	
deb packages and tools 	2014-11-16 		22 weekly downloads 	
kreenie 	2014-10-03 		11 weekly downloads 	
podcast 	2014-06-28 		0 	
greenie-16.04-beta2.iso 	2017-02-16 	1.2 GB 	271271 weekly downloads 	
greenie-16.04-beta.iso 	2017-02-07 	1.2 GB 	33 weekly downloads 	
greenie-desktop-14.04.6-dvd_reupload.iso 	2014-12-11 	1.1 GB 	33 weekly downloads 	
README 	2014-12-11 	130 Bytes 	55 weekly downloads 	
greenie-desktop-14.04.6-dvd.md5 	2014-12-07 	66 Bytes 	0 	
greenie-desktop-14.04.5-dvd.iso 	2014-11-17 	1.1 GB 	44 weekly downloads 	
greenie-desktop-14.04.5-dvd.md5 	2014-11-16 	66 Bytes 	0 	
greenie-desktop-14.04.4-7th-anniversary-dvd.iso 	2014-09-07 	1.3 GB 	22 weekly downloads 	
greenie-desktop-14.04.4-dvd.iso 	2014-09-02 	1.1 GB 	0 	
greenie-xplike-14.04.3-cd.iso 	2014-08-08 	730.9 MB 	33 weekly downloads 	
greenie-desktop-14.04.3-dvd.iso 	2014-08-03 	1.1 GB 	0 	
greenie-ebook-14.04.3-dvd.iso 	2014-08-03 	1.3 GB 	0 	
greenie-desktop-14.04.2-cd.iso 	2014-07-26 	729.8 MB 	0 	
greenie-ebook-14.04.2-dvd.iso 	2014-06-27 	1.1 GB 	0 	
pozadie-14.04.2.jpg 	2014-06-26 	222.8 kB 	0 	
greenie-ebook-14.04.2-beta.iso 	2014-06-16 	1.0 GB 	0 	
greenie-desktop-14.04.1-cd.iso 	2014-06-01 	730.9 MB 	0 	
greenie-ebook-14.04.1-dvd.iso 	2014-05-11 	979.4 MB 	77 weekly downloads 	
greenie-ebook-14.04-dvd.iso 	2014-04-20 	852.5 MB 	0 	
greenie-7.1l.iso 	2010-09-06 	734.0 MB 	11 weekly downloads 	
Totals: 24 Items 	  	16.3 GB 	305 	
WARNING - DO NOT DOWNLOAD GREENIE 14.04.6 (problems with MD5) Greenie 14.04.5 is okay, re-upload of 14.04.6 should be fine too...
Source: README, updated 2014-12-11
EOF
)
#
home_page[X]="http://sourceforge.net/projects/greenie/"
#
distro[X]="greenie"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04-beta2"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="886233493e8cd975474e0fefe30de3bdf7831761" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://sourceforge.net/projects/greenie/files/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.5 GB"
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
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/lubuntu.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="file=/cdrom/preseed/lubuntu.seed boot=casper xforcevesa quiet splash --"
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
