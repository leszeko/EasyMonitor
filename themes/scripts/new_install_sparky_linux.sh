#!/bin/bash
# new_install_sparky_linux.sh
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
SparkyLinux
Ostatnia aktualizacja: 2017-07-15 15:07 UTC

[SparkyLinux]

    OS Type: Linux
    Oparty na: Debian
    Pochodzenie: Poland
    Architektura: i386, x86_64
    Pulpit: Budgie, Enlightenment, JWM, KDE Plasma, LXDE, LXQt, MATE, Openbox, Xfce
    Kategoria: Desktop, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Aktywna
    Popularność: 33 (316 trafień dziennie) 

SparkyLinux is a lightweight, fast and simple Linux distribution designed for both old and new computers featuring customised Enlightenment and LXDE desktops. It has been built on the "testing" branch of Debian GNU/Linux.

Popularność (trafień dziennie): 12 miesięcy: 31 (336), 6 miesięcy: 33 (316), 3 miesięcy: 26 (363), 4 tygodnie: 18 (518), 1 tydzień: 25 (403)

Average visitor rating: 8.26/10 from 23 review(s).


SparkyLinux Summary
Dystrybucja 	SparkyLinux
Strona domowa 	https://sparkylinux.org/
Listy pocztowe 	--
Forum użytkowników 	https://sparkylinux.org/forum/
Alternative User Forums 	LinuxQuestions.org
Dokumentacja 	https://sparkylinux.org/wiki/doku.php
Zrzuty ekranu 	https://sparkylinux.org/screenshots • DistroWatch Gallery
Screencasts 	
Serwery lustrzane 	https://sparkylinux.org/download/ •
Bug Tracker 	https://sourceforge.net/p/sparkylinux/tickets/
Strony zwązane 	 
Recenzje 	3.x: DistroWatch • Hectic Geek • LinuxInsider • Navy Christian • Dedoimedo • Everyday Linux User
2.x: DistroWatch
Gdzie kupić 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"								# fitst distro[X] = null end array of distros/packages..
version[X]="-5.0"
arch[X]="-i686"
desktop[X]="-minimalgui"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/sparkylinux/files/base/
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
add_menu_label_x="Live to ram"
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="boot=live live-config live-media-path=/live splash -- quiet toram"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal noapci nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live text mode"
append_x="boot=live live-config live-media-path=/live systemd.unit=multi-user.target"
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
The data on this device will be destroyed and overwritten!!!
You can find it bay:
sudo fdisk -l

Execute this below example in a terminal:
In this example in second line the „${file_name[X]}” is iso image, so you can change it $Yellow and /dev/<dev> have to be the USB card/stick !$Reset
( you will need to install pv and dd commands ) After writing wait a while for sync.
$Reset
--- $Cream
vdd ${file_name[X]} /dev/sd<x> $Reset
---
$Magenta
SparkyLinux Live mode user name is: live The password is: live System root (administrator) password is blank.
If you have to work as superuser, use “sudo” (with no password): sudo command.
change passwor for root: sudo su passwd

No system reinstallation is required. If you have Sparky up to 4.5 installed on your hard drive, simply make full system upgrade:
sudo apt-get update
sudo apt-get dist-upgrade

If any problem, run:
sudo dpkg --configure -a
sudo apt-get install -f

SparkyLinux (Advanced) installer - Yad and text based installer, used as a a backup, and lets you install one of 20 about desktops of your choice (MinimalISO only)
APTus provides an option to install any desktop you like, so do it if you are not happy with Openbox.

26. Po pierwszym uruchomieniu z dysku twardego możesz doinstalować kilka pakietów językowych za pomocą Synaptic lub apt-get:
– wpolish
– myspell-pl
– aspell-pl
– iceweasel-l10n-pl
– icedove-l10n-pl
– libreoffice-l10n-pl

Jest to aktualizacja e17 0.21.6 gotowa Sparky repozytorium teraz.
Jeśli chcesz, aby nowe instalacje, uruchom:
sudo apt-get update
sudo apt-get install enlightenment

sudo apt-get update
sudo apt-get install extra
"
#
#!FIXME ### --- New Item ------ ###
X=2
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"								# fitst distro[X] = null end array of distros/packages..
version[X]="-5.0"
arch[X]="-x86_64"
desktop[X]="-minimalgui"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/sparkylinux/files/base/
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
add_menu_label_x="Live to ram"
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="boot=live live-config live-media-path=/live splash -- quiet toram"
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal noapci nosplash irqpoll --"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live text mode"
append_x="boot=live live-config live-media-path=/live systemd.unit=multi-user.target"
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
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"								# fitst distro[X] = null end array of distros/packages..
version[X]="-5.0"
arch[X]="-i686"
desktop[X]="-rescue"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/sparkylinux/files/rescue/
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
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x=" boot=live live-config live-media-path=/live # locales="
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapci noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal nosplash irqpoll --"
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
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"								# fitst distro[X] = null end array of distros/packages..
version[X]="-4.5.3"
arch[X]="-x86_64"
desktop[X]="-rescue"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 https://sourceforge.net/projects/sparkylinux/files/rescue/
 "}
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
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x=" boot=live live-config live-media-path=/live # locales="
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapci noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal nosplash irqpoll --"
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
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"
version[X]="-5.0"
arch[X]="-i686"
desktop[X]="-gameover"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/sparkylinux/files/gameover/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="4.5 GB"
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
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="boot=live live-config live-media-path=/live splash -- quiet # locales="
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapci noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal nosplash irqpoll --"
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
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"
version[X]="-5.0"
arch[X]="-x86_64"
desktop[X]="-gameover"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/sparkylinux/files/gameover/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="4.5 GB"
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
iso_command_x="fromiso=$dev_name"
append_x="boot=live live-config live-media-path=/live splash -- quiet # locales="
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapci noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal nosplash irqpoll --"
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
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"
version[X]="-5.0"
arch[X]="-x86_64"
desktop[X]="-multimedia"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/sparkylinux/files/multimedia/
"}
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
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="boot=live live-config live-media-path=/live splash -- quiet # locales="
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapci noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal nosplash irqpoll --"
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

EOF
)
#
home_page[X]="https://sparkylinux.org"
#
distro[X]="sparkylinux"
version[X]="-5.0"
arch[X]="-i686"
desktop[X]="-multimedia"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${arch[X]}${desktop[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}.allsums.txt" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"				# comment file name to disable if sum is set
gpg[X]="${file_name[X]}.sig"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${arch[X]}${desktop[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
https://sourceforge.net/projects/sparkylinux/files/multimedia/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="boot"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="no"
#
free_space[X]="2.5 GB"
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
kernel_x="/live/vmlinuz"
iso_command_x="fromiso=$dev_name"
append_x="boot=live live-config live-media-path=/live splash -- quiet # locales="
initrd_x="/live/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Troubleshooting"
append_x="boot=live live-config live-media-path=/live ramdisk_size=1048576 root=/dev/ram rw noapic noapci noapm nodma nomce nolapic pci=nomsi nomodeset radeon.modeset=0 nouveau.modeset=0 nosmp vga=normal nosplash irqpoll --"
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
