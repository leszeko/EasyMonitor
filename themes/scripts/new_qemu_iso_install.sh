#!/bin/bash
# new_qemu_os_iso_install.sh
# Test Install os from iso in qemu hard disk image

Begin ()
{

prepare_check_environment
get_parameters
ask_for_install
create_qemu_hdd_image
run_install_system
create_qemu_hdd_image_backing_file
download_files
# extract_from_iso
# extract_from_tar
# extract_from_zip
# extract_from_gzip
run_instaled_system
end_message

}

get_parameters ()
{
##################
# Parameters to change

iso_folder="$HOME"
driver_folder="$iso_folder/Virtio_Drivers"
file_type=".iso"
# path to iso file
# the name of iso will be used as name to create folder in your home folder for install system in qemu image

qemu_command="qemu-system-x86_64"

hdd_image_size=1G
qemu_memory="-m 768"
qemu_vga="-vga std"
# cirrus # std # vmware # virtio
qemu_net="-net nic,model=rtl8139 -net user"
# Windows XP -net nic,model=rtl8139 -net user
# -netdev user,id=mynet0 net=192.168.0.0/24,dhcpstart=192.168.0.9
# You can use -net nic,model=? to get a list of valid network devices that you can pass to the -net nic option.
# -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9
# -net user,hostname=vm_os,smb=$HOME
# Then, in the guest, you will be able to access the shared directory on the host 10.0.2.4 with the share name "qemu".
# For example, in Windows Explorer you would go to \\10.0.2.4\qemu.
qemu_soundhw="-soundhw ac97"
# For 32 bit Windows 7 a sound driver for the Intel 82801AA AC97 exists.
# For 64 bit Windows 7 Intel HDA is available as an option (QEMU option: -soundhw hda)
# sb16,adlib # es1370 # ac97 # hda # all
qemu_usb="-usb -device usb-ehci,id=ehci -device usb-host,bus=ehci.0,vendorid=1452"
# USB 2.0 pass through can be configured from host to guest with variations of: -usb -device usb-ehci,id=ehci -device usb-host,bus=ehci.0,vendorid=1452
# For Windows 8.1 USB tablet is available only with USB 2.0 pass through (QEMU option: -device usb-ehci,id=ehci -device usb-tablet,bus=ehci.0

###################
# advanced parameters to change

mount_point_image="/mnt/image"

: ${mirrors_1="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.102/"}; files_names_1="virtio-win-0.1.102_x86.vfd virtio-win-0.1.102.iso"
#: ${mirrors_2="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.102/"}; file_name_2="virtio-win-0.1.102.iso"

# https://fedoraproject.org/wiki/Windows_Virtio_Drivers#Direct_download
# ISO contents
# The .iso contains the following bits:
# NetKVM/: Virtio Network driver
# viostor/: Virtio Block driver
# vioscsi/: Virtio SCSI driver
# viorng/: Virtio RNG driver
# vioser/: Virtio serial driver
# Balloon/: Virtio Memory Balloon driver
# qxl/: QXL graphics driver for Windows 7 and earlier. (build virtio-win-0.1.103-1 and later)
# qxldod/: QXL graphics driver for Windows 8 and later. (build virtio-win-0.1.103-2 and later)
# pvpanic/: QEMU pvpanic device driver (build virtio-win-0.1.103-2 and later)
# guest-agent/: QEMU Guest Agent 32bit and 64bit MSI installers
# qemupciserial/: QEMU PCI serial device driver
# *.vfd: VFD floppy images for using during install of Windows XP

# http://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-0.100.exe
##################
# End parameters to change

}

prepare_check_environment ()
{
################# Variables for color terminal
Color_terminal_variables() {
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[01;34m'"" Magenta=""$'\033[00;35m'""
LGreen=""$'\033[01;32m'"" LRed=""$'\033[01;31m'"" LWhite=""$'\033[01;37m'"" LYellow=""$'\033[01;33m'"" LCyan=""$'\033[01;36m'"" LBlue=""$'\033[00;34m'"" LMagenta=""$'\033[01;35m'""
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[0;38;5;225m'"";Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[01;38;5;111m'"";LCream=""$'\033[1;38;5;225m'"";LOrange=""$'\033[1;38;5;202m'"";Blink=""$'\033[5m'""
if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
fi
Nline=""$'\n'"" Reset=""$'\033[0;0m'"" EraseR=""$'\033[K'"" Back=""$'\b'"" Creturn=""$'\033[\r'"" Ctabh=""$'\033[\t'"" Ctabv=""$'\033[\v'"" SaveP=""$'\033[s'"" RestoreP=""$'\033[u'""
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
}
Color_terminal_variables
#################

	if [ ! -t 0 ]; then				# script is executed outside the terminal
	konsole --hold -e "/bin/bash \"$0\" $*"	# execute the script inside a terminal window
	exit $?
	fi
	
	echo "$Nline$Green Install an Operating System from boot iso into qemu $hdd_image_size hard disk image,$Orange Test beta script$Reset"
	echo "$Green # by Leszek Ostachowski (C2016) GPL V2$Reset$Nline"
	
	# Gathering informations about dowload program
	if command -v wget >/dev/null 2>&1; then
		_get_command() { wget -O- "$@" ; }
	elif command -v curl >/dev/null 2>&1; then
		_get_command() { curl -fL "$@" ; }
	else echo "$Red Eroor: This script needs curl or wget, exit$Reset$Nline" >&2; exit 2
	fi
	
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	
	
}

function reply_ask () {
while true
  do
   IFS= read -p "$SaveP$1" -sdR -N 1 REPLY
    case  $REPLY in
          $'\x0a') break ;; # Enter
    esac

     case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
          $2|$3) break ;; # trigers
          [a-z]) if [ -z "${3}" ]; then break;fi; IFS= read -p "$RestoreP" -s -r -t 000.1 rest ;; # if only $2 is set, berak on any key as $3
              *) IFS= read -p "$RestoreP" -s -r -t 000.1 rest ;; # Clear keyboard buffer if an escape sequence characters
    esac

  done

    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        $2) echo -n "yes" ;;
        *)  echo -n "no" ;;
    esac
}

select_reply ()
{

local question=$1 one=$2 two=$3 kone=$4 ktwo=$5 pselect=$6 timebreak=$7 cfirst=$Red csecond=$Green REPLY rest three onel twol x y

 [[ "$pselect" == "1" ]] && cfirst=$Green csecond=$Red; [[ "$pselect" == "" ]] && cfirst=$White csecond=$White
 
 [[ ! "$timebreak" == "" ]] && timebreak=$[$timebreak*4]
 onel=$(echo $kone | tr '[A-Z]' '[a-z]')
 twol=$(echo $ktwo | tr '[A-Z]' '[a-z]')

 # prepar konsoe to donot start srool at end of window
 OIFS="$IFS";IFS=''; while read; do ((rest++)); done <<< $question;IFS="$OIFS";((rest++))
 for (( x=$rest ; x>0; x--)); do  echo "$EraseR"; done
 Linesup $rest

 while true
  do
   echo -n "$SaveP"

    IFS= read -p "$question $cfirst$one$Reset or $csecond$two$Reset$Yellow " -s -N 1 -t 0.3 REPLY
    [[ "$kone" == "$ktwo" ]] && twol="" # !
    [[ "$cfirst" == "$Green" ]] && pselect=$onel; [[ "$cfirst" == "$Red" ]]  && pselect=$twol

    [[ ! "$timebreak" == "" ]] &&  y=$(echo -n "$pselect time out: $[$timebreak/4] ") && echo -n "$y" && Charsbk ${#y} && ((timebreak--)) && [[ $timebreak == 0 ]] && # time break
    { echo -n "$pselect$EraseR"; REPLY=$pselect; break;}

    echo -n "$pselect$MoveL" # print preselect

    [[ "$REPLY" == $'\x20' ]] && { three=$csecond csecond=$cfirst cfirst=$three; [[ ! "$timebreak" == "" ]] && timebreak=$[$7*4];} # Space
    [[ ! "$pselect" == "" ]] && [[ "$REPLY" == $'\x0a' ]] && { echo -n "$pselect$EraseR"; REPLY=$pselect; break;} # Enter

    [[ "$REPLY" == $'\x1b' ]] && # Get the rest of the escape sequence ( 2 next - 3 max characters total)
    { IFS= read -s -r -N 1 -t 000.1 rest; REPLY+="$rest"; IFS= read -s -r -N 1 -t 000.1 rest; REPLY+="$rest"
      # echo -n "HEX= $EraseR"; echo "$REPLY" | hexdump -v -e '"\\\x" 1/1 "%02x" " "'
      [[ "$REPLY" == $'\x1b[A' ]] && { three=$csecond csecond=$cfirst cfirst=$three;} # Up
      [[ "$REPLY" == $'\x1b[C' ]] && { three=$csecond csecond=$cfirst cfirst=$three;} # Right
      [[ "$REPLY" == $'\x1b[B' ]] && { three=$csecond csecond=$cfirst cfirst=$three;} # Down
      [[ "$REPLY" == $'\x1b[D' ]] && { three=$csecond csecond=$cfirst cfirst=$three;} # Left
      [[ ! "$timebreak" == "" ]] && timebreak=$[$7*4]
    }

  pselect=$(echo $REPLY | tr '[A-Z]' '[a-z]')
  case "$pselect" in  # case chars keys

  [[:lower:]] ) # [a..z]

    echo -n "$REPLY"
    [[ "$kone" == "$onel" ]] && [[ "$ktwo" == "$twol" ]] && { echo -n "$MoveL$EraseR$pselect"; break;} # if both of keytriger in lowercase passed

    { [[ ! "$kone" == "$onel" ]] && [[ "$ktwo" == "$twol" ]];} || { [[ "$kone" == "$onel" ]] && [[ ! "$ktwo" == "$twol" ]];} &&  # if one of keytriger in uppercase passed
    { echo -n "$MoveL$EraseR$pselect";[[ "$twol" == "$pselect" ]] || [[ "$onel" == "$pselect" ]] && { break;}; echo -n "$Cream Please press: $onel,$twol,space,Enter" ;}

    [[ ! "$kone" == "$onel" ]] && [[ ! "$ktwo" == "$twol" ]] && # if both of keytriger in uppercase passed
    { three=$csecond csecond=$cfirst cfirst=$three
     { [[ "$twol" == "$pselect" ]] && cfirst=$Red csecond=$Green;} || { [[ "$onel" == "$pselect" ]] && cfirst=$Green csecond=$Red;}
     y=$(echo -n "$MoveL$Cream Enter for - confirm"); echo -n "$y"; sleep 0.7; Charsbk ${#y}; echo -n "$EraseR"
    }
  ;;

  * )

   : # case whether else nop

  ;;

  esac

 echo -n "$RestoreP"

 done

 echo -n "$Reset$Nline"
 case $(echo "$REPLY" | tr '[A-Z]' '[a-z]') in
  $onel ) return 0 ;;
      * ) return 1 ;;
 esac

}


ask_select () {

	#...# add Quit nad Enter to menu
	local x= loop_time_out= again= rest= select_list=("${options[@]}")
	! [[ -z ${add_options[@]} ]] && select_list+=(${add_options[@]})
	select_list+=("{N}one" "{E}nter")
	
	
	for (( x=$(( ${#select_list[@]}+7 )); x>0; x--))
	do
	 echo "$EraseR"
	done
	Linesup $(( ${#select_list[@]}+7 ))
	
	echo "$ask_info"
	
	# Time out loop
	{ ! [[ -z "$time_out" ]] && loop_time_out=$time_out ;} || { loop_time_out=0 ;}
	
	while true
	do
	
	loop_time_out=$[$loop_time_out-1]
	
	echo "$Reset$SaveP$EraseR"
	echo -n "$EraseR$Magenta Select and Press:$Green $(( ${#select_list[@]} )) ${select_list[$@-1]} akcept,$Yellow $(( ${#select_list[@]}-1 )) ${select_list[$@-2]}$Reset"
	! [[ -z ${add_options[@]} ]] && echo -n " -$Red $(( ${#select_list[@]}-2 )) ${add_options[$@-1]},$White $(( ${#select_list[@]}-3 )) ${add_options[$@-2]}$Reset"
	echo "$Nline$EraseR"
	# Print menu loop
	for (( x=$(( ${#options[@]} )); x>0; x--))
	do
	
	if [ "$[default]" = "$x" ]; then  echo -n "$Green"; echo -n ""$'\E[6n'""; read -sdR -t 000.1 CURPOS; CURPOS=${CURPOS#*[}; Charsbk 9; fi
	printf "%-4s %s\n" "$x)" "${select_list[$x-1]}$Reset$EraseR"
	
	done
	
	# Read key and print time out
	# IFS= Separator
	IFS= read -p "$EraseR$Nline$EraseR$Orange Preselected:$Green ${select_list[$default-1]%%:*},$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink ?: " -s -N 1 -t 1 key; echo -n "$Reset"
	# \x1b is the start of an escape sequence
	if [ "$key" == $'\x1b' ]; then
	# Get the rest of the escape sequence ( 2 next - 3 or 6 max characters total)
	IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
	IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
	fi
	
	 echo -n "$EraseR$Nline$EraseR Starting in $loop_time_out seconds... "; # echo -n "${CURPOS}"
	
	Debug () {
	echo -n "$EraseR$Nline$EraseR$Nline"; echo "/Key=/$EraseR\"$key\"/$EraseR"
	echo -n "$EraseR$Nline$EraseR"
	echo -n "/${#key}/HEX= $EraseR"
	echo "$key" | hexdump -v -e '"\\x" 1/1 "%02x" " "'
	echo -n "$EraseR$Nline$EraseR"
	}
	# Debug
	
	
	# case nuber keys
	case "$key" in
		[1-9] )
		
		if [ 9 -gt $(( ${#select_list[@]}-1 )) ]
		then :
			if ! [ "$key" -gt $(( ${#select_list[@]}-1 )) ]
			then :
				default=$key; loop_time_out=$time_out
			fi
		else :
			IFS= read -r -N 1 -t 1.5 -s rest; key+="$rest"
			if ! [ "$key" -gt $(( ${#select_list[@]}-1 )) ]
			then :
				default=$key; loop_time_out=$time_out
			fi
		fi
		
		;;
	esac
	
	# case arrow keys
	if [ "$key" == $'\x1b[A' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#options[@]} )) ]; then default=1; fi; fi # Up
	if [ "$key" == $'\x1b[C' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi; fi # Right
	
	if [ "$key" == $'\x1b[B' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#options[@]} )); fi; fi # Down
	if [ "$key" == $'\x1b[D' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#select_list[@]}-1 )); fi; fi # Left
	
	# case chars keys
	case $(echo $key | tr '[A-Z]' '[a-z]') in [${keys[@]}] ) for (( x=0; x<${#keys}; x++)) do if [ "${keys:x:1}" = "$(echo $key | tr '[A-Z]' '[a-z]')" ]; then default=$[$x+1]; fi; done; loop_time_out=$time_out ;; esac
	
	# case Esc, Quit, Enter, time out
	if  [ "$key" == $'\x1b' ]; then read -s -N 1 -t 1 key; fi # twice Esc
	if  [ "$key" == $'\x1b' ] || [ "$key" = "$(( ${#select_list[@]}-1 ))" ] || [ "$key" = $'Quit' ] || [ "$key" = $'n' ] || [ "$key" = $'N' ]; then default=$(( ${#select_list[@]}-1 )); break
	elif [ "$key" == $'\x0a' ] || [ "$key" = "$(( ${#select_list[@]} ))" ] || [ "$key" = $'Enter' ] || [ "$key" = $'e' ] || [ "$key" = $'E' ]; then break
	elif [ "$loop_time_out" = 0 ] ; then break
	fi
	echo -n "$RestoreP"
	done
	
	# calculate result
	Selected="${select_list[default-1]}"
	# echo "$Nline Akcepted: $Selected"
	# echo " Pos: $default"
	unset time_out

}



file_ask ()
{
	files=$(ls *$file_type)
	if ! [ $? = 0 ]; then echo "$LRed Erorr: No "$iso_folder/*$file_type" files, exit$Reset$Nline"; exit 1;fi
	unset options
	OIFS="$IFS"
	 IFS=''; while read pos; do options+=("„$pos”"); done <<< $files
	# IFS='' readarray -t options <<< "$files"
	# IFS=$'\n'; declare -a options=($files)
	IFS="$OIFS"
	
	ask_info="$Nline$Green Menu ask selection,..$Orange Test beta script$Green # by Leszek Ostachowski (C2016) GPL V2$Nline List of iso files in your $HOME folder$Reset"
	options=$options keys=() default=1 time_out=60
	ask_select
	
	Selected=${Selected#*„}
	Selected=${Selected%”*}
	if [ "$Selected" == "{Q}uit" ]; then exit; fi
	MESSAGE+="$Nline$Green $(( mn+=1 )). Select: $Selected to install in $qemu_command $Reset$Nline"
}

ask_for_install ()
{
	cd $iso_folder
	if ! [ $? = 0 ]; then echo "$LRed Erorr: No "$iso_folder", exit$Reset$Nline"; exit 1;fi
	
	file_ask
	system_install_boot_iso="$Selected"
	
	name_of_system=${system_install_boot_iso##*/}
	name_of_system=${name_of_system%.*}
	install_folder="$iso_folder/$name_of_system"
	hdd_qcow2_image="$install_folder/$name_of_system"-qcow2.img""
	backing_img="$install_folder/$name_of_system"_backing.img""

	
	select_reply "$Nline$Green You are going to:$Nline\
	1. Create qemu hard disk image in folder $name_of_system and start install $system_install_boot_iso into this image$Nline\
	2. After installation create qemu hdd backing file$Nline\
	3. Download from $mirrors_1$Nline\
	   $files_names_1
	4. Finaly run OS for install Windows „Virtio Drivers” from iso file$Nline\
	$Cyan( you need $hdd_image_size free space left on root of $install_folder folder).$Nline\
	$Orange Please answer:" "[Y]es" "{n}o$Orange$Blink ?-$Reset" "y" "N" "1" "15"
	if ! [ $? = 0 ]; then echo "$Nline$Orange ok, next time$Reset$Nline"; exit 0;fi
	
	echo "$Reset"
	
	mkdir -p "$install_folder"
	if ! [ $? = 0 ]; then echo "Error: Cannot create folder, exit $install_folder"; exit 1; fi
	
}

create_qemu_hdd_image ()
{
	
	if [ -f "$hdd_qcow2_image" ]
	then
	select_reply "$Nline$Green Create qemu hard disk image:$Nline$Nline$Red file:$Reset $hdd_qcow2_image$Green exist.$Nline$Nline$Yellow Delete an create new?$Orange Please answer:"\
	"[R]ecreate" "{S}kip$Orange$Blink ?-$Reset" "R" "S" 
	 if [ $? = 0 ]
	 then file_message="Recreate" Color=$Yellow
	 else   file_message="Skipped recreate" Color=$Orange
	 fi
	echo " $Color$file_message"
	else file_message="Create" Color=$Green
	fi
	
	if [ ! "$file_message" == "Skipped recreate" ]; then
		echo "$Nline$Color $file_message - qemu-img create -f qcow2 $hdd_qcow2_image $hdd_image_size $Reset$Nline"
		qemu-img create -f qcow2 "$hdd_qcow2_image" "$hdd_image_size"
		 if [ $? = 0 ]
		 then echo "$Nline$Color ok$Reset"
		 else echo "$Nline$Red Error: $file_message qcow2 image - $hdd_qcow2_image in size $hdd_image_size, exit $Reset$Nline"; exit 1
		fi
	else
	 echo "$Nline$Color ok $file_message: $hdd_qcow2_image $Reset"
	fi
	MESSAGE+="$Nline$Color $(( mn+=1 )). $file_message qcow2 image - "$hdd_qcow2_image" in size $hdd_image_size $Reset$Nline"
	
}

run_install_system ()
{
	echo "$Nline$Green Run install from iso:$Nline$Cyan After few reboots necessary to finish install an OS$Nline quit from qemu, then script will create backing image and run again OS for driver installation $Reset"
	
	echo "$Nline$Green $qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda "$hdd_qcow2_image" -cdrom "$system_install_boot_iso" -boot d $Reset$Nline"
	
	$qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda "$hdd_qcow2_image" -cdrom "$system_install_boot_iso" -boot d
	if [ $? = 0 ]
	 then echo "$Nline$Color ok$Reset"
	 else echo "$Nline$Red Error: no $qemu_command command, exit $Reset$Nline"; exit 1
	fi
	MESSAGE+="$Nline$Green $(( mn+=1 )). Run install - $system_install_boot_iso $Reset$Nline"
}

create_qemu_hdd_image_backing_file ()
{

	cat <<-EOF
	
	$Green Create qemu hdd backing file:
	$Cyan
	# To start a new disposable environment based on a known good image
	# invoke the qemu-img command with the backing_file option and tell it what image to base its copy on.
	# When you run QEMU using the disposable environment, all writes to the virtual disc will go to this disposable image, not the base copy.$Reset
	EOF
	
	if [ -f "$backing_img" ]
	then echo "$Green$Nline$Red file:$Reset $backing_img$Green exist.$Reset$Nline"
	  if ! [[ "no" == $(reply_ask "$Yellow Delete an create new?$Orange Please answer:$Red {Y}es or [n]o $Orange$Blink?-$Reset$Yellow y$MoveL" "n" "y" "2") ]]
	   then Color=$Orange file_message="Skipped recreate" R=" n"
	   else Color=$Yellow file_message="Recreate" R=" y"
	  fi
	
	  echo "$Back$R $Color$file_message"
	else Color=$Green file_message="Create"
	fi
	
	if [ ! "$file_message" == "Skipped recreate" ]; then
			echo "$Nline$Color $file_message backing_img: qemu-img create -f qcow2 -o backing_file="$hdd_qcow2_image" "$backing_img" $Reset$Nline"
			qemu-img create -f qcow2 -o backing_file="$hdd_qcow2_image" "$backing_img"
		 if [ $? = 0 ]
		 then
		  echo "$Nline$Color ok$Reset"
		 else
		  if [[ "no" == $(reply_ask "$Nline$Red Error: Create $backing_img,$Orange Please answer:$Red {C}ontinue or [e]xit $Orange$Blink?-$Reset$Yellow e$MoveL" "e") ]]
		  then echo "$Nline$Orange ok, next time$Reset$Nline"; exit 1
		  else echo "$Nline ok continue$Reset"; Color=$Red file_message="Failed create:"
		  fi
		fi
	else
	 echo "$Nline$Color ok $file_message "$backing_img"$Reset"
	fi
	MESSAGE+="$Nline$Color $(( mn+=1 )). $file_message - $backing_img $Reset$Nline"
	
	

}

run_instaled_system ()
{
	
	echo "$Nline$Green Run instaled system for driver install:$Nline$Nline $qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda "$backing_img" -cdrom "$driver_folder/virtio-win-0.1.102.iso" -boot c $Reset$Nline"
	$qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda "$backing_img" -cdrom "$driver_folder/virtio-win-0.1.102.iso" -boot c
	if [ $? = 0 ]
	 then echo "$Nline$Color ok$Reset"
	 else echo "$Nline$Red Error: no $qemu_command command, exit $Reset$Nline"; exit 1
	fi
	MESSAGE+="$Nline$Green $(( mn+=1 )). Run instaled system for driver install: $backing_img $Reset$Nline"
}

downloda_it ()
{
	local mirrors_to_download="$1" files_to_download="$2" file_to_download= dowload_message=
	shift
	
	for file_to_download in $files_to_download
	do
		get_it ()
		{
		# Build download command, mirror and path
		local mirror= mirrors="$1" file="$2"
		shift
		for mirror in $mirrors
		do
		_get_command "$mirror$file" && return 0
		done
		return 1
		}
	
	
	if  [ -f "$file_to_download" ]
	then
		echo "$Nline$Red Download file:$Reset „$file_to_download”$Green exist$Reset"
		if ! [[ "no" == $(reply_ask "$Nline$Green Download again?$Orange Please answer:$Red {r}edownload or [N]o $Orange$Blink?-$Reset$Yellow n$MoveL" "r") ]]
		then Color=$Yellow dowload_message="Redownload" R="r"
		else Color=$Orange dowload_message="Skipped redownload" R="n"
		fi
		echo "$Back $R $Color$dowload_message"
	else
		Color=$Green dowload_message="Download"
	fi
	
	if [ ! "$dowload_message" == "Skipped redownload" ]
	then
		echo "$Nline$Color $dowload_message: "$mirrors_to_download" "$file_to_download"  > "$file_to_download" =$Reset$Nline"
		get_it "$mirrors_to_download" "$file_to_download"  > "$file_to_download"
			if ! [ $? = 0 ]
			then
			  if [[ "no" == $(reply_ask "$Red Error: $dowload_message $Green$file_to_download.$Orange Please answer:$Red {C}ontinue or [e]xit $Blink?-$Reset$Yellow c$MoveL" "e") ]]
			  then echo "$Nline ok continue$Reset";dowload_message="Error: $dowload_message" Color=$Red
			  else echo "$Back e$Nline$Orange ok, next time$Reset$Nline"; exit 1
			  fi
			else
			echo "$Green $dowload_message ok$Reset"
			fi
	fi
	MESSAGE+="$Nline$Color $(( mn+=1 )). $dowload_message $file_to_download to $install_folder folder $Reset$Nline"
	
	done
}

download_files ()
{
	
	mkdir -p "$driver_folder"
	if ! [ $? = 0 ]
	then
		echo "$Red Error: Cannot create folder $driver_folder, exit$Reset$Nline"
		exit 1
	fi
	cd $driver_folder
	
	downloda_it "$mirrors_1" "$files_names_1"
	
	
	cd $iso_folder

}

extract_from_iso() {

	mkdir -p "/mnt/$file_name_1"
	mount -o loop "$install_folder/$file_name_1" "/mnt/$file_name_1"
	cp -fr "/mnt/$file_name_1/"* "$install_folder/"
	if ! [ $? = 0 ]
	then
	  echo "$Nline $Red Error: Extract from iso, exit 1 $Reset$Nline"; exit 1
	else
	  MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_1 isolinux folder to $install_folder $Reset$Nline"
	fi
	umount "/mnt/$file_name_1"
	cd "/mnt/"
	rm -df "$file_name_1"
	cd "$install_folder"
}

extract_from_tar() {

	echo "$Nline$Green Extract from $memdisk_folder/$file_name_2 memdisk: $Reset$Nline"
	tar -xvf $memdisk_folder/$file_name_2 syslinux-6.03/bios/memdisk/memdisk
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from tar, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Extract memdisk from $file_name_2 $Reset$Nline"
	fi
	mv syslinux-6.03/bios/memdisk/memdisk $memdisk_folder/
	rm -fr syslinux-6.03
	
}

extract_from_zip () {

	echo "$Nline$Green Extract from $file_name_1: $Reset$Nline"
	unzip $file_name_1
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from $file_name_1, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_1 to $install_folder $Reset$Nline"
	fi

}

extract_from_gzip () {

	echo "$Nline$Green Change compression from gzip to zip of $file_name_1 for boot from Grub 2: $Reset$Nline"
	gzip -d $file_name_1
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from $file_name_1, exit 1 $Reset$Nline"; exit 1;fi
	
	# change compression to zip for pass Grub 2 bug?
	zip $file_name_1 boot.img
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: zip $file_name_1, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Change compression from gzip to zip of $file_name_1 in $install_folder $Reset$Nline"
	fi
	rm -f boot.img

}




umount_hdd_qcow2_image () {

	umount $mount_point_image
	qemu-nbd -d /dev/nbd0
	vgchange -an VolGroupName
	killall qemu-nbd

}

end_message() {

	
	cat <<-EOF > "$install_folder/run_$name_of_system.sh"
	#!/bin/sh
	# run qemu
	$qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_soundhw $qemu_usb -hda "$backing_img" -hdb /dev/sda -boot c
	EOF
	chmod 0775 "$install_folder/run_$name_of_system.sh"
	
	cat <<-EOF > "$install_folder/mount_$name_of_system.sh"
	#!/bin/sh
	# mount qemu hdd qcow2 imag
	EOF
	chmod 0775 "$install_folder/mount_$name_of_system.sh"

mount_hdd_qcow2_image ()
	{
	echo "$Nline$Green modprobe nbd max_part=16 $Reset$Nline"
	modprobe nbd max_part=16
	
	echo "$Nline$Green qemu-nbd -c /dev/nbd0 $hdd_qcow2_image $Reset$Nline"
	qemu-nbd -c /dev/nbd0 $hdd_qcow2_image
	
	echo "$Nline$Green partprobe /dev/nbd0 $Reset$Nline"
	partprobe /dev/nbd0
	
	echo "$Nline$Green mkdir -p $mount_point_image $Reset$Nline"
	mkdir -p $mount_point_image
	
	echo "$Nline$Green mount /dev/nbd0p1 $mount_point_image $Reset$Nline"
	mount /dev/nbd0p1 $mount_point_image
	
	}
	
	cat <<-EOF
		$Green
		Hi,
		You has successfully:
		$MESSAGE
		$Orange
		Exaple to run: $qemu_command $qemu_vga $qemu_memory $qemu_net $qemu_usb -hda "$backing_img" # -m - size of memory for quemu
		$Magenta
		If you had 2 operating systems installed on 2 different partitions (dual booting)
		you could use qemu to boot one of them inside the other,
		but you must never ever ever boot the same OS twice (unless it's a read-only OS like a live CD image for instance)
		
		https://wiki.gentoo.org/wiki/QEMU/Options
		http://wiki.qemu.org/Testing
		https://en.wikibooks.org/wiki/QEMU/Images
		$Reset$Nline
	EOF
}
##################
Begin

# The qemu-img convert command can do conversion between multiple formats, including raw, qcow2, VDI (VirtualBox), VMDK (VMWare) and VHD (Hyper-V). Table 7.1. qemu-img format strings

# **Image format**    **Argument to qemu-img**
# raw                     raw
# qcow2                   qcow2
# VDI (VirtualBox)        vdi
# VMDK (VMWare)           vmdk
# VHD (Hyper-V)           vpc


# qemu-img info test.vmdk
# qemu-img convert -O raw diskimage.qcow2 diskimage.raw

# mount
# modprobe nbd max_part=16
# qemu-nbd -c /dev/nbd0 *-qcow2.img
# partprobe /dev/nbd0
# mount /dev/nbd0p1 $mount_point_image

# umount $mount_point_image
# qemu-nbd -d /dev/nbd0
# vgchange -an VolGroupName
# killall qemu-nbd

# To use a VDI image from kvm without converting it, vdfuse may be used again.

# vdfuse -f test.vdi ~/some-dir
# kvm -hda ~/some-dir/EntireDisk ...
