#!/bin/bash
# new_install_OpenMandriva.sh
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
OpenMandriva Lx
Ostatnia aktualizacja: 2017-06-20 23:37 UTC

[OpenMandriva Lx]

    OS Type: Linux
    Oparty na: Independent
    Pochodzenie: France
    Architektura: i686, x86_64
    Pulpit: KDE Plasma
    Kategoria: Desktop, Live Medium, Raspberry Pi
    Release Model: Fixed
    Init: systemd
    Status: Aktywna
    Popularność: 78 (155 trafień dziennie) 

The OpenMandriva distribution is a full-featured Linux desktop and server, sponsored by the OpenMandriva Association. It is based on ROSA, a Russian Linux distribution project which forked Mandriva Linux in 2012, incorporating many of Mandriva's original tools and utilities and adding in-house enhancements. The goal of OpenMandriva is to facilitate the creation, improvement, promotion and distribution of free and open-source software in general, and OpenMandriva projects in particular.

Popularność (trafień dziennie): 12 miesięcy: 58 (194), 6 miesięcy: 78 (155), 3 miesięcy: 58 (189), 4 tygodnie: 97 (107), 1 tydzień: 98 (103)

Average visitor rating: 8.07/10 from 14 review(s).


OpenMandriva Summary
Dystrybucja 	OpenMandriva Lx
Strona domowa 	http://openmandriva.org/
Listy pocztowe 	http://ml.openmandriva.org/
Forum użytkowników 	http://forums.openmandriva.org/
Alternative User Forums 	LinuxQuestions.org
Dokumentacja 	http://wiki.openmandriva.org/
Zrzuty ekranu 	DistroWatch Gallery
Screencasts 	
Serwery lustrzane 	https://www.openmandriva.org/Downloads • LinuxTracker.org
Bug Tracker 	http://issues.openmandriva.org/
Strony zwązane 	OpenMandriva Turkey
Recenzje 	3.x: DarkDuck • LinuxBSDos • DistroWatch
2014: DistroWatch • Hectic Geek • Linux EXPRES (Czech) • LinuxBSDos • DistroWatch • Blogspot • Hectic Geek • Gaël Duval's Blog
2013: DistroWatch • LinuxBSDos • Blogspot • Navy Christian
Gdzie kupić 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://openmandriva.org"
#
distro[X]="OpenMandrivaLx"								# fitst distro[X] = null end array of distros/packages..
version[X]=".3.02"
desktop[X]="-PLASMA."
arch[X]="x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}" 				# file with sum to download or sum
sum_file[X]="${sum[X]}.sha1sum"				# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 ftp://ftp.mirrorservice.org/sites/downloads.openmandriva.org/release_current/OpenMandriva_Lx_3/
 https://sourceforge.net/projects/openmandriva/files/release/3.02/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.3 GB"
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
kernel_x="/boot/vmlinuz0"
iso_command_x="iso-scan/filename="
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2017-06-19-13-48-41-00 locale.lang=en_US quiet rhgb splash=silent"
initrd_x="/boot/liveinitrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (Install)"
## rd.live.image toram
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2017-06-19-13-48-41-00 locale.lang=en_US quiet rhgb splash=silent systemd.unit=calamares.target"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (failsafe)"
## rd.live.image toram
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2017-06-19-13-48-41-00 xdriver=vesa nomodeset plymouth.enable=0 vga=792 failsafe"
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

EOF
)
#
home_page[X]="http://openmandriva.org"
#
distro[X]="OpenMandrivaLx"								# fitst distro[X] = null end array of distros/packages..
version[X]=".3.02"
desktop[X]="-PLASMA."
arch[X]="i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}" 				# file with sum to download or sum
sum_file[X]="${sum[X]}.sha1sum"				# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 ftp://ftp.mirrorservice.org/sites/downloads.openmandriva.org/release_current/OpenMandriva_Lx_3/
 https://sourceforge.net/projects/openmandriva/files/release/3.02/
 "}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.3 GB"
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
kernel_x="/boot/vmlinuz0"
iso_command_x="iso-scan/filename="
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2017-06-19-11-31-28-00 locale.lang=en_US quiet rhgb splash=silent"
initrd_x="/boot/liveinitrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (Install)"
## rd.live.image toram
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2017-06-19-11-31-28-00 locale.lang=en_US quiet rhgb splash=silent systemd.unit=calamares.target"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (failsafe)"
## rd.live.image toram
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2017-06-19-11-31-28-00 xdriver=vesa nomodeset plymouth.enable=0 vga=792 failsafe"
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
home_page[X]="http://openmandriva.org"
#
distro[X]="OpenMandrivaLx"								# fitst distro[X] = null end array of distros/packages..
version[X]=".3.01"
desktop[X]="-PLASMA."
arch[X]="x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="README-3.01.1.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}.txt"				# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/openmandriva/files/release/3.01/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.3 GB"
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
kernel_x="/boot/vmlinuz0"
iso_command_x="iso-scan/filename="
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2016-12-21-18-39-47-00 locale.lang=en_US quiet rhgb splash=silent"
initrd_x="/boot/liveinitrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (Install)"
## rd.live.image toram
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2016-12-21-18-39-47-00 locale.lang=en_US quiet rhgb splash=silent systemd.unit=calamares.target"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live (failsafe)"
## rd.live.image toram
append_x="rootfstype=auto ro rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 rd.live.image acpi_osi=Linux acpi_osi='!Windows 2012' acpi_backlight=vendor audit=0 logo.nologo root=live:UUID=2016-12-21-18-39-47-00 xdriver=vesa nomodeset plymouth.enable=0 vga=792 failsafe"
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
home_page[X]=""
#
distro[X]=""
version[X]=""
desktop[X]=""
arch[X]=""
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]=""
#sum_file[X]="${sum[X]}"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"
#
: ${mirrors[X]=""}
#
use_get_download_parameters[X]="no"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="no"
boot_memdisk[X]="no"
#
free_space[X]="0 GB"
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

}


 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
