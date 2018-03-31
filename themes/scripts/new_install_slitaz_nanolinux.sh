#!/bin/bash
# new_slitaz_nanolinux.sh
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
https://en.wikipedia.org/wiki/Lightweight_Linux_distribution
https://en.wikipedia.org/wiki/List_of_Linux_distributions_that_run_from_RAM

SliTaz GNU/Linux
Last Update: 2016-09-26 02:02 UTC

[SliTaz GNU/Linux]

    OS Type: Linux
    Based on: Independent
    Origin: Switzerland
    Architecture: armel, i386, x86_64
    Desktop: Openbox
    Category: Desktop, Live Medium, Old Computers, Raspberry Pi
    Release Model: Fixed
    Init: other
    Status: Active
    Popularity: 101 (108 hits per day) 

SliTaz GNU/Linux is a mini distribution and live CD designed to run speedily on hardware with 256 MB of RAM. SliTaz uses BusyBox, a recent Linux kernel and GNU software. It boots with Syslinux and provides more than 200 Linux commands, the lighttpd web server, SQLite database, rescue tools, IRC client, SSH client and server powered by Dropbear, X window system, JWM (Joe's Window Manager), gFTP, Geany IDE, Mozilla Firefox, AlsaPlayer, GParted, a sound file editor and more. The SliTaz ISO image fits on a less than 30 MB media and takes just 80 MB of hard disk space.

Popularity (hits per day): 12 months: 98 (130), 6 months: 101 (108), 3 months: 113 (84), 4 weeks: 118 (68), 1 week: 115 (65)

Average visitor rating: 9.33/10 from 12 review(s).


SliTaz Summary
Distribution 	SliTaz GNU/Linux
Home Page 	http://www.slitaz.org/
Mailing Lists 	http://www.slitaz.org/en/mailing-list.html
User Forums 	http://forum.slitaz.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.slitaz.org/en/doc/
Screenshots 	http://www.slitaz.org/artwork/screenshots.html • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.slitaz.org/en/get/ • LinuxTracker.org
Bug Tracker 	http://bugs.slitaz.org/
Related Websites 	Wikipedia
Reviews 	4.0: DarkDuck • Blogspot
2.0: Dedoimedo • Tech Source
1.0: Dedoimedo • Free Software Magazine • Wordpress • DistroWatch • Tech Source
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.slitaz.org/"
#
distro[X]="slitaz-"								# fitst distro[X] = null end array of distros/packages..
version[X]="rolling"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://mirror.switch.ch/ftp/mirror/slitaz/iso/rolling/
http://distro.ibiblio.org/slitaz/iso/rolling/
http://mirror1.slitaz.org/iso/rolling/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="0.1 GB"
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
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="bigraw iso"
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
Nanolinux
Last Update: 2016-07-10 12:20 UTC

[Nanolinux]

    OS Type: Linux
    Based on: Tiny Core
    Origin: Germany
    Architecture: i386, x86_64
    Desktop: SLWM
    Category: Desktop, Live Medium
    Release Model: Fixed
    Init: other
    Status: Active
    Popularity: 205 (39 hits per day) 

Nanolinux is an open-source, free and very lightweight Linux distribution that requires only 14 MB of disk space. It includes tiny versions of the most common desktop applications and several games. It is based on the "MicroCore" edition of the Tiny Core Linux distribution. Nanolinux uses BusyBox, Nano-X instead of X.Org, FLTK 1.3.x as the default GUI toolkit, and the super-lightweight SLWM window manager. The included applications are mainly based on FLTK.

Popularity (hits per day): 12 months: 187 (44), 6 months: 205 (39), 3 months: 191 (36), 4 weeks: 190 (34), 1 week: 177 (34)

Average visitor rating: 4/10 from 2 review(s).


Nanolinux Summary
Distribution 	Nanolinux
Home Page 	http://sourceforge.net/projects/nanolinux/
Mailing Lists 	--
User Forums 	http://sourceforge.net/p/nanolinux/discussion/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://sourceforge.net/p/nanolinux/wiki/
Screenshots 	http://sourceforge.net/projects/nanolinux/
Screencasts 	
Download Mirrors 	http://sourceforge.net/projects/nanolinux/files/ • LinuxTracker.org
Bug Tracker 	http://sourceforge.net/p/nanolinux/tickets/
Related Websites 	Wikipedia
Reviews 	 
Where To Buy 	OSDisc.com (sponsored link)
Nanolinux 1.3 is the latest version released on 5th of April 2015. Nanolinux64 1.3 is the new 64bit version released on 26th of December 2015.
EOF
)
#
home_page[X]="http://sourceforge.net/projects/nanolinux/"
#
distro[X]="nanolinux"
desktop[X]=""
arch[X]=""
version[X]="-1.3"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="39675b355e27f4836ae8a1ebe45daee2"
# sum_file[X]="${sum[X]}.sum"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://sourceforge.net/projects/nanolinux/files/"}
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
	url_to_download="$Red Off_line_$Reset"

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
append_x="bigraw iso"
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
#!FIXME ### --- New Item ------ ###
X=3
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://sourceforge.net/projects/nanolinux/"
#
distro[X]="nanolinux64"
desktop[X]=""
arch[X]=""
version[X]="-1.3"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="d63d51642a9053d4ccd81e50af75bc16"
# sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/nanolinux/files/"}
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
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="bigraw iso"
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
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=4
comment[X]=$(cat<<-EOF
[Anitaos]

Welcome. This Distro is for older computers . Using a build as you go approach. Iso's are barebones no browser etc ready to add what you want.
Forked from Puppy Linux 412/4.31 and updated.
Before Installation its recommended to read wiki first. Then download your suitable iso from here ( LTS ISO'S FINAL )


I have uploaded lots of extra software for AnitaOS and there i s also some extra wireless drivers for the AnitaOS4.31 iso both of which are here: https://sourceforge.net/projects/anitaos/files/Anitaos/

SlimPup Linux
http://distrowatch.com/dwres.php?resource=links#embed
EOF
)
#
home_page[X]="https://linuxiarze.pl/distro-anitaos/"
#
distro[X]="AnitaOS"
version[X]="4.31v1"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="44f76475dccf1b76153d20c07cc6bb5f"
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/anitaos/files/Anitaos/LATEST%20LTS%20ANITAOS%20ISO/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.3 GB"
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
kernel_x="/vmlinuz"
iso_command_x=""
append_x="psubdir=$distro_dir"
initrd_x="/initrd.gz"
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
#!FIXME ### --- New Item ------ ###
X=5
comment[X]=$(cat<<-EOF
GGParted Live
Last Update: 2017-08-26 01:22 UTC

[GParted Live]

    OS Type: Linux
    Based on: Debian
    Origin: USA
    Architecture: i686, x86_64
    Desktop: Fluxbox
    Category: Disk Management, Data Rescue, Live Medium
    Status: Active
    Popularity: 109 (92 hits per day) 

GParted Live is a business card-size live CD distribution with a single purpose - to provide tools for partitioning hard disks in an intuitive, graphical environment. The distribution uses X.Org, the light-weight Fluxbox window manager, and the latest 4.x Linux kernel. GParted Live runs on most x86 machines with a Pentium II or better.

Popularity (hits per day): 12 months: 104 (113), 6 months: 109 (92), 3 months: 116 (80), 4 weeks: 78 (142), 1 week: 87 (108)

Average visitor rating: 7.33/10 from 3 review(s).


GParted Live Summary
Distribution 	GParted Live
Home Page 	http://gparted.sourceforge.net/livecd.php
Mailing Lists 	--
User Forums 	http://gparted.sourceforge.net/forum.php
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://gparted.sourceforge.net/documentation.php
Screenshots 	http://gparted.sourceforge.net/screenshots.php • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://gparted.sourceforge.net/download.php • LinuxTracker.org
Bug Tracker 	http://gparted.sourceforge.net/bugs.php
Related Websites 	 
Reviews 	0.3: Techgage
0.2: Linux.com
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-08-09: Distribution Release: GParted Live 0.29.0-1
EOF
)
#
home_page[X]=""
#
distro[X]="gparted"
version[X]="-live-0.29.0-1"
desktop[X]=""
arch[X]="-i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="CHECKSUMS.TXT"
sum_file[X]="${sum[X]}"
gpg[X]="CHECKSUMS.TXT.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://gparted.org/gparted-live/stable/
http://sourceforge.net/projects/gparted/files/gparted-live-stable/0.29.0-1/"}
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
add_menu_label_x="Live to ram"
kernel_x="/live/vmlinuz"
iso_command_x="findiso="
append_x="boot=live username=user config components quiet union=overlay noswap noprompt vga=788 ip=frommedia toram=filesystem.squashfs"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live to ram"
iso_command_x="root=$isofile isoloop="
append_x="boot=live username=user config components quiet union=overlay noswap noprompt vga=788 ip=frommedia toram=filesystem.squashfs"
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
#!FIXME ### --- New Item ------ ###
X=6
comment[X]=$(cat<<-EOF
NimbleX
Last Update: 2017-08-26 01:22 UTC

[NimbleX]

    OS Type: Linux
    Based on: Slackware, Slax
    Origin: Romania
    Architecture: i486
    Desktop: KDE
    Category: Live Medium
    Status: Discontinued (defined)
    Popularity: Not ranked

NimbleX is a Slackware-based live CD which is able to boot from a CD, USB storage device or from another computer on the Local Area Network. Its main features are small size, a varied selection of software packages, and good hardware support.

Visitor rating: No visitor rating given yet. Rate this project.


NimbleX Summary
Distribution 	NimbleX
Home Page 	http://www.nimblex.net/ http://web.archive.org/web/20121014150250/http://www.nimblex.net/
Mailing Lists 	--
User Forums 	http://forum.nimblex.net/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.nimblex.net/manual
Screenshots 	http://www.nimblex.net/screenshots • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.nimblex.net/download •
Bug Tracker 	--
Related Websites 	 
Reviews 	2010: DistroWatch
2008: Linux.com
2007: Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2010-04-30: Development Release: NimbleX 2010 Beta
 • 2008-07-22: Distribution Release: NimbleX 2008
EOF
)
#
home_page[X]="http://osarchive.sda1.eu/nimblex"
#
distro[X]="NimbleX-2010_Beta"
arch[X]=""
version[X]=""
desktop[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sha256"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"
#
: ${mirrors[X]=" http://dl.sda1.eu/linux/NimbleX/"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.5 GB"
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
add_menu_label_x="KDE 4"
kernel_x="/boot/vmlinuz-nx10"
iso_command_x="from="
append_x="quiet vga=791 autoexec=startx"
initrd_x="/boot/initrd-nx10.gz"
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
passwd for root toor
Other interesting parameters are:

autoexec=command1;command2 ---> Skips the login prompt and executes the commands you specify. For some of the commands you also have to use sleep~999999 because in some cases NimbleX will auto shutdown after the commands are executed. sleep delays reboot for a number of seconds. The tilta (~) character is treated like a space here.

toram or copy2ram ---> provides the best speed out there for NimbleX during utilization. It slows booting time because it copies all the files in RAM but it allows you to utilize the optical drive and provides a very good performance in the graphical interface. This one is especially useful when you boot from the CD.

load=module1;module2 ---> allows you to load a modules from the /optional/ directory. If you want to load modules automatically just copy them in the /modules/ directory.

noload=module1;module_x ---> allows you to disable loading of the modules from the /modules/ directory.

passwd=yourpass ---> Changes the default \"toor\" password to \"yourpass\". If you use \"ask\" instead of \"yourpass\" you'll have to enter the new password during boot.

httpfs=http://10.10.1.1/NimbleX-2008.iso ---> Allows you to boot NimbleX from a http server where the NimbleX iso is stored. Keep in mind that you have to use the IP address of the server (not the DNS name) and before using the parameter make sure you have the correct http address to allow you to reach the ISO from a browser or something.
"
#
#!FIXME ### --- New Item ------ ###
X=7
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://osarchive.sda1.eu/nimblex"
#
distro[X]="NimbleX-2008"
arch[X]=""
version[X]=""
desktop[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sha256"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"
#
: ${mirrors[X]=" http://dl.sda1.eu/linux/NimbleX/"}
#
use_get_download_parameters[X]="no"
use_install_script[X]="yes"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.3 GB"
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
add_menu_label_x="KDE 3"
kernel_x="/boot/vmlinuz-nx08"
iso_command_x=""
append_x="ramdisk_size=7120 root=/dev/ram0 rw vga=791 splash=silent quiet autoexec=xconf;kdm"
initrd_x="/boot/initrd-nx08.gz"
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
find_reala_boot_path
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
echo "$Yellow Move folder: nimblex to $real_boot_root"
if [ -d "$real_boot_root/nimblex" ]
then :
      echo "$Red Folder:$SmoothBlue "$real_boot_root/nimblex"$Orange allredy exist!$Reset"
      answer=$(
		r_ask_select "$Green Skip - [*] or$Orange [R]$Red Move Folder! nimblex to nimblex_old
		$Nline$Orange Please select: " "1" "{S}kip" "{R}emove"
		)
		[[ "$answer" == "remove" ]] && \
		{
			rm -fr "$real_boot_root/nimblex_old" > /dev/null 2>&1
			mv -vf "$real_boot_root/nimblex" "$real_boot_root/ nimblex_old"
			mv -f "nimblex" "$real_boot_root"
			return 0
			
		}
		[[ "$answer" == "skip" ]] && \
		{
			echo "$Orange Skipped$Reset"
		}
else :
	mv -f "nimblex" "$real_boot_root"
	
fi
}
#
Important_after_installation[X]="
passwd for root toor
Other interesting parameters are:

autoexec=command1;command2 ---> Skips the login prompt and executes the commands you specify. For some of the commands you also have to use sleep~999999 because in some cases NimbleX will auto shutdown after the commands are executed. sleep delays reboot for a number of seconds. The tilta (~) character is treated like a space here.

toram or copy2ram ---> provides the best speed out there for NimbleX during utilization. It slows booting time because it copies all the files in RAM but it allows you to utilize the optical drive and provides a very good performance in the graphical interface. This one is especially useful when you boot from the CD.

load=module1;module2 ---> allows you to load a modules from the /optional/ directory. If you want to load modules automatically just copy them in the /modules/ directory.

noload=module1;module_x ---> allows you to disable loading of the modules from the /modules/ directory.

passwd=yourpass ---> Changes the default \"toor\" password to \"yourpass\". If you use \"ask\" instead of \"yourpass\" you'll have to enter the new password during boot.

httpfs=http://10.10.1.1/NimbleX-2008.iso ---> Allows you to boot NimbleX from a http server where the NimbleX iso is stored. Keep in mind that you have to use the IP address of the server (not the DNS name) and before using the parameter make sure you have the correct http address to allow you to reach the ISO from a browser or something.
"
#
#!FIXME ### --- New Item ------ ###
X=8
comment[X]=$(cat<<-EOF
SystemRescueCd
Last Update: 2017-11-05 10:46 UTC

[SystemRescueCd]

    OS Type: Linux
    Based on: Gentoo
    Origin: France
    Architecture: i586
    Desktop: JWM, Xfce
    Category: Data Rescue, Live Medium
    Status: Active
    Popularity: 110 (84 hits per day) 

SystemRescueCd is a Gentoo-based Linux system on a bootable CD-ROM or USB drive, designed for repairing a system and data after a crash. It also aims to provide an easy way to carry out administration tasks on a computer, such as creating and editing hard disk partitions. It contains many useful system utilities (GNU Parted, PartImage, FSTools) and some basic ones (editors, Midnight Commander, network tools). It aims to be very easy to use. The kernel of the system supports all of today's most important file systems, including ext2, ext3, ext4, ReiserFS, Reiser4FS, btrfs, XFS, JFS, VFAT, NTFS, ISO9660, as well as network file systems, such as Samba and NFS.

Popularity (hits per day): 12 months: 111 (91), 6 months: 110 (84), 3 months: 115 (87), 4 weeks: 129 (63), 1 week: 97 (121)

Average visitor rating: 9/10 from 4 review(s).


SystemRescueCd Summary
Distribution 	SystemRescueCd
Home Page 	http://www.system-rescue-cd.org/
Mailing Lists 	https://lists.sourceforge.net/lists/listinfo/systemrescuecd-announce
User Forums 	https://forums.system-rescue-cd.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.system-rescue-cd.org/manual/
Screenshots 	http://www.system-rescue-cd.org/Screenshots/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.system-rescue-cd.org/Download/ •
Bug Tracker 	--
Related Websites 	Wikipedia
Reviews 	1.x: Tech Source
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.system-rescue-cd.org/"
#
distro[X]="systemrescuecd"
version[X]="-x86-5.1.2"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="42b403c050d3f99352f95b0e21a0837100391c42"
#sum_file[X]="${sum[X]}"
#gpg[X]=""
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/5.1.2/"}
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
kernel_x="/isolinux/rescue32"
iso_command_x="isoloop="
append_x="rescue32 dostartx"
initrd_x="/isolinux/initram.igz"
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
install_package[8] () {
X=8
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash; exit
}
#
Important_after_installation[X]="
Mount the CD-ROM ISO image
You first have to mount the ISO image (or a media where you have burned it). You just need an empty directory on your system on which the ISO image can be mounted. We will use /tmp/cdrom in this example but you can use any directory such as /mnt/cdrom:

mkdir -p /tmp/cdrom
mount -o loop,exec /path/to/systemrescuecd-x86-x.y.z.iso /tmp/cdrom
Plug in the USB stick
Just make sure the USB stick has been plugged in, and wait a few seconds to be sure the device has been detected by the system.

Execute the installer
Now you just have to execute the installation script which is at the root of the CD-ROM. This script requires several commands to run but it won’t be a problem. To be sure the script will always work, these commands are part of the CD-ROM:

cd /tmp/cdrom
bash ./usb_inst.sh
This script will show you a list of USB sticks detected on your system. Only removable medias are in the list. This way it’s not possible to destroy a persistent device by accident.

Unmount the ISO image
Now you can unmount the ISO image

cd ~
umount /tmp/cdrom
"
#
#!FIXME ### --- New Item ------ ###
X=9
comment[X]=$(cat<<-EOF
Finnix
Last Update: 2017-08-26 01:22 UTC

[Finnix]

    OS Type: Linux
    Based on: Debian (Testing)
    Origin: USA
    Architecture: armhf, i386, powerpc
    Desktop: No Desktop
    Category: Data Rescue, Live Medium
    Status: Active
    Popularity: 234 (30 hits per day) 

Finnix is a small, self-contained, bootable Linux CD distribution for system administrators, based on Debian GNU/Linux. You can use it to mount and manipulate hard drives and partitions, monitor networks, rebuild boot records, install other operating systems, and much more.

Popularity (hits per day): 12 months: 234 (34), 6 months: 234 (30), 3 months: 232 (29), 4 weeks: 217 (31), 1 week: 233 (30)

Average visitor rating: 10/10 from 1 review(s).


Finnix Summary
Distribution 	Finnix
Home Page 	http://www.finnix.org/
Mailing Lists 	http://lists.colobox.com/cgi-bin/mailman/listinfo/finnix
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	FAQ
Screenshots 	http://www.finnix.org/Screenshots • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.finnix.org/Download
Bug Tracker 	--
Related Websites 	Wikipedia
Reviews 	105: Linux User
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.finnix.org/"
#
distro[X]="finnix"
version[X]="-111"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]="${file_name[X]}.sum"
#sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.gpg"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
 http://www.finnix.org/releases/111/
 http://mirror.coolbit.nl/pub/finnix/releases/111/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.2 GB"
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
kernel_x="/boot/x86/linux"
iso_command_x="findiso="
append_x="vga=normal nomodeset quiet --"
initrd_x="/boot/x86/initrd.xz"
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

#!FIXME ### --- New Item ------ ###
X=10
comment[X]=$(cat<<-EOF
[Minux]
Lightweight General Purpose Linux Distribution
Brought to you by: nimday

Description
Lightweight/Minimalist general purpose Linux distribution based on TinyCore Linux
Minux is loaded with FLTK and GTK based applications

JWM - Window Manager
FlaxPDF - PDF Reader
Rendera - Painting Program
Dillo - Web Browser
FLBurn - Burning Software
Fluff - File Manager
FlPicsee - Picture Viewer
Flgames - FLTK Games
XMMS - Audio Player
MtPaint - Image Editor

And much more

Compiler/Interpreter/Assembler also available

ISO Image only 24 MB
EOF
)
#
home_page[X]="https://sourceforge.net/projects/minux/"
#
distro[X]="minux-1.0.1"
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="9e99bf98d62964f397c9613424550022cf31c5b9"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.gpg"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
https://sourceforge.net/projects/minux/files/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="0.025 GB"
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
kernel_x=""
iso_command_x="findiso="
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
#!FIXME ### --- New Item ------ ###
X=11
comment[X]=$(cat<<-EOF
Welcome. [This Distro is for older computers] . Using a build as you go approach. Iso's are barebones no browser etc ready to add what you want.
Forked from Puppy Linux 412/4.31 and updated.
Before Installation its recommended to read wiki first. Then download your suitable iso from here ( LTS ISO'S FINAL )
https://sourceforge.net/projects/anitaos/files/Anitaos/LATEST%20LTS%20ANITAOS%20ISO/

I have uploaded lots of extra software for AnitaOS and there i s also some extra wireless drivers for the AnitaOS4.31 iso 
both of which are here: https://sourceforge.net/projects/anitaos/files/Anitaos/

. To go to commandline press CTRL ALT together and Backspace.

If you need help with wireless and other topics consult the wiki area. 
New Info on seamonkey in Wiki Area. If extra wireless Drivers are required, It is best to use the NON-SMP ISO - for extra non-SMP kernel wireless drivers.
NEW WGET UPDATE (This Page): https://sourceforge.net/projects/anitaos/files/Anitaos/

Anitaos Web Site
EOF
)
#
home_page[X]="https://sourceforge.net/projects/anitaos/"
#
distro[X]="AnitaOS"
version[X]="4.31v3"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="0ebdd696293518bffa53b72416a304ac834c9d89"
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/anitaos/files/Anitaos/LATEST%20LTS%20ANITAOS%20ISO/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.3 GB"
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
kernel_x="/vmlinuz"
iso_command_x=""
append_x="psubdir=$distro_dir # pmedia=cd"
initrd_x="/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[11] () {
X=11
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=12
comment[X]=$(cat<<-EOF
About [HelenOS]
screenshot.png
HelenOS features in a single screenshot. The image depicts the HelenOS 
compositing GUI, networking, filesystems, sound subsystem and a multithreaded, 
multiprocessor 64-bit kernel in action. The ​Colorful Prague picture used in the 
screenshot is a courtesy of ​Miroslav Petrasko.

HelenOS is a portable microkernel-based multiserver operating system designed 
and implemented from scratch. It decomposes key operating system functionality 
such as file systems, networking, device drivers and graphical user interface 
into a collection of fine-grained user space components that interact with each 
other via message passing. A failure or crash of one component does not directly 
harm others. HelenOS is therefore flexible, modular, extensible, fault tolerant 
and easy to understand.

HelenOS does not aim to be a clone of any existing operating system and trades 
compatibility with legacy APIs for cleaner design. Most of HelenOS components 
have been made to order specifically for HelenOS so that its essential parts can 
stay free of adaptation layers, glue code, franken-components and the 
maintenance burden incurred by them.

HelenOS runs on seven different processor architectures and machines ranging 
from embedded ARM devices and single-board computers through multicore 32-bit 
and 64-bit desktop PCs to 64-bit Itanium and SPARC rack-mount servers.

HelenOS is open source, free software. Its source code is available under the 
BSD license. Some third-party components are licensed under GPL.
EOF
)
#
home_page[X]="http://www.helenos.org/"
#
distro[X]="HelenOS"
version[X]="-0.7.1"
desktop[X]=""
arch[X]="-ia32"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]=""
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://www.helenos.org/releases/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]=""
#
free_space[X]="0.1 GB"
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
install_package[12] () {
X=12
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#
Important_after_installation[X]=""
#
#!FIXME ### --- New Item ------ ###
X=13
comment[X]=$(cat<<-EOF
About [HelenOS]
screenshot.png
HelenOS features in a single screenshot. The image depicts the HelenOS 
compositing GUI, networking, filesystems, sound subsystem and a multithreaded, 
multiprocessor 64-bit kernel in action. The ​Colorful Prague picture used in the 
screenshot is a courtesy of ​Miroslav Petrasko.

HelenOS is a portable microkernel-based multiserver operating system designed 
and implemented from scratch. It decomposes key operating system functionality 
such as file systems, networking, device drivers and graphical user interface 
into a collection of fine-grained user space components that interact with each 
other via message passing. A failure or crash of one component does not directly 
harm others. HelenOS is therefore flexible, modular, extensible, fault tolerant 
and easy to understand.

HelenOS does not aim to be a clone of any existing operating system and trades 
compatibility with legacy APIs for cleaner design. Most of HelenOS components 
have been made to order specifically for HelenOS so that its essential parts can 
stay free of adaptation layers, glue code, franken-components and the 
maintenance burden incurred by them.

HelenOS runs on seven different processor architectures and machines ranging 
from embedded ARM devices and single-board computers through multicore 32-bit 
and 64-bit desktop PCs to 64-bit Itanium and SPARC rack-mount servers.

HelenOS is open source, free software. Its source code is available under the 
BSD license. Some third-party components are licensed under GPL.
EOF
)
#
home_page[X]="http://www.helenos.org/"
#
distro[X]="HelenOS"
version[X]="-0.7.1"
desktop[X]=""
arch[X]="-amd64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
#sum[X]=""
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="http://www.helenos.org/releases/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]=""
#
free_space[X]="0.1 GB"
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
install_package[13] () {
X=13
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]=""
#


#!FIXME ### --- New Item ------ ###
X=14
comment[X]=$(cat<<-EOF
[Super Grub2 Disk]

Last Update: 2017-08-26 01:22 UTC

Super Grub2 Disk
OS Type: GRUB
Based on: Independent
Origin: Spain 
Architecture: i386, x86_64
Desktop: 
Category: Data Rescue, Live Medium, Specialist
Status: Active
Popularity: 204 (37 hits per day)
Super Grub2 Disk is a live CD that helps the user to boot into almost any operating system even if the system cannot boot into it by normal means. This allows a user to boot into an installed operating system if their GRUB installation has been overwritten, erased or otherwise corrupted. Super Grub2 Disk can detect installed operating systems and provide a boot menu which allows the user to boot into their desired operating system. Super Grub2 Disk is not an operating system itself, but a live boot loader which can be run from a CD or USB thumb drive. 

Popularity (hits per day): 12 months: 182 (48), 6 months: 204 (37), 3 months: 164 (48), 4 weeks: 121 (92), 1 week: 42 (301)

Average visitor rating: 9.45/10 from 11 review(s).


Super Grub2 Disk Summary
Distribution	Super Grub2 Disk
Home Page	http://www.supergrubdisk.org/super-grub2-disk/
Mailing Lists	http://www.supergrubdisk.org/mailing-list/
User Forums	http://www.supergrubdisk.org/forum/
Alternative User Forums	LinuxQuestions.org
Documentation	http://www.supergrubdisk.org/wiki/SuperGRUB2Disk
Screenshots	http://www.supergrubdisk.org/super-grub2-disk/
Screencasts	
Download Mirrors	https://sourceforge.net/projects/supergrub2/files/ •
Bug Tracker	https://github.com/supergrub/supergrub/labels/bug
Related Websites	
Reviews	2.02: DistroWatch
Where To Buy	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.supergrubdisk.org/super-grub2-disk/"
#
distro[X]="super_grub2"
version[X]="_disk_hybrid_2.02s10-beta5"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha1"
sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="https://sourceforge.net/projects/supergrub2/files/2.02s10-beta5/super_grub2_disk_2.02s10-beta5/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
#
free_space[X]="0.3 GB"
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
install_package[14] () {
X=14
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
