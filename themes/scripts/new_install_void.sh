#!/bin/bash
# new_install_void.sh
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
Void
Last Update: 2017-02-24 22:50 UTC

[Void]

    OS Type: Linux
    Based on: Independent
    Origin: Spain
    Architecture: armv6, armv7, i686, x86_64
    Desktop: Cinnamon, Enlightenment, MATE, Xfce
    Category: Desktop, Live Medium, Raspberry Pi
    Release Model: Rolling
    Status: Active
    Popularity: 147 (68 hits per day) 

Void is an independently-developed, general-purpose operating system based on the monolithic Linux kernel. It features a hybrid binary/source package management system which allows users to quickly install, update and remove software, or to build software directly from sources with the help of the XBPS source packages collection. Other features of the distribution include support for Raspberry Pi single-board computers (both armv6 and armv7), rolling-release development model with daily updates, integration of OpenBSD's LibreSSL software, and native init system called "runit".

Popularity (hits per day): 12 months: 142 (70), 6 months: 147 (68), 3 months: 141 (76), 4 weeks: 118 (105), 1 week: 60 (232)

Average visitor rating: 10/10 from 3 review(s).


Void Summary
Distribution 	Void
Home Page 	http://www.voidlinux.eu/
Mailing Lists 	https://groups.google.com/forum/#!forum/voidlinux
User Forums 	https://forum.voidlinux.eu/
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://wiki.voidlinux.eu/Main_Page
Screenshots 	--
Screencasts 	
Download Mirrors 	http://www.voidlinux.eu/download/ • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	2015: Alv.me (Russian) • DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

https://repo.voidlinux.eu/live/current/
../
sha256sums.txt                                     21-Feb-2017 19:36                4998
sha256sums.txt.asc     
void-live-i686-20170220-cinnamon.iso               20-Feb-2017 18:14           585105408
void-live-i686-20170220-enlightenment.iso          20-Feb-2017 17:56           525336576
void-live-i686-20170220-lxde.iso                   20-Feb-2017 18:18           465567744
void-live-i686-20170220-lxqt.iso                   20-Feb-2017 18:23           486539264
void-live-i686-20170220-mate.iso                   20-Feb-2017 18:08           670040064
void-live-i686-20170220-xfce.iso                   20-Feb-2017 18:02           558891008
void-live-i686-20170220.iso                        20-Feb-2017 17:48           270532608
void-live-x86_64-20170220-cinnamon.iso             20-Feb-2017 17:26           585105408
void-live-x86_64-20170220-enlightenment.iso        20-Feb-2017 17:14           526385152
void-live-x86_64-20170220-lxde.iso                 20-Feb-2017 17:30           465567744
void-live-x86_64-20170220-lxqt.iso                 20-Feb-2017 17:35           483393536
void-live-x86_64-20170220-mate.iso                 20-Feb-2017 17:22           667942912
void-live-x86_64-20170220-xfce.iso                 20-Feb-2017 17:18           558891008
void-live-x86_64-20170220.iso                      20-Feb-2017 17:11           275775488
void-live-x86_64-musl-20170220-cinnamon.iso        20-Feb-2017 19:06           572522496
void-live-x86_64-musl-20170220-enlightenment.iso   20-Feb-2017 18:48           513802240
void-live-x86_64-musl-20170220-lxde.iso            20-Feb-2017 19:09           454033408
void-live-x86_64-musl-20170220-lxqt.iso            20-Feb-2017 19:13           470810624
void-live-x86_64-musl-20170220-mate.iso            20-Feb-2017 19:01           656408576
void-live-x86_64-musl-20170220-xfce.iso            20-Feb-2017 18:55           546308096
void-live-x86_64-musl-20170220.iso                 20-Feb-2017 18:41           265289728
EOF
)
#
home_page[X]="http://www.voidlinux.eu/"
#
distro[X]="void-live"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-i686"
version[X]="-20170220"
desktop[X]="-lxqt"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="sha256sums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sums.txt.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://repo.voidlinux.eu/live/current/
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
kernel_x="/boot/vmlinuz"
iso_command_x="root=live:CDLABEL=VOID_LIVE iso-scan/filename="
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8"
initrd_x="/boot/initrd"
# rd.live.ram
#^^^^^^^^^^
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8 rd.live.ram"
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

xbps-install -Su
xbps-install octoxbps
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://www.voidlinux.eu/"
#
distro[X]="void-live"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-i686"
version[X]="-20170220"
desktop[X]="-mate"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="sha256sums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sums.txt.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://repo.voidlinux.eu/live/current/
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
iso_command_x="root=live:CDLABEL=VOID_LIVE iso-scan/filename="
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8"
initrd_x="/boot/initrd"
# rd.live.ram
#^^^^^^^^^^
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8 rd.live.ram"
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

xbps-install -Su
xbps-install octoxbps
"
#
#!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://www.voidlinux.eu/"
#
distro[X]="void-live"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-i686"
version[X]="-20170220"
desktop[X]="-enlightenment"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="sha256sums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sums.txt.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://repo.voidlinux.eu/live/current/
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
kernel_x="/boot/vmlinuz"
iso_command_x="root=live:CDLABEL=VOID_LIVE iso-scan/filename="
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8"
initrd_x="/boot/initrd"
# rd.live.ram
#^^^^^^^^^^
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8 rd.live.ram"
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
home_page[X]="http://www.voidlinux.eu/"
#
distro[X]="void-live"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-i686"
version[X]="-20170220"
desktop[X]="-cinnamon"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="sha256sums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sums.txt.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://repo.voidlinux.eu/live/current/
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
kernel_x="/boot/vmlinuz"
iso_command_x="root=live:CDLABEL=VOID_LIVE iso-scan/filename="
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8"
initrd_x="/boot/initrd"
# rd.live.ram
#^^^^^^^^^^
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8 rd.live.ram"
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
home_page[X]="http://www.voidlinux.eu/"
#
distro[X]="void-live"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-i686"
version[X]="-20170220"
desktop[X]="-xfce"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="sha256sums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sums.txt.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://repo.voidlinux.eu/live/current/
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
kernel_x="/boot/vmlinuz"
iso_command_x="root=live:CDLABEL=VOID_LIVE iso-scan/filename="
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8"
initrd_x="/boot/initrd"
# rd.live.ram
#^^^^^^^^^^
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8 rd.live.ram"
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
home_page[X]="http://www.voidlinux.eu/"
#
distro[X]="void-live"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-i686"
version[X]="-20170220"
desktop[X]="-lxde"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="sha256sums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="sha256sums.txt.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://repo.voidlinux.eu/live/current/
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
kernel_x="/boot/vmlinuz"
iso_command_x="root=live:CDLABEL=VOID_LIVE iso-scan/filename="
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8"
initrd_x="/boot/initrd"
# rd.live.ram
#^^^^^^^^^^
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
append_x="ro init=/sbin/init rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 gpt add_efi_memmap vconsole.unicode=1 vconsole.keymap=us locale.LANG=en_US.UTF-8 rd.live.ram"
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
gpg[X]=""
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0 GB"
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

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
