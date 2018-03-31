#!/bin/bash
# new_install_puppy.sh
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
Puppy Linux
Last Update: 2016-08-01 05:24 UTC

[Puppy Linux]

    OS Type: Linux
    Based on: Independent
    Origin: Australia
    Architecture: i386, x86_64
    Desktop: JWM, Openbox
    Category: Desktop, Old Computers, Live Medium, Netbooks
    Release Model: Fixed
    Init: SysV
    Status: Active
    Popularity: 25 (389 hits per day) 

Puppy Linux is yet another Linux distribution. What's different here is that Puppy is extraordinarily small, yet quite full-featured. Puppy boots into a ramdisk and, unlike live CD distributions that have to keep pulling stuff off the CD, it loads into RAM. This means that all applications start in the blink of an eye and respond to user input instantly. Puppy Linux has the ability to boot off a flash card or any USB memory device, CDROM, Zip disk or LS/120/240 Superdisk, floppy disks, internal hard drive. It can even use a multisession formatted CD-RW/DVD-RW to save everything back to the CD/DVD with no hard drive required at all.

Popularity (hits per day): 12 months: 24 (412), 6 months: 25 (389), 3 months: 26 (351), 4 weeks: 26 (356), 1 week: 30 (352)

Average visitor rating: 9.29/10 from 24 review(s).


Puppy Linux Summary
Distribution 	Puppy Linux
Home Page 	http://www.puppylinux.com/
Mailing Lists 	--
User Forums 	http://www.murga-linux.com/puppy
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://puppylinux.org/wikka/
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.puppylinux.com/download • LinuxTracker.org
Bug Tracker 	--
Related Websites 	Puppy Linux Announcements • PuppyLinux.org • Puppy Linux News • Wikipedia • Dotpups.de (German) • Puppy China • Puppy China • Puppy Hungary • Puppy Japan • Puppy Poland
Reviews 	5.x: DistroWatch • Make Tech Easier • Linux Insider • Linux User • DistroWatch • DarkDuck • DistroWatch • Blogspot • OS News • DistroWatch • PCWorld • Tech • Dedoimedo • Linux Journal • IT Lure
4.x: LWN • DistroWatch • Tech Exposures • Dedoimedo • Blogspot • Blogspot • Tech Source
3.x: DistroWatch • Lifehacker
2.x: Free Software Magazine • ReviLinux • Blogspot • Tuxmachines
1.x: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
Slacko Puppy 6.3.
http://slacko.eezy.xyz/index.php
http://puppylinux.org/main/Download%20Latest%20Release.htm
http://puppylinux.com/
http://puppylinux.org/

Recent Related News and Releases
  Releases, download links and checksums:
 • 2015-11-17: Distribution Release: Puppy Linux 6.3 "Slacko"
 • 2014-10-28: Distribution Release: Puppy Linux 6.0 "Tahrpup"
 • 2014-03-12: Distribution Release: Puppy Linux 5.7 "Slacko"
 • 2013-08-13: Distribution Release: Puppy Linux 5.6 "Slacko"
 • 2013-07-28: Distribution Release: Puppy Linux 5.7 "Precise"
 • 2013-05-21: Distribution Release: Puppy Linux 5.6 "Precise"
 • 2013-03-10: Distribution Release: Puppy Linux 5.5 "Precise"
 • 2013-03-06: Distribution Release: Puppy Linux 5.5 "Slacko"
 • 2013-03-03: Distribution Release: Puppy Linux 5.5 "Wary", "Racy"
 • 2012-12-04: Distribution Release: Puppy Linux 5.4 "Slacko"
 • 2012-10-23: Distribution Release: Puppy Linux 5.4 "Precise"
 • 2012-05-05: Distribution Release: Puppy Linux 5.3.3 "Slacko"
EOF
)
#
home_page[X]="http://www.puppylinux.com/"
#
distro[X]="slacko"								# fitst distro[X] = null end array of distros/packages..
version[X]="-6.3.2-uefi"
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${file_name[X]}.md5.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://distro.ibiblio.org/puppylinux/puppy-slacko-6.3.2/32/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
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
kernel_x="/vmlinuz"
iso_command_x=""
append_x=""
initrd_x="/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="no kms no savefile"
append_x="pfix=ram,nox"
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

}

 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
