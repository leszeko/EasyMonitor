#!/bin/bash
# EM_New_Test_Script.sh
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

get_parameters ()
{
##################
# Parameters to change
#
total_free_space="X GB"
vendor_keyring="vendors.gpg"
MESSAGE=''
##################
#!FIXME ### --- New Item ------ ###
X=1 # Nr. pos
comment[X]=$(cat <<-EOF
Last Update: 2017-09-02 17:06 UTC

[Linux From Scratch]

    OS Type: Linux
    Based on: Independent
    Origin: Canada
    Architecture: i386, x86_64
    Desktop: Fluxbox, IceWM, KDE, KDE Plasma, LXDE, LXQt, Openbox, Xfce
    Category: Source-based, Education
    Status: Active
    Popularity: 174 (46 hits per day) 

Linux From Scratch (LFS) is a project that provides you with the steps necessary to build your own custom Linux system. There are a lot of reasons why somebody would want to install an LFS system. The question most people raise is "why go through all the hassle of manually installing a Linux system from scratch when you can just download an existing distribution like Debian or Redhat". That is a valid question which I hope to answer for you. The most important reason for LFS's existence is teaching people how a Linux system works internally. Building an LFS system teaches you about all that makes Linux tick, how things work together, and depend on each other. And most importantly, how to customize it to your own taste and needs.

Popularity (hits per day): 12 months: 139 (65), 6 months: 174 (46), 3 months: 176 (39), 4 weeks: 166 (38), 1 week: 164 (37)

Average visitor rating: 7.75/10 from 4 review(s).


Linux From Scratch Summary
Distribution 	Linux From Scratch
Home Page 	http://www.linuxfromscratch.org
Mailing Lists 	http://www.linuxfromscratch.org/support.html
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.linuxfromscratch.org/lfs/view/stable/
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.linuxfromscratch.org/lfs/download.html • LinuxTracker.org
Bug Tracker 	http://wiki.linuxfromscratch.org/lfs/
Related Websites 	Wikipedia • LFS France
Reviews 	6.x: Tuxmachines (Part 1, Part 2, Part 3)
5.x: LWN
Where To Buy 	OSDisc.com (sponsored link)
EOF
)

#
home_page[X]="http://www.linuxfromscratch.org"
#
distro[X]="Linux From Scratch"							# fitst distro[X] = null end array of distros/packages..
version[X]="LFS-BOOK-8.2-NOCHUNKS.html"
desktop[X]=""
arch[X]=""
file_type[X]=""
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
#sum[X]="${file_name[X]}.sha256sum" 						# file with sum to download or sum
#sum_file[X]="${sum[X]}"								# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://www.linuxfromscratch.org/lfs/downloads/stable/
"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="0 GB"
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
	# echo "Mirrors \"${mirrors[X]}\", file \"${file_name[X]}\""
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
	)
	# echo "File size \"$file_Size_to_download\""
	! [ -z "$file_Size_to_download" ] \
	&& \
	{
		echo "$Green ok$Reset"
		echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Green of - „$file_name_x” $Reset"
	} \
	|| \
	{
		echo "$Nline$Red Error: Get file size of - $Cyan„${file_name[distro_x]}”$Green to download ,$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	}
	
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
add_menu_label_x=""
kernel_x=""
iso_command_x="fromiso=$dev_name"
append_x=""
initrd_x=""
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[1] () {
X=1
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$( cat <<-EOF
smartos
EOF
)
#
home_page[X]="https://smartos.org/"
#
distro[X]="smartos"
desktop[X]=""
arch[X]=""
version[X]="-20170202T040152Z"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="md5sums.txt"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="

"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.4 GB"
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
	! [ -z "$file_Size_to_download" ] \
	&& \
	{
		echo "$Green ok$Reset"
		echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Green of - „$file_name_x” $Reset"
	} \
	|| \
	{
		echo "$Nline$Red Error: Get file size of - $Cyan„${file_name[distro_x]}”$Green to download ,$Red exit 1 $Reset$Nline"
		/bin/bash
		exit
	}
	
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
kernel_x="/platform/i86pc/kernel/amd64/unix"
iso_command_x=""
append_x="-B console=${os_console},${os_console}-mode="115200,8,n,1,-",root_shadow='$5$2HOHRnK3$NvLlm.1KQBbB0WjoP7xcIwGnllhzp2HnT.mDO7DpxYA',smartos=true module /platform/i86pc/amd64/boot_archive"
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
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}"
#
#!FIXME ### --- New Item ------ ###

X=3
comment[X]=$( cat <<-EOF
Based on Android7.1
EOF
)
#
home_page[X]="http://www.phoenixos.com/"
#
distro[X]="PhoenixOSInstaller"
desktop[X]=""
version[X]="-v1.5.0.297"
arch[X]="-x86"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}.md5"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://files.phoenixos.com/os/
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
install_package[3] () {
X=3
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=4
comment[X]=$( cat <<-EOF


EOF
)
#
home_page[X]="https://sourceforge.net/projects/multibootusb-live/"
#
distro[X]="MultiBootUSB-Live"
version[X]="-V8.8.0"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="26957f15ed9c8203d67d32a4df1c7b3b69aac4fb"
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://sourceforge.net/projects/multibootusb-live/files/8.8.0/
"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1 GB"
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
add_menu_label_x="Live"
kernel_x="/live/vmlinuz1"
iso_command_x="findiso="
append_x="boot=live components"
initrd_x="/live/initrd1"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Failsafe"
append_x="boot=live components noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[4] () {
X=4
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="Description

This project provides a Live DVD for the multibootusb program, for installing multiple Linux Distros on to a single Pen drive and able to boot from it. This makes the program ready to use on the go on any system without installing it.

Apart from burning on to a DVD ( and booting through it ), this .iso file can also be written on to a small dedicated pen drive ( ~ 1 GB ) through this DVD's multibootusb program and further used for writing linux images on to other pen drives ( not on the same ! ) thereby making everything portable.

Note: Click \"+ Other Locations\" on the file manager for opening local disks, while browsing for images to write through this dvd's multibootusb program. Also note that the pen drive needs to be in fat32 format for proper booting. if in other formats, for eg. ntfs, you can use the GParted program that is in this dvd, to reformat it to fat32 ( will cleanup all data ). Watch https://www.youtube.com/watch?v=CjQRkISnHQ4 before formatting."
#
#!FIXME ### --- New Item ------ ###
X=5
comment[X]=$( cat <<-EOF
LinuxConsole
Last Update: 2017-12-30 19:17 UTC

[LinuxConsole]

    OS Type: Linux
    Based on: Independent
    Origin: France
    Architecture: i586
    Desktop: MATE
    Category: Desktop, Gaming, Live Medium, Old Computers
    Status: Active
    Popularity: 148 (58 hits per day) 

LinuxConsole is an independently developed Linux live CD with different editions designed for desktops, servers, gaming consoles, and old computers. Its primary characteristics are easy installation, extensive choice of software in the form of modules, and excellent hardware detection.

Popularity (hits per day): 12 months: 161 (54), 6 months: 148 (58), 3 months: 132 (74), 4 weeks: 155 (49), 1 week: 150 (48)

Visitor rating: No visitor rating given yet. Rate this project.


LinuxConsole Summary
Distribution 	LinuxConsole
Home Page 	http://www.linuxconsole.org/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://jukebox.linuxconsole.org/official/ • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	1.0.2010: DistroWatch
1.0.2009: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.linuxconsole.org/"
#
distro[X]="linuxconsole" # comment name to disable
version[X]=".2018"
desktop[X]=""
arch[X]="-x86"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5sum"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="http://jukebox.linuxconsole.org/official/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="2.3 GB"
key_server[X]=""
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
 ### NOTE: install script executed after downlad files in install folder
install_package[5] () {
X=5
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"

}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[5] () {
X=5
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="LiceCD"
kernel_x="k4148"
iso_command_x=""
append_x="loglevel=0  livecd"
initrd_x="4148"
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

#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=6
comment[X]=$( cat <<-EOF

EOF
)
#
home_page[X]=""
#
distro[X]=""
arch[X]=""
version[X]=""
desktop[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sha256"
#sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="no"
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
	url_to_download="Offline_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[6] () {
X=6
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x=""
kernel_x=""
iso_command_x=""
append_x=""
initrd_x=""
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
install_package[6] () {
X=6
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]="
${file_name[X]}
Set up an administration password
In order to perform administration tasks, you need to set up an administration password when starting Tails, using Tails Greeter.
When Tails Greeter appears, in the Welcome to Tails window, click on the Yes button. Then click on the Forward button.
In the Administration password section, specify a password of your choice in both the Password and Verify Password text boxes.
How to open a root terminal
To open a root terminal during your working session, you can do any of the following:
Choose Applications ▸ System Tools ▸ Root Terminal.
Execute sudo -i in a terminal.
$SmoothBlue
You can write image to your USB stick.
Make sure the USB card/stick is inserted but not mounted.
Be absolutely certain that you know the correct drive name (ex: /dev/sdb)!
The data on this device will be destroyed and $Red overwritten!!!!
$Cream
---
vdd
---$Reset"
#
#!FIXME ### --- New Item ------ ###
X=7
comment[X]=$( cat <<-EOF
Omarine
Last Update: 2018-03-16 14:32 UTC

[Omarine]

    OS Type: Linux
    Based on: Independent
    Origin: Vietnam
    Architecture: x86_64
    Desktop: GNOME, KDE Plasma
    Category: Desktop, Server
    Status: Active
    Popularity: 308 (8 hits per day) 

Omarine is a Linux-based operating system for servers. It can also be used for desktops with the GNOME or KDE Plasma option right at the login screen without any additional configuration. Omarine was originally based on Slackware Linux, but is now independently developed. It uses the RPM package management software.

Popularity (hits per day): 12 months: 308 (4), 6 months: 308 (8), 3 months: 308 (16), 4 weeks: 147 (50), 1 week: 51 (216)

Visitor rating: No visitor rating given yet. Rate this project.


Omarine Summary
Distribution 	Omarine
Home Page 	https://omarine.org/omarine/
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	https://omarine.org/omarine/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	ftp://ftp.omarine.org/phamtyn/OMARINE/
Bug Tracker 	--
Related Websites 	--
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://omarine.org/omarine/"
#
distro[X]="omarine-3.0-dvd"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]=""
#sum_file[X]="${sum[X]}"
gpg[X]=""
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
ftp://ftp.omarine.org/phamtyn/OMARINE/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="4.5 GB"
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
		get_size_file_to_download "${mirrors[X]}" "${file_name[X]}" | awk '{result = $1'${count}'; printf "'${precision}'",result}'
	)
	echo "$Nline$Cyan Total file size to download is =$SmoothBlue ${file_Size_to_download} GB$Green of - „$file_name_x” $Reset"
	
	echo "$Nline$Green Take the snap of homepage from: $Cyan${home_page[X]}$Nline$Green to file: $Cyan${file_name[X]%.*}.html : $Reset$Nline"
	_snp_command "${file_name[X]%.*}.html" "${home_page[X]}"
	
elif ! [ $? = 0 ]
then :
	# echo "$Nline$Cyan No internet connection go offline$Reset"
	url_to_download="Offline_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[7] () {
X=7
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x=""
kernel_x=""
iso_command_x=""
append_x=""
initrd_x=""
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
comment[X]=$( cat <<-EOF
BigLinux
Last Update: 2017-10-29 01:20 UTC

[BigLinux]

    OS Type: Linux
    Based on: Debian, deepin
    Origin: Brazil
    Architecture: x86_64
    Desktop: Cinnamon, Deepin
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 189 (43 hits per day) 

BigLinux is a Brazilian Linux distribution localised into Brazilian Portuguese. It is was originally based on Kubuntu, but starting from 2017 the distribution has been re-born based on deepin. It offers two desktop environments - Cinnamon and Deepin.

Popularity (hits per day): 12 months: 217 (36), 6 months: 189 (43), 3 months: 178 (44), 4 weeks: 174 (43), 1 week: 162 (41)

Average visitor rating: 10/10 from 3 review(s).


BigLinux Summary
Distribution 	BigLinux)
Home Page 	https://www.biglinux.com.br/
Mailing Lists 	--
User Forums 	https://www.biglinux.com.br/forum/
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	https://www.biglinux.com.br/web/fotos/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://www.biglinux.com.br/web/download/ •
Bug Tracker 	--
Related Websites 	Wikipedia
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://www.biglinux.com.br/"
#
distro[X]="BigLinux%207.10"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="b771adff34de7e98091c93625ea99630"
#sum_file[X]="${sum[X]}"
gpg[X]=""
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://biglinux.c3sl.ufpr.br/releases/
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
	url_to_download="Offline_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[8] () {
X=8
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x=""
kernel_x=""
iso_command_x=""
append_x=""
initrd_x=""
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
comment[X]=$( cat <<-EOF


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
#sum[X]=""
#sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sha256sum.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="

"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="2 GB"
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
	url_to_download="Offline_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[9] () {
X=9
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x=""
kernel_x=""
iso_command_x="findiso="
append_x=""
initrd_x=""
add_to_grub_menu
add_to_xxx_menu

add_menu_label_x=""
kernel_x="/"
iso_command_x="findiso="
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

comment[X]=$( cat <<-EOF

EOF
)
X=10
#
home_page[X]=""
#
distro[X]=""
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
# sum[X]=""
# sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="1.5 GB"
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
	get_size_file_to_download "${mirrors[X]}" "${file_name[X]}"
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
	url_to_download="Offline_"

else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[10] () {
X=10
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x=""
kernel_x=""
iso_command_x=""
append_x=""
initrd_x=""
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
install_package[10] () {
X=10
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
