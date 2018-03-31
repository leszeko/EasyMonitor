#!/bin/bash
# new_install_rosa.sh
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
ROSA
Last Update: 2016-08-02 10:48 UTC

[ROSA]

    OS Type: Linux
    Based on: Independent (forked from Mandriva)
    Origin: Russia
    Architecture: i586, x86_64
    Desktop: GNOME, KDE, KDE Plasma, LXQt, MATE
    Category: Desktop, Live Medium
    Release Model: Fixed
    Status: Active
    Popularity: 80 (166 hits per day) 

ROSA is a Russian company developing a variety of Linux-based solutions. Its flagship product, ROSA Desktop, is a Linux distribution featuring a highly customised KDE desktop and a number of modifications designed to enhance the user-friendliness of the working environment. The company also develops an "Enterprise Server" edition of ROSA which is based on Red Hat Enterprise Linux.

Popularity (hits per day): 12 months: 56 (212), 6 months: 80 (166), 3 months: 77 (167), 4 weeks: 83 (164), 1 week: 78 (166)

Average visitor rating: 9/10 from 2 review(s).


ROSA Summary
Distribution 	ROSA
Home Page 	http://www.rosalab.com/
Mailing Lists 	http://lists.rosalab.ru/
User Forums 	http://forum.rosalab.ru/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://wiki.rosalab.ru/
Screenshots 	http://www.rosalinux.com/products/desktop • LinuxQuestions.org • DistroWatch Gallery
Screencasts 	LinuxQuestions.org
Download Mirrors 	http://wiki.rosalab.ru/en/index.php/ROSA_Release • LinuxTracker.org
Bug Tracker 	http://support.rosalab.ru/
Related Websites 	ROSA Type • ROSA Germany • ROSA Romania • ROSA Spain
Reviews 	R8: DarkDuck
R7: DarkDuck • Dedoimedo
R5: Ordinatechnic
R4: Blogspot
2012: LinuxBSDos • The Linux Rain • LinuxBSDos • Blogspot • DistroWatch • Wordpress (Russian) • Blogspot • LinuxBSDos • Dedoimedo • LinuxBSDos • DarkDuck • O'Reilly Community
2011: Computerra (Russian)
Where To Buy 	OSDisc.com (sponsored link)

http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.FRESH.PLASMA.R8.i586.iso
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.FRESH.KDE.R8.i586.iso
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.FRESH.GNOME.R8.i586.iso
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.FRESH.MATE.R8.i586.iso
EOF
)
#
home_page[X]="http://wiki.rosalab.ru/en/index.php/ROSA_Release"
#
distro[X]="ROSA.FRESH."								# fitst distro[X] = null end array of distros/packages..
version[X]=""
desktop[X]="PLASMA.R8."
arch[X]="i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${file_name[X]}.md5sum" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/
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
kernel_x="/isolinux/vmlinuz0"
iso_command_x="root=live:CDLABEL=ROSA.FRESH.PLASMA.R8.i586 iso-scan/filename="
append_x="rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 rhgb splash=silent logo.nologo vga=788"
initrd_x="/isolinux/initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="root=live:CDLABEL=ROSA.FRESH.PLASMA.R8.i586 rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 xdriver=vesa plymouth.enable=0 nomodeset vga=792"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Install"
append_x="root=live:CDLABEL=ROSA.FRESH.PLASMA.R8.i586 rootfstype=auto ro rd.live.image quiet  install rhgb splash=silent logo.nologo vga=788"
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
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.Fresh.R8.1/

ROSA.FRESH.KDE.R8.1.i586.iso                       22-Feb-2017 14:02          2087714816
ROSA.FRESH.KDE.R8.1.i586.iso.md5sum                22-Feb-2017 14:02                  63
ROSA.FRESH.KDE.R8.1.x86_64.uefi.iso                22-Feb-2017 10:35          2097152000
ROSA.FRESH.KDE.R8.1.x86_64.uefi.iso.md5sum
EOF
)
#
home_page[X]="http://wiki.rosalab.ru/en/index.php/ROSA_Release"
#
distro[X]="ROSA.FRESH."								# fitst distro[X] = null end array of distros/packages..
version[X]=""
desktop[X]="KDE.R8.1."
arch[X]="i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${file_name[X]}.md5sum" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.Fresh.R8.1
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
kernel_x="/isolinux/vmlinuz0"
iso_command_x="root=live:CDLABEL=ROSA.FRESH.KDE.R8.1.i586 iso-scan/filename="
append_x="rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 rhgb splash=silent logo.nologo vga=788"
initrd_x="/isolinux/initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="root=live:CDLABEL=ROSA.FRESH.KDE.R8.1.i586 rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 xdriver=vesa plymouth.enable=0 nomodeset vga=792"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Install"
append_x="root=live:CDLABEL=ROSA.FRESH.KDE.R8.1.i586 rootfstype=auto ro rd.live.image quiet  install rhgb splash=silent logo.nologo vga=788"
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
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.FRESH.GNOME.R8.i586.iso
EOF
)
#
home_page[X]="http://wiki.rosalab.ru/en/index.php/ROSA_Release"
#
distro[X]="ROSA.FRESH."								# fitst distro[X] = null end array of distros/packages..
version[X]=""
desktop[X]="GNOME.R8."
arch[X]="i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${file_name[X]}.md5sum" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/
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
kernel_x="/isolinux/vmlinuz0"
iso_command_x="root=live:CDLABEL=ROSA.FRESH.GNOME.R8.i586 iso-scan/filename="
append_x="rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 rhgb splash=silent logo.nologo vga=788"
initrd_x="/isolinux/initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="root=live:CDLABEL=ROSA.FRESH.GNOME.R8.i586 rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 xdriver=vesa plymouth.enable=0 nomodeset vga=792"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Install"
append_x="root=live:CDLABEL=ROSA.FRESH.GNOME.R8.i586 rootfstype=auto ro rd.live.image quiet  install rhgb splash=silent logo.nologo vga=788"
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
http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/ROSA.FRESH.MATE.R8.i586.iso
EOF
)
#
home_page[X]="http://wiki.rosalab.ru/en/index.php/ROSA_Release"
#
distro[X]="ROSA.FRESH."								# fitst distro[X] = null end array of distros/packages..
version[X]=""
desktop[X]="MATE.R8."
arch[X]="i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${file_name[X]}.md5sum" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://mirror.rosalab.ru/rosa/rosa2014.1/iso/ROSA.Fresh.R8/
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
kernel_x="/isolinux/vmlinuz0"
iso_command_x="root=live:CDLABEL=ROSA.FRESH.MATE.R8.i586 iso-scan/filename="
append_x="rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 rhgb splash=silent logo.nologo vga=788"
initrd_x="/isolinux/initrd0.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="root=live:CDLABEL=ROSA.FRESH.MATE.R8.i586 rootfstype=auto ro rd.live.image quiet  rd.luks=0 rd.md=0 rd.dm=0 xdriver=vesa plymouth.enable=0 nomodeset vga=792"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Install"
append_x="root=live:CDLABEL=ROSA.FRESH.MATE.R8.i586 rootfstype=auto ro rd.live.image quiet  install rhgb splash=silent logo.nologo vga=788"
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
home_page[X]=""
#
distro[X]=""
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=""
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sha256"
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="0 GB"
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
add_menu_label_x="Live memdisk"
iso_command_x="memdisk"
append_x="iso"
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

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
