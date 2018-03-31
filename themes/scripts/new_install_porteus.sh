#!/bin/bash
# new_install_porteus.sh
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
#!FIXME ### --- New Item ------ ###
X=1 # Nr. pos
comment[X]=$(cat<<-EOF
[Porteus]

    OS Type: Linux
    Based on: Slackware
    Origin: Ireland
    Architecture: i486, x86_64
    Desktop: Cinnamon, KDE Plasma, MATE, Xfce
    Category: Live Medium
    Release Model: Fixed
    Init: SysV
    Status: Active
    Popularity: 97 (128 hits per day) 

Porteus is a fast, portable and modular live CD/USB medium based on Slackware Linux. The distribution started as a community remix of Slax, another Slackware-based live CD, with KDE 3 as the default desktop for the i486 edition and a stripped-down KDE 4 as the desktop environment for the x86_64 flavour. The lightweight LXDE is available as an alternative desktop environment.

Popularity (hits per day): 12 months: 76 (161), 6 months: 97 (128), 3 months: 92 (113), 4 weeks: 95 (111), 1 week: 86 (116)

Average visitor rating: 6.5/10 from 6 review(s).


Porteus Summary
Distribution 	Porteus
Home Page 	http://www.porteus.org/
Mailing Lists 	--
User Forums 	http://forum.porteus.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://porteus.org/docs.html
Screenshots 	http://porteus.org/info/screens.html • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://build.porteus.org/ • LinuxTracker.org
Bug Tracker 	--
Related Websites 	 
Reviews 	3.x: DistroWatch • Everyday Linux User
2.x: DistroWatch • Linux User
1.x: Blogspot • Linux Review (Farsi) • LWN • DarkDuck
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2016-12-29: Distribution Release: Porteus 3.2.2
 • 2016-09-10: Development Release: Porteus 3.2 RC5
 • 2016-06-08: Development Release: Porteus 3.2 RC3
 • 2016-05-08: Development Release: Porteus 3.2 RC2
 • 2014-12-09: Distribution Release: Porteus 3.1
 • 2014-11-16: Development Release: Porteus 3.1 RC2
 • 2014-10-19: Development Release: Porteus 3.1 RC1
 • 2014-08-05: Distribution Release: Porteus 3.0.1
 • 2014-03-11: Distribution Release: Porteus 3.0
 • 2014-02-07: Development Release: Porteus 3.0 RC2
 • 2013-12-24: Development Release: Porteus 3.0 RC1
 • 2013-08-09: Distribution Release: Porteus 2.1
 • More Porteus releases...
EOF
)
#
home_page[X]="http://www.porteus.org/"
#
distro[X]="Porteus"								# fitst distro[X] = null end array of distros/packages..
desktop[X]="-KDE"
version[X]="-v3.2.2"
arch[X]="-i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${version[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
# sum[X]="" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${version[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://ftp.vim.org/ftp/os/Linux/distr/porteus/i586/Porteus-v3.2.2/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="0.8 GB"
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
kernel_x="/boot/syslinux/vmlinuz"
iso_command_x="from="
append_x="changes=$distro_dir"
initrd_x="/boot/syslinux/initrd.xz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Copy to ram"
append_x="copy2ram"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[1] () {
X=1
find_reala_boot_path
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
echo "$Yellow Move folder: porteus to $real_boot_root"
if [ -d "$real_boot_root/porteus" ]
then :
      echo "$Red Folder:$SmoothBlue "$real_boot_root/porteus"$Orange allredy exist!$Reset"
      answer=$(
		r_ask_select "$Green Skip - [*] or$Orange [R]$Red Move Folder! porteus to porteus_old
		$Nline$Orange Please select: " "1" "{S}kip" "{R}emove"
		)
		[[ "$answer" == "remove" ]] && \
		{
			rm -fr "$real_boot_root/porteus_old" > /dev/null 2>&1
			mv -vf "$real_boot_root/porteus" "$real_boot_root/porteus_old"
			mv -f "porteus" "$real_boot_root"
			return 0
			
		}
		[[ "$answer" == "skip" ]] && \
		{
			echo "$Orange Skipped$Reset"
		}
else :
	mv -f "porteus" "$real_boot_root"
fi
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
 password - guest toor

"
#

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
