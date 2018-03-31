#!/bin/bash
# new_install_opensuse.sh
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
openSUSE
Last Update: 2017-07-29 19:20 UTC

[openSUSE]

    OS Type: Linux
    Based on: Independent
    Origin: Germany
    Architecture: arm64, armhf, ppc64, ppc64el, s390x, x86_64
    Desktop: Cinnamon, GNOME, IceWM, KDE, LXDE, Openbox, WMaker, Xfce
    Category: Desktop, Server, Live Medium, Raspberry Pi
    Release Model: Fixed, Rolling
    Init: systemd
    Status: Active
    Popularity: 6 (1,094 hits per day) 

The openSUSE project is a community program sponsored by SUSE Linux and other companies. Promoting the use of Linux everywhere, this program provides free, easy access to openSUSE, a complete Linux distribution. The openSUSE project has three main goals: make openSUSE the easiest Linux for anyone to obtain and the most widely used Linux distribution; leverage open source collaboration to make openSUSE the world's most usable Linux distribution and desktop environment for new and experienced Linux users; dramatically simplify and open the development and packaging processes to make openSUSE the platform of choice for Linux developers and software vendors.

Popularity (hits per day): 12 months: 5 (1,213), 6 months: 6 (1,094), 3 months: 6 (1,030), 4 weeks: 7 (1,062), 1 week: 3 (1,601)

Average visitor rating: 8.8/10 from 92 review(s).



openSUSE Summary
Distribution 	openSUSE (formerly SUSE Linux)
Home Page 	http://www.opensuse.org/
Mailing Lists 	http://en.opensuse.org/openSUSE:Communication_channels
User Forums 	http://forums.opensuse.org/
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://en.opensuse.org/Portal:Documentation
Screenshots 	http://en.opensuse.org/Screenshots • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://software.opensuse.org/
http://mirrors.opensuse.org/list/all.html
Bug Tracker 	http://bugs.opensuse.org/
Related Websites 	openSUSE News • openSUSE Community • Planet SUSE • openSUSE Guide • SUSEGeek • APT for SUSE • Links2Linux.de • Wikipedia • openSUSE Brazil • openSUSE Czech Republic • openSUSE France • openSUSE Hungary • openSUSE Italy • openSUSE Poland • openSUSE Russia • openSUSE Spain
Reviews 	Tumbleweed: Ordinatechnic • LWN
42.2: Dedoimedo • Everyday Linux User • Dedoimedo • DistroWatch
42.1: Dedoimedo • Pro-Linux (German) • DistroWatch • Ordinatechnic • LinuxFR (French)
13.2: Dedoimedo • Ordinatechnic • Wordpress (Russian) • Dedoimedo • DistroWatch • LinuxFR • Heise (German) • Every Day Linux User
13.1: Blogspot • Linux.com • TalLinux • DistroWatch • Dedoimedo • Blogspot • derStandard (German)
12.x: Dedoimedo • Pro-Linux (German) • Guia do PC (Portuguese) • DistroWatch • HecticGeek • The Register • LWN • ZDNet • Heise Open (German) • BeginLinux • Wordpress • Linux Za Sve (Croatian) • DistroWatch • Blogspot • Dedoimedo • Linux Za Sve (Croatian) • Heise Open (German) • Linux Za Sve (Croatian) • Dedoimedo • Pro-Linux (German) • Linux Review (Farsi) • Wordpress • My Linux Rig • OverBlog (French) • DistroWatch • Dedoimedo • openSUSE.cz (Czech) • Linux User • derStandard (German) • Heise Open (German)
11.x: Dedoimedo • Linux Review (Persian) • MuyComputer (Spanish) • Index (Hungarian) • LWN • ITworld • DistroWatch • MyBroadband • Linux User • Blogspot • The Register • openSUSE.cz (Czech) • Linux EXPRESS (Czech) • Pro-Linux (German) • Heise Open (German) • derStandard (German) • PC Advisor • Dedoimedo • Wordpress • LinMagazine (Hebrew) • derStandard (German) • Computerworld Blogs • Heise Open (German) • LinuxEXPRES (Czech) • Dedoimedo • MakeUseOf • Pro-Linux (German) • Adventures in Open Source • SourceForge (Japanese) • LWN • Dedoimedo • DistroWatch • Linux EXPRESS (Czech) • Wordpress (Russian) • Heise Open (German) • Wordpress • Radio World • It's A Binary World • HeadshotGamer • Linux EXPRESS (Czech) • Pro-Linux (German) • DistroWatch • Heise Open (German) • ABC Linuxu (Czech) • Ars Technica • Linuxoid (Russian) • LinuxPlanet • It's A Binary World • LinuxPlanet • Guia do PC (Portuguese) • Pro-Linux (German) • Linux Express (Czech) • Root.cz (Czech) • HTML.it (Italian) • Blogspot • Heise Open (German) • ABC Linuxu (Czech) • The Register
10.x: Download Squad • Linuxoid (Russian) • Blogspot • Mandrake Tips4Free • ABC Linuxu (Czech) • Root.cz (Czech) • DistroWatch • Pro-Linux (German) • Tuxmachines • Blogspot • Heise Open (German) • Blogspot • Blogspot • ABC Linuxu (Czech) • Guia do Hardware (Portuguese) • Free-Bees • Wordpress • InformationWeek • Tuxmachines • LinuxForums • Blogbeebe (Part 1, Part 2, Part 3) • JonRob's Blog • Heise Open (German) • Pro-Linux (German) • Tuxmachines • Free-Bees • ABC Linuxu (Czech) • Pro-Linux (German) • Groklaw • Linux-Noob • Tuxmachines
9.x: Forever For Now • Index.hu (Hungarian) • Hardware Upgrade (Italian) • Pro-Linux (German) • Cool Solutions • Linux-Noob • Cool Solutions • Mandrake Tips4Free • OSNews • Linux Gazette • OSNews • OSNews • Pro-Linux (German) • OSNews • Linux Magazine (PDF) • OSNews • OSNews • OSNews • Pro-Linux (German) • LWN • Sydney Morning Herald • Pro-Linux (German)
8.x: Linux Journal • OSNews • Linux Journal • OSNews • DistroWatch
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="http://www.opensuse.org"
#
distro[X]="openSUSE-Leap"								# fitst distro[X] = null end array of distros/packages..
version[X]="-42.3-DVD"
desktop[X]=""
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}" 				# file with sum to download or sum
sum_file[X]="${sum[X]}.sha256"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://download.opensuse.org/distribution/openSUSE-current/iso/
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
home_page[X]="http://www.opensuse.org"
#
distro[X]="openSUSE-Leap"
version[X]="-42.3-NET"
desktop[X]=""
arch[X]="-x86_64"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}"
sum_file[X]="${sum[X]}.sha256"
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://download.opensuse.org/distribution/openSUSE-current/iso/
"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
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
add_menu_label_x="memdisk"
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
home_page[X]="http://www.opensuse.org"
#
distro[X]="openSUSE-13.2"
desktop[X]=""
version[X]="-NET"
arch[X]="-i586"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]=""
# sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://download.opensuse.org/distribution/13.2/iso/
"}
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
home_page[X]="http://www.opensuse.org"
#openSUSE-13.2-KDE-Live-i686.iso
distro[X]="openSUSE"
version[X]="-13.2"
desktop[X]="-KDE-Live"
arch[X]="-i686"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]=""
# sum_file[X]="${sum[X]}"
gpg[X]="${file_name[X]}.asc"
gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
http://download.opensuse.org/distribution/13.2/iso/
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
kernel_x="/boot/i386/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet"
initrd_x="/boot/i386/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Install"
append_x="ramdisk_size=512000 ramdisk_blocksize=4096 liveinstall splash=silent quiet"
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
Important_after_installation[X]="Change password in console - type sudo su & passwd"
#
#!FIXME ### --- New Item ------ ###
X=5
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://www.opensuse.org"
#
distro[X]="openSUSE"
version[X]="-Tumbleweed"
desktop[X]="-KDE"
arch[X]="-Live-i686-Current"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha256"
sum_file[X]="${sum[X]}"
 gpg[X]="${file_name[X]}.sha256"
 gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="http://download.opensuse.org/tumbleweed/iso/"}
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
### NOTE: gen_boot_menus[x] procedure executed after downlad files in install folder if add_to_boot_menu[X]="yes" UUID="2017-07-29-17-33-46-00" LABEL="\"openSUSE Tumbleweed KDE Live\""
gen_boot_menus[5] () {
X=5
install_folder_x="${install_folder[X]}"
file_name_x="${file_name[X]}"
find_reala_boot_path
add_menu_label_x="Live"
kernel_x="/boot/ix86/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/ix86/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
GeckoLinux
Last Update: 2017-08-26 01:22 UTC

[GeckoLinux]

    OS Type: Linux
    Based on: openSUSE
    Origin: USA
    Architecture: x86_64
    Desktop: Budgie, Cinnamon, GNOME, KDE Plasma, LXQt, MATE, Xfce
    Category: Desktop, Live Medium
    Status: Active
    Popularity: 68 (167 hits per day) 

GeckoLinux is a Linux spin based on the openSUSE distribution, with a focus on polish and out-of-the-box usability on the desktop. The distribution features many desktop editions which can be installed from live discs. Some patent encumbered open source software is included in GeckoLinux which is not available in the default installation of openSUSE. Special attention has been given to the quality of the font rendering. GeckoLinux provides two main editions, Static (which is based on openSUSE Leap) and Rolling (based on openSUSE Tumbleweed).

Popularity (hits per day): 12 months: 49 (225), 6 months: 68 (167), 3 months: 88 (119), 4 weeks: 87 (113), 1 week: 91 (105)

Average visitor rating: 8.89/10 from 9 review(s).


GeckoLinux Summary
Distribution 	GeckoLinux
Home Page 	http://geckolinux.github.io/
Mailing Lists 	 
User Forums 	https://groups.google.com/forum/#!forum/geckolinux
Alternative User Forums 	LinuxQuestions.org
Documentation 	https://github.com/geckolinux/geckolinux-project/wiki
Screenshots 	http://geckolinux.github.io/ • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://geckolinux.github.io/#download
Bug Tracker 	https://github.com/geckolinux/geckolinux-project/issues
Related Websites 	
Reviews 	421.x: DistroWatch
Where To Buy 	OSDisc.com (sponsored link)

Home / Static / 422.170302
Name 	Modified 	Size 	Downloads / Week 	Status
Parent folder
GeckoLinux_XFCE.x86_64-422.170302.0.iso 	2017-03-03 	1.0 GB 	4040 weekly downloads 	i
GeckoLinux_Budgie10.x86_64-422.170302.0.iso 	2017-03-03 	1.0 GB 	2828 weekly downloads 	i
GeckoLinux_LXQt.x86_64-422.170302.0.iso 	2017-03-03 	1.0 GB 	6868 weekly downloads 	i
GeckoLinux_Gnome.x86_64-422.170302.0.iso 	2017-03-03 	1.0 GB 	3636 weekly downloads 	i
GeckoLinux_Mate.x86_64-422.170302.0.iso 	2017-03-03 	1.1 GB 	3232 weekly downloads 	i
GeckoLinux_Cinnamon.x86_64-422.170302.0.iso 	2017-03-03 	1.0 GB 	7474 weekly downloads 	i
GeckoLinux_Plasma_Stable.x86_64-422.170302.0.iso 	2017-03-03 	1.1 GB 	6969 weekly downloads 	i
GeckoLinux_BareBones.x86_64-422.170302.0.iso 	2017-03-03 	803.2 MB 	1010 weekly downloads 	i
Totals: 8 Items 	 
EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]="GeckoLinux"
desktop[X]="_Cinnamon"
arch[X]=".x86_64"
version[X]="-422.170302.0"

file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]="2ffe064f8b265387e21081c564ae10943a1eb87d"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="http://sourceforge.net/projects/geckolinux/files/Static/422.170302/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
$SmoothBlue
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
Notice: Please verify your download checksums by clicking the   i   icon next to your download in the Sourceforge directory listing.

Notice: The live system password is linux for normal and root users.
"
#
#!FIXME ### --- New Item ------ ###
X=7
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]="GeckoLinux"
desktop[X]="_Plasma_Stable"
arch[X]=".x86_64"
version[X]="-422.170302.0"

file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]="69ea6c1c864a2930d7f1dbe1a59a7034673c6136"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="http://sourceforge.net/projects/geckolinux/files/Static/422.170302/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
home_page[X]="http://www.opensuse.org"
#
distro[X]="openSUSE"
version[X]="-Tumbleweed"
desktop[X]="-NET"
arch[X]="-i586-Current"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha256"
sum_file[X]="${sum[X]}"
 gpg[X]="${file_name[X]}.sha256"
 gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="http://download.opensuse.org/tumbleweed/iso/"}
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
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="iso"
initrd_x=""
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
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
home_page[X]="http://www.opensuse.org"
#
distro[X]="openSUSE"
version[X]="-Tumbleweed"
desktop[X]="-NET"
arch[X]="-x86_64-Current"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"
sum[X]="${file_name[X]}.sha256"
sum_file[X]="${sum[X]}"
 gpg[X]="${file_name[X]}.sha256"
 gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}"
#
: ${mirrors[X]="http://download.opensuse.org/tumbleweed/iso/"}
#
use_get_download_parameters[X]="yes"
use_install_script[X]="no"
extract_from_iso[X]="no"
add_to_boot_menu[X]="yes"
boot_memdisk[X]="yes"
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
add_menu_label_x="memdisk"
kernel_x=""
iso_command_x="memdisk"
append_x="iso"
initrd_x=""
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x=""
append_x=""
add_to_grub_menu
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
[GeckoLinux]
Home / Rolling / 999.170302
Name	Modified	Size	Downloads / Week	Status
Parent folder
GeckoLinux_ROLLING_Plasma.x86_64-999.170302.0.iso	2017-03-03	1.2 GB	6161 weekly downloads	i
GeckoLinux_ROLLING_BareBones.x86_64-999.170302.0.iso	2017-03-03	859.8 MB	1111 weekly downloads	i
GeckoLinux_ROLLING_XFCE.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	3131 weekly downloads	i
GeckoLinux_ROLLING_Mate.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	2828 weekly downloads	i
GeckoLinux_ROLLING_Gnome.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	5151 weekly downloads	i
GeckoLinux_ROLLING_Budgie10.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	1818 weekly downloads	i
GeckoLinux_ROLLING_Cinnamon.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	4040 weekly downloads	i
GeckoLinux_ROLLING_LXQt.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	6464 weekly downloads	i
Totals: 8 Items	 	8.6 GB	304	
EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]="GeckoLinux_ROLLING"
desktop[X]="_Cinnamon"
arch[X]=".x86_64"
version[X]="-999.170302.0"

file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]="76b489ce536f6864ddeb20a59a8b37aa9d89beb1"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="http://sourceforge.net/projects/geckolinux/files/Rolling/999.170302/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
add_to_grub_menu
add_to_xxx_menu
}

 ### NOTE: install script executed after downlad files in install folder if use_install_script[X]="yes"
install_package[10] () {
X=10
echo "install script executed after downlad files in install folder if use_install_script[X]="yes""
/bin/bash exit
}
#
Important_after_installation[X]="
$SmoothBlue
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
Notice: Please verify your download checksums by clicking the   i   icon next to your download in the Sourceforge directory listing.

Notice: The live system password is linux for normal and root users.
"
#
#!FIXME ### --- New Item ------ ###
X=11
comment[X]=$(cat<<-EOF
[GeckoLinux]
Home / Rolling / 999.170302
Name	Modified	Size	Downloads / Week	Status
Parent folder
GeckoLinux_ROLLING_Plasma.x86_64-999.170302.0.iso	2017-03-03	1.2 GB	6161 weekly downloads	i
GeckoLinux_ROLLING_BareBones.x86_64-999.170302.0.iso	2017-03-03	859.8 MB	1111 weekly downloads	i
GeckoLinux_ROLLING_XFCE.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	3131 weekly downloads	i
GeckoLinux_ROLLING_Mate.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	2828 weekly downloads	i
GeckoLinux_ROLLING_Gnome.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	5151 weekly downloads	i
GeckoLinux_ROLLING_Budgie10.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	1818 weekly downloads	i
GeckoLinux_ROLLING_Cinnamon.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	4040 weekly downloads	i
GeckoLinux_ROLLING_LXQt.x86_64-999.170302.0.iso	2017-03-03	1.1 GB	6464 weekly downloads	i
Totals: 8 Items	 	8.6 GB	304	
EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]="GeckoLinux_ROLLING"
desktop[X]="_Plasma"
arch[X]=".x86_64"
version[X]="-999.170302.0"

file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]="72324ac79dd09a198b31c83efb731da1ba4687bc"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="http://sourceforge.net/projects/geckolinux/files/Rolling/999.170302/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
Important_after_installation[X]="
$SmoothBlue
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
Notice: Please verify your download checksums by clicking the   i   icon next to your download in the Sourceforge directory listing.

Notice: The live system password is linux for normal and root users.
"
#!FIXME ### --- New Item ------ ###
X=12
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]=""
desktop[X]=""
arch[X]=".x86_64"
version[X]="-999."

file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]=""
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="http://sourceforge.net/projects/geckolinux/files/Rolling/999.170302/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
Important_after_installation[X]="
$SmoothBlue
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
Notice: Please verify your download checksums by clicking the   i   icon next to your download in the Sourceforge directory listing.

Notice: The live system password is linux for normal and root users.
"
#!FIXME ### --- New Item ------ ###
X=13
comment[X]=$(cat<<-EOF

EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]=""
desktop[X]=""
arch[X]=".x86_64"
version[X]="-999."

file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]=""
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="http://sourceforge.net/projects/geckolinux/files/Rolling/999.170302/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
Important_after_installation[X]="
$SmoothBlue
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
Notice: Please verify your download checksums by clicking the   i   icon next to your download in the Sourceforge directory listing.

Notice: The live system password is linux for normal and root users.
"
#!FIXME ### --- New Item ------ ###
X=14
comment[X]=$(cat<<-EOF
[GeckoLinux]
Home / NEXT
Name	Modified	Size	Downloads / Week	Status
Parent folder
GeckoLinux_Plasma_NEXT.x86_64-422.170303.0.iso	2017-03-03	1.1 GB	3232 weekly downloads	i
GeckoLinux_Plasma_NEXT.x86_64-422.170205.0.iso	2017-02-05	1.1 GB	22 weekly downloads	i
GeckoLinux_Plasma_NEXT.x86_64-421.161103.0.iso	2016-11-05	1.1 GB	0	i
Totals: 3 Items
EOF
)
#
home_page[X]="http://geckolinux.github.io/"
#
distro[X]="GeckoLinux"
desktop[X]="_Plasma_NEXT"
arch[X]=".x86_64"
version[X]="-422.170303.0"
file_type[X]=".iso"
file_name[X]="${distro[X]}${desktop[X]}${arch[X]}${version[X]}${file_type[X]}"
sum[X]="ce09a9a833c2b5aae79b6dee06b356b8ff9c93c2"
#sum_file[X]="${sum[X]}"
#gpg[X]="${file_name[X]}.sig"
#gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${desktop[X]}${arch[X]}${version[X]}_iso"
# https://sourceforge.net/projects/geckolinux/files/
: ${mirrors[X]="https://sourceforge.net/projects/geckolinux/files/NEXT/"}
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
kernel_x="/boot/x86_64/loader/linux"
iso_command_x="isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system="
append_x="splash=silent quiet kiwi_hybrid=1"
initrd_x="/boot/x86_64/loader/initrd"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Live Failsafe"
append_x="rsplash=silent quiet ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processor.max+cstate=1 nomodeset x11failsafe kiwi_hybrid=1"
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
Important_after_installation[X]="
$SmoothBlue
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
Notice: Please verify your download checksums by clicking the   i   icon next to your download in the Sourceforge directory listing.

Notice: The live system password is linux for normal and root users.
"
}

 ### --------- ### ### Program ### include ### Program ### ### --------- ###
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/new_instal_distro.sh"
