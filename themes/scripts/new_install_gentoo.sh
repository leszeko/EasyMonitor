#!/bin/bash
# new_install_gentoo.sh
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
comment=$(cat<<-EOF
Gentoo Linux
Last Update: 2017-08-12 21:50 UTC

[Gentoo Linux]

    OS Type: Linux
    Based on: Independent
    Origin: USA
    Architecture: i486, i586, i686, x86_64, alpha, arm, hppa, ia64, mips, powerpc, ppc64, sparc64
    Desktop: AfterStep, Awesome, Blackbox, Enlightenment, Fluxbox, GNOME, IceWM, KDE Plasma, LXDE, MATE, Openbox, WMaker, Xfce
    Category: Desktop, Server, Source-based
    Release Model: Rolling
    Init: OpenRC
    Status: Active
    Popularity: 40 (258 hits per day) 

Gentoo Linux is a versatile and fast, completely free Linux distribution geared towards developers and network professionals. Unlike other distros, Gentoo Linux has an advanced package management system called Portage. Portage is a true ports system in the tradition of BSD ports, but is Python-based and sports a number of advanced features including dependencies, fine-grained package management, "fake" (OpenBSD-style) installs, safe unmerging, system profiles, virtual packages, config file management, and more.

Popularity (hits per day): 12 months: 41 (269), 6 months: 40 (258), 3 months: 43 (244), 4 weeks: 45 (249), 1 week: 49 (235)

Average visitor rating: 9.59/10 from 39 review(s).


Gentoo Summary
Distribution 	Gentoo Linux
Home Page 	http://www.gentoo.org/
Mailing Lists 	http://www.gentoo.org/main/en/lists.xml
User Forums 	http://forums.gentoo.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.gentoo.org/doc/en/index.xml
http://wiki.gentoo.org/
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.gentoo.org/main/en/mirrors.xml • LinuxTracker.org
Bug Tracker 	http://bugs.gentoo.org/
Related Websites 	Planet Gentoo • GentooVPS • Wikipedia • Gentoo Germany • Gentoo Germany • Gentoo Japan • Gentoo Russia • Gentoo Taiwan
Reviews 	2016: DistroWatch
12.x: Blogspot • Ubuntu Manual • Linux User
2008: Linuxoid (Russian) • It's a Binary World
2007: ThePCSpy
2006: LXer
2005: Blogspot • OSNews • Viva O Linux (Portuguese) • DistroWatch
2004: Linux Journal • Linux Gazette • LXer
1.x: OSNews
Where To Buy 	OSDisc.com (sponsored link)

EOF
)
#
home_page[X]="http://www.gentoo.org/"
#
distro[X]="livedvd"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-x86-amd64-32ul"
version[X]="-20160704"
desktop[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
# sum[X]="9d86f81f87e192d56ccf48d2e6d982b6d3f92f3b" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.DIGESTS.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/Gentoo_${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://gentoo.mirrors.tds.net/pub/gentoo//releases/x86/20160704/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2 GB"
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
add_menu_label_x="Live 32bit"
kernel_x="/isolinux/gentoo"
iso_command_x="isoboot="
append_x="root=/dev/ram0 init=/linuxrc aufs cdroot splash quiet looptype=squashfs loop=/image.squashfs vconsole.keymap= locale=$bootlang $modeset_opt $nox $acpi_opt console=tty1 --"
initrd_x="/isolinux/gentoo.xz"

add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live 64bit"
kernel_x="/isolinux/gentoo64"
initrd_x="/isolinux/gentoo64.xz"
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
Porteus Kiosk
Last Update: 2017-03-14 00:03 UTC

[Porteus Kiosk]

    OS Type: Linux
    Based on: Gentoo
    Origin: Ireland
    Architecture: x86_64
    Desktop: Firefox
    Category: Live Medium, Specialist
    Release Model: Fixed
    Status: Active
    Popularity: 141 (73 hits per day) 

Porteus Kiosk is a lightweight Gentoo-based Linux operating system which has been downscaled and confined to allow the use of one application only - the Firefox web browser. The browser has been locked down to prevent users from tampering with settings or downloading and installing software. When the kiosk boots, it automatically opens Firefox to the user's preferred home page. The browsing history is not kept, no passwords are saved, and many menu items have been disabled for increased security. When Firefox is restarted all caches are cleared and the browser reopens with a clean session.

Popularity (hits per day): 12 months: 145 (67), 6 months: 141 (73), 3 months: 146 (73), 4 weeks: 93 (153), 1 week: 54 (225)

Average visitor rating: 6/10 from 1 review(s).


Porteus Kiosk Summary
Distribution 	Porteus Kiosk
Home Page 	http://porteus-kiosk.org/
Mailing Lists 	--
User Forums 	http://forum.porteus.org/viewforum.php?f=101
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://porteus-kiosk.org/documentation.html
Screenshots 	http://porteus-kiosk.org/screenshots.html
Screencasts 	
Download Mirrors 	http://porteus-kiosk.org/download.html • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://porteus-kiosk.org/"
#
distro[X]="Porteus"
desktop[X]="-Kiosk"
version[X]="-3.7.0"
arch[X]="-i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="md5sum"
sum_file[X]="${sum[X]}.sum"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://porteus-kiosk.org/public/3.7/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="2 GB"
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
kernel_x="/boot/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="quiet first_run"
initrd_x="/boot/initrd.xz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="iso"
initrd_x=""
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
#!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://porteus-kiosk.org/"
#
distro[X]="Porteus"
desktop[X]="-Kiosk"
version[X]="-4.3.0"
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="md5sum"
sum_file[X]="${sum[X]}.sum"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://porteus-kiosk.org/public/4.3/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="2 GB"
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
kernel_x="/boot/initrd.xz"
iso_command_x="from="
append_x="quiet first_run"
initrd_x="/boot/initrd.xz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="iso"
initrd_x=""
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
