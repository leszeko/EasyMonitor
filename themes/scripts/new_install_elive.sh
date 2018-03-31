#!/bin/bash
# new_install_elive.sh
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
Elive
Last Update: 2017-02-10 14:54 UTC

[Elive]

    OS Type: Linux
    Based on: Debian (Stable)
    Origin: Belgium
    Architecture: i486
    Desktop: Enlightenment
    Category: Live Medium
    Release Model: Fixed
    Status: Active
    Popularity: 99 (132 hits per day) 

Elive, or Enlightenment live CD, is a Debian-based desktop Linux distribution and live CD featuring the Enlightenment window manager. Besides being pre-configured and ready for daily desktop use, it also includes "Elpanel" - a control centre for easy system and desktop administration. Elive is a commercial distribution; while the live CD is available as a free download, those wishing to install it to a hard disk are asked to pay US$15 for an installation module.

Popularity (hits per day): 12 months: 94 (136), 6 months: 99 (132), 3 months: 121 (97), 4 weeks: 119 (106), 1 week: 108 (106)

No vistor rating given yet. Rate this project.


Elive Summary
Distribution 	Elive
Home Page 	http://www.elivecd.org/
Mailing Lists 	--
User Forums 	http://forum.elivecd.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	http://www.elivecd.org/screenshots/stable/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.elivecd.org/download/stable/ • LinuxTracker.org
Bug Tracker 	http://bugs.elivecd.org/
Related Websites 	Wikipedia
Reviews 	2.0: LWN • Blogspot
1.0: DistroWatch
0.x: DistroWatch • Tuxmachines • Tuxmachines • Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)

http://isos.elive.valinbsd.org/stable/
elive_2.0_Topaz_new-kernel_up003.iso               23-Mar-2011 22:06           721281024
elive_2.0_Topaz_new-kernel_up003.md5               23-Mar-2011 22:06                  65
elive_2.0_Topaz_new-kernel_up003.md5.sig           23-Mar-2011 22:06                 197
elive_2.0_Topaz_old-kernel_up001.iso               10-Apr-2010 20:38           731031552 - old fgrx
elive_2.0_Topaz_old-kernel_up001.md5               10-Apr-2010 20:38                  48
elive_2.0_Topaz_old-kernel_up001.md5.sig           10-Apr-2010 20:38                 197
EOF
)
#
home_page[X]="http://www.elivecd.org/"
#
distro[X]="elive_2.0_Topaz"								# fitst distro[X] = null end array of distros/packages..
version[X]="_new-kernel_up003"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
#gpg[X]="${sum_file[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://isos.elive.valinbsd.org/stable/
 http://isos.elive.valinbsd.org/development/
 https://sourceforge.net/projects/archiveos/files/e/elive/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com keyserver.cns.vt.edu"
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
kernel_x="/boot/vmlinuz-2.6.30.9-elive-686"
iso_command_x="fromiso="
append_x="boot=eli quiet vga=788 resolution"
initrd_x="/boot/initrd.img-2.6.30.9-elive-686"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="boot=eli quiet vga=788 hardscreen"
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
Run the script for fix the repositories
    http://www.elivecd.org/wp-content/uploads/files/fix-for-elive-topaz-repository.sh
    Install the package google-chrome-stable for have a more updated browser
    Old-kernel cant find iso on ext4 file system
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://www.elivecd.org/"
#
distro[X]="elive_2.0_Topaz"								# fitst distro[X] = null end array of distros/packages..
version[X]="_old-kernel_up001"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
#gpg[X]="${sum_file[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://isos.elive.valinbsd.org/stable/
 http://isos.elive.valinbsd.org/development/
 https://sourceforge.net/projects/archiveos/files/e/elive/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="1 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com keyserver.cns.vt.edu"
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
kernel_x="/boot/vmlinuz-2.6.26.8-elive-686"
iso_command_x="fromiso=$dev_name"
append_x="boot=eli quiet vga=788 resolution"
initrd_x="/boot/initrd.img-2.6.26.8-elive-686"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="boot=eli quiet vga=788 hardscreen"
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
$Red Run the script for fix the repositories
    http://www.elivecd.org/wp-content/uploads/files/fix-for-elive-topaz-repository.sh
    Install the package google-chrome-stable for have a more updated browser
    Old-kernel cant find iso on ext4 file system
    * If you write iso to volume - partition as Isohybrid, then you be able to run it from grub menu entry.
"
#
#!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://www.elivecd.org/"
#
distro[X]="elive_2.8.0"								# fitst distro[X] = null end array of distros/packages..
version[X]="_beta_hybrid"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${sum_file[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://isos.elive.valinbsd.org/development/
 http://isos.elive.valinbsd.org/stable/
 https://sourceforge.net/projects/archiveos/files/e/elive/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="3 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com keyserver.cns.vt.edu"
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
kernel_x="/live/vmlinuz1"
iso_command_x="fromiso=$dev_name"
append_x="username=eliveuser boot=live config modprobe.blacklist=nouveau,radeonhd,radeon,vmwgfx loglevel=0 quiet splash"
initrd_x="/live/initrd1.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(debug)"
append_x="username=eliveuser boot=live config modprobe.blacklist=nouveau,radeonhd,radeon,vmwgfx loglevel=7 verbose debug nosplash"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(old computers)"
kernel_x="/live/vmlinuz2"
iso_command_x="fromiso=$dev_name"
append_x="username=eliveuser boot=live config modprobe.blacklist=nouveau,radeonhd,radeon,vmwgfx loglevel=0 quiet splash"
initrd_x="/live/initrd2.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(old debug)"
kernel_x="/live/vmlinuz2"
iso_command_x="fromiso=$dev_name"
append_x="username=eliveuser boot=live config modprobe.blacklist=nouveau,radeonhd,radeon,vmwgfx loglevel=7 verbose debug nosplash"
initrd_x="/live/initrd2.img"
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
#!FIXME ### --- New Item ------ ###
X=4
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]=""
#
distro[X]=""
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]=""
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="0 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[4] () {
X=4
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
gen_boot_menus[4] () {
X=4
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
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
install_package[4] () {
X=4
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
