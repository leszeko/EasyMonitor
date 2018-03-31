#!/bin/bash
# new_install_antiX.sh
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=1 # Nr. pos
comment[X]=$(cat<<-EOF
AntiX
Last Update: 2017-01-17 07:09 UTC

[antiX]

    OS Type: Linux
    Based on: Debian (Stable)
    Origin: Greece
    Architecture: i486, x86_64
    Desktop: Fluxbox, IceWM, JWM, Xfce
    Category: Live Medium, Old Computers
    Release Model: Fixed, Semi-Rolling, Rolling
    Status: Active
    Popularity: 24 (415 hits per day) 

antiX is a fast, lightweight and easy-to-install Linux live CD distribution based on Debian's "Stable" branch for x86 compatible systems. antiX offers users the "antiX Magic" in an environment suitable for old computers. The goal of antiX is to provide a light, but fully functional and flexible free operating system for both newcomers and experienced users of Linux. It should run on most computers, ranging from 256 MB old PIII systems with pre-configured swap to the latest powerful boxes. 256 MB RAM is recommended minimum for antiX. The installer needs minimum 2.7 GB hard disk size. antiX can also be used as a fast-booting rescue CD. A special Xfce edition made in collaboration with the MEPIS Community called "MX" is also available.

Popularity (hits per day): 12 months: 25 (430), 6 months: 24 (415), 3 months: 22 (476), 4 weeks: 19 (535), 1 week: 30 (401)

Average visitor rating: 9.78/10 from 9 review(s).


antiX Summary
Distribution 	antiX
Home Page 	http://antix.mepis.com/
Mailing Lists 	--
User Forums 	http://antix.freeforums.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.mepiscommunity.org/user_manual_mx15/mxum.html
http://download.tuxfamily.org/antix/docs-antiX-15/FAQ/index.html
Screenshots 	LinuxQuestions.org • DistroWatch Gallery
Screencasts 	LinuxQuestions.org
Download Mirrors 	http://antix.mepis.com/index.php/Main_Page#Downloads • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	15: DistroWatch • Dedoimedo
14.x: Dedoimedo • Dedoimedo • Blogspot
13.x: Everyday Linux User • Blogspot • Blogspot • Linux Za Sve (Croatian)
12.x: LWN
11.x: Blogspot • DistroWatch
8.x: IT Lure
7.x: Blogspot
Where To Buy 	OSDisc.com (sponsored link)
Index of /mirrors/linux/mxlinux/Final/antiX-16/
../
antiX-16.1_386-base.iso                            16-Jan-2017 16:52    518M
antiX-16.1_386-base.iso.md5                        17-Jan-2017 10:27      58
antiX-16.1_386-base.iso.sig                        17-Jan-2017 10:26     310
antiX-16.1_386-core-libre.iso                      16-Jan-2017 19:15    200M
antiX-16.1_386-core-libre.iso.md5                  17-Jan-2017 10:27      64
antiX-16.1_386-core-libre.iso.sig                  17-Jan-2017 10:26     310
antiX-16.1_386-full.iso                            16-Jan-2017 17:52    697M
antiX-16.1_386-full.iso.md5                        17-Jan-2017 10:28      58
antiX-16.1_386-full.iso.sig                        17-Jan-2017 10:26     310
antiX-16.1_386-net.iso                             25-Jan-2017 18:00    140M
antiX-16.1_386-net.iso.md5                         25-Jan-2017 19:15      57
antiX-16.1_386-net.iso.sig                         25-Jan-2017 19:15     310
antiX-16.1_x64-base.iso                            16-Jan-2017 17:15    503M
antiX-16.1_x64-base.iso.md5                        17-Jan-2017 10:28      58
antiX-16.1_x64-base.iso.sig                        17-Jan-2017 10:26     310
antiX-16.1_x64-core-libre.iso                      16-Jan-2017 19:26    200M
antiX-16.1_x64-core-libre.iso.md5                  17-Jan-2017 10:28      64
antiX-16.1_x64-core-libre.iso.sig                  17-Jan-2017 10:26     310
antiX-16.1_x64-full.iso                            16-Jan-2017 19:00    680M
antiX-16.1_x64-full.iso.md5                        17-Jan-2017 10:28      58
antiX-16.1_x64-full.iso.sig                        17-Jan-2017 10:30     310
antiX-16.1_x64-net.iso                             25-Jan-2017 18:06    140M
antiX-16.1_x64-net.iso.md5                         25-Jan-2017 19:15      57
antiX-16.1_x64-net.iso.sig    
EOF
)
#
home_page[X]="http://antix.mepis.com/"
#
distro[X]="antiX"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.2"
desktop[X]=""
arch[X]="_386-full"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/antix-linux/files/Final/antiX-16/
 http://iso.mxrepo.com/Final/antiX-16/
 http://mx.debian.nz/Final/antiX-16/
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
kernel_x="/antiX/vmlinuz"
iso_command_x="from=hd fromiso="
append_x="quiet splash=v vga=791 xres=1024x768"
initrd_x="/antiX/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="nomodeset xorg=safe"
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
To remove gpg keys:
gpg --keyring vendors.gpg --delete-key <key>

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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://antix.mepis.com/"
#
distro[X]="antiX"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.2"
desktop[X]=""
arch[X]="_386-net"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/antix-linux/files/Final/antiX-16/
 http://iso.mxrepo.com/Final/antiX-16/
 http://mx.debian.nz/Final/antiX-16/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="0.2 GB"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://antix.mepis.com/"
#
distro[X]="antiX"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.2"
desktop[X]=""
arch[X]="_x64-full"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/antix-linux/files/Final/antiX-16/
 http://iso.mxrepo.com/Final/antiX-16/
 http://mx.debian.nz/Final/antiX-16/"}
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
kernel_x="/antiX/vmlinuz"
iso_command_x="from=hd fromiso="
append_x="quiet splash=v vga=791 xres=1024x768"
initrd_x="/antiX/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="nomodeset xorg=safe"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=4
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://antix.mepis.com/"
#
distro[X]="antiX"								# fitst distro[X] = null end array of distros/packages..
version[X]="-16.2"
desktop[X]=""
arch[X]="_x64-net"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/antix-linux/files/Final/antiX-16/
 http://iso.mxrepo.com/Final/antiX-16/
 http://mx.debian.nz/Final/antiX-16/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="0.2 GB"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=5
comment[X]=$(cat<<-EOF
MX Linux
Last Update: 2016-12-14 17:35 UTC

[MX Linux]

    OS Type: Linux
    Based on: Debian (Stable), antiX
    Origin: Greece
    Architecture: i386, x86_64
    Desktop: Xfce
    Category: Live Medium, Desktop
    Release Model: Fixed
    Status: Active
    Popularity: 44 (276 hits per day) 

MX Linux, a desktop-oriented Linux distribution based on Debian's "stable" branch, is a cooperative venture between the antiX and former MEPIS Linux communities. Using Xfce as the default desktop, it is a mid-weight operating system designed to combine an elegant and efficient desktop with simple configuration, high stability, solid performance and medium-sized footprint.

Popularity (hits per day): 12 months: 96 (138), 6 months: 44 (276), 3 months: 26 (425), 4 weeks: 40 (300), 1 week: 45 (288)

Average visitor rating: 9.86/10 from 28 review(s).


MX Linux Summary
Distribution 	MX Linux
Home Page 	https://mxlinux.org/
Mailing Lists 	--
User Forums 	https://forum.mxlinux.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://www.mxlinux.org/user_manual_mx16/mxum.html
https://www.mxlinux.org/wiki
Screenshots 	https://mxlinux.org/screenshots • LinuxQuestions.org • DistroWatch Gallery
Screencasts 	https://youtu.be/9lyJV5DdRnA • LinuxQuestions.org
Download Mirrors 	https://mxlinux.org/download-links#Mirrors •
Bug Tracker 	https://mxlinux.org/bugs-features
Related Websites 	http://mxrepo.com/snapshots/
Reviews 	16: DarkDuck • DistroWatch • Dedoimedo
15: Dedoimedo • OCS-Mag • Linux-Community (German)
14.x: Dedoimedo • Dedoimedo • Blogspot
Where To Buy 	OSDisc.com (sponsored link)
Index of /mirrors/linux/mxlinux/Final/MX-16/

MX-16_386.iso                                      13-Dec-2016 12:06      1G
MX-16_386.iso.md5                                  13-Dec-2016 11:31      48
MX-16_386.iso.sig                                  13-Dec-2016 11:30     310
MX-16_x64.iso                                      13-Dec-2016 12:08      1G
MX-16_x64.iso.md5                                  13-Dec-2016 11:30      48
MX-16_x64.iso.sig
EOF
)
#
home_page[X]="https://mxlinux.org/"
#
distro[X]="MX"
version[X]="-16.1"
desktop[X]=""
arch[X]="_386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="
http://ftp.cc.uoc.gr/mirrors/linux/mxlinux/MX/Final/MX-16.1/
http://ftp.acc.umu.se/mirror/mxlinux.org/isos/MX/Final/MX-16.1/
https://sourceforge.net/projects/mx-linux/files/Final/MX-16.1/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.5 G"
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
kernel_x="/antiX/vmlinuz"
iso_command_x="from=hd fromiso="
append_x="quiet splash=v vga=791 xres=1024x768"
initrd_x="/antiX/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="nomodeset xorg=safe"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=6
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="https://mxlinux.org/"
#
distro[X]="MX"
version[X]="-16.1"
desktop[X]=""
arch[X]="_x64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="
http://ftp.cc.uoc.gr/mirrors/linux/mxlinux/MX/Final/MX-16.1/
http://ftp.acc.umu.se/mirror/mxlinux.org/isos/MX/Final/MX-16.1/
https://sourceforge.net/projects/mx-linux/files/Final/MX-16.1/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.5 G"
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
kernel_x="/antiX/vmlinuz"
iso_command_x="from=hd fromiso="
append_x="quiet splash=v vga=791 xres=1024x768"
initrd_x="/antiX/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="nomodeset xorg=safe"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=7
comment[X]=$(cat<<-EOF
MEPIS Linux
Last Update: 2017-08-26 01:22 UTC

[MEPIS Linux]

    OS Type: Linux
    Based on: Debian
    Origin: USA
    Architecture: i586, x86_64
    Desktop: KDE
    Category: Beginners, Desktop, Live Medium
    Status: Dormant (defined)
    Popularity: Not ranked

MEPIS Linux is a Debian-based desktop Linux distribution designed for both personal and business purposes. It includes cutting-edge features such as a live, installation and recovery CD, automatic hardware configuration, NTFS partition resizing, ACPI power management, WiFi support, anti-aliased TrueType fonts, a personal firewall, KDE, and much more.

Visitor rating: No visitor rating given yet. Rate this project.


MEPIS Summary
Distribution 	MEPIS
Home Page 	http://www.mepis.org/
Mailing Lists 	--
User Forums 	http://forum.mepiscommunity.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.mepis.org/docs/
User's Manual
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.mepis.org/mirrors • LinuxTracker.org
Bug Tracker 	--
Related Websites 	MEPIS Community • Wikipedia •
Reviews 	11.0: Dedoimedo • DistroWatch • Blogspot
8.x: Thinkdigit • LWN • OSNews • Dobosevic.com (Croatian) • It's A Binary World • LinuxPlanet • DistroWatch • Linux Community (German) • Dedoimedo
7.x: Linuxoid (Russian)
6.x: LinMagazine (Hebrew) • Seopher • Tuxmachines • Free-Bees
3.x: Free-Bees
200x: ABC Linuxu (Czech) • Pro-Linux (German) • OSNews • OSNews
Where To Buy 	OSDisc.com (sponsored link)
Indeks – /mepis.org/released
antix/		19.09.2012, 02:00:00
MEPIS-getting-started.pdf	63.0 kB	23.02.2010, 01:00:00
SimplyMEPIS-1.5G_11.0.12_32.iso	1.1 GB	29.01.2012, 01:00:00
SimplyMEPIS-1.5G_11.0.12_32.md5sum	66 B	29.01.2012, 01:00:00
SimplyMEPIS-1.5G_11.0.12_64.iso	1.1 GB	29.01.2012, 01:00:00
SimplyMEPIS-1.5G_11.0.12_64.md5sum	66 B	29.01.2012, 01:00:00
SimplyMEPIS-CD_8.0.15-rel_32.iso	685 MB	12.01.2010, 01:00:00
SimplyMEPIS-CD_8.0.15-rel_32.md5sum	67 B	11.01.2010, 01:00:00
SimplyMEPIS-CD_8.0.15-rel_64.iso	684 MB	12.01.2010, 01:00:00
SimplyMEPIS-CD_8.0.15-rel_64.md5sum	67 B	11.01.2010, 01:00:00
SimplyMEPIS-CD_8.5.03-rel1_32.iso	699 MB	16.04.2010, 02:00:00
SimplyMEPIS-CD_8.5.03-rel1_32.md5sum	68 B	16.04.2010, 02:00:00
SimplyMEPIS-CD_8.5.03-rel1_64.iso	695 MB	16.04.2010, 02:00:00
SimplyMEPIS-CD_8.5.03-rel1_64.md5sum	68 B	16.04.2010, 02:00:00
SimplyMEPIS-DVD_11.0.12_32.iso	3.7 GB	29.01.2012, 01:00:00
SimplyMEPIS-DVD_11.0.12_32.md5sum	65 B	29.01.2012, 01:00:00
SimplyMEPIS-DVD_11.0.12_64.iso	3.8 GB	29.01.2012, 01:00:00
SimplyMEPIS-DVD_11.0.12_64.md5sum	65 B	29.01.2012, 01:00:00
SimplyMEPIS-USB_8.5.03-rel1_32.iso	926 MB	16.04.2010, 02:00:00
SimplyMEPIS-USB_8.5.03-rel1_32.md5sum	69 B	16.04.2010, 02:00:00
SimplyMEPIS-USB_8.5.03-rel1_64.iso	925 MB	16.04.2010, 02:00:00
SimplyMEPIS-USB_8.5.03-rel1_64.md5sum	69 B	15.04.2010, 02:00:00
EOF
)
#
home_page[X]="http://www.mepis.org/"
#
distro[X]="SimplyMEPIS"
version[X]="-1.5G_11.0.12_32"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}.md5sum"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sha256sum.asc"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
ftp://artfiles.org/mepis.org/released/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.2 GB"
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
kernel_x="/boot/vmlinuz"
iso_command_x="from=hd,usb fromiso="
append_x="vga=788 quiet splash aufs"
initrd_x="/boot/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(Xorg config)"
append_x="vga=788 quiet confx"
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
Important_after_installation[X]="
"
#

 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=9
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
#sum[X]=""
#sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sha256sum.asc"
gpg_file[X]="${gpg[X]}"
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
free_space[X]="0 GB"
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
