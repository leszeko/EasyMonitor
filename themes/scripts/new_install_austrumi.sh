#!/bin/bash
# new_install_austrumi.sh
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
AUSTRUMI
Last Update: 2017-08-17 23:08 UTC

[AUSTRUMI]

    OS Type: Linux
    Based on: Slackware
    Origin: Latvia
    Architecture: x86_64
    Desktop: FVWM
    Category: Data Rescue, Desktop, Live Medium
    Status: Active
    Popularity: 78 (151 hits per day) 

AUSTRUMI (Austrum Latvijas Linukss) is a bootable live Linux distribution based on Slackware Linux. It requires limited system resources and can run on any Intel-compatible system with a CD-ROM installed. The entire operating system and all of the applications run from RAM, making AUSTRUMI a fast system and allowing the boot medium to be removed after the operating system starts.

Popularity (hits per day): 12 months: 86 (151), 6 months: 78 (151), 3 months: 79 (132), 4 weeks: 70 (155), 1 week: 105 (76)

Average visitor rating: 10/10 from 1 review(s).


AUSTRUMI Summary
Distribution 	AUSTRUMI
Home Page 	http://cyti.latgola.lv/ruuni/
Mailing Lists 	--
User Forums 	http://austrumi.mypunbb.com/
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	ftp://austrumi.ru.lv/
Bug Tracker 	--
Related Websites 	 
Reviews 	1.x: Tuxmachines
0.9: Tuxmachines • Tuxmachines
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2007-06-01: Distribution Release: AUSTRUMI 1.5.0
EOF
)
#
home_page[X]="http://cyti.latgola.lv/ruuni/"
#
distro[X]="austrumi"								# fitst distro[X] = null end array of distros/packages..
arch[X]="64"
version[X]="-3.6.8"
desktop[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
# sum[X]="" 				# file with sum to download or sum
# sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
ftp://austrumi.ru.lv/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="yes"
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
kernel_x="/bzImage"
iso_command_x="findiso="
append_x="rcutree.rcu_idle_gp_delay=1 dousb emb_user"
initrd_x="/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(failsafe)"
append_x="rcutree.rcu_idle_gp_delay=1 dousb nocache emb_user"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[1] () {
X=1
find_reala_boot_path
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
echo "$Yellow Move folder: austrumi to $real_boot_root"
if [ -d "$real_boot_root/austrumi" ]
then :
      echo "$Red Folder:$SmoothBlue "$real_boot_root/austrumi"$Orange allredy exist!$Reset"
      answer=$(
		r_ask_select "$Green Skip - [*] or$Orange [R]$Red Move Folder! austrumi to austrumi_old
		$Nline$Orange Please select: " "1" "{S}kip" "{R}emove"
		)
		[[ "$answer" == "remove" ]] && \
		{
			rm -fr "$real_boot_root/austrumi_old" > /dev/null 2>&1
			mv -vf "$real_boot_root/austrumi" "$real_boot_root/ austrumi_old"
			mv -f "austrumi" "$real_boot_root"
			if [ -f "$real_boot_root/austrumi/bzImage" ]
			then :
				cp -fr "$real_boot_root/austrumi/bzImage" "$install_folder_x"  2>/dev/null
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: copy "$real_boot_root/austrumi/bzImage" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
				else :
				fi
			fi
			if [ -f "$real_boot_root/austrumi/initrd.gz" ]
			then :
				cp -fr "$real_boot_root/austrumi/initrd.gz" "$install_folder_x"  2>/dev/null
				if ! [ $? = 0 ]
				then :
					echo "$Nline$Red Error: copy "$real_boot_root/austrumi/initrd.gz" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
				else :
				fi
			 fi
			return 0
			
		}
		[[ "$answer" == "skip" ]] && \
		{
			echo "$Orange Skipped$Reset"
		}
else :
	mv -f "austrumi" "$real_boot_root"
	# austrumi /austrumi/bzImage /austrumi/initrd.gz
	if [ -f "$real_boot_root/austrumi/bzImage" ]
	then :
		cp -fr "$real_boot_root/austrumi/bzImage" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: copy "$real_boot_root/austrumi/bzImage" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
		fi
	fi
	if [ -f "$real_boot_root/austrumi/initrd.gz" ]
	then :
		cp -fr "$real_boot_root/austrumi/initrd.gz" "$install_folder_x"  2>/dev/null
		if ! [ $? = 0 ]
		then :
			echo "$Nline$Red Error: copy "$real_boot_root/austrumi/initrd.gz" file to $install_folder_x $Reset$Nline"; /bin/bash ; exit 1
		else :
		fi
	fi
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
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://austrumi.linuxfreedom.com/download.html"
#
distro[X]="austrumi-2.2.9"
desktop[X]=""
arch[X]=""
version[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="5a7260705f6883d76ac5e2792d3e0952"
#sum[X]="austrumi-2.2.9"
#sum_file[X]="${sum[X]}.md5"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]="
http://linuxfreedom.com/austrumi/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="all"
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
add_menu_label_x="Live"
kernel_x="/austrumi/bzImage"
iso_command_x="findiso="
append_x="dolivecd # dolivecd nocache # dolivecd emb_user "
initrd_x="/austrumi/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live"
kernel_x="/austrumi/bzImage"
iso_command_x="findiso="
append_x="dousb emb_user"
initrd_x="/austrumi/initrd.gz"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="iso"
initrd_x=""
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

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
