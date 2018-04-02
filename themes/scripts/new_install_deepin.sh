#!/bin/bash
# new_install_deepin.sh
# Highly flexibly specialized dynamic arrayed relational database crouched in the bashingizm on school board
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
Last Update: 2016-09-13 07:01 UTC

[deepin]

    OS Type: Linux
    Based on: Debian (Unstable)
    Origin: China
    Architecture: armhf, i386, x86_64
    Desktop: Deepin
    Category: Desktop
    Release Model: Fixed
    Status: Active
    Popularity: 10 (756 hits per day) 

deepin (formerly, Deepin, Linux Deepin, Hiweed GNU/Linux) is a Debian-based distribution (it was Ubuntu-based until version 15 released in late 2015) that aims to provide an elegant, user-friendly and reliable operating system. It does not only include the best the open source world has to offer, but it has also created its own desktop environment called DDE or Deepin Desktop Environment which is based on the Qt 5 toolkit. Deepin focuses much of its attention on intuitive design. Its home-grown applications, like Deepin Software Centre, DMusic and DPlayer are tailored to the average user. Being easy to install and use, deepin can be a good Windows alternative for office and home use.

Popularity (hits per day): 12 months: 11 (746), 6 months: 10 (756), 3 months: 11 (814), 4 weeks: 10 (850), 1 week: 10 (892)

Average visitor rating: 10 from 1 review(s).


deepin Summary
Distribution 	deepin (formerly Deepin, before Linux Deepin, Hiweed GNU/Linux)
Home Page 	http://deepin.org/
Mailing Lists 	--
User Forums 	http://bbs.deepin.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://wiki.deepin.org/
Screenshots 	LinuxQuestions.org • DistroWatch Gallery
Screencasts 	LinuxQuestions.org
Download Mirrors 	http://deepin.org/download.html • LinuxTracker.org
Bug Tracker 	http://mantis.linuxdeepin.com/my_view_page.php
Related Websites 	Wikipedia
Reviews 	15: LUKI (German) • DistroWatch
2014: Linux.com • TalLinux (Italian) • DistroWatch • LinuxBSDos • Root.cz (Czech) • Blogspot
2013: TechRepublic • Blogspot • LinuxBSDos
12.x: Dedoimedo • Blogspot • Techgage • LinuxBSDos • Linux and Life • LinuxBSDos
11.x: Make Tech Easier • LinuxBSDos
EOF
)
#
home_page[X]="http://deepin.org/"
#
distro[X]="deepin"								# comment name to disable
version[X]="-15.3-"
desktop[X]=""
arch[X]="i386"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda
sum[X]="MD5SUM" 						# file with sum to download or sum
sum_file[X]="${sum[X]}"								# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/deepin/files/15.3/
http://cdimage.deepin.com/releases/15.3/
http://ftp.ubuntu-tw.org/mirror/deepin-cd/15.3/
http://mirror.inode.at/data/deepin-cd/15.3/
http://ftp.fau.de/deepin-cd/15.3/
http://mirror.onet.pl/pub/mirrors/deepin-cd/15.3/
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
		get_size_file_to_download "${mirrors[X]}" ${file_name[X]} | awk '{result=$1'${count}'; printf "'${precision}' '${unit}'",result}'
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
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="file=/preseed/deepin.seed boot=live components quiet splash union=overlay"
initrd_x="/live/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live failsafe"
append_x="file=/preseed/deepin.seed boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal union=overlay"
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
$Magenta
change passwor for root: sudo su && passwd
$Magenta$(( mn+=1 )). To run:$Nline - Reboot and select menuentry: ${file_name[X]}
"
#
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF
[deepin]
 http://ftp.fau.de/deepin-cd/15.4/
 http://piotrkosoft.net/pub/mirrors/deepin-cd/15.4/
 http://mirror.onet.pl/pub/mirrors/deepin-cd/15.4/
 http://ftp.ubuntu-tw.org/mirror/deepin-cd/15.4/
 http://cdimage.deepin.com/releases/15.4/
EOF
)
#
home_page[X]="http://deepin.org/"
#
distro[X]="deepin"
version[X]="-15.4"
desktop[X]=""
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="MD5SUMS"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/deepin/files/15.4/Release/
"
}
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
get_download_parameters[2] () {
X=2
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
	
	echo "$Cyan Get data for - distro[$X] ${distro[X]}$Reset"
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" ${file_name[X]} | awk '{result=$1'${count}'; printf "'${precision}' '${unit}'",result}'
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
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="file=/preseed/deepin.seed boot=live components quiet splash union=overlay"
initrd_x="/live/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live failsafe"
append_x="file=/preseed/deepin.seed boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal union=overlay"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF
[deepin]
 http://ftp.fau.de/deepin-cd/15.4/
 http://piotrkosoft.net/pub/mirrors/deepin-cd/15.4/
 http://mirror.onet.pl/pub/mirrors/deepin-cd/15.4/
 http://ftp.ubuntu-tw.org/mirror/deepin-cd/15.4/
 http://cdimage.deepin.com/releases/15.4/
EOF
)
#
home_page[X]="http://deepin.org/"
#
distro[X]="deepin"
version[X]="-15.4.1"
desktop[X]=""
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="MD5SUMS"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://sourceforge.net/projects/deepin/files/15.4.1/
"
}
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
get_download_parameters[3] () {
X=3
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
	
	echo "$Cyan Get data for - distro[$X] ${distro[X]}$Reset"
	file_Size_to_download=$(
		count='/1024/1024^2' precision='%.3f' unit='GB'
		get_size_file_to_download "${mirrors[X]}" ${file_name[X]} | awk '{result=$1'${count}'; printf "'${precision}' '${unit}'",result}'
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
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="file=/preseed/deepin.seed boot=live components quiet splash union=overlay"
initrd_x="/live/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live failsafe"
append_x="file=/preseed/deepin.seed boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal union=overlay"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=4
comment[X]=$(cat<<-EOF
GoboLinux
Last Update: 2017-04-05 04:23 UTC

[GoboLinux]

    OS Type: Linux
    Based on: Independent
    Origin: Brazil
    Architecture: x86_64
    Desktop: Awesome
    Category: Desktop, Live Medium, Source-based
    Release Model: Fixed
    Status: Active
    Popularity: 63 (196 hits per day) 

GoboLinux is a modular Linux distribution - it organizes the programs in a new, logical way. Instead of having parts of a program thrown at /usr/bin, other parts at /etc and yet more parts thrown at /usr/share/something/or/another, each program gets its own directory tree, keeping them all neatly separated and allowing the user to see everything that's installed in the system and which files belong to which programs in a simple and obvious way.

Popularity (hits per day): 12 months: 103 (117), 6 months: 63 (196), 3 months: 78 (166), 4 weeks: 50 (249), 1 week: 23 (532)

Average visitor rating: 7/10 from 1 review(s).


GoboLinux Summary
Distribution 	GoboLinux
Home Page 	http://www.gobolinux.org/
Mailing Lists 	http://lists.gobolinux.org/mailman/listinfo/gobolinux-users
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.gobolinux.org/?page=documentation
Screenshots 	http://www.gobolinux.org/?page=screenshots • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.gobolinux.org/?page=downloads • LinuxTracker.org
Bug Tracker 	http://bugs.gobolinux.org/
Related Websites 	Wikipedia •
Reviews 	016: DistroWatch
015: DistroWatch
014: Blogspot
013: Linux.com
010: LWN
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.gobolinux.org"
#
distro[X]="GoboLinux"
version[X]="-016.01-"
desktop[X]=""
arch[X]="x86_64"
file_type[X]=".iso"
# file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="48739770c0d664ef1b89420ad452a8e4b85d1ca83116f7a1298f205d1fdc44c6"
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 https://github.com/gobolinux/LiveCD/releases/download/016.01/
"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="1,5 GB"
key_server[X]="hkp://keys.gnupg.net https://pgp.mit.edu keyring.debian.org keyserver.ubuntu.com"
#
 ### NOTE: Get dowload parameters - script executed before start download files if use_get_download_parameters[X]="yes"
get_download_parameters[4] () {
X=4
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
elif ! [ $? = 0 ]
then :
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
add_menu_label_x=""
append_x=""
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
Description: 

[ Dark Colors Theme for GRUB 2]
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
extract_from_iso[X]="no"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="0.1 GB"
key_server[X]=""
 ### NOTE: Get dowload parameters - script executed before start download files
get_download_parameters[5] () {
X=5
# NOTE: get the url to dowload from page if exist connection
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? = 0 ]
then :
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
	# echo "$Nline$Cyan No internet connection go $Red$Blink Off line$Reset"
	url_to_download="Off_line_"

else :
	
fi
}
 ### NOTE: install script executed after downlad files in install folder
install_package[5] () {
X=5
tar xvfz "Dark_Colors_Grub2_theme.tar.gz";
cd Dark_Colors_Grub2_theme;
/bin/bash install_dark_colors_grub2_theme.sh;
}
#
Important_after_installation[X]=""
#
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
X=6
comment[X]=$(cat<<-EOF
[tails]
https://mirrors.kernel.org/tails/stable/tails-i386-2.11/
tails-i386-2.11.iso                                06-Mar-2017 17:57      1G
tails-i386-2.11.iso.sig
EOF
)
#
home_page[X]="https://tails.boum.org/"
#
# distro[X]="tails-"
arch[X]="i386-"
version[X]="2.11"
desktop[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sha256"
#sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"
#
: ${mirrors[X]="https://mirrors.kernel.org/tails/stable/tails-i386-2.11/"}
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
elif ! [ $? = 0 ]
then :
else :
fi
}
 ### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes"
gen_boot_menus[6] () {
X=6
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live 32"
kernel_x="/live/vmlinuz"
iso_command_x="fromiso="
append_x="boot=live config apparmor=1 security=apparmor nopersistence noprompt timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash noautologin module=Tails kaslr slab_nomerge slub_debug=FZ mce=0 vsyscall=none  quiet"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live 32 Troubleshooting"
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live config apparmor=1 security=apparmor nopersistence noprompt timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash noautologin module=Tails kaslr slab_nomerge slub_debug=FZ mce=0 vsyscall=none  noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live memdisk"
iso_command_x="memdisk"
append_x="iso"
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
 ### --- New Item ------ ###!FIXME ### --- New Item ------ ###
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
sum[X]="${file_name[X]}.sha256sum"
sum_file[X]="${sum[X]}"
# gpg[X]="sha256sums.txt.asc"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="no"
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
elif ! [ $? = 0 ]
then :
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
 ### --------- ###
}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"

