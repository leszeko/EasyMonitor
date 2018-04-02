#!/bin/bash
# new_install_mint.sh
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
Linux Mint
Last Update: 2017-07-01 14:01 UTC

[Linux Mint]

    OS Type: Linux
    Based on: Debian, Ubuntu (LTS)
    Origin: Ireland
    Architecture: i386, x86_64
    Desktop: Cinnamon, GNOME, KDE, MATE, Xfce
    Category: Beginners, Desktop, Live Medium
    Release Model: Fixed
    Init: systemd,SysV
    Status: Active
    Popularity: 1 (2,771 hits per day) 

Linux Mint is an Ubuntu-based distribution whose goal is to provide a more complete out-of-the-box experience by including browser plugins, support for DVD playback, Java and other components. It also adds a custom desktop and menus, several unique configuration tools, and a web-based package installation interface. Linux Mint is compatible with Ubuntu software repositories.

Popularity (hits per day): 12 months: 1 (2,774), 6 months: 1 (2,771), 3 months: 1 (2,672), 4 weeks: 1 (2,347), 1 week: 1 (2,283)

Average visitor rating: 8.83/10 from 229 review(s).


Linux Mint Summary
Distribution 	Linux Mint
Home Page 	http://linuxmint.com/
Mailing Lists 	http://forums.linuxmint.com/viewtopic.php?f=152&t=73603
User Forums 	http://linuxmint.com/forum/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://community.linuxmint.com/
Screenshots 	http://www.linuxmint.com/screenshots.php • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.linuxmint.com/download.php
Bug Tracker 	https://bugs.launchpad.net/linuxmint
linuxmint-18.2-cinnamon-32bit.iso                  28-Jun-2017 16:58          1664090112
linuxmint-18.2-cinnamon-64bit.iso                  28-Jun-2017 15:45          1676083200
linuxmint-18.2-kde-32bit.iso                       29-Jun-2017 13:02          1999634432
linuxmint-18.2-kde-64bit.iso                       29-Jun-2017 12:09          2005401600
linuxmint-18.2-mate-32bit.iso                      28-Jun-2017 18:01          1729101824
linuxmint-18.2-mate-64bit.iso                      28-Jun-2017 12:31          1739718656
linuxmint-18.2-xfce-32bit.iso                      29-Jun-2017 11:09          1636827136
linuxmint-18.2-xfce-64bit.iso                      28-Jun-2017 13:22          1647968256
sha256sum.txt                                      29-Jun-2017 16:08                 774
sha256sum.txt.gpg
EOF
)
#
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-cinnamon"
arch[X]="-32bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
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
#
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-cinnamon"
arch[X]="-64bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
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
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-kde"
arch[X]="-32bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
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
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-kde"
arch[X]="-64bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
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
#!FIXME ### --- New Item ------ ###
X=5
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-mate"
arch[X]="-32bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
 ### NOTE: Get dowload parameters - script executed before start download files
get_download_parameters[5] () {
X=5
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
gen_boot_menus[5] () {
X=5
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
ffind_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder
install_package[5] () {
X=5
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=6
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-mate"
arch[X]="-64bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
get_download_parameters[6] () {
X=6
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
gen_boot_menus[6] () {
X=6
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[6] () {
X=6
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=7
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-xfce"
arch[X]="-32bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
get_download_parameters[7] () {
X=7
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
gen_boot_menus[7] () {
X=7
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[7] () {
X=7
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=8
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://linuxmint.com/"
#
distro[X]="linuxmint"								# fitst distro[X] = null end array of distros/packages..
version[X]="-18.2"
desktop[X]="-xfce"
arch[X]="-64bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="sha256sum.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sum.txt.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirrors.evowise.com/linuxmint/stable/18.2/
http://mirror.onet.pl/pub/mirrors/linuxmint/isos/stable/18.2/
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
get_download_parameters[8] () {
X=8
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
gen_boot_menus[8] () {
X=8
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[8] () {
X=8
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=9
comment[X]=$(cat<<-EOF
feren OS
Last Update: 2017-08-26 01:22 UTC

[feren OS]

    OS Type: Linux
    Based on: Linux Mint, Ubuntu, Debian
    Origin: USA
    Architecture: x86_64
    Desktop: Cinnamon
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 50 (223 hits per day) 

feren OS is a desktop Linux distribution based on Linux Mint's main edition. The feren OS distribution ships with the Cinnamon desktop environment and includes the WINE compatibility layer for running Windows applications. The distribution also ships with the WPS productivity software, which is mostly compatible with Microsoft Office, and the Vivaldi web browser.

Popularity (hits per day): 12 months: 105 (112), 6 months: 50 (223), 3 months: 38 (246), 4 weeks: 16 (536), 1 week: 7 (1,196)

Average visitor rating: 7.65/10 from 34 review(s).


feren OS Summary
Distribution 	feren OS
Home Page 	http://ferenos.weebly.com/
Mailing Lists 	--
User Forums 	
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://ferenos.weebly.com/tips-and-tricks.html
Screenshots 	http://ferenos.weebly.com/screenshots-and-videos.html DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://sourceforge.net/projects/ferenoslinux/files/
Bug Tracker 	https://github.com/feren-OS/feren-OS-Bug-Repoting/issues
Related Websites 	
Reviews 	
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-08-18: Distribution Release: feren OS 2017.08
EOF
)
#
home_page[X]="http://ferenos.weebly.com/"
#
distro[X]="feren OS 2017 August Snapshot x64"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]="​​​"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sha256sum.asc"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/ferenos_iso"
#
: ${mirrors[X]="http://sourceforge.net/projects/ferenoslinux/files/"}
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
get_download_parameters[9] () {
X=9
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
gen_boot_menus[9] () {
X=9
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(compatibility mode)"
append_x="file=/cdrom/preseed/linuxmint.seed boot=casper xforcevesa ramdisk_size=1048576 root=/dev/ram rw noapic noacpi nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[9] () {
X=9
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
