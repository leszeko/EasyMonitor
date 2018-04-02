#!/bin/bash
# new_install_korora.sh
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
Korora Project
Last Update: 2017-08-01 10:31 UTC

[Korora Project]

    OS Type: Linux
    Based on: Fedora
    Origin: Australia
    Architecture: x86_64
    Desktop: Cinnamon, GNOME, KDE Plasma, MATE, Xfce
    Category: Beginners, Desktop, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 78 (152 hits per day) 

Korora was born out of a desire to make Linux easier for new users, while still being useful for experts. The main goal of Korora is to provide a complete, easy-to-use system for general computing. Originally based on Gentoo Linux in 2005, Korora was re-born in 2010 as a Fedora Remix with tweaks and extras to make the system "just work" out of the box.

Popularity (hits per day): 12 months: 61 (190), 6 months: 78 (152), 3 months: 76 (137), 4 weeks: 74 (149), 1 week: 81 (130)

Average visitor rating: 9.55/10 from 11 review(s).


Korora Summary
Distribution 	Korora Project
Home Page 	https://kororaproject.org/
Mailing Lists 	--
User Forums 	https://kororaproject.org/support/engage
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://kororaproject.org/support/documentation
Screenshots 	https://kororaproject.org/discover • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://kororaproject.org/download • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	24: DistroWatch
23: DarkDuck • DistroWatch • Dedoimedo • DuskFire • Linux INsider
22: Hectic Geek
21: Desktop Linux Reviews • DistroWatch
20: Dedoimedo • DistroWatch • Blogspot • ZDNet
19: Wordpress • DistroWatch • LinuxBSDos
17: DistroWatch
16: DistroWatch • ZDNet Blogs
15: Dedoimedo
Gentoo-based: Tuxmachines • Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)
Looking for the latest version? Download korora-live-gnome-25-x86_64.iso (2.3 GB)
Home / 25
Name 	Modified 	Size 	Downloads / Week 	Status
Parent folder
korora-25-checksums.txt 	2016-12-07 	2.2 kB 	99 weekly downloads 	i
korora-live-kde-25-x86_64.iso 	2016-12-06 	2.6 GB 	203203 weekly downloads 	i
korora-live-mate-25-x86_64.iso 	2016-12-06 	2.3 GB 	157157 weekly downloads 	i
korora-live-xfce-25-x86_64.iso 	2016-12-06 	2.2 GB 	212212 weekly downloads 	i
korora-live-cinnamon-25-x86_64.iso 	2016-12-06 	2.2 GB 	218218 weekly downloads 	i
korora-live-gnome-25-x86_64.iso 	2016-12-06 	2.3 GB 	404404 weekly downloads 	i
Totals: 6 Items
EOF
)
#
home_page[X]="https://kororaproject.org/"
#
distro[X]="korora"								# fitst distro[X] = null end array of distros/packages..
version[X]="-live"
desktop[X]="-kde-25"
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="c8803e613eb380bdf135265a12b5adf6e66f843b" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://sourceforge.net/projects/kororaproject/files/25/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="3 GB"
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
kernel_x="/isolinux/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="root=live:CDLABEL=korora-live-kde-25-x86_64 rootfstype=auto rd.live.image quiet"
initrd_x="/isolinux/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (nomodeset)"
append_x="root=live:CDLABEL=korora-live-kde-25-x86_64 rootfstype=auto rd.live.image quiet nomodeset"
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
[Korora Project]
Looking for the latest version? Download korora-live-gnome-25-x86_64.iso (2.3 GB)
Home / 26
Name 	Modified 	Size 	Downloads / Week 	Status
Parent folder
korora-26-checksums.txt 	< 12 hours ago 	2.4 kB 	0 	i
korora-live-xfce-26-x86_64.iso 	2017-09-18 	2.4 GB 	88 weekly downloads 	i
korora-live-mate-26-x86_64.iso 	2017-09-18 	2.8 GB 	88 weekly downloads 	i
korora-live-kde-26-x86_64.iso 	2017-09-18 	2.8 GB 	66 weekly downloads 	i
korora-live-gnome-26-x86_64.iso 	2017-09-18 	2.5 GB 	5252 weekly downloads 	i
korora-live-cinnamon-26-x86_64.iso 	2017-09-18 	2.6 GB 	77 weekly downloads 	i
Totals: 6 Items 	 
EOF
)
#
home_page[X]="https://kororaproject.org/"
#
distro[X]="korora-live"
desktop[X]="-kde"
version[X]="-26"
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="8ba7cc75e939952ec8c966db1e095154419fe955"
# sum_file[X]="${sum[X]}.sum"
# gpg[X]="korora-26-checksums.txt"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://sourceforge.net/projects/kororaproject/files/26/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.646 GB"
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
kernel_x="/isolinux/vmlinuz0"
iso_command_x="iso-scan/filename="
append_x="root=live:CDLABEL=korora-live-kde-26-x86_64 rootfstype=auto ro rd.live.image quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0"

initrd_x="/isolinux/initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (nomodeset)"
append_x="root=live:CDLABEL=korora-live-kde-26-x86_64 rootfstype=auto ro rd.live.image quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset"
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
"
#

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
