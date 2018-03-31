#!/bin/bash
# new_install_arch_based_linux.sh
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
 ### Linux Mint ###
X=1 # Nr. pos
comment[X]=$(cat<<-EOF
Manjaro Linux
Last Update: 2017-07-03 15:50 UTC

[Manjaro Linux]

    OS Type: Linux
    Based on: Arch
    Origin: Austria, Germany, France
    Architecture: i686, x86_64
    Desktop: Budgie, Cinnamon, Deepin, GNOME, i3, KDE Plasma, LXDE, LXQt, Xfce
    Category: Desktop, Live Medium
    Release Model: Rolling
    Init: OpenRC,systemd
    Status: Active
    Popularity: 3 (1,873 hits per day) 

Manjaro Linux is a fast, user-friendly, desktop-oriented operating system based on Arch Linux. Key features include intuitive installation process, automatic hardware detection, stable rolling-release model, ability to install multiple kernels, special Bash scripts for managing graphics drivers and extensive desktop configurability. Manjaro Linux offers Xfce as the core desktop options, as well as a minimalist Net edition for more advanced users. Community-supported GNOME 3/Cinnamon and KDE flavours are available. Users also benefit from the supportive and vibrant Manjaro community forum.

Popularity (hits per day): 12 months: 3 (1,487), 6 months: 3 (1,873), 3 months: 3 (1,919), 4 weeks: 3 (1,702), 1 week: 3 (1,725)

Average visitor rating: 8.75/10 from 215 review(s).


Manjaro Summary
Distribution 	Manjaro Linux
Home Page 	https://manjaro.org/
Mailing Lists 	https://lists.manjaro.org/
User Forums 	https://forum.manjaro.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://wiki.manjaro.org/
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://manjaro.org/get-manjaro/ • LinuxTracker.org
Bug Tracker 	https://manjaro.org/feedback/
EOF
)
#
home_page[X]="https://manjaro.org/"
#
distro[X]="manjaro-"									# fitst distro[X] = null end array of distros/packages..
desktop[X]="kde-"
version[X]="17.0.2-stable-"
arch[X]="i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"		# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${file_name[X]}.sig"				 				# file with sum to download or sum
sum_file[X]="${sum[X]}"									# comment file name to disable if sum is set
# gpg[X]="manjaro-kde-17.0.2-stable-x86_64.iso.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"		# folder for download iso file from mirros - independent can be hard code
#
: ${mirrors[X]="
 https://sourceforge.net/projects/manjarolinux/files/release/17.0.2/kde/
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
gen_boot_menus[1] () {
X=1
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
# NOTE: find_reala_boot_path procedure try set variables:
# $real_dev_path_X - psychcal path for boot proces; $uuid; $dev_file_system_type
# $dev_name; $distro_dir - only path; $isofile - real path and isofle
find_reala_boot_path
add_menu_label_x="Live (i686) (free)"
kernel_x="/boot/vmlinuz-i686"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo"
initrd_x="/boot/intel_ucode.img
	initrd $real_dev_path_X/boot/initramfs-i686.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (i686) (nonfree)"
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo nonfree=yes"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
iso_command_x=""
append_x=""
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

To change password for root code - su sudo & passwd root

You may want to disable KMS for various reasons, such as getting a blank screen
or a no signal error from the display, when using the Catalyst driver, etc.
To disable KMS add nomodeset as a kernel parameter.
Along with nomodeset kernel parameter, for Intel graphics card you need to add
i915.modeset=0 and for Nvidia graphics card you need to add nouveau.modeset=0.
For Nvidia Optimus dual-graphics system, you need to add all the three 
kernel parameters (i.e. nomodeset i915.modeset=0 nouveau.modeset=0).
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF
EOF
)
#
home_page[X]="https://manjaro.org/"
distro[X]="manjaro-"
desktop[X]="xfce-"
version[X]="17.0.2-stable-"
arch[X]="i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha1"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/manjarolinux/files/release/17.0.2/xfce/
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
gen_boot_menus[2] () {
X=2
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (i686) (free)"
kernel_x="/boot/vmlinuz-i686"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo"
initrd_x="/boot/intel_ucode.img
	initrd $real_dev_path_X/boot/initramfs-i686.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (i686) (nonfree)"
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo nonfree=yes"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
iso_command_x=""
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
Important_after_installation[X]="${Important_after_installation[1]}"

#
#!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF
EOF
)
home_page[X]="https://manjaro.org/"
#
distro[X]="manjaro-"
desktop[X]="gnome-"
version[X]="17.0.2-stable-"
arch[X]="i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha1"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/manjarolinux/files/release/17.0.2/gnome/
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
gen_boot_menus[3] () {
X=3
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (i686) (free)"
kernel_x="/boot/vmlinuz-i686"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo"
initrd_x="/boot/intel_ucode.img
	initrd $real_dev_path_X/boot/initramfs-i686.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (i686) (nonfree)"
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo nonfree=yes"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=4
comment[X]=$(cat<<-EOF
EOF
)
#
home_page[X]="https://manjaro.org/"
distro[X]="manjaro-"
desktop[X]="kde-"
version[X]="17.0.2-stable-"
arch[X]="x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha1"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/manjarolinux/files/release/17.0.2/kde/
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
gen_boot_menus[4] () {
X=4
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (x86_64) (free)"
kernel_x="/boot/vmlinuz-x86_64"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo"
initrd_x="/boot/intel_ucode.img
	initrd $real_dev_path_X/boot/initramfs-x86_64.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (x86_64) (nonfree)"
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo nonfree=yes"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=5
comment[X]=$(cat<<-EOF
EOF
)
#
home_page[X]="https://manjaro.org/"
distro[X]="manjaro-"
desktop[X]="xfce-"
version[X]="17.0.2-stable-"
arch[X]="x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha1"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/manjarolinux/files/release/17.0.2/xfce/
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
get_download_parameters[5] () {
X=5
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
gen_boot_menus[5] () {
X=5
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (x86_64) (free)"
kernel_x="/boot/vmlinuz-x86_64"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo"
initrd_x="/boot/intel_ucode.img
	initrd $real_dev_path_X/boot/initramfs-x86_64.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (x86_64) (nonfree)"
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo nonfree=yes"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[5] () {
X=5
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]="${Important_after_installation[1]}"

#
#!FIXME ### --- New Item ------ ###
X=6
comment[X]=$(cat<<-EOF
EOF
)
#
home_page[X]="https://manjaro.org/"
distro[X]="manjaro-"
desktop[X]="gnome-"
version[X]="17.0.2-stable-"
arch[X]="x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha1"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/manjarolinux/files/release/17.0.2/gnome/
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
gen_boot_menus[6] () {
X=6
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (x86_64) (free)"
kernel_x="/boot/vmlinuz-x86_64"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo"
initrd_x="/boot/intel_ucode.img
	initrd $real_dev_path_X/boot/initramfs-x86_64.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (x86_64) (nonfree)"
append_x="misobasedir=manjaro misolabel=MJRO1702 nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo nonfree=yes"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[6] () {
X=6
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=7
comment[X]=$(cat<<-EOF
Description: 

[Dark Colors Theme for GRUB 2]
by Leszek Ostachowski® (©2017) @GPL V2
Forked from Archxion by Legendary Bibo Changed by American_Jesus
and ubuntu-mate GRUB2 theme by nadrimajsto
and Maple Theme for GRUB 2 Created by PM2D...

__________________________________

* Fast installation - copy below lines to konsole for run.
__________________________________

wget -O "Dark_Colors_Grub2_theme.tar.gz" "https://dl.opendesktop.org/api/files/download/id/1490460174/Dark_Colors_Grub2_theme.tar.gz"
tar xvfz "Dark_Colors_Grub2_theme.tar.gz"
cd Dark_Colors_Grub2_theme
sudo bash install_dark_colors_grub2_theme.sh
EOF
)
#
home_page[X]="https://www.trinity-look.org/p/1000085/"
#
distro[X]="Dark_Colors_Grub2_theme" # comment name to disable
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".tar.gz"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sha256"
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="https://www.trinity-look.org/p/1000085/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="yes"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="0.1 GB"
key_server[X]=""
 ### NOTE: Get dowload parameters - script executed before start download files
get_download_parameters[7] () {
X=7
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
	

	echo "$Cyan Get data for - distro[$X] ${distro[X]}, from package page - ${home_page[X]}$Reset$Nline"
	file_to_download=$(wget -O - "${home_page[X]}"| grep 'wget -O')
	file_to_download=${file_to_download%&*}
	file_to_download=${file_to_download##*;}
	url_to_download=${file_to_download%/*}
	echo "$Nline$Green Url_to_download: $Cyan"$url_to_download/"$Reset"
	mirrors[X]="$url_to_download/"
elif ! [ $? = 0 ]
then :
	# echo "$Nline$Cyan No internet connection go offline$Reset"
	url_to_download="Off_line_"

else :
	
fi
}
 ### NOTE: install script executed after downlad files in install folder
install_package[7] () {
X=7
tar xvfz "Dark_Colors_Grub2_theme.tar.gz";
cd Dark_Colors_Grub2_theme;
/bin/bash install_dark_colors_grub2_theme.sh;
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=8
comment[X]=$(cat<<-EOF
Antergos
Last Update: 2017-03-07 04:52 UTC

[Antergos]

    OS Type: Linux
    Based on: Arch
    Origin: Spain
    Architecture: x86_64
    Desktop: Cinnamon, GNOME, KDE, MATE, Openbox, Xfce
    Category: Desktop, Live Medium
    Release Model: Rolling
    Status: Active
    Popularity: 10 (811 hits per day) 

Antergos is a modern, elegant and powerful operating system based on Arch Linux. It started life under the name of Cinnarch, combining the Cinnamon desktop with the Arch Linux distribution, but the project has moved on from its original goals and now offers a choice of several desktops, including GNOME 3 (default), Cinnamon, Razor-qt and Xfce. Antergos also provides its own graphical installation program.

Popularity (hits per day): 12 months: 13 (672), 6 months: 10 (811), 3 months: 9 (913), 4 weeks: 8 (1,031), 1 week: 10 (1,057)

Average visitor rating: 9.33/10 from 9 review(s).


Antergos Summary
Distribution 	Antergos (formerly Cinnarch)
Home Page 	https://www.antergos.com/
Mailing Lists 	--
User Forums 	https://forum.antergos.com/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://wiki.antergos.com/
Screenshots 	LinuxQuestions.org • DistroWatch Gallery
Screencasts 	LinuxQuestions.org
Download Mirrors 	https://www.antergos.com/try-it/ • LinuxTracker.org
Bug Tracker 	https://bugs.antergos.com/
Related Websites 	 
Reviews 	2016: DistroWatch • Everyday Linux User • FOSS Force
2015: Ordinatechnic
2014: DistroWatch • LinuxBSDos
2013: LinuxBSDos • Blogspot • LinuxBSDos
2012: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://www.antergos.com/"
#
distro[X]="antergos"
version[X]="-17.6"
desktop[X]=""
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="MD5SUMS${version[X]}"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 http://mirrors.nic.cz/antergos/iso/release/
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
gen_boot_menus[8] () {
X=8
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path


add_menu_label_x="Live (86_64)"
kernel_x="/arch/boot/vmlinuz"
iso_command_x="img_dev=$dev_name img_loop="
append_x="archisobasedir=arch archisolabel=ANTERGOS modules-load=loop rd.modules-load=loop udev.log-priority=crit rd.udev.log-priority=crit quiet splash"
initrd_x="/arch/boot/intel_ucode.img
initrd $real_dev_path_X/arch/boot/archiso.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (86_64) (nonfree)"
append_x="archisobasedir=arch archisolabel=ANTERGOS modules-load=loop rd.modules-load=loop udev.log-priority=crit rd.udev.log-priority=crit nonfree=yes quiet splash"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
iso_command_x=""
append_x=""
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=9
comment[X]=$(cat<<-EOF
OBRevenge OS
Last Update: 2017-02-03 02:57 UTC

[OBRevenge OS]

    OS Type: Linux
    Based on: Arch
    Origin: USA
    Architecture: i386, x86_64
    Desktop: Openbox
    Category: Desktop, Live Medium
    Release Model: Rolling
    Status: Active
    Popularity: 286 (1 hits per day) 

OBRevenge OS is a desktop operating system that is based on the Arch Linux distribution. OBRevenge features a live DVD and offers users the Openbox window manager and Xfce panel with the Whisker menu as the default login session. The distribution includes a welcome window and the Pamac graphical software manager to help users get set up with the software and drivers they need. The distribution can be installed using the Calamares system installer.

Popularity (hits per day): 12 months: 286 (0), 6 months: 286 (1), 3 months: 286 (3), 4 weeks: 286 (9), 1 week: 199 (42)

Average visitor rating: 9.5/10 from 2 review(s).


OBRevenge Summary
Distribution 	OBRevenge OS
Home Page 	http://obrevenge.weebly.com/
Mailing Lists 	--
User Forums 	https://plus.google.com/u/0/communities/115644675078865877931
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://github.com/obrevenge/obrevenge-iso/wiki
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://sourceforge.net/projects/obrevenge/files/
Bug Tracker 	https://github.com/obrevenge/obrevenge-iso/issues
Related Websites 	 
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://obrevenge.weebly.com/"
#
distro[X]="obrevenge"
version[X]="-2017.03"
desktop[X]=""
arch[X]="-i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="5c8461de9556edd8fc0a84babdfc1d6c043525c4"
# sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sha256sum.asc"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/obrevenge/files/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.3 GB"
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
gen_boot_menus[9] () {
X=9
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
aadd_menu_label_x="Live (i686)"
kernel_x="/arch/boot/i686/vmlinuz"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="archisobasedir=arch archisolabel=obrevenge-201703-32bit"
initrd_x="/arch/boot/intel_ucode.img
initrd $real_dev_path_X/arch/boot/i686/archiso.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
iso_command_x=""
append_x=""
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=10
#
home_page[X]="http://obrevenge.weebly.com/"
#
distro[X]="obrevenge"
version[X]="-2017.05"
desktop[X]=""
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="6cf8f1068f0c00ae2470e9d013ee933b47639e6f"

# sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sha256sum.asc"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/obrevenge/files/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.3 GB"
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
gen_boot_menus[10] () {
X=10
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (x86_64)"
kernel_x="/arch/boot/x86_64/vmlinuz"
iso_command_x="showopts img_dev=$dev_name img_loop="
append_x="archisobasedir=arch archisolabel=ARCH_201705"
initrd_x="/arch/boot/intel_ucode.img
initrd $real_dev_path_X/arch/boot/x86_64/archiso.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
kernel_x=""
iso_command_x=""
append_x=""
initrd_x=""
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
iso_command_x=""
append_x=""
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=11
comment[X]=$(cat<<-EOF
LinHES
Last Update: 2017-02-16 10:49 UTC

[LinHES]

    OS Type: Linux
    Based on: Arch
    Origin: USA
    Architecture: x86_64
    Desktop: Enlightenment, WMaker
    Category: Live Medium, MythTV
    Release Model: Fixed
    Status: Active
    Popularity: 170 (54 hits per day) 

LinHES is an attempt to make the installation of GNU/Linux and MythTV as trivial as possible. It includes everything needed to get your set-top box up and running in as little time as possible. LinHES is based on Arch Linux and is targeted at anyone looking for a set-top box solution.

Popularity (hits per day): 12 months: 163 (59), 6 months: 170 (54), 3 months: 162 (61), 4 weeks: 119 (97), 1 week: 39 (303)

No vistor rating given yet. Rate this project.


LinHES Summary
Distribution 	LinHES (formerly KnoppMyth)
Home Page 	http://www.linhes.org/
Mailing Lists 	http://lists.linhes.org/
User Forums 	http://forum.linhes.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.linhes.org/projects/linhes/wiki/Guides
Screenshots 	http://www.linhes.org/projects/linhes/wiki/Screenshots
Screencasts 	
Download Mirrors 	http://www.linhes.org/projects/linhes/wiki/Downloads
Bug Tracker 	http://linhes.org/projects/linhes/issues
Related Websites 	 
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.linhes.org/"
#
distro[X]="LinHES"
version[X]="_R8.4.3"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sha256sum.asc"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 http://www.linhes.org/downloads/Current/
 "}
#
comment=cat<<-EOF
Index of /downloads/Current/
Name	Last Modified	Size	Type
Parent Directory/	 	-  	Directory
LinHES_R8.4.1.iso	2016-May-18 23:18:55	913.0M	application/octet-stream
LinHES_R8.4.1.iso.md5	2016-May-18 23:18:55	0.1K	application/octet-stream
LinHES_R8.4.2.iso	2016-Nov-18 17:28:45	908.0M	application/octet-stream
LinHES_R8.4.2.iso.md5	2016-Nov-18 17:05:47	0.1K	application/octet-stream
LinHES_R8.4.3.iso	2017-Feb-15 20:27:49	905.0M	application/octet-stream
LinHES_R8.4.3.iso.md5	2017-Feb-15 20:27:49	0.1K	application/octet-stream
lighttpd/1.4.39
EOF
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
get_download_parameters[11] () {
X=11
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
gen_boot_menus[11] () {
X=11
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (x86_64)"
kernel_x="/arch/boot/x86_64/vmlinuz"
iso_command_x="img_dev=$dev_name archisolabel=LinHES_201702 img_loop="
append_x="archisobasedir=arch splash console=tty1"
initrd_x="/arch/boot/x86_64/archiso.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
#!FIXME ### --- New Item ------ ###
X=12
comment[X]=$(cat<<-EOF
ArchLabs
Last Update: 2017-09-20 14:53 UTC

[ArchLabs]

    OS Type: Linux
    Based on: Arch
    Origin: New Zealand
    Architecture: x86_64
    Desktop: Openbox
    Category: Live Medium
    Status: Active
    Popularity: 113 (81 hits per day) 

ArchLabs is a distribution based on Arch Linux and featuring the Openbox window manager as the primary desktop interface. ArchLabs is a 64-bit, rolling release distribution which provides a live DVD. The distribution can be installed using the Calamares graphical system installer.

Popularity (hits per day): 12 months: 205 (40), 6 months: 113 (81), 3 months: 66 (163), 4 weeks: 21 (394), 1 week: 6 (1,078)

Average visitor rating: 8.33/10 from 21 review(s).


Archlabs
Distribution 	ArchLabs
Home Page 	https://archlabsblog.wordpress.com/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://archlabsblog.wordpress.com/tutorials/
https://wiki.archlinux.org/
Screenshots 	--
Screencasts 	
Download Mirrors 	https://sourceforge.net/projects/archlabs-linux-minimo/files/ArchLabsMinimo/ •
Bug Tracker 	--
Related Websites 	--
Reviews 	
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://archlabsblog.wordpress.com/"
#
distro[X]="archlabs"
version[X]="-minimo-2017.09"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="de979e55a264f72ccd19a5d11c9d79a950d9c16e"
# sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sha256sum.asc"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://sourceforge.net/projects/archlabs-linux-minimo/files/ArchLabsMinimo/
 "}
#
comment=cat<<-EOF

Looking for the latest version? Download archlabs-minimo-2017.09.iso (956.3 MB)
Home / ArchLabsMinimo
Name 	Modified 	Size 	Downloads / Week 	Status
Parent folder
archlabs-minimo-2017.09.iso 	2017-09-18 	956.3 MB 	9,6209,620 weekly downloads 	i
archlabs-v5.0.0-minimo.iso 	2017-08-27 	996.1 MB 	7676 weekly downloads 	i
Totals: 2 Items 	  	2.0 GB 	9,696 	
EOF
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
get_download_parameters[12] () {
X=12
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
gen_boot_menus[12] () {
X=12
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (x86_64)"
kernel_x="/arch/boot/x86_64/vmlinuz"
iso_command_x="img_dev=$dev_name archisolabel=archlabs-minimo-201709-x86_64 img_loop="
append_x="archisobasedir=arch splash"
initrd_x="/arch/boot/intel_ucode.img
       initrd $real_dev_path_X/arch/boot/x86_64/archiso.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
X=13
distro[X]="parabola"

#!FIXME ### --- New Item ------ ###
X=14
comment[X]=$(cat<<-EOF
Parabola GNU/Linux-libre
Last Update: 2017-10-19 18:00 UTC

[Parabola GNU/Linux-libre]

    OS Type: Linux
    Based on: Arch
    Origin: Chile
    Architecture: armv7, i686, x86_64
    Desktop: Blackbox, Fluxbox, GNOME, IceWM, KDE, LXDE, MATE, Openbox, WMaker, Xfce
    Category: Free Software, Desktop, Server
    Status: Active
    Popularity: 76 (138 hits per day) 

Parabola GNU/Linux-libre is an unofficial "libre" variant of Arch Linux. It aims to provide a fully free (as in freedom) distribution based on the packages of the Arch Linux project, with packages optimised for i686 and x86_64 processors. The goal is to give the users complete control over their systems with 100% "libre" software. Parabola GNU/Linux-libre is listed by the Free Software Foundation (FSF) as a fully free software distribution. Besides a standard installation CD image, the project also provides a live/rescue DVD image with MATE as the default desktop environment.

Popularity (hits per day): 12 months: 87 (144), 6 months: 76 (138), 3 months: 84 (129), 4 weeks: 64 (172), 1 week: 28 (414)

Average visitor rating: 7.67/10 from 6 review(s).


Parabola Summary
Distribution 	Parabola GNU/Linux-libre
Home Page 	https://parabola.nu/
Mailing Lists 	https://lists.parabola.nu//mailman/listinfo/
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://wiki.parabola.nu/
Screenshots 	--
Screencasts 	
Download Mirrors 	https://parabola.nu/download/ • LinuxTracker.org
Bug Tracker 	https://labs.parabola.nu/
Related Websites 	 
Reviews 	2017: DistroWatch
2011: OSNews
Where To Buy 	OSDisc.com (sponsored link)

EOF
)
#
home_page[X]="https://parabola.nu/"
#
distro[X]="parabola"
version[X]="-mate-2016.11.03-dual"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="SHA512SUMS"
sum_file[X]="${sum[X]}"
gpg[X]="${sum_file[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://mirror.grapentin.org/parabola/iso/mate-2016.11.03/
http://repo.parabola.nu/iso/mate-2016.11.03/
 "}
#
comment=cat<<-EOF
http://mirror.grapentin.org/parabola/iso/talkingparabola-2017.05.28/
http://mirror.grapentin.org/parabola/iso/mate-2016.11.03/
http://mirror.grapentin.org/parabola/iso-beta/systemd-cli-2017.10.17/
EOF
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.3 GB"
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
gen_boot_menus[14] () {
X=14
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (i686)"
kernel_x="/parabola/boot/i686/vmlinuz"
iso_command_x="img_dev=$dev_name img_loop="
append_x="parabolaisobasedir=parabola parabolaisolabel=PARA_201611"
initrd_x="/parabola/boot/i686/parabolaiso.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (x86_64)"
kernel_x="/parabola/boot/x86_64/vmlinuz"
iso_command_x="img_dev=$dev_name img_loop="
append_x="parabolaisobasedir=parabola parabolaisolabel=PARA_201611"
initrd_x="/parabola/boot/x86_64/parabolaiso.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#

#!FIXME ### --- New Item ------ ###
X=15
#
home_page[X]="https://parabola.nu/"
#
distro[X]="parabola"
version[X]="-systemd-cli-dual-complete-2017.10.17-21.39-alpha"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
# sum[X]="${file_name[X]}.sig"
# sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://mirror.grapentin.org/parabola/iso-beta/systemd-cli-2017.10.17/
 "}
#
comment=cat<<-EOF

EOF
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.3 GB"
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
gen_boot_menus[15] () {
X=15
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live (i686)"
kernel_x="/parabola/boot/i686/vmlinuz"
iso_command_x="img_dev=$dev_name img_loop="
append_x="parabolaisobasedir=parabola parabolaisolabel=PARA_201710"
initrd_x="/parabola/boot/i686/parabolaiso.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (x86_64)"
kernel_x="/parabola/boot/x86_64/vmlinuz"
iso_command_x="img_dev=$dev_name img_loop="
append_x="parabolaisobasedir=parabola parabolaisolabel=PARA_201710"
initrd_x="/parabola/boot/x86_64/parabolaiso.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#

#!FIXME ### --- New Item ------ ###

X=16
comment[X]=$(cat<<-EOF
Artix Linux
Last Update: 2017-10-10 02:06 UTC

[Artix Linux]

    OS Type: Linux
    Based on: Arch
    Origin: Greece
    Architecture: x86_64
    Desktop: i3, LXQt
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 235 (30 hits per day) 

Artix Linux is a fork (or continuation as an autonomous project) of the Arch-OpenRC and Manjaro-OpenRC projects. Artix Linux offers a lightweight, rolling-release operating system featuring the OpenRC init software. Three editions of Artix are available, a minimal Base system, an edition featuring the i3 window manager and an edition which runs the LXQt desktop.

Popularity (hits per day): 12 months: 291 (15), 6 months: 235 (30), 3 months: 132 (61), 4 weeks: 59 (185), 1 week: 19 (595)

Average visitor rating: 7.92/10 from 13 review(s).


Artix Linux Summary
Distribution 	Artix Linux
Home Page 	https://artixlinux.org/
Mailing Lists 	--
User Forums 	https://artixlinux.org/forum/
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://sourceforge.net/projects/artix-linux/files/iso/
Bug Tracker 	--
Related Websites 	 
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://artixlinux.org/"
#
distro[X]="artix"
version[X]="-i3-rolling-x86_64"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="README"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://sourceforge.net/projects/artix-linux/files/iso/i3/
 "}
#
comment=cat<<-EOF
 README 	2017-09-15 	105 Bytes 	1212 weekly downloads 	i
artix-i3-rolling-x86_64.iso 	2017-08-08 	697.3 MB 	200200 weekly downloads 	i
artix-i3-rolling-x86_64-pkgs.txt 	2017-08-08 	11.6 kB 	1616 weekly downloads 	i
Totals: 3 Items 	  	697.3 MB 	228 	
SHA256 sum
b861deacb42011423e0f1c8d6f1476ba5589778117eddfc898737b161289655d  artix-i3-rolling-x86_64.iso

EOF
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.9 GB"
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
gen_boot_menus[16] () {
X=16
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz-x86_64"
iso_command_x="img_dev=$dev_name img_loop="
append_x="artixbasedir=artix artixlabel=ARTIX"
initrd_x="/boot/initramfs-x86_64.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=17
#
home_page[X]="http://artixlinux.org/"
#
distro[X]="artix"
version[X]="-lxqt-20171015-x86_64"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="README"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://sourceforge.net/projects/artix-linux/files/iso/lxqt/
 "}
#
comment=cat<<-EOF


EOF
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.9 GB"
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
gen_boot_menus[17] () {
X=17
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz-x86_64"
iso_command_x="img_dev=$dev_name img_loop="
append_x="artixbasedir=artix artixlabel=ARTIX_201710"
initrd_x="/boot/initramfs-x86_64.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#

### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=18
#
comment[X]=$(cat<<-EOF
[ Reborn OS is a Linux distro based on Arch ]
focusing on bringing the configurability and power of Arch Linux to you in an easy to use installer. With over 10 DE's to choose from upon installation and over 20 optional features, Reborn OS is for you - whoever you may be.
Features i3 Budgie Deepin Enlightenment Gnome KDE Openbox LXQT Cinnamon XFCE Base Installation (without a DE) Flatpak Support
EOF
)
#
home_page[X]="https://rebornos.wordpress.com/"
#
distro[X]="Reborn"
version[X]="-OS-2018.03.27-x86_64"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="41ba891ca812c461b14710eb44bef1de6e3a2196"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://sourceforge.net/projects/antergos-deepin/files/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.4 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[18] ()
{
X=18
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
gen_boot_menus[18] () {
X=18
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/arch/boot/x86_64/vmlinuz"
iso_command_x="img_dev=$dev_name img_loop="
append_x="archisobasedir=arch cow_spacesize=10G earlymodules=loop modules-load=loop rd.modules-load=loop nohibernate quiet archisolabel=Reborn-OS_201803"
initrd_x="/arch/boot/intel_ucode.img
initrd $real_dev_path_X/arch/boot/x86_64/archiso.img"
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
Important_after_installation[X]="${Important_after_installation[1]}"
#

}
 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
