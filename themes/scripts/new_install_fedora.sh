#!/bin/bash
# new_install_fedora.sh
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
Fedora
Last Update: 2017-08-13 07:21 UTC

[Fedora]

    OS Type: Linux
    Based on: Independent
    Origin: USA
    Architecture: armhfp, i686, x86_64
    Desktop: Awesome, Cinnamon, Enlightenment, GNOME, KDE Plasma, LXDE, MATE, Openbox, Ratpoison, Xfce
    Category: Desktop, Server, Live Medium
    Release Model: Fixed
    Init: systemd
    Status: Active
    Popularity: 8 (995 hits per day) 

Fedora (formerly Fedora Core) is a Linux distribution developed by the community-supported Fedora Project and owned by Red Hat. Fedora contains software distributed under a free and open-source license and aims to be on the leading edge of such technologies. Fedora has a reputation for focusing on innovation, integrating new technologies early on and working closely with upstream Linux communities. The default desktop in Fedora is the GNOME desktop environment and the default interface is the GNOME Shell. Other desktop environments, including KDE, Xfce, LXDE, MATE and Cinnamon, are available. Fedora Project also distributes custom variations of Fedora called Fedora spins. These are built with specific sets of software packages, offering alternative desktop environments or targeting specific interests such as gaming, security, design, scientific computing and robotics.

Popularity (hits per day): 12 months: 6 (1,010), 6 months: 8 (995), 3 months: 7 (970), 4 weeks: 7 (960), 1 week: 7 (795)

Average visitor rating: 8.92/10 from 106 review(s).


Fedora Summary
Distribution 	Fedora Project
Home Page 	https://getfedora.org/
Mailing Lists 	http://fedoraproject.org/wiki/Communicate
User Forums 	Fedora Forum
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://docs.fedoraproject.org/
http://fedoraproject.org/wiki/Docs
Screenshots 	https://fedoraproject.org/wiki/Category:Screenshots_library • DistroWatch Gallery
Screencasts 	
Download Mirrors 	https://getfedora.org/
https://admin.fedoraproject.org/mirrormanager/mirrors
http://torrent.fedoraproject.org/
Bug Tracker 	https://bugzilla.redhat.com/
Related Websites 	Fedora Magazine • Fedora Unity • Remi's RPM Repository • RPM Fusion • RPM Search • ATrpms • Wikipedia • Fedora Czech Republic • Fedora France • Fedora Germany • Fedora Hungary • Fedora Indonesia • Fedora Italy • Fedora Spain • Fedora Poland
Reviews 	26: Pro-Linux (German) • DistroWatch
25: Digiplace (Dutch) • DarkDuck • Everyday Linux User • Dedoimedo • Ars Technica • Pro-Linux (German) • DistroWatch • Hectic Geek
24: Dedoimedo • Pro-Linux (German) • DistroWatch • Unixmen • LinuxFR.org (French) • derStandard (German)
23: Dedoimedo • Sayak Biswas • LinuxBSDos • Hectic Geek • DistroWatch • LinuxFR (French)
22: Ordinatechnic • Dedoimedo • DistroWatch • HecticGeek • Pro-Linux
21: Ars Technica • Pro-Linux (German) • Blogspot • Dedoimedo • DistroWatch • Desktop Linux Reviews • Hectic Geek • Linux.com • derStandard (German)
20: Digiplace (Dutch) • Pro-Linux (German) • Blogspot • Dedoimedo • derStandard (German)
19: Dedoimedo • Dedoimedo • derStandard (German) • DistroWatch • Blogspot • derStandard (German) • LinuxBSDos • Hectic Geek • Blogspot • LinuxFR (French) • Heise (German)
18: LinuxBSDos • Wordpress • Pro-Linux (German) • Blogspot (Spanish) • DistroWatch • Blogspot • Dedoimedo • Wordpress • Heise Open (German)
17: Blogspot • LinuxBSDos • Dedoimedo • DistroWatch • Linux For You • Blogspot • Wordpress • derStandard (German)
16: Tom's Hardware • Dedoimedo • LinuxBSDos • Linux Review (Farsi) • Dedoimedo • The Register • Pro-Linux (German) • Linux User • DistroWatch • Wordpress • LinuxEXPRESS (Slovak) • Heise (German) • derStandard (German)
15: Techgage • LinuxBSDos • Pro-Linux (German) • Computing • DistroWatch • LinuxBSDos • MuyLinux (Spanish) • derStandard (German) • Dedoimedo • LinuxBSDos • Wordpress • Ars Technica • Heise Open (German)
14: IT Lure • Linux User • Dedoimedo • LinuxBSDos • Pro-Linux (German) • DistroWatch • derStandard (German) • The Register • Heise Open (German) • ITworld
13: Dedoimedo • LinuxBSDos • Pro-Linux (German) • DistroWatch • Blogspot • derStandard (German) • The Register • Heise Open (German)
12: Dedoimedo • MakeUseOf • Adventures in Open Source • Pro-Linux (German) • DistroWatch • The Register • Heise Open (German)
11: TuxRadar • Adventures in Open Source • Pro-Linux (German) • DistroWatch • Heise Open (German)
10: It's A Binary World • HeadshotGamer • eWEEK • Pro-Linux (German) • ABC Linuxu (Czech) • MontanaLinux • Root.cz (Czech) • Channel Register • Heise Open (German) • Tux-planet (French)
9: It's A Binary World • Linuxoid (Russian) • Pro-Linux (German) • PC Advisor • Root.cz (Czech) • Tech Source • Heise Open (German) • Reg Developer
8: Linuxoid (Russian) • Terrell Prudé • Pro-Linux (German) • DistroWatch • Root.cz (Czech) • Heise Open (German)
7: LinuxLinks • PC Advisor • ITmedia (Japanese) • DistroWatch • Tuxmachines • Heise Open (German) • ABC Linuxu (Czech)
6: Enterprise Networking Planet • Free-Bees • Brad-X • Heise Open (German) • Linux Forums • Red Hat Magazine • Phoronix
5: Red Hat Magazine • Free-bees • OSNews • Linux Forums
4: Free-Bees • Tux:Tops • ABC Linuxu (Czech) • Red Hat Magazine
3: Linux-Noob • OSNews • Red Hat Magazine • OSNews
2: OSNews • OSNews • OSNews • OSNews
1: Pro-Linux (German) • OSNews • OSNews
Where To Buy 	OSDisc.com (sponsored link)
EOF
)
#
home_page[X]="https://getfedora.org/"
#
distro[X]="Fedora-Workstation"								# fitst distro[X] = null end array of distros/packages..
version[X]="-Live"
desktop[X]=""
arch[X]="-x86_64-25-1.3"
file_type[X]=".iso"
file_name[X]="${distro[X]}${version[X]}${desktop[X]}${arch[X]}${file_type[X]}"	# the file to downloda - comment name to disable
sum[X]="${file_name[X]}-CHECKSUM" 				# file with sum to download or sum
sum_file[X]="${sum[X]}"							# comment file name to disable if sum is set
# gpg[X]="${file_name[X]}.sig"
# gpg_file[X]="${gpg[X]}"
install_folder[X]="/ISO/${distro[X]}${version[X]}${desktop[X]}${arch[X]}_iso"	# folder for download iso file from mirros
#
: ${mirrors[X]="
 http://dl.fedoraproject.org/pub/fedora/linux/releases/25/Workstation/x86_64/iso/
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
kernel_x="/isolinux/vmlinuz"
iso_command_x="iso-scan/filename="
append_x="root=live:CDLABEL=Fedora-WS-Live-25-1-3 rd.live.image quietrd.udev.log-priority=crit quiet splash"
initrd_x="/isolinux/initrd.img"
add_to_grub_menu
add_to_xxx_menu
add_menu_label_x="Troubleshooting"
append_x="root=live:CDLABEL=Fedora-WS-Live-25-1-3 rd.live.image nomodeset quiet"
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
