#!/bin/bash
# new_install_ubuntu.sh
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
Ubuntu
Last Update: 2017-08-06 21:20 UTC

[Ubuntu]

    OS Type: Linux
    Based on: Debian
    Origin: Isle of Man
    Architecture: armhf, i686, powerpc, ppc64el, s390x, x86_64
    Desktop: Unity
    Category: Beginners, Desktop, Server, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 4 (1,477 hits per day) 

Ubuntu is a complete desktop Linux operating system, freely available with both community and professional support. The Ubuntu community is built on the ideas enshrined in the Ubuntu Manifesto: that software should be available free of charge, that software tools should be usable by people in their local language and despite any disabilities, and that people should have the freedom to customise and alter their software in whatever way they see fit. "Ubuntu" is an ancient African word, meaning "humanity to others". The Ubuntu distribution brings the spirit of Ubuntu to the software world.

Popularity (hits per day): 12 months: 4 (1,426), 6 months: 4 (1,477), 3 months: 5 (1,279), 4 weeks: 5 (1,284), 1 week: 3 (1,554)

Average visitor rating: 7.6/10 from 127 review(s).


Ubuntu Summary
Distribution 	Ubuntu
Home Page 	https://www.ubuntu.com/
Mailing Lists 	https://lists.ubuntu.com/mailman/listinfo/
User Forums 	https://ubuntuforums.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://wiki.ubuntu.com/UserDocumentation
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://www.ubuntu.com/download/ • LinuxTracker.org
Bug Tracker 	https://bugs.launchpad.net/
EOF
)
#
home_page[X]="https://www.ubuntu.com/"
#
distro[X]="ubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04.3"
desktop[X]="-desktop"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://releases.ubuntu.com/16.04/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.6 GB"
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
home_page[X]="https://www.ubuntu.com/"
#
distro[X]="ubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04.3"
desktop[X]="-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://releases.ubuntu.com/16.04/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.6 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
[]
http://releases.ubuntu.com/17.04/ubuntu-17.04-desktop-amd64.iso
EOF
)
#
home_page[X]="https://www.ubuntu.com/"
#
distro[X]="ubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://releases.ubuntu.com/17.04/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
home_page[X]="https://www.ubuntu.com/"
#
distro[X]="ubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-desktop"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://releases.ubuntu.com/17.04/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
home_page[X]="https://www.kubuntu.org/"
#
distro[X]="kubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04.3"
desktop[X]="-desktop"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/kubuntu/releases/16.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.6 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"

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
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
home_page[X]="https://www.kubuntu.org/"
#
distro[X]="kubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04.3"
desktop[X]="-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/kubuntu/releases/16.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.6 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
home_page[X]="https://www.kubuntu.org/"
#
distro[X]="kubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-desktop"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/kubuntu/releases/17.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.6 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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
##
home_page[X]="https://www.kubuntu.org/"
#
distro[X]="kubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/kubuntu/releases/17.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.6 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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

EOF
)
home_page[X]="https://ubuntustudio.org/"
#
distro[X]="ubuntustudio"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04"
desktop[X]="-dvd"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/ubuntustudio/releases/16.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.6 GB"
#
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
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
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

#
#!FIXME ### --- New Item ------ ###
X=10
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="https://ubuntustudio.org/"
#
distro[X]="ubuntustudio"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04"
desktop[X]="-dvd"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/ubuntustudio/releases/16.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.6 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[10] () {
X=10
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
gen_boot_menus[10] () {
X=10
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[10] () {
X=10
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

#!FIXME ### --- New Item ------ ###
X=11
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="https://ubuntustudio.org/"
#
distro[X]="ubuntustudio"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-dvd"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/ubuntustudio/releases/17.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.6 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[11] () {
X=11
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
gen_boot_menus[11] () {
X=11
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[11] () {
X=11
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

#
#!FIXME ### --- New Item ------ ###
X=12
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="https://ubuntustudio.org/"
#
distro[X]="ubuntustudio"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-dvd"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/ubuntustudio/releases/17.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.6 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[12] () {
X=12
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
gen_boot_menus[12] () {
X=12
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[12] () {
X=12
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

#!FIXME ### --- New Item ------ ###
X=13
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="http://lubuntu.net/"
#
distro[X]="lubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04"
desktop[X]="-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/lubuntu/releases/16.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[13] () {
X=13
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
gen_boot_menus[13] () {
X=13
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[13] () {
X=13
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

#!FIXME ### --- New Item ------ ###
X=14
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="http://lubuntu.net/"
#
distro[X]="lubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04"
desktop[X]="-desktop"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/lubuntu/releases/16.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[14] () {
X=14
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
gen_boot_menus[14] () {
X=14
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[14] () {
X=14
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#


#!FIXME ### --- New Item ------ ###
X=15
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="http://lubuntu.net/"
#
distro[X]="lubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/lubuntu/releases/17.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[15] () {
X=15
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
gen_boot_menus[15] () {
X=15
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[15] () {
X=15
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

#!FIXME ### --- New Item ------ ###
X=16
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="http://lubuntu.net/"
#
distro[X]="lubuntu"								# fitst distro[X] = null end array of distros/packages..
version[X]="-17.04"
desktop[X]="-desktop"
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/lubuntu/releases/17.04/release/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[16] () {
X=16
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
gen_boot_menus[16] () {
X=16
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[16] () {
X=16
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#

#!FIXME ### --- New Item ------ ###
X=17
comment[X]=$(cat<<-EOF
Ubuntu Budgie
Last Update: 2016-11-09 13:09 UTC

[Ubuntu Budgie]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: United Kingdom
    Architecture: i386, x86_64
    Desktop: Budgie
    Category: Desktop, Live Medium
    Release Model: Fixed
    Status: Active
    Popularity: 101 (130 hits per day) 

Ubuntu Budgie (previously budgie-remix) is an Ubuntu-based distribution featuring the Budgie desktop, originally developed by the Solus project. Written from scratch and integrating tightly with GNOME stack, Budgie focuses on simplicity and elegance, while also offering useful features, such as the Raven notification and customisation centre.

Popularity (hits per day): 12 months: 150 (65), 6 months: 101 (130), 3 months: 87 (146), 4 weeks: 57 (227), 1 week: 24 (513)

No vistor rating given yet. Rate this project.


Ubuntu Budgie Summary
Distribution 	Ubuntu Budgie (previously budgie-remix)
Home Page 	https://budgie-remix.org/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	https://budgie-remix.org/gallery/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://budgie-remix.org/downloads/ •
Bug Tracker 	https://bugs.launchpad.net/budgie-remix
Related Websites 	GitHub.com
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
home_page[X]="https://budgie-remix.org/"
#
distro[X]="budgie-remix"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04.3"
desktop[X]=""
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="7ad902f5cbaa76c83a20769fd046fe8c356d3233" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="SHA256SUMS.gpg"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/budgie-remix/files/16.04.3%20release/i386/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[17] () {
X=17
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
gen_boot_menus[17] () {
X=17
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[17] () {
X=17
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=18
comment[X]=$(cat<<-EOF

EOF
)
home_page[X]="https://budgie-remix.org/"
#
distro[X]="budgie-remix"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.04.1"
desktop[X]=""
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="a601ba623a158eabbfdeb2039bd206988d1bc4a2" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="SHA256SUMS.gpg"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/budgie-remix/files/16.04.3%20release/amd64/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[18] () {
X=18
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
gen_boot_menus[18] () {
X=18
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[18] () {
X=18
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=19
comment[X]=$(cat<<-EOF
Linux Lite
Last Update: 2017-03-31 03:09 UTC

[Linux Lite]

    OS Type: Linux
    Based on: Debian, Ubuntu (LTS)
    Origin: New Zealand
    Architecture: i386, x86_64
    Desktop: Xfce
    Category: Beginners, Desktop, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 17 (556 hits per day) 

Linux Lite is a beginner-friendly Linux distribution based on Ubuntu's long-term support (LTS) release and featuring the Xfce desktop. Linux Lite primarily targets Windows users. It aims to provide a complete set of applications to assist users with their everyday computing needs, including a full office suite, media players and other essential daily software.

Popularity (hits per day): 12 months: 17 (523), 6 months: 17 (556), 3 months: 19 (477), 4 weeks: 15 (572), 1 week: 20 (516)

Average visitor rating: 8.68/10 from 40 review(s).


Linux Lite Summary
Distribution 	Linux Lite
Home Page 	https://www.linuxliteos.com/
Mailing Lists 	--
User Forums 	https://www.linuxliteos.com/forums/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://www.linuxliteos.com/manual/
Screenshots 	https://www.linuxliteos.com/screenshots/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://www.linuxliteos.com/download.php • LinuxTracker.org
Bug Tracker 	https://www.linuxliteos.com/bugs/
Related Websites 	Linux Lite Thailand
Reviews 	3.x: DistroWatch • Everyday Linux User • Linux Insider
2.x: Everyday Linux User • DistroWatch • Blogspot • Desktop Linux Reviews • Hectic Geek • Blogspot
1.x: Desktop Linux Reviews • Linux Insider • Blogspot • Everyday Linux User • Blogspot
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
home_page[X]="https://www.linuxliteos.com/"
#
distro[X]="linux-lite"								# fitst distro[X] = null end array of distros/packages..
version[X]="-3.4"
desktop[X]=""
arch[X]="-32bit"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="d796342d21aa8c02efca04d88f7192c436cfa1f6" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="SHA256SUMS.gpg"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/linuxlite/files/3.4/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[19] () {
X=19
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
gen_boot_menus[19] () {
X=19
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="xforcevesa"
append_x="file=/cdrom/preseed/custom.seed boot=casper xforcevesa nomodeset ramdisk_size=1048576 root=/dev/ram rw noapic noapci nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[19] () {
X=19
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=20
comment[X]=$(cat<<-EOF
LXLE
Last Update: 2017-04-08 10:55 UTC

[LXLE]

    OS Type: Linux
    Based on: Debian, Lubuntu
    Origin: USA
    Architecture: i386, x86_64
    Desktop: LXDE
    Category: Desktop, Live Medium, Old Computers
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 22 (408 hits per day) 

LXLE is an easy-to-use lightweight desktop Linux distribution based on Lubuntu and featuring the LXDE desktop environment. Compared to its parent, LXLE has a number of unique characteristics: it is built from Ubuntu's LTS (long-term support) releases, it covers most users' everyday needs by providing a good selection of default applications, and it adds useful modifications and tweaks to improve performance and functions.

Popularity (hits per day): 12 months: 23 (440), 6 months: 22 (408), 3 months: 32 (311), 4 weeks: 37 (286), 1 week: 39 (281)

Average visitor rating: 8.57/10 from 23 review(s).


LXLE Summary
Distribution 	LXLE
Home Page 	http://lxle.net/
Mailing Lists 	http://lists.sourceforge.net/lists/listinfo/lxle-general
User Forums 	http://lxle.net/forums/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://wiki.lxle.net/doku.php • http://lxle.net/?id=support
Screenshots 	http://lxle.net/?id=screenshots • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.lxle.net/download • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	14.04: Linux User • DistroWatch • Blogspot
12.04: Blogspot • DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
home_page[X]="http://lxle.net/"
#
distro[X]="lxle"								# fitst distro[X] = null end array of distros/packages..
version[X]="_16_04_2"
desktop[X]=""
arch[X]="_32"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="SHA256SUMS.gpg"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/lxle/files/Final/OS/16.04.2-32/
https://sourceforge.net/projects/lxle/files/Final/OS/16.04.2-64/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.7 GB"
#
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[20] () {
X=20
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
gen_boot_menus[20] () {
X=20
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz.efi"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/custom.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="install"
append_x="file=/cdrom/preseed/custom.seed boot=casper only-ubiquity quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[20] () {
X=20
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=21 # Nr. pos
comment[X]=$(cat<<-EOF
Zorin OS
Last Update: 2017-02-25 12:09 UTC

[Zorin OS]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: Ireland
    Architecture: i386, x86_64
    Desktop: GNOME, LXDE
    Category: Beginners, Desktop, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 9 (954 hits per day) 

Zorin OS is an Ubuntu-based Linux distribution designed especially for newcomers to Linux. It has a Windows-like graphical user interface and many programs similar to those found in Windows. Zorin OS also comes with an application that lets users run many Windows programs. The distribution's ultimate goal is to provide a Linux alternative to Windows and let Windows users enjoy all the features of Linux without complications.

Popularity (hits per day): 12 months: 8 (980), 6 months: 9 (954), 3 months: 10 (795), 4 weeks: 11 (675), 1 week: 10 (661)

Average visitor rating: 8.01/10 from 79 review(s).


Zorin Summary
Distribution 	Zorin OS
Home Page 	http://www.zorin-os.com/
Mailing Lists 	--
User Forums 	http://www.zoringroup.com/forum/viewforum.php?f=3
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	http://zorin-os.com/gallery.html • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://zorin-os.com/free.html • LinuxTracker.org
Bug Tracker 	--
Related Websites 	--
Reviews 	12: DistroWatch • DarkDuck • Everyday Linux User • CMS Critic • derStandard (German)
11: DistroWatch
10: DistroWatch • Dedoimedo
9: Blogspot • Blogspot
8: Blogspot • Blogspot • ZDNet • Linux Insider • Everyday Linux User • Blogspot
7: Dedoimedo • Blogspot • DistroWatch • Blogspot
6: Blogspot • Everyday Linux User • Linux Insider • DarkDuck • Wordpress • DistroWatch • Linux User • DarkDuck • DarkDuck • Linux Za Sve (Croatian) • Linux Za Sve (Croatian)
5: Wordpress • Tech-FAQ
4: Blogspot • DistroWatch
3: Dedoimedo • Blogspot
2: Viva O Linux (Portuguese) • IT Lure
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.zorin-os.com/"
#
distro[X]="Zorin-OS"								# fitst distro[X] = null end array of distros/packages..
version[X]="-12.1-Core"
desktop[X]=""
arch[X]="-32"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="a8b4c5cfb4592561faad3062d421133967f4ed4d" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/zorin-os/files/12/
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
get_download_parameters[21] () {
X=21
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
gen_boot_menus[21] () {
X=21
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity quiet splash ---"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[21] () {
X=21
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
X=22 # Nr. pos
comment[X]=$(cat<<-EOF
Ultimate Edition
Last Update: 2017-06-25 03:43 UTC

[Ultimate Edition]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: USA
    Architecture: armhf, i386, x86_64
    Desktop: Awesome, Budgie, GNOME, KDE Plasma, MATE
    Category: Desktop, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 36 (280 hits per day) 

Ultimate Edition, first released in December 2006, is a fork of Ubuntu and Linux Mint. The goal of the project is to create a complete, seamlessly integrated, visually stimulating, and easy-to-install operating system. Single-button upgrade is one of several special characteristics of this distribution. Other main features include custom desktop and theme with 3D effects, support for a wide range of networking options, including WiFi and Bluetooth, and integration of many extra applications and package repositories.

Popularity (hits per day): 12 months: 35 (294), 6 months: 36 (280), 3 months: 39 (250), 4 weeks: 53 (210), 1 week: 68 (152)

Average visitor rating: 9/10 from 4 review(s).


Ultimate Edition Summary
Distribution 	Ultimate Edition
Home Page 	http://ultimateedition.info/
Mailing Lists 	--
User Forums 	http://forumubuntusoftware.info/
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://sourceforge.net/projects/ultimateedition/files • LinuxTracker.org
Bug Tracker 	--
Related Websites 	Ultimate Edition Australia • Ultimate Edition Romania
Reviews 	5.x : LinuxInsider
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://ultimateedition.info/"
#
distro[X]="ultimate-editionx"								# fitst distro[X] = null end array of distros/packages..
version[X]="-5.5"
desktop[X]=""
arch[X]="-x64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="6b945dc404f9e6f93fc0daefe7b1887cf8dea267" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/ultimateedition/files/
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
get_download_parameters[22] () {
X=22
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
gen_boot_menus[22] () {
X=22
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper noeject quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity noeject quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[22] () {
X=22
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
X=23 # Nr. pos
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://ultimateedition.info/"
#
distro[X]="ultimate-edition"								# fitst distro[X] = null end array of distros/packages..
version[X]="-5.0"
desktop[X]=""
arch[X]="-x64-gamers"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="b38bfca097f8a3b6d3bf296898d21292b46e697d" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/ultimateedition/files/
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
get_download_parameters[23] () {
X=23
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
gen_boot_menus[23] () {
X=23
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper noeject quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity noeject quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[23] () {
X=23
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
X=24 # Nr. pos
comment[X]=$(cat<<-EOF
Black Lab Linux
Last Update: 2017-08-26 01:22 UTC

[Black Lab Linux]

    OS Type: Linux
    Based on: Debian, Ubuntu (LTS)
    Origin: USA
    Architecture: x86_64
    Desktop: GNOME, KDE Plasma, LXDE, MATE, Xfce
    Category: Beginners, Desktop, Live Medium
    Status: Active
    Popularity: 39 (263 hits per day) 

Black Lab Linux (formerly OS4 OpenLinux) is a user-friendly, commercial desktop and server Linux distribution based on Ubuntu. Some of its most interesting features include support for popular browser plugins, addition of packages for multimedia production, content creation and software development, and an innovative desktop layout based on GNOME Shell. Separate editions with KDE and Xfce desktops are also available. The company behind the distribution also sells a desktop mini-system with Black Lab Linux pre-installed.

Popularity (hits per day): 12 months: 35 (292), 6 months: 39 (263), 3 months: 49 (222), 4 weeks: 26 (369), 1 week: 8 (1,128)

Average visitor rating: 6.11/10 from 9 review(s).


Black Lab Summary
Distribution 	Black Lab Linux (formerly OS4 OpenLinux, before PC/OS)
Home Page 	http://www.blacklablinux.org/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://blltechweb.blogspot.com/p/documentation.html
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://sourceforge.net/projects/os4online/files/ • LinuxTracker.org
Bug Tracker 	http://blltechweb.blogspot.com/p/support.html
Related Websites 	Black Lab Software, Inc. • Black Lab Linux Experimental • Wikipedia
Reviews 	6.1: Desktop Linux Reviews
13: Blogspot • Blogspot
2009: Linux.com
2008: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-08-21: Distribution Release: Black Lab Linux 11.0.3
 SummaryFilesReviewsSupportWikiTicketsDiscussionBlogCode
Index of /blacklab/enterprise/
Name 	Last Modified 	Size 	Type
Parent Directory	 	 	Directory
Developer and Expansion Packs/	2016-Jul-13 19:42:28	- 	Directory
bll-1103-ent-x64.iso	2017-Aug-19 14:27:31	1.7G 	application/octet-stream
bll-1103-ent-x64.iso.md5	2017-Aug-19 14:28:00	0.1K 	application/octet-stream
bll-1103-ent-x64.iso.sha256	2017-Aug-19 14:28:29	0.1K 	application/octet-stream
bll-1103-mate-x64.iso.md5	2017-Aug-10 19:09:33	0.1K 	application/octet-stream
bll-ent-11-x86_64.iso	2017-May-30 00:29:49	1.6G 	application/octet-stream
bll-ent-11-x86_64.iso.md5	2017-May-30 00:23:55	0.1K 	application/octet-stream
bll-ent-11-x86_64.iso.sha256	2017-May-30 00:23:44	0.1K 	application/octet-stream
bll-ent-9-x86_64.iso	2017-Apr-10 16:15:49	1.5G 	application/octet-stream
bll-ent-9-x86_64.iso.md5	2017-Apr-10 16:32:48	0.1K 	application/octet-stream
EOF
)
#
home_page[X]="http://www.blacklablinux.org/"
#
distro[X]="bll"								# fitst distro[X] = null end array of distros/packages..
version[X]="-1103-ent"
desktop[X]=""
arch[X]="-x64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.sha256" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://distro.ibiblio.org/blacklab/enterprise/
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
get_download_parameters[24] () {
X=24
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
gen_boot_menus[24] () {
X=24
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper noeject quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity noeject quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[24] () {
X=24
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
X=25 # Nr. pos
comment[X]=$(cat<<-EOF
[ Black Lab Linux ]
Last Update: 2017-08-26 01:22 UTC

EOF
)
#
home_page[X]="http://www.blacklablinux.org/"
#
distro[X]="bll"								# fitst distro[X] = null end array of distros/packages..
version[X]="-1103-mate"
desktop[X]=""
arch[X]="-x64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.sha256" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://distro.ibiblio.org/blacklab/enterprise/
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
get_download_parameters[25] () {
X=25
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
gen_boot_menus[25] () {
X=25
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper noeject quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity noeject quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[25] () {
X=25
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
X=26 # Nr. pos
comment[X]=$(cat<<-EOF
Ubuntu MATE
Last Update: 2017-08-26 01:22 UTC

[Ubuntu MATE]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: United Kingdom
    Architecture: armhf, i386, powerpc, x86_64
    Desktop: MATE
    Category: Beginners, Desktop, Live Medium, Raspberry Pi
    Status: Active
    Popularity: 26 (373 hits per day) 

Ubuntu MATE is a desktop Linux distribution which aims to bring the simplicity and elegance of the Ubuntu operating system through a classic, traditional desktop environment - the MATE desktop. MATE is the continuation of the GNOME 2 desktop environment which was used as Ubuntu's default desktop until 10.10 (when it was replaced by Unity). The project began its life as an Ubuntu "remix", but starting with version 15.04, it was formally accepted as an official member of the Ubuntu family of Linux distributions.

Popularity (hits per day): 12 months: 21 (452), 6 months: 26 (373), 3 months: 30 (314), 4 weeks: 22 (401), 1 week: 37 (271)

Average visitor rating: 9.56/10 from 50 review(s).


Ubuntu MATE Summary
Distribution 	Ubuntu MATE
Home Page 	https://ubuntu-mate.org/
Mailing Lists 	--
User Forums 	https://ubuntu-mate.community/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://ubuntu-mate.community/t/tips-tutorials-and-guides-index/14519
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://ubuntu-mate.org/utopic/ • LinuxTracker.org
Bug Tracker 	https://bugs.launchpad.net/
Related Websites 	 
Reviews 	17.04: DarkDuck
16.10: CMS Critic
16.04: DarkDuck • DistroWatch
15.10: Dedoimedo
14.10: Blogspot • DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-07-28: Development Release: Ubuntu MATE 17.10 Alpha 2
 • 2017-04-13: Distribution Release: Ubuntu MATE 17.04
EOF
)
#
home_page[X]="https://ubuntu-mate.org/"
#
distro[X]="ubuntu"								# fitst distro[X] = null end array of distros/packages..
desktop[X]="-mate"
version[X]="-16.04.3-desktop"
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="SHA256SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="SHA256SUMS.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/
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
get_download_parameters[26] () {
X=26
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
gen_boot_menus[26] () {
X=26
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper noeject quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity noeject quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[26] () {
X=26
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
X=27 # Nr. pos
comment[X]=$(cat<<-EOF
DEFT Linux
Last Update: 2017-08-26 01:22 UTC

[DEFT Linux]

    OS Type: Linux
    Based on: Debian, Lubuntu
    Origin: Italy
    Architecture: i486
    Desktop: LXDE, Openbox
    Category: Live Medium, Forensics
    Status: Active
    Popularity: 180 (45 hits per day) 

DEFT (Digital Evidence & Forensic Toolkit) is a customised distribution of the Ubuntu live Linux CD. It is an easy-to-use system that includes excellent hardware detection and some of the best open-source applications dedicated to incident response and computer forensics.

Popularity (hits per day): 12 months: 187 (44), 6 months: 180 (45), 3 months: 172 (40), 4 weeks: 161 (39), 1 week: 157 (37)

Visitor rating: No visitor rating given yet. Rate this project.


DEFT Summary
Distribution 	DEFT Linux
Home Page 	http://www.deftlinux.net/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.deftlinux.net/deft-manual/
Screenshots 	http://www.deftlinux.net/screenshot/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.deftlinux.net/download/
Bug Tracker 	--
Related Websites 	 
Reviews 	5: Br4v3-H34r7's BloG (Arabic)
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-02-14: Distribution Release: DEFT Linux 2017.1 "Zero"
 Index of /mirrors/deft/zero/

../
deftZ-2017-1.iso                                   10-Feb-2017 01:18           532676608
deftZ-2017-1.iso.md5     
EOF
)
#
home_page[X]="http://www.deftlinux.net/"
#
distro[X]="deftZ"								# fitst distro[X] = null end array of distros/packages..
desktop[X]=""
version[X]="-2017-1"
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
#gpg[X]=""
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"	# folder for download iso file from mirros
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
free_space[X]="0.6 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[27] () {
X=27
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
gen_boot_menus[27] () {
X=27
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper noeject quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/ubuntu.seed boot=casper only-ubiquity noeject quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[27] () {
X=27
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
X=28 # Nr. pos
comment[X]=$(cat<<-EOF
BackSlash Linux
Last Update: 2017-08-28 00:36 UTC

[BackSlash Linux]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: India
    Architecture: x86_64
    Desktop: KDE Plasma
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 298 (10 hits per day) 

BackSlash Linux is an Ubuntu-based desktop distribution featuring a custom shell running on top of the KDE Plasma desktop. BackSlash features a user interface inspired by macOS.

Popularity (hits per day): 12 months: 298 (5), 6 months: 298 (10), 3 months: 294 (20), 4 weeks: 132 (62), 1 week: 50 (228)

Average visitor rating: 9.25/10 from 4 review(s).


BackSlash Linux
Distribution 	BackSlash Linux
Home Page 	https://backslashlinux.com/
Mailing Lists 	--
User Forums 	http://backslashlinux.boards.net/board/1/general-discussion
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	--
Screencasts 	
Download Mirrors 	https://sourceforge.net/projects/backslash-linux/files/BackSlash%20Linux/ •
Bug Tracker 	https://bugs.launchpad.net/backslashlinux
Related Websites 	--
Reviews 	
Where To Buy 	OSDisc.com (sponsored link)
 beta-releases 	2017-08-13 		322322 weekly downloads 	 
Olaf 	2017-05-08 		396396 weekly downloads 	 
Flavors 	2017-03-31 		2626 weekly downloads 	 
Anna 	2017-01-02 		2626 weekly downloads 	 
Elsa 	2017-01-01 		3030 weekly downloads 	 
EOF
)
#
home_page[X]="https://backslashlinux.com/"
#
distro[X]="BackSlash "								# fitst distro[X] = null end array of distros/packages..
desktop[X]="Linux "
version[X]="Olaf "
arch[X]="x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="d47849594e16966e36b53b86e60d5d4ffb81e006" 				# file with sum to download or sum
#sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
#gpg[X]=""
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://sourceforge.net/projects/backslash-linux/files/BackSlash%20Linux/Olaf/
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
get_download_parameters[28] () {
X=28
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
gen_boot_menus[28] () {
X=28
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/custom.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/custom.seed boot=casper only-ubiquity quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[28] () {
X=28
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
X=29 # Nr. pos
comment[X]=$(cat<<-EOF
[BackSlash Linux]
https://sourceforge.net/projects/backslash-linux/files/BackSlash%20Linux/beta-releases/kristoff/
EOF
)
#
home_page[X]="https://backslashlinux.com/"
#
distro[X]="kristoff"								# fitst distro[X] = null end array of distros/packages..
desktop[X]=""
version[X]="-beta"
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="ed6573d3d22fd4296613aeee3f6f086ae232e9c1" 				# file with sum to download or sum
#sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
#gpg[X]=""
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://sourceforge.net/projects/backslash-linux/files/BackSlash%20Linux/beta-releases/kristoff/
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
get_download_parameters[29] () {
X=29
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
gen_boot_menus[29] () {
X=29
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/custom.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (install)"
append_x="file=/cdrom/preseed/custom.seed boot=casper only-ubiquity quiet splash --"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[29] () {
X=29
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
#!FIXME ### --- New Item ------ ###
X=30
comment[X]=$(cat<<-EOF
KDE neon
Last Update: 2017-11-09 03:04 UTC

[KDE neon]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: United Kingdom
    Architecture: x86_64
    Desktop: KDE Plasma
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 24 (386 hits per day) 

KDE neon is a Ubuntu-based Linux distribution and live DVD featuring the latest KDE Plasma desktop and other KDE community software. Besides the installable DVD image, the project provides a rapidly-evolving software repository with all the latest KDE software. Two editions of the product are available - a "User" edition, designed for those interested in checking out the latest KDE software as it gets released, and a "Developer's" edition, created as a platform for testing cutting-edge KDE applications.

Popularity (hits per day): 12 months: 22 (448), 6 months: 24 (386), 3 months: 25 (377), 4 weeks: 25 (427), 1 week: 17 (600)

Average visitor rating: 9.18/10 from 114 review(s).


KDE neon Summary
Distribution 	KDE neon
Home Page 	https://neon.kde.org/
Mailing Lists 	--
User Forums 	https://forum.kde.org/viewforum.php?f=309
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://community.kde.org/Neon
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://neon.kde.org/download •
Bug Tracker 	https://bugs.launchpad.net/
Related Websites 	 
Reviews 	2017: DarkDuck
5.7: DistroWatch • Dedoimedo
5.6: Phoronix
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://neon.kde.org/"
#
distro[X]="neon-userltsedition-current"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]="26957f15ed9c8203d67d32a4df1c7b3b69aac4fb"
#sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://files.kde.org/neon/images/neon-userltsedition/current/
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
get_download_parameters[30] () {
X=30
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
	echo "$Cyan Get data for - distro[$X] ${distro[X]}$Reset"
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
	)
	echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Green of - „$file_name_x” $Reset"
	
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
gen_boot_menus[30] () {
X=30
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/casper/vmlinuz.efi"
iso_command_x="iso-scan/filename="
append_x="boot=casper quiet splash ---"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(OEM mode)"
append_x=" boot=casper quiet splash --- oem-config/enable=true"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[30] () {
X=30
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="

"
#

}

 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
