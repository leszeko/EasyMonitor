#!/bin/bash
# new_install_zenwalk.sh
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
Zenwalk Linux
Last Update: 2016-07-02 08:07 UTC

[Zenwalk Linux]

    OS Type: Linux
    Based on: Slackware
    Origin: France
    Architecture: i486, i686, x86_64
    Desktop: GNOME, Openbox, WMaker, Xfce
    Category: Desktop, Live Medium
    Release Model: Fixed
    Status: Active
    Popularity: 94 (147 hits per day) 

Zenwalk Linux (formerly Minislack) is a Slackware-based GNU/Linux operating system with a goal of being slim and fast by using only one application per task and with focus on graphical desktop and multimedia usage. Zenwalk features the latest Linux technology along with a complete programming environment and libraries to provide an ideal platform for application programmers. Zenwalk's modular approach also provides a simple way to convert Zenwalk Linux into a finely-tuned modern server (e.g. LAMP, messaging, file sharing).

Popularity (hits per day): 12 months: 62 (191), 6 months: 94 (147), 3 months: 111 (122), 4 weeks: 109 (124), 1 week: 102 (126)

No vistor rating given yet. Rate this project.


Zenwalk Summary
Distribution 	Zenwalk Linux (formerly Minislack)
Home Page 	http://support.zenwalk.org/
Mailing Lists 	--
User Forums 	http://support.zenwalk.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://manual.zenwalk.org/
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.zenwalk.org/viewforum.php?f=65 • LinuxTracker.org
Bug Tracker 	--
Related Websites 	Blogspot • Wikipedia
Reviews 	8.x: DistroWatch
7.x: DistroWatch • Wordpress • DistroWatch • Blogspot • LinuxBSDos
6.x: Linux Journal • Linux User • LinuxBSDos • Wordpress • It's A Binary World • LinuxBSDos
5.x: It's A Binary World • OStatic • Viva o Linux (Portuguese) • Blogspot • Linux.com • DistroWatch • Blogspot
4.x: Framasoft (French) • Blogspot • OSNews • Nuxified • Free-Bees
3.x: ABC Linuxu (Czech) • Free-bees • Wordpress • Pro-Linux (German)
2.x: LinuxForums • Free-bees • Linux-User (German) • OSNews
1.x: LinMagazine (Hebrew) • Tuxmachines • OSNews • Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://support.zenwalk.org/"
#
distro[X]="zenwalk"								# fitst distro[X] = null end array of distros/packages..
version[X]="-current_220217"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://download.zenwalk.org/x86_64/current/
http://slackware.uk/zenwalk/x86_64/current/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="yes"
extract_from_iso[X]="all"
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
add_menu_label_x="Live huge.s"
kernel_x="/kernels/huge.s/bzImage"
iso_command_x="fromiso="
append_x="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 nomodeset SLACK_KERNEL=huge.s"
initrd_x="/isolinux/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live  (kms.s huge.s)"
append_x="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 SLACK_KERNEL=huge.s"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[1] () {
X=1
find_reala_boot_path
echo "$Yellow Make link: ln -s "$real_dev_path_X/slackware64" "$real_boot_root/z""
rm -f "${real_boot_root}"/z
ln -s "$real_dev_path_X/slackware64" "$real_boot_root/z"
return 0
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
Important, after to install:
To install from hdd
Select source from hdd and enter your install folder contain extracted iso:
/dev/sd<xx>
/ISO/Zenwalk-current_iso/slackware64/
you cam make link
ln --directory Zenwalk-current_iso/slackware64/ /z
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
