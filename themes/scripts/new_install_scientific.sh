#!/bin/bash
# new_install_scientific.sh
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
Scientific Linux
Last Update: 2017-01-26 16:08 UTC

[Scientific Linux]

    OS Type: Linux
    Based on: Red Hat
    Origin: USA
    Architecture: i386, x86_64
    Desktop: GNOME, IceWM, KDE
    Category: Desktop, High Performance Computing, Live Medium, Scientific, Server
    Release Model: Fixed
    Status: Active
    Popularity: 76 (167 hits per day) 

Scientific Linux is a recompiled Red Hat Enterprise Linux, co-developed by Fermi National Accelerator Laboratory and the European Organization for Nuclear Research (CERN). Although it aims to be fully compatible with Red Hat Enterprise Linux, it also provides additional packages not found in the upstream product; the most notable among these are various file systems, including Cluster Suite and Global File System (GFS), FUSE, OpenAFS, Squashfs and Unionfs, wireless networking support with Intel wireless firmware, MadWiFi and NDISwrapper, Sun Java and Java Development Kit (JDK), the lightweight IceWM window manager, R - a language and environment for statistical computing, and the Alpine email client.

Popularity (hits per day): 12 months: 74 (170), 6 months: 76 (167), 3 months: 65 (202), 4 weeks: 38 (330), 1 week: 20 (585)

No vistor rating given yet. Rate this project.


Scientific Summary
Distribution 	Scientific Linux
Home Page 	https://www.scientificlinux.org/
Mailing Lists 	https://www.scientificlinux.org/community/
User Forums 	http://scientificlinuxforum.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://www.scientificlinux.org/documentation/
Screenshots 	LinuxQuestions.org • DistroWatch Gallery
Screencasts 	LinuxQuestions.org
Download Mirrors 	https://www.scientificlinux.org/downloads/ • LinuxTracker.org
Bug Tracker 	--
Related Websites 	Wikipedia
Reviews 	7.x: Dedoimedo • DistroWatch • Dedoimedo
6.x: Dedoimedo • Dedoimedo • DistroWatch • Dedoimedo • Blogspot
5.x: DistroWatch • Dedoimedo
Where To Buy 	OSDisc.com (sponsored link)

SHA1SUM						24-Jan-2017 15:52 	612
SHA1SUM.gpgsigned				24-Jan-2017 15:54 	857
SHA256SUM					26-Jan-2017 08:34 	804
SHA256SUM.gpgsigned				26-Jan-2017 08:35 	1.0K
SL-7-DVD-x86_64.iso				16-Jan-2017 13:19 	6.9G
SL-7.3-Everything-x86_64.iso			16-Jan-2017 14:10 	7.8G
SL-7.3-Install-Dual-Layer-DVD-x86_64.iso	16-Jan-2017 13:19 	6.9G
SL-7.3-x86_64-2017-01-20-LiveCD.iso		21-Jan-2017 03:27 	698M
SL-7.3-x86_64-2017-01-20-LiveDVDextra.iso	21-Jan-2017 03:28 	1.6G
SL-7.3-x86_64-2017-01-20-LiveDVDgnome.iso	21-Jan-2017 03:29 	1.6G
SL-7.3-x86_64-2017-01-20-LiveDVDkde.iso		21-Jan-2017 03:30 	1.7G
SL-7.3-x86_64-netinst.iso			16-Jan-2017 12:59 	406M
http://fedoraproject.org/wiki/FedoraLiveCD for more details.
livecd-tools
livecd-iso-to-disk --format --reset-mbr --efi SL-7-x86_64-DVD.iso /dev/sd<x>
EOF
)
#
home_page[X]="https://www.scientificlinux.org/"
#
distro[X]="SL"								# fitst distro[X] = null end array of distros/packages..
version[X]="-7.3"
arch[X]="-x86_64"
desktop[X]="-2017-01-20-LiveDVDkde"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
# sum[X]="552d6735cc4017e22dae62daa98b3cd1" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="SHA1SUM.gpgsigned"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://ftp2.scientificlinux.org/linux/scientific/7.3/x86_64/iso/
ftp://ftp.fau.de/scientific/7.3/x86_64/iso/
ftp://ftp.icm.edu.pl/pub/Linux/dist/scientific/7.3/x86_64/iso/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
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
kernel_x="/isolinux/vmlinuz0"
iso_command_x="root=live:CDLABEL=SL-73-x86_64-LiveDVDkde iso-scan/filename="
append_x="rootfstype=auto ro rd.live.image quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0"
initrd_x="initrd=initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="root=live:CDLABEL=SL-73-x86_64-LiveDVDkde rootfstype=auto ro rd.live.image quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset"
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
home_page[X]="https://www.scientificlinux.org/"
#
distro[X]="SL"								# fitst distro[X] = null end array of distros/packages..
version[X]="-7.3"
arch[X]="-x86_64"
desktop[X]="-2017-01-20-LiveDVDgnome"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
# sum[X]="552d6735cc4017e22dae62daa98b3cd1" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="SHA1SUM.gpgsigned"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://ftp2.scientificlinux.org/linux/scientific/7.3/x86_64/iso/
ftp://ftp.fau.de/scientific/7.3/x86_64/iso/
ftp://ftp.icm.edu.pl/pub/Linux/dist/scientific/7.3/x86_64/iso/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
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
iso_command_x="root=live:CDLABEL=SL-73-x86_64-LiveDVDgnome iso-scan/filename="
append_x="rootfstype=auto ro rd.live.image quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0"
initrd_x="initrd=initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="root=live:CDLABEL=SL-73-x86_64-LiveDVDgnome rootfstype=auto ro rd.live.image quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset"
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
home_page[X]=""
#
distro[X]=""
desktop[X]=""
version[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]=""
# sum_file[X]="${sum[X]}"
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
