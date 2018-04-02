#!/bin/bash
# new_install_debian.sh
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

EOF
)
#
home_page[X]="https://www.debian.org/"
#
distro[X]="debian-live"					# fitst distro[X] = null end array of distros/packages..
version[X]="-9.3.0"
arch[X]="-i386"
desktop[X]="-kde"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="SHA1SUMS" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
gpg[X]="${sum[X]}.sign"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://cdimage.debian.org/debian-cd/current-live/i386/iso-hybrid/
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
add_menu_label_x="(686)"
kernel_x="/live/vmlinuz-4.9.0-4-686"
iso_command_x="findiso="
append_x="boot=live components quiet splash"
initrd_x="/live/initrd.img-4.9.0-4-686"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(686 failsafe)"
kernel_x="/live/vmlinuz-4.9.0-4-686"
iso_command_x="findiso="
append_x="boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
initrd_x="/live/initrd.img-4.9.0-4-686"
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
xorriso -as cdrecord -v dev=/dev/sr0 -eject ${file_name[X]}
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
Emmabuntüs
Last Update: 2017-10-02 20:31 UTC

[Emmabuntüs]

    OS Type: Linux
    Based on: Debian (Stable), Ubuntu (LTS)
    Origin: France
    Architecture: i386, x86_64
    Desktop: LXDE, Xfce
    Category: Beginners, Desktop, Live Medium, Old Computers
    Status: Active
    Popularity: 106 (93 hits per day) 

Emmabuntüs is a desktop Linux distributionwith editions based on based on Xubuntu and Debian's Stable branch. It strives to be beginner-friendly and reasonably light on resources so that it can be used on older computers. It also includes many modern features, such as large number of pre-configured programs for everyday use, dockbar for launching applications, easy installation of non-free software and media codecs, and quick setup through automated scripts. The distribution supports English, French, German, Italian, Portuguese and Spanish languages.

Popularity (hits per day): 12 months: 103 (113), 6 months: 106 (93), 3 months: 95 (111), 4 weeks: 98 (115), 1 week: 93 (107)

Average visitor rating: 8/10 from 5 review(s).


Emmabuntüs Summary
Distribution 	Emmabuntüs
Home Page 	http://emmabuntus.org/
Mailing Lists 	--
User Forums 	http://forum.emmabuntus.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://emmabuntus.sourceforge.net/mediawiki/ • http://emmabuntus.developpez.com/
Screenshots 	http://emmabuntus.sourceforge.net/gallery/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://download.emmabuntus.org/ • LinuxTracker.org
Bug Tracker 	http://sourceforge.net/p/emmabuntus/tickets/
Related Websites 	Wikipedia
Reviews 	1.0 "Debian": Developpez • DarkDuck
3: C't Magazin (de) • Developpez (fr) • Blogspot • Frederic Bezies
12.x: Make Tech Easier • LinuxFr (French) • Everyday Linux User • Blogspot • Linux Community (German) • Linux Za Sve (Croatian) • DarkDuck
Where To Buy 	OSDisc.com (sponsored link)
http://download.linux-live-cd.org/Emmabuntus/Emmabuntus3/1.01/Emmabuntus3-desktop-amd64-14.04.2-1.01.iso
Emmabuntus3-desktop-amd64-14.04.2-1.01.iso.md5
Emmabuntus3-desktop-14.04.2-1.01.iso
https://sourceforge.net/project/emmabuntus/Emmabuntus%20DE2/Images/1.00/emmabuntus-de2-amd64-stretch-1.00.iso
EOF
)
#
home_page[X]="http://emmabuntus.org/"
#
distro[X]="Emmabuntus3"
desktop[X]="-desktop"
arch[X]="-amd64"
version[X]="-14.04.2-1.01"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
#
: ${mirrors[X]="http://download.linux-live-cd.org/Emmabuntus/Emmabuntus3/1.01/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="3.690 GB"
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
kernel_x="/casper/vmlinuz.efi"
iso_command_x="iso-scan/filename="
append_x="file=/cdrom/preseed/xubuntu.seed boot=casper quiet splash --"
initrd_x="/casper/initrd.lz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="file=/cdrom/preseed/xubuntu.seed boot=casper only-ubiquity quiet splash --"
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
Subgraph OS
Last Update: 2017-09-24 15:08 UTC

[Subgraph OS]

    OS Type: Linux
    Based on: Debian
    Origin: USA
    Architecture: x86_64
    Desktop: GNOME
    Category: Desktop, Live Medium, Privacy, Security
    Status: Active
    Popularity: 122 (75 hits per day) 

Subgraph OS is a Debian-based Linux distribution which provides several security, anonymous web browsing and hardening features. Subgraph OS uses a hardened Linux kernel, application firewall to block specific executables from accessing the network and forces all Internet traffic through the Tor network. The distribution's file manager features tools to remove meta-data from files and integrates with the OnionShare file sharing application. The Icedove e-mail client is set up to automatically work with Enigmail for encrypting e-mails.

Popularity (hits per day): 12 months: 155 (55), 6 months: 122 (75), 3 months: 108 (100), 4 weeks: 51 (214), 1 week: 26 (374)

Average visitor rating: 8/10 from 1 review(s).


Subgraph Summary
Distribution 	Subgraph OS
Home Page 	https://subgraph.com/sgos/index.en.html
Mailing Lists 	--
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://subgraph.com/sgos-handbook/sgos_handbook.shtml
Screenshots 	https://subgraph.com/sgos/screenshots/index.en.html • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://subgraph.com/sgos/download/index.en.html
Bug Tracker 	https://sourceforge.net/p/bluestarlinux/tickets/
Related Websites 	 
Reviews 	Alpha: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
https://dist.subgraph.com/sgos/alpha/subgraph-os-alpha_2017-09-22_1.iso
https://dist.subgraph.com/sgos/alpha/subgraph-os-alpha_2017-09-22_1.iso.sha256
https://dist.subgraph.com/sgos/alpha/subgraph-os-alpha_2017-09-22_1.iso.sha256.sig
EOF
)
#
home_page[X]="https://subgraph.com/sgos/index.en.html"
#
distro[X]="subgraph-os"
desktop[X]=""
version[X]="-alpha_2017-09-22_1"
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha256"
sum_file[X]="${sum[X]}"
gpg[X]="${sum_file[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://dist.subgraph.com/sgos/alpha/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.277 GB"
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
linux	/live/vmlinuz boot=live noconfig=sudo username=user user-fullname=User hostname=subgraph union=overlay quiet splash apparmor=1 security=apparmor
	initrd	/live/initrd.img

install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/live/vmlinuz"
iso_command_x="fromiso="
append_x="boot=live noconfig=sudo username=user user-fullname=User hostname=subgraph union=overlay quiet splash apparmor=1 security=apparmor"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live nomodeset"
append_x="boot=live noconfig=sudo username=user user-fullname=User hostname=subgraph union=overlay nomodeset nosplash vga=normal apparmor=1 security=apparmor "
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
BunsenLabs Linux
Last Update: 2017-10-16 00:36 UTC

[BunsenLabs Linux]

    OS Type: Linux
    Based on: Debian (Stable)
    Origin: Japan
    Architecture: i386, x86_64
    Desktop: Openbox
    Category: Desktop
    Status: Active
    Popularity: 128 (67 hits per day) 

BunsenLabs Linux is a distribution offering a light-weight and easily customizable Openbox desktop. The BunsenLabs distribution is based on Debian's Stable branch and is a community continuation of the CrunchBang Linux distribution.

Popularity (hits per day): 12 months: 127 (71), 6 months: 128 (67), 3 months: 124 (67), 4 weeks: 122 (67), 1 week: 111 (66)

Average visitor rating: 9.14/10 from 37 review(s).


BunsenLabs Linux Summary
Distribution 	BunsenLabs Linux
Home Page 	https://www.bunsenlabs.org/
Mailing Lists 	 
User Forums 	https://forums.bunsenlabs.org
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://www.bunsenlabs.org/installation.html
Bug Tracker 	https://www.bunsenlabs.org/resources.html#packages-and-bug-reports
Related Websites 	 
Reviews 	Deuterium: Dedoimedo
Hydrogen: DistroWatch • Linux Insider
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://www.bunsenlabs.org"
#
distro[X]="BunsenLabs Linux"
version[X]="bl-Deuterium-amd64_20170429"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="bl-Deuterium_20170429.sha256sums.txt"
sum_file[X]="${sum[X]}"
gpg[X]="bl-Deuterium-amd64_20170429.iso.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://kelaino.bunsenlabs.org/ddl/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="yes"
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
	
	echo "$Nline$Green Import the gpg key to $vendor_keyring from:$Cyan (wget -qO- https://pkg.bunsenlabs.org/BunsenLabs-RELEASE.asc) $Reset$Nline"
	gpg --no-default-keyring --keyring $vendor_keyring --import <(wget -qO- https://pkg.bunsenlabs.org/BunsenLabs-RELEASE.asc) && echo "$Nline$Green ok$Reset$Nline" || echo "$Nline$LRed Error: to receive key$Reset$Nline"
	
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
kernel_x="/live/vmlinuz-3.16.0-4-amd64"
iso_command_x="findiso="
append_x="boot=live components quiet splash"
initrd_x="/live/initrd.img-3.16.0-4-amd64"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="fail-safe mode"
append_x="boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[4] () {
X=4
echo "$Yellow install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
:
}
#
Important_after_installation[X]="To log in after booting the live session, enter the username user and the password live."
#
#!FIXME ### --- New Item ------ ###
X=5
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="https://www.bunsenlabs.org"
#
distro[X]="BunsenLabs Linux bl-Deuterium-i386_20170429.iso 	879M"
version[X]="bl-Deuterium-i386_20170429"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="bl-Deuterium_20170429.sha256sums.txt"
sum_file[X]="${sum[X]}"
gpg[X]="bl-Deuterium-i386_20170429.iso.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://kelaino.bunsenlabs.org/ddl/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="yes"
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
	
	echo "$Nline$Green Import the gpg key to $vendor_keyring from:$Cyan (wget -qO- https://pkg.bunsenlabs.org/BunsenLabs-RELEASE.asc) $Reset$Nline"
	gpg --no-default-keyring --keyring $vendor_keyring --import <(wget -qO- https://pkg.bunsenlabs.org/BunsenLabs-RELEASE.asc) && echo "$Nline$Green ok$Reset$Nline" || echo "$Nline$LRed Error: to receive key $Reset$Nline"
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
kernel_x="/live/vmlinuz-3.16.0-4-686-pae"
iso_command_x="findiso="
append_x="boot=live components quiet splash"
initrd_x="/live/initrd.img-3.16.0-4-686-pae"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="fail-safe mode"
append_x="boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder
install_package[5] () {
X=5
echo "$Yellow install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
:
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=6
comment[X]=$(cat<<-EOF
DuZeru
Last Update: 2017-10-29 02:08 UTC

[DuZeru]

    OS Type: Linux
    Based on: Debian
    Origin: Brazil
    Architecture: i386, x86_64
    Desktop: Xfce
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 154 (51 hits per day) 

DuZeru is a Brazilian Linux distribution that is based on Debian's Stable branch. DuZeru ships with the Xfce desktop environment and is available in both 32-bit and 64-bit x86 builds.

Popularity (hits per day): 12 months: 178 (47), 6 months: 154 (51), 3 months: 225 (30), 4 weeks: 210 (30), 1 week: 190 (37)

Average visitor rating: 8.8/10 from 10 review(s).


DuZeru Summary
Distribution 	DuZeru
Home Page 	http://duzeru.org/
Mailing Lists 	
User Forums 	http://forum.duzeru.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://duzeru.org/versoes-do-sistema/
Bug Tracker 	
Related Websites 	
Reviews 	
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://duzeru.org/"
#
distro[X]="DuZeru_2.4"
version[X]="dz-2.4"
desktop[X]=""
arch[X]="_amd64"
file_type[X]=".iso"
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/duzeru/files/DuZeru_2.4/"}
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
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live config  quiet splash"
initrd_x="/live/initrd.img"
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
home_page[X]="http://duzeru.org/"
#
distro[X]="DuZeru_2.4"
version[X]="grayhat"
desktop[X]=""
arch[X]="_amd64"
file_type[X]=".iso"
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/duzeru/files/DuZeru_2.4/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="4 GB"
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
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live config  quiet splash"
initrd_x="/live/initrd.img"
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
SteamOS
Last Update: 2017-08-26 01:22 UTC

[SteamOS]

    OS Type: Linux
    Based on: Debian (Stable)
    Origin: USA
    Architecture: x86_64
    Desktop: GNOME
    Category: Gaming
    Status: Active
    Popularity: 78 (134 hits per day) 

SteamOS is a Debian-based Linux distribution designed to run Valve's Steam and Steam games. It also provides a desktop mode (GNOME) which can run regular Linux applications. In addition to a stable Debian base, SteamOS features various third-party drivers and updated graphics stack, a newer Linux kernel with long-term support, and a custom graphics compositor designed to provide a seamless transition between Steam, its games and the SteamOS system overlay. The base operating system is open-source software, but the Steam client is proprietary.

Popularity (hits per day): 12 months: 80 (151), 6 months: 78 (134), 3 months: 85 (132), 4 weeks: 81 (135), 1 week: 85 (140)

Average visitor rating: 7/10 from 6 review(s).


SteamOS Summary
Distribution 	SteamOS
Home Page 	http://store.steampowered.com/steamos/
Mailing Lists 	--
User Forums 	http://steamcommunity.com/groups/steamuniverse/discussions/1/
Alternative User Forums 	LinuxQuestions.org
Documentation 	FAQ • Installation Instructions
Screenshots 	--
Screencasts 	
Download Mirrors 	http://repo.steampowered.com/download/ • LinuxTracker.org
Bug Tracker 	--
Related Websites 	Wikipedia
Reviews 	1.0 Beta: Linux User • Dedoimedo • PC Authority • Techgage
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://store.steampowered.com/steamos/"
#
distro[X]="SteamOSDVD"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="MD5SUMS"
sum_file[X]="${sum[X]}"
#gpg[X]=""
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://repo.steampowered.com/download/"}
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
kernel_x="/install.386/vmlinuz"
iso_command_x="findiso="
append_x="preseed/file=/cdrom/default.preseed DEBCONF_DEBUG=developer desktop=steamos vga=788 --- quiet"
initrd_x="install.386/initrd.gz"
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
[Voyage Linux] is Debian derived distribution that is best run on a x86 embedded platforms such as PC Engines APU/ALIX/WRAP, Soekris 45xx/48xx/65xx and Atom-based boards. It can also run on low-end x86 PC platforms. Typical installation requires 256MB disk space, although larger storage allows more packages to be installed. Voyage Linux is so small that it is best suitable for running a full-feature firewall, wireless access point, Asterisk/VoIP gateway, music player or network storage device. Currently, Voyage Linux has the following editions:

    Voyage Linux - the basic version

    Voyage MPD - Music Player Daemon 

All editions are delivered as distribution tarball and Live CD in i386 architecture. AMD64 architecture is available for Voyage Linux only. We also offer SDK to ease customizing Voyage Linux, using Debian Live framework. 
http://mirror.voyage.hk/download/ISO/
EOF
)
#
home_page[X]="http://linux.voyage.hk/"
#
distro[X]="voyage"
version[X]="-0.11.0"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="MD5SUM"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sha256sum.asc"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://cz.voyage.hk/download/ISO/
http://de.voyage.hk/download/ISO/
http://mirror.voyage.hk/download/ISO/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.1 GB"
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
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live config noautologin noxautologin nouser debug nolocales quickreboot ide_core.nodma=0.0 all_generic_ide username=root hostname=voyage  quiet"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="boot=live config noautologin noxautologin nouser debug nolocales quickreboot ide_core.nodma=0.0 all_generic_ide username=root hostname=voyage  noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal"
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
Important_after_installation[X]="
root password is voyage
"
#
#!FIXME ### --- New Item ------ ###
X=10
comment[X]=$(cat<<-EOF
Voyager Live
Last Update: 2018-02-26 15:34 UTC

[Voyager Live]

    OS Type: Linux
    Based on: Debian (Stable), Xubuntu
    Origin: France
    Architecture: i386, x86_64
    Desktop: Xfce
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 75 (165 hits per day) 

Voyager Live is an Xubuntu-based distribution and live DVD showcasing the Xfce desktop environment. Its features include the Avant Window Navigator or AWN (a dock-like navigation bar), Conky (a program which displays useful information on the desktop), and over 300 photographs and animations that can be used as desktop backgrounds.

Popularity (hits per day): 12 months: 64 (174), 6 months: 75 (165), 3 months: 59 (206), 4 weeks: 44 (271), 1 week: 34 (353)

Average visitor rating: 8.55/10 from 22 review(s).


Voyager Summary
Distribution 	Voyager Live
Home Page 	http://voyagerlive.org/
Mailing Lists 	--
User Forums 	http://voyagerlive.org/index.php/community/
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://sourceforge.net/projects/voyagerlive/ • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	16.x: Linux Insider
X8: Dedoimedo
14.x: Ordinatechnic • Blogspot
13.x: Wordpress (French) • Blogspot
12.x: Semageek (French) • Dedoimedo
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://sourceforge.net/projects/voyagerlive/"
#
distro[X]="Voyager"
version[X]="Voyager-9-Debian"
desktop[X]=""
arch[X]="-i386"
file_type[X]=".iso"
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="b62e1ae33b0a1b3b9fafd6acb125f0f074583ea8"
# sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/voyagerlive/files/"}
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
kernel_x="/live/vmlinuz-4.9.0-3-686-pae"
iso_command_x="findiso="
append_x="boot=live components locales=en_US.UTF-8 keyboard-layouts=us autologin quiet splash"
initrd_x="/live/initrd.img-4.9.0-3-686-pae"
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
PrimTux
Last Update: 2017-12-20 16:00 UTC

[PrimTux]

    OS Type: Linux
    Based on: Debian (Stable)
    Origin: France
    Architecture: i386, x86_64
    Desktop: Fluxbox
    Category: Desktop, Education, Raspberry Pi
    Status: Active
    Popularity: 200 (40 hits per day) 

PrimTux is a Debian-based distribution developed by a small team of school teachers and computer enthusiasts in the educational environment. It is not intended to replace or become the main operating system of a modern computer, but an upgrade for obsolete equipment and benefiting the school or educational environment in the spirit of education.

Popularity (hits per day): 12 months: 239 (33), 6 months: 200 (40), 3 months: 292 (25), 4 weeks: 289 (25), 1 week: 301 (22)

Visitor rating: No visitor rating given yet. Rate this project.


PrimTux Summary
Distribution 	PrimTux
Home Page 	http://primtux.fr/
Mailing Lists 	--
User Forums 	http://forum.primtux.fr/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://wiki.primtux.fr/doku.php/start • http://primtux.developpez.com/tutoriels/demarrage-rapide/
Screenshots 	http://primtux.fr/screenshots/
Screencasts 	
Download Mirrors 	http://primtux.fr/telecharger-primtux/ •
Bug Tracker 	
Related Websites 	https://fr.vikidia.org/wiki/PrimTux • Wikipedia
Reviews 	2: LinuxFR (French)
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://primtux.fr/"
#
distro[X]="PrimTux3"
version[X]="PrimTux3-2017-11-02-i386.hybrid"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.md5"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/primtux/files/Distribution/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="3.6 GB"
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
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live components quiet splash hostname=localhost locales=en_US.UTF-8 keyboard-layouts=us"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Failsafe"
append_x="boot=live components noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal hostname=localhost locales=en_US.UTF-8 keyboard-layouts=us"
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
#!FIXME ### --- New Item ------ ###
X=12
comment[X]=$(cat<<-EOF

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
install_package[12] () {
X=12
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="
Description

This project provides a Live DVD for the multibootusb program, for installing multiple Linux Distros on to a single Pen drive and able to boot from it.
This makes the program ready to use on the go on any system without installing it.

Apart from burning on to a DVD ( and booting through it ), this .iso file can also be written on to a small dedicated pen drive ( ~ 1 GB )
through this DVD's multibootusb program and further used for writing linux images on to other pen drives ( not on the same ! ) thereby making everything portable.

Note: Click \"+ Other Locations\" on the file manager for opening local disks, while browsing for images to write through this dvd's multibootusb program.
Also note that the pen drive needs to be in fat32 format for proper booting.
if in other formats, for eg. ntfs, you can use the GParted program that is in this dvd, to reformat it to fat32 ( will cleanup all data ).
Watch https://www.youtube.com/watch?v=CjQRkISnHQ4 before formatting."
#
#
#!FIXME ### --- New Item ------ ###
X=13
comment[X]=$(cat<<-EOF
Dreamlinux
Last Update: 2017-08-26 01:22 UTC

[Dreamlinux]

    OS Type: Linux
    Based on: Debian
    Origin: Brazil
    Architecture: i386
    Desktop: Xfce
    Category: Desktop, Live Medium
    Status: Discontinued (defined)
    Popularity: Not ranked

Dreamlinux is a Brazilian distribution based on Debian GNU/Linux. A live CD with a graphical hard disk installation option, it boots directly into an Xfce or GNOME desktops which provide access to a good collection of desktop applications and a central control panel for system configuration.

Visitor rating: No visitor rating given yet. Rate this project.


Dreamlinux Summary
Distribution 	Dreamlinux
Home Page 	http://www.dreamlinuxblog.blogspot.com/
Mailing Lists 	--
User Forums 	http://dreamlinuxforums.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://dreamlinuxforums.org/wiki/
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://dreamlinux.net/
Bug Tracker 	--
Related Websites 	Dreamlinux France • Dreamlinux Italy • Wikipedia
Reviews 	5.x: Linux and Life • ZDNet Blogs • DistroWatch • Dedoimedo • Gnuman
3.x: ZDNet Blogs • Tux Geek • Dedoimedo
2.x: Blogspot • Free-Bees • Blogspot • LinuxSoft • Wordpress • Tuxmachines
1.x: Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://sourceforge.net/projects/archiveos/files/d/dreamlinux/"
#
distro[X]="Dreamlinux-5"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="0dc8a36712ce62f1cc2afc12089daee7"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://sourceforge.net/projects/archiveos/files/d/dreamlinux/
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
get_download_parameters[13] () {
X=13
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
gen_boot_menus[13] () {
X=13
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz"
iso_command_x="findiso="
append_x="boot=live vga=788 selinux=0 quiet"
initrd_x="/boot/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[13] () {
X=13
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="

"
#
#!FIXME ### --- New Item ------ ###
X=14
comment[X]=$(cat<<-EOF
Uruk GNU/Linux
Last Update: 2017-12-05 07:53 UTC

[Uruk GNU/Linux]

    OS Type: Linux
    Based on: Debian, Trisquel
    Origin: Iraq
    Architecture: i686, x86_64
    Desktop: MATE
    Category: Free Software, Desktop, Live Medium
    Status: Active
    Popularity: 124 (74 hits per day) 

Uruk GNU/Linux is a free software desktop distribution based on Trisquel. It follows the licensing guidelines of the Free Software Foundation. Uruk primarily uses .deb package files, but strives to support a wide range of package formats, including .rpm files.

Popularity (hits per day): 12 months: 167 (53), 6 months: 124 (74), 3 months: 91 (126), 4 weeks: 53 (241), 1 week: 10 (947)

Average visitor rating: 9.6/10 from 5 review(s).


Uruk Summary
Distribution 	Uruk GNU/Linux
Home Page 	https://urukproject.org/dist/
Mailing Lists 	https://urukproject.org/dist/en.html#contact
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	
Screenshots 	http://www.distroscreens.com/2016/05/uruk-gnulinux-10-screenshots.html • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://sourceforge.net/projects/urukos/files/
Bug Tracker 	https://urukproject.org//bt/login_page.php
Related Websites 	 
Reviews 	1.0: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://urukproject.org/dist/"
#
distro[X]="uruk"
version[X]="_2.0"
desktop[X]=""
arch[X]="-i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha256"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://sourceforge.net/projects/urukos/files/2.0/
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
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz"
iso_command_x="findiso="
append_x="boot=live vga=788 selinux=0 quiet"
initrd_x="/boot/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[14] () {
X=14
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
}
#
Important_after_installation[X]="

"
#
#!FIXME ### --- New Item ------ ###
X=15
comment[X]=$(cat<<-EOF
Last Update: 2018-03-11 00:50 UTC

[Neptune]

    OS Type: Linux
    Based on: Debian (Stable)
    Origin: Germany
    Architecture: x86_64
    Desktop: Fluxbox, KDE Plasma
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 132 (73 hits per day) 

Neptune is a GNU/Linux distribution for desktops. It is based on Debian's Stable branch, except for a newer kernel, some drivers and newer versions of popular applications, such as LibreOffice. It also ships with the latest version of the KDE desktop. The distribution's main goals are to provide a good-looking general-purpose desktop with pre-configured multimedia playback and to offer an easy-to-use USB installer with a persistence option.

Popularity (hits per day): 12 months: 125 (75), 6 months: 132 (73), 3 months: 113 (108), 4 weeks: 50 (249), 1 week: 9 (934)

Average visitor rating: 8.83/10 from 6 review(s).


Neptune Summary
Distribution 	Neptune
Home Page 	http://neptuneos.com/
Mailing Lists 	--
User Forums 	http://www.zevenos.com/forum/forumdisplay.php?fid=21
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://neptuneos.com/en/tutorials.html
Screenshots 	http://neptuneos.com/en/screenshots.html • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://neptuneos.com/en/download.html • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	4.x: DistroWatch • DistroWatch
3.x: Blogspot
2.x: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://neptuneos.com/en/"
#
distro[X]="latest-stable"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha256"
sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://mirror-ams.filepup.net/neptune/stable/
http://download.neptuneos.com/download/
"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.4 GB"
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
add_menu_label_x="Live"
kernel_x="/boot/vmlinuz"
iso_command_x="findiso="
append_x="boot=live vga=788 selinux=0 quiet"
initrd_x="/boot/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[15] () {
X=15
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
