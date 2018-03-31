#!/bin/bash
# new_install_extix.sh
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
ExTiX
Last Update: 2017-07-12 13:04 UTC

[ExTiX]

    OS Type: Linux
    Based on: Debian, Ubuntu
    Origin: Sweden
    Architecture: x86_64
    Desktop: Budgie, KDE, LXQt
    Category: Desktop, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 70 (167 hits per day) 

ExTiX is a desktop Linux distribution and live DVD based on Ubuntu, offering a choice of KDE or LXQt desktop environments.

Popularity (hits per day): 12 months: 91 (150), 6 months: 70 (167), 3 months: 72 (145), 4 weeks: 65 (171), 1 week: 113 (68)

Average visitor rating: 7.5/10 from 4 review(s).


ExTiX Summary
Distribution 	ExTiX
Home Page 	http://www.extix.se/
Mailing Lists 	--
User Forums 	http://linux.exton.net/forum
Alternative User Forums 	LinuxQuestions.org
Documentation 	--
Screenshots 	DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://sourceforge.net/projects/extix/files/
Bug Tracker 	--
Related Websites 	 
Reviews 	15.1: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-07-12: Distribution Release: ExTiX 17.7

EOF
)
#
home_page[X]="http://www.extix.se/"
#
distro[X]="extix"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-64bit"
desktop[X]="-kde"
version[X]="-refracta-isoh-uefi-1920mb-161221"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${desktop[X]}${version[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${arch[X]}${desktop[X]}${version[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${desktop[X]}${version[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/extix/files/
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
comment=$(cat<<-EOF

menuentry "ExTiX (defaults) US English" {
    set gfxpayload=keep
    linux   /live/vmlinuz boot=live  username=extix    
    initrd  /live/initrd.img
}

menuentry "ExTiX (defaults) UK English" {
    set gfxpayload=keep
    linux   /live/vmlinuz boot=live  username=extix lang=en_GB 
    initrd  /live/initrd.img
}


submenu 'Advanced options ...' {

    menuentry "ExTiX (nomodeset)" {
	set gfxpayload=keep
	linux   /live/vmlinuz boot=live nomodeset nouveau.modeset=0 radeon.modeset=0 vga=normal  username=extix  
	initrd  /live/initrd.img
    }
    menuentry "ExTiX (no hardware probe)" {
	set gfxpayload=keep
	linux   /live/vmlinuz boot=live nocomponents=xinit noapm noapic nolapic nodma nosmp vga=normal  username=extix 
	initrd  /live/initrd.img
    }
    menuentry "ExTiX (load to RAM)" {
	set gfxpayload=keep
	linux   /live/vmlinuz boot=live toram  username=extix    
	initrd  /live/initrd.img
    }

EOF
)
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/live/vmlinuz"
iso_command_x=""
append_x="boot=live username=extix"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Nomodeset"
append_x="boot=live nomodeset nouveau.modeset=0 radeon.modeset=0 vga=normal username=extix"
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
PASSWORDS The password for root is root. No password is needed for the ordinary user extix.
If you write iso to volume - partition as Isohybrid, then you be able to run it from grub menu entry.
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://www.extix.se/"
#
distro[X]="cruxex"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-64bit"
version[X]="-3.3"
desktop[X]="-lxde-nvidia-730mb-170216"
file_type[X]=".zip"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_zip"	# folder for download iso file from mirros
#
: ${mirrors[X]="
"https://sourceforge.net/projects/cruxex/files/"
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="yes"
extract_from_iso[X]="no"
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
comment[X]=$(cat<<-EOF

LABEL default
MENU LABEL Run CruxEX
KERNEL /cruxex/boot/vmlinuz
APPEND vga=769 initrd=/cruxex/boot/initrfs.img load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 cruxex.flags=perch

LABEL default
MENU LABEL Run CruxEX debug
KERNEL /cruxex/boot/vmlinuz
APPEND vga=769 initrd=/cruxex/boot/initrfs.img load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 debug

#root=your_iso_image isoloop=$isofile
search --file --no-floppy --set root /crux-media
EOF
)
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/cruxex/boot/vmlinuz"
iso_command_x=""
append_x="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 cruxex.flags=perch"
initrd_x="/cruxex/boot/initrfs.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="debug"
append_x="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 debug"
add_to_grub_menu
add_to_xxx_menu
}
 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[2] () {
X=2
echo "$Green Install script executed after downlad files in install folder if use_install_script[X]=\"yes\"$Reset"
extract_from_zip
find_reala_boot_path
echo "$Yellow Move folder: cruxex to $real_boot_root"
if [ -d "$real_boot_root/cruxex" ]
then :
      echo "$Red Folder:$SmoothBlue "$real_boot_root/cruxex"$Orange allredy exist!$Reset"
      answer=$(
		r_ask_select "$Green Skip - [*] or$Orange [R]$Red Move Folder! cruxex to porteus_old
		$Nline$Orange Please select: " "1" "{S}kip" "{R}emove"
		)
		[[ "$answer" == "remove" ]] && \
		{
			rm -fr "$real_boot_root/cruxex_old" > /dev/null 2>&1
			mv -vf "$real_boot_root/cruxex" "$real_boot_root/cruxex_old"
			mv -f "cruxex" "$real_boot_root"
			mkdir -p ./cruxex/boot
			cp -fr "$real_boot_root"/cruxex/boot ./cruxex/
			return 0
			
		}
		[[ "$answer" == "skip" ]] && \
		{
			echo "$Orange Skipped$Reset"
		}
else :
	mv -f "cruxex" "$real_boot_root"
	mkdir -p ./cruxex/boot
	cp -fr "$real_boot_root"/cruxex/boot ./cruxex/
fi
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
home_page[X]="http://www.extix.se/"
#
distro[X]="exlight"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-64bit"
version[X]="-e20-refracta-isoh"
desktop[X]="-nvidia-1420mb-170105"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${arch[X]}${version[X]}${desktop[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${version[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/exlight/files/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="1.5 GB"
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
comment[X]=$(cat<<-EOF
abel live
	menu label ExLight (default)
    kernel /live/vmlinuz 
    append initrd=/live/initrd.img boot=live  username=exlight  
    
label nox
	menu label ExLight (text-mode)
    kernel /live/vmlinuz 
    append initrd=/live/initrd.img boot=live 3  username=exlight 

label nomodeset
        menu label ExLight (nomodeset)
    kernel /live/vmlinuz
    append initrd=/live/initrd.img boot=live nomodeset  username=exlight 

label toram
	menu label ExLight (load to RAM)
    kernel /live/vmlinuz
    append initrd=/live/initrd.img boot=live  toram  username=exlight 

label noprobe
	menu label ExLight (no probe)
    kernel /live/vmlinuz noapic noapm nodma nomce nolapic nosmp vga=normal  username=exlight 
    append initrd=/live/initrd.img boot=live   

EOF
)
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/live/vmlinuz"
iso_command_x=""
append_x="boot=live  username=exlight"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="(no probe)"
append_x="noapic noapm nodma nomce nolapic nosmp vga=normal  username=exlight"
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
home_page[X]="http://www.extix.se/"
#
distro[X]="extix"								# fitst distro[X] = null end array of distros/packages..
arch[X]="-17.8-64bit"
desktop[X]="-lxqt"
version[X]="-refracta-nvidia-1540mb-171012"
file_type[X]=".iso"
file_name[X]="${distro[X]}${arch[X]}${desktop[X]}${version[X]}${file_type[X]}"	# the file to downloda - comment name to disable - end of playing at split name in sections :)
sum[X]="${distro[X]}${arch[X]}${desktop[X]}${version[X]}.md5" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${arch[X]}${desktop[X]}${version[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/extix/files/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
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
