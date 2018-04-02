 ###
echo " Read or edit it !"
echo " To edit multiple documents is good to use KATE’S TAB BAR PLUGINS"
echo " For global change in all themes is good to use kfilereplace"
echo " Tilde is a very nice text editor for the console/terminal"
exit

!!! ### ### ###

 Very important things:

If you overwrite your first system/data device you will also lose mbr
and the partition table! along with data on first partition
So the best solution is to be prepared for such situations and:

1. Create first partition, let say 15G and use it only for testing / playing.
In typical incidents of overwriting ( sda - sda1 ) you lose only data
in first 1-10G, but also MBR and partition table!

2. So create a usb stick or use second device with grub and fdisk or sfdisk
and write their information about partition table or make copy of mbr
and partition table using dd command. So after disaster mistake or strange
behavior of installers you will be able to go back almost immediately without
loss of your important data stored on above partitions areas..
( I lose it twice, trying install Grub 2 into partition /unstable/
or during manipulation in partitionmanager/fdisk - fix order -
porably it write GPT into old MBR place? = 0 or a lot of partitions )

Simplest - text info:

fdisk -l > disk_info.log
and use those informations to recreate the partition table..

Using dd on mbr:

<code>
sudo fdisk -l # =

</code>

 ### cat----------------------------------------------------------------

/dev/sda1            2048   30732344   30730297  14,7G 83 Linux
                     ^^^^
 ### cat----------------------------------------------------------------

and use start sector as count parameter to store area before first partition.
To store in file:

<code>
# to store MBR in file along with disk prtition table and "embedding area"
sudo dd if=/dev/sda of=sda_mbr_dpt_gap.img count=$^^^^

</code>

<code>
# to restore file to device
 sudo dd if=sda_mbr_dpt_gap.img of=/dev/sda

</code>

 ### Or ###

1. Create first possible smallest partition (boot) and store it along with mbr
2. Second for paly/testing
3. Rest partitions for use

sudo fdisk -l # =
 ### cat----------------------------------------------------------------
/dev/sda1 2048   30732344   30730297  14,7G 83 Linux # (this is big partition :)
          $^^^   $^^^^^^^
/dev/sda2 30732345   61464689   30732345  14,7G 83 Linux

 ### cat----------------------------------------------------------------

 and use it:
# to store mbr in file
sudo dd if=/dev/sda of=sda_mbr_dpt_gap.img count=$^^^
# to strore mbr and (boot) partition
sudo dd if=/dev/sda of=sda_mbr_dpt_gap_part.img count=$^^^^^^^

If you need more info about the partition structures
https://en.wikipedia.org/wiki/GUID_Partition_Table
https://en.wikipedia.org/wiki/Partition_type

4. Dividing a disk into partitions is an art in itself. :)
The home directory is intended for user data and most often it is mounted
from a different partition, so as not to mix the system files and user data
.. It seems convenient if we wanted to use different system distributions
and the same data for our user, but... So much theory , and in practice
in the home directory the operating system installs config files..
for environments. This data can affect the compatibility and hang of
programs.
The solution may be installing the home directory on the partition "/"
- "root" with distribution and only linking directories with clean data
for programs.

Tips.. ( today disks are big enough.. let play )
So in the case of old mbr. For systems, we will create all three basic
partitions ( the "primary" partitions, so we can run from them old
versions of windows / dos, which require it along with the boot flag
and the possibility of hiding them from other systems from this stable)
About 20GB or more each and then "extended" for other types partition.
The first partition on the extended partition is best used as a "swap"
partition - 2GB ( for hibernate process /kernel parameter - "resume=/dev/sda$X"/
better allocate more than amount of RAM ) and then allocate the rest of the
partitions to homes / data and linux distributions..
(I created 13 such partitions, and the last one is for large amount of data)

!!! ###  NOTE: ### ###
  The MBR - first sector of device - 512 bytes,
  but those 512 bytes seems to be divided into three different structures.
  So the MBR mean only first sector of any device (FSD), contains three
  different structures and copying them together to difrent drives
  or back all of it after repartiton can lead to ovewrite two or three
  different things.
  So in old style BIOS and prtition table:
  1. Bootstrap (MBR) 446 bytes #
  2. Partition table. 64 bytes #
  3. Signature. 2 bytes        #
  And after 512 bytes of first sector
  4. MBR gap, or "embedding area" and which is usually at least
     62*512 - 31 KiB (DOS compability) or 2048*512. Can hold stage "1.5 - 2"
     But in new style all rest of code boot loader is stored in "stage 2"
     hardcoded as blok list on filesytem belong to partition # FIXME
     // I used to have a non-professional calculator pretending to be a 32-bit
     machine, and called the Amiga and so far I can not go out of the way as
     the professionals can handle such a mess in stiff structures,
     to whimsically correct and avoid the end was not seen//
     https://www.gnu.org/software/grub/manual/legacy/grub.html#Embedded-data
 ---------------------
 ### Boot loaders

Grub

 Device naming has changed between GRUB Legacy, Grub4DOS and GRUB 2.
 Partitions are numbered from 1 instead of 0 while
 drives are still numbered from 0, and prefixed with partition-table type.
 For example, /dev/sda1 would be referred as (hd0,msdos1) (for MBR)
 or (hd0,gpt1) (for GPT).
 ( Grub start count disks from 0, partitions from 0)
 ( Grub 2 start count disks from 0, partitions from 1)

If you need more info:
https://www.gnu.org/software/grub/grub-documentation.html

---------------------
 Difference between GRUB for DOS and GNU GRUB

 First of all, GRUB for DOS has a flexible boot loader. Unlike GNU GRUB which
 relies on three stages of files to boot, GRUB for DOS uses a much better
 solution. The main function of GRUB is placed in a single file grldr, while
 the boot loader is placed in another file grldr.mbr, which can be installed to
 MBR or partition boot sector. At startup, boot code in grldr.mbr will
 dynamically scan the root directory of every local partition for grldr
 and load the first one found. Using this scheme, the location of boot file
 is no longer fixed, users can move it across partition boundary without
 causing booting problems.

 Secondly, GRUB for DOS can be loaded in multiple ways. GRUB for DOS runtime
 image comes in two forms. One is grldr, which can be loaded by MBR/partition
 boot sector and the Windows NT/2000/XP/2003/Vista boot manager.
 It can also act as the eltorito boot file for bootable CDROM.
 The other is grub.exe, which is a hybrid executable that can be launched
 from linux console and DOS prompt.

 Thirdly, GRUB for DOS extends the function of GNU GRUB.
 The most significant enhancement is the map command. In GRUB for DOS
 the map command can be used to create virtual harddisks and floppies
 from image files. These virtual devices can be accessed even after DOS starts.

 There are other useful features of GRUB for DOS which are not present in
 GNU GRUB, such as ATAPI CDROM driver, Chinese support, and so on.

 If you need more info:
 http://diddy.boot-land.net/grub4dos/Grub4dos.htm
 http://xpt.sourceforge.net/techdocs/nix/disk/boot/boot07-GrubForDosInfo/ar01s02.html
 https://sourceforge.net/projects/grub4dos/files/
  ---------------------
  mbrback - Linux Shell Script To Backup and Restore MBR
  change partition nr. 5 id for linux from script:
  sfdisk --change-id /dev/hdb 5 83
  store partition table in text format:
  sfdisk -d /dev/sda > sda-part-table-txt.sf

  MBR. 446 bytes - Old GRUB Legacy <1.98 - "Stage 1";  GRUB 2 >1.98 - "boot.img"
  The sole function of boot.img is to read the first sector of the core image
  32KB from a local disk and jump to it. Because of the size restriction
  boot.img cannot understand any file system structure
  so grub-setup ### hardcodes ### the location of the first sector
  of the core image ( old Stage 1.5 ) into boot.img
  when installing GRUB.

  ( - "MBR gap", or "embedding area" and which is usually at least 31 KiB)
  https://www.gnu.org/software/grub/manual/html_node/BIOS-installation.html
  Some systems can use sach embedding areas at start or end of volumes for
  its own prouposes..
  - hold back copy or conversions of MBR and paritions table for go back )
  ### !

  Copy boot code. 446 bytes to file:
  dd if=<device> of=MBR.img bs=446 count=1 conv=notrunc
  dd if=MBR.img of=<device> bs=446 count=1

  Copy Partition table. 64 bytes to file:
  dd if=<device> of=Partition_Table.img bs=1 skip=446 count=64 conv=notrunc
  dd if=Partition_Table.img of=<device> bs=1 seek=446 count=64

  Copy Signature. 2 bytes to file:
  dd if=<device> of=Signature.img bs=1 skip=500 count=2 conv=notrunc
  dd if=Signature.img of=<device> bs=1 seek=500 count=2
 ###  NOTE: ### ###
  iflag=skip_bytes
  oflag=seek_bytes
  bs=BYTES - per block used to count
  Do not truncate the output file. conv=notrunc
  Preserve blocks in the output file not explicitly written by this invocation
  of the dd utility. So you can replace some contents of file by another one
  or with combination of skip seek try re-read bloks with errors to file again,
  without repped all read operation again.
 ###------------------#

Tips for GRUB

1. If you create let say first or second partition enough to contain almost
any iso - 10G. Then you can write image into such partition by dd command and
try boot it by menu entry.
 ### NOTE ! Convert iso file into boot partition contest and
 then write it to hdd or usb boot partition (hybridization)
https://theartofmachinery.com/2016/04/21/partitioned_live_usb.html

Here’s an example:
<code>
isohybrid -partok downoladed_image.iso

</code>

The file is modified in place.

isohybrid MBR selection:
Option	MBR File	Comments
no options (default)	isohdpfx.bin	Boot from base device
--forcehd0	isohdpfx_f.bin	Boot from BIOS disk 0x80
--ctrlhd0	isohdpfx_c.bin	If the Ctrl key is held during boot time,
  then boot from BIOS disk 0x80
--partok	isohdppx.bin	Boot from a partition device
  (e.g. /dev/sdx1 rather than /dev/sdx)
--partok --forcehd0	isohdppx_f.bin Boot from a partition of BIOS disk 0x80
--partok --ctrlhd0	isohdppx_c.bin If the Ctrl key is held during boot time
then boot from BIOS disk 0x80 otherwise, boot from a partition device.

If you came here just wanting to know how to make a bootable USB drive
and don’t care about creating extra partitions then you can make things
much simpler. Just run isohybrid on a bootable ISO without the -partok
and write it directly to the whole drive.

ISO images that were prepared by "--partok" (i.e. with "isohdppx*.bin")
have to be write to a partition device (e.g. "/dev/sdb1" rather than "/dev/sdb")
Such an ISO partition may then be booted by chainloading or by a suitable MBR at
the start of the base disk device. Some reports indicate that
"isohybrid --partok" images can be chainloaded by GRUB but only
from primary MBR partitions. Logical MBR partitions and
GPT partitions are reported not to work in this combination.
 ###

Anyway:
If you write iso image in to volume and point out config files for loader,should
work if init procedure of booted system will try find source on all volumes,
not only on a own loadet diver for CD devices.
If your loader do not recognized iso format, extract boot files
to location with different file system and point out them in your boot config.
or instead of writing iso image to an volume, extract all it contents to volume
and then direct point out files.

But if init procedure take control, and reset system, load and check out only
its own drivers, all yours setups or virtual CD will no longer be accessible.
So in that case means only that you have to change/patch the original boot
procedure. Which in fact leads to the point that everything we need is a module
to read from iso kernel intial ramdisk and remaster boot menu for setup iso file
as source or write to the volume as an iso or extract files, which limits
the amount of our capacity by the number of available volumes destined for
this purpose.

For very easy example:
if you write antiX iso into volume and try boot as partition or
virtual CD, its bootloader starts and you will see boot menu..
Bat after run antiX and its init procedure take control all wiill be lost
and boot fails. Fortunately, until you add by hand to its kernel parameter
or remaster menu and add "from=hd" option
and if you will want boot from iso file "fromiso=${isofile}"
 ###
 The "map" process is implemented using INT 13 - any disk emulation will remain
 accessible from an OS that uses compatible mode disk access, e.g. DOS
 and Windows 9x. The emulation can not however, be accessed from an OS which
 uses protected mode drivers (Windows NT/2000/XP/Vista, Linux, FreeBSD)
 once the protected mode kernel file(s) take control.

 map command take real effect after boot command and before is only build
 sequence for mapping
 or map --hook (grub4dos)
 so till end or and boot or map --hook, files are still on old paths

 Grub4dos
 At the map command line, the notation (hdm,n)+1 is interpreted to
 represent the whole partition (hdm,n), not just the first sector of the
 partition. Virtual CD/DVD Drives. Grub4dos also check partitions content and
 trying build and correct partition table for simulations..

 Memory mapping uses the same command syntax as the direct mapping
 examples above, with the addition of the --mem switch
 and then it work as memdisk.
 So if you maap file for drive emulation with the addition of the --mem switch
 then file for emulation not must be in one cotiguous disk area.

  Virtual CD/DVD drives are numbered from (hd32) to (0xFF) -

  (hd32) - first virtual CD/DVD drive
  (hd33) - second virtual CD/DVD drive
  (hd34) - third virtual CD/DVD drive
  etc.
  (0xFF) - last virtual CD/DVD drive (try this if mapping as (hd32) doesnt work)
  (hd32) is a grub drive number equivalent to (0xA0).
  If a virtual drive is specified with a drive number greater than or equal
  to 0xA0, then it will be treated as a cdrom (i.e. - with 2048-byte sectors).
  CD/DVD Drives
  Physical/real CD/DVD drives are numbered from zero -
  (cd0) - first CD/DVD drive
  (cd1) - second CD/DVD drive
  etc.
 ###
 sbootmgr.dsk  This nifty little tool allows selecting various devices to boot
              from a menu, and even allows booting a CD-ROM in machines where
              the BIOS doesnt support it (or its supposed to support it, but
              it just doesnt work).  If you have trouble booting the
              Slackware CD-ROM, you might try writing this image to a floppy,
              booting it, and then selecting your CD-ROM drive as the boot
              device.

              The SBM installer is available as a Slackware package (called
              "btmgr") in the extra/ packages collection.

 you can also use sbootmgr.dsk, with memdisk.bin from syslinux
 to enable cdrom booting with grub:
 title cdrom
 kernel (hd0,0)/boot/grub/memdisk.bin
 initrd (hd0,0)/boot/grub/sbootmgr.dsk

  https://sourceforge.net/projects/btmgr/
 ###

# NOTE: You can copy then paste the code between <code> and </code> to terminal
and the text will be appended to the file > /boot/grub/menu.lst <

Example title entry for Old Grub:
<code>
su -c 'cat << EOF >> /boot/grub/menu.lst

title Boot /dev/sda1 (hd0,0)
        # root (hd0,1) # if second partition
        rootnoverify (hd0,0)
        chainloader +1
EOF
cat /boot/grub/menu.lst
'

</code>
 ###------------------#

Example menu entry for New Grub 2:
--class determine icon for menuentry from theme
<code>
su -c 'cat >> /etc/grub.d/40_custom << EOF

menuentry "Boot /dev/sda1 (hd0,1)" --class usb_boot {
        insmod part_msdos
        insmod ntfs
        # root (hd0,2) # if second partition
        set root=(hd0,1)
        chainloader +1
        }
EOF

if [ -e /boot/grub/grub.cfg ]
then :
	grub-mkconfig -o /boot/grub/grub.cfg
fi
if [ -e /boot/grub2/grub.cfg ]
then :
	grub2-mkconfig -o /boot/grub2/grub.cfg
fi

cat /etc/grub.d/40_custom
'

</code>

Example title entry for Grub4DOS: ( from Grub )

<code>

su -c 'cat << EOF >> /boot/grub/menu.lst

title Grub4dos boot sda2 as ISO partition
      # copy grub.exe to kernel boot path
      kernel /boot/grub/grub.exe --config-file="rootnoverify (hd0,1);\\
      map --heads=0 --sectors-per-track=0 (hd0,1)+1 (0xff);\\
      map --hook;chainloader (0xff) "
EOF
'

</code>

or

<code>

# NOTE: before change variable - path_to_iso="/path/file.iso"
su -c '
path_to_iso="/path/file.iso"
cat << EOF >> /boot/grub/menu.lst

title Grub4dos boot ISO file or to ram
      # copy grub.exe to kernel boot path
      kernel /boot/grub/grub.exe --config-file="find --set-root $path_to_iso;\\
      # if iso is not one cotiguous disk area then copy to ram;\\
      map --heads=0 --sectors-per-track=0 $path_to_iso (0xff)\\
      || map --mem --heads=0 --sectors-per-track=0 $path_to_iso (0xff);\\
      map --hook; root (0xff); chainloader (0xff) "
EOF
'

</code>

Example title entry for Grub4DOS: ( from Grub2 )

<code>
su -c 'cat << "EOF" >> /etc/grub.d/40_custom

menuentry "Boot /dev/sda2 (ISO)" --class usb_boot {
          # copy grub.exe to kernel boot path
          set opts='"'"'map --heads=0 --sectors-per-track=0 (hd0,1)+1 (0xff);
          map --hook;
          chainloader (0xff) '"'"'
          linux16 /boot/grub/grub.exe --config-file=$opts
          }
EOF

if [ -e /boot/grub/grub.cfg ]
then :
	grub-mkconfig -o /boot/grub/grub.cfg
fi
if [ -e /boot/grub2/grub.cfg ]
then :
	grub2-mkconfig -o /boot/grub2/grub.cfg
fi

cat /etc/grub.d/40_custom
'

</code>

Example boot grub4dos from lilo
(for lilo config "/etc/lilo.conf" add for grub /boot/grub/menu_grub4dos.lst )
<code>
su -c'
read -r -d "" FILECONTENT <<"ENDFILECONTENT"

# copy grub.exe to root of lilo boot path
image = /boot/grub/grub.exe
     label = Grub4dos
     append = "--config-file=configfile /boot/grub/menu_grub4dos.lst"
ENDFILECONTENT
echo "$FILECONTENT" >>/etc/lilo.conf

read -r -d "" FILECONTENT <<"ENDFILECONTENT"
title Grub4dos Boot /dev/sda2 (ISO)
      root (hd0,2)
      map --heads=0 --sectors-per-track=0 (hd0,1)+1 (0xff)
      map --hook
      chainloader (0xff)
ENDFILECONTENT
echo "$FILECONTENT" >>/boot/grub/menu_grub4dos.lst

lilo
'



 ###------------------#

2. Hard way. Another idea is mount iso in loop device
and then copy content into cleaned partition
so for example of proceed as root.. :
<code>
su
# some useful information - Label, you can use it for label device
fdisk -l $your_image.iso
blkid $your_image.iso

# cleaning and prepare partition for iso content
mkfs.ext4 -L "$LABEL" /dev/<dev><x>

# create folder for mount prepared device and mount formated device
cd /mnt
mkdir -p /mnt/copy_$your_image
mount /dev/<dev><x> /mnt/copy_$your_image
# create folder for mount iso and mount your image
mkdir -p /mnt/$your_image
mount $your_image.iso /mnt/$your_image
# and extract files
cp -r "/mnt/$your_image/"* /mnt/copy_$your_image/
# delete no more needed folder
umount /mnt/$your_image/
rm -f $your_image

</code>
 ###------------------#
# Extract a squashfs:
# mkdir -p /mnt/copy_$your_image
# mkdir -p /mnt/$your_image
# sudo mount -t squashfs ${file.squashfs} /mnt/$your_image
# sudo cp -av /mnt/$your_image/. /mnt/copy_$your_image
# sudo umount /mnt/$your_image
# rm -f $your_image

 Now look on content of /mnt/copy_$your_image and try figure out some config
 things like -  /boot/grub/menu.lst /boot/grub<x>/menu.cfg /isolinux/*cfg
 Make necessary changes.., install loader...
 And then for example:

Old Grub:
<code>
su -c 'cat  >> /boot/grub/menu.lst << EOF

title boot menu.lst dev/sda1 (hd0,0)
# corresponding to     sd<x> (hdx,x) which you used for hold extracted files
        root (hd0,0)
        configfile /boot/grub/menu.lst

EOF

cat /boot/grub/menu.lst
'

</code>
 ###------------------#

New Grub 2:
<code>
su -c 'cat >> /etc/grub.d/40_custom << EOF

menuentry "Boot grub.cfg /dev/sda1 (hd0,1)" --class usb_boot {
# corresponding to sd<x> (hdx,x) which you used for hold extracted files
       insmod part_msdos
       insmod ntfs
       set root=(hd0,1)
       configfile /boot/grub/grub.cfg
       }
EOF

if [ -e /boot/grub/grub.cfg ]
then :
	grub-mkconfig -o /boot/grub/grub.cfg
fi
if [ -e /boot/grub2/grub.cfg ]
then :
	grub2-mkconfig -o /boot/grub2/grub.cfg
fi
cat /etc/grub.d/40_custom
'

</code>
 ### ### ###

 Second hard drive usually is the USB drive if you have only one internal drive
 If you have two or more internal hard drives, USB is sdc and might be sdd
 https://help.ubuntu.com/community/BootFromUSB
 ( Old Grub start count disks from 0, partitions from 0)
 ( New Grub start count disks from 0, partitions from 1)
 and prefixed with partition-table type. For example:
 /dev/sda1 would be referred as (hd0,msdos1) (for MBR) or (hd0,gpt1) (for GPT).

 Booting usb stick from grub menu (<device_name>,<partition_index>)
 Old Grub - You can add to your /boot/grub/menu.lst for boot stik from grub menu
 Examples :
 ###
<code>
su -c 'cat << EOF >> /boot/grub/menu.lst

title Boot USB Stik on /dev/sdb - hd1
        rootnoverify (hd1) # referred to device or partition which you boot
        #rootnoverify (hd1,0)
        chainloader +1
EOF
'

</code>
 ###

<code>
su -c 'cat << EOF >> /boot/grub/menu.lst

title Boot Record on sda11 - hd0,10
        root (hd0,10)
        chainloader +1
EOF
'

</code>
 ###
<code>
su -c 'cat <<EOF >> /boot/grub/menu.lst

title menu.lst on sda3 - hd0,2
        root (hd0,2)
        configfile /boot/grub/menu.lst
        chainloader +1
EOF
'

</code>
 ###
<code>
su -c 'cat >> /boot/grub/menu.lst << EOF

title Run from USB DISK
        root (cd)
        kernel /boot/vmlinuz file=/cdrom/preseed/ubuntu.seed boot=casper\
        noprompt cdrom-detect/try-usb=true persistent
        initrd /boot/initrd.gz
        boot
EOF
'

</code>
 ###
 Sample menu.lst config for boot tree different kinds of MS systems
 from primary patritions on sda
<code>
su -c 'cat >> /boot/grub/menu.lst << EOF

title Windows Ultimate 7 ( sda1 )
    rootnoverify (hd0,0)
    unhide (hd0,0)
    hide (hd0,1)
    hide (hd0,2)
    makeactive
    chainloader +1

title Windows XP ( sda2 )
    rootnoverify (hd0,1)
    unhide (hd0,1)
    hide (hd0,0)
    hide (hd0,2)
    makeactive
    chainloader +1

title DOS ( sda3 )
    rootnoverify (hd0,2)
    unhide (hd0,2)
    hide (hd0,1)
    hide (hd0,2)
    makeactive
    chainloader +1
EOF
'

</code>
 ###
If you hide extended partition then it content disappear, but unhide will return
it to previous state.
 ###
 swapping. BOOT FROM SECOND DISK
<code>
su -c 'cat >> /boot/grub/menu.lst <<EOF

title BOOT FROM SECOND DISK

        ### Different kinds of entries for disk/partitions
        #rootnoverify (hd0)
        rootnoverify (hd1)
        #rootnoverify (hd1,0)
        #rootnoverify (hd1,1)
        #configfile (hd1,1)/boot/grub/menu_second.lst

        ### Perform a virtual swap between hard disks
        ### - map (hd1) (hd0) map (hd0) (hd1)
        ### Some operating systems, such as DOS/Windows
        ### can only start from the first hard disk.
        ### If you have such an operating system installed
        ### on a different hard disk, you can implement a logical change
        ### for the respective menu entry.
        ### However, this only works if the operating system accesses
        ### the hard disks by way of the BIOS when booting.
        ### For Grub/Linux better create new title/config
        ### file - ((hd1,1)/boot/grub/menu_second.lst
        ### and change sequences of hd0 on hd1
        ### and root=sda\$x/sdb\$x on root=LABEL=\$xxx
        ### and /etc/fstab with LABEL mount points)

        ### map command take real effect after boot command
        ### or map --hook (grub4dos)
        ### so till end and boot, files are still on old paths
        map (hd1) (hd0)
        map (hd0) (hd1)

        ### hides / unhides a DOS/Windows partition
        #unhide (hd1,0)
        #hide   (hd0,0)

        ### Set the active flag in the partition for DOS/windows
        #makeactive

        ### +1 indicates that GRUB should read one sector
        ### from the start of the partition.
        chainloader +1
        #chainloader (hd1)+1
        #chainloader (hd1,0)+1
        ### boot the OS or chain-loader which has been loaded.
        ### Only necessary if running the fully interactive command-line
        ### (it is implicit at the end of a menu entry)
        #boot

EOF
'

</code>
 ###

 If you need more info:
 https://wiki.archlinux.org/index.php/GRUB_Legacy
 https://www.novell.com/documentation/suse91/suselinux-adminguide/html/ch07s04.html

 ###
# Grub on sda MBR
title Grub2 in sda MBR
    rootnoverify (hd0)
    chainloader +1

# Grub on sdb MBR

title Legacy Grub in sdb MBR
    rootnoverify (hd1)
    chainloader +1

# hides / ( unhides a DOS (or Windows) partition
        unhide (hd0,0)
        hide   (hd0,1)
 ###
Swapping.
 To perform a virtual swap between hard disks
 ( by way of the BIOS when booting.)
 and active then boot from first partition on second disk.
 Like this:
<code>
su -c 'cat >> /boot/grub/menu.lst <<EOF
title Swap (hd1) (hd0) Boot (hd1,0)
    map (hd1) (hd0)
    map (hd0) (hd1)
    rootnoverify (hd1,0) # referred to device or partition which you boot
    makeactive
    chainloader +1
EOF
'

</code>

 New Grub 2 - You can add to your /etc/grub.d/40_custom
 for boot stik from grub menu
<code>
su -c 'cat >> /etc/grub.d/40_custom <<EOF

menuentry "Boot USB Stik (on /dev/sdb)" --class usb_boot {
        insmod part_msdos
        insmod ntfs
        set root="hd1"  # referred to device or partition which you boot
        #root=(hd1,1)
        chainloader +1
}
EOF

if [ -e /boot/grub/grub.cfg ]; then grub-mkconfig -o /boot/grub/grub.cfg; fi
if [ -e /boot/grub2/grub.cfg ]; then grub2-mkconfig -o /boot/grub2/grub.cfg; fi
'

</code>
  ###------------------#
 New Grub 2
 This performs a virtual swap between your first and second hard drive:

 drivemap -s (hd0) (hd1)

 hides / unhides a DOS (or Windows) partition:

 parttool (hd0,1) hidden-
 parttool (hd0,2) hidden+

 Set root volume and make it active then boot:

 set root=(hd0,1)
 parttool ${root} boot+
 chainloader +1

 ###------------------#
<code>
su -c 'read -r -d "" FILECONTENT <<"ENDFILECONTENT"
menuentry "BOOT FROM SECOND DISK" --class hdd_boot {
        insmod part_msdos
        insmod ntfs
        ### swap the hard disks by way of the BIOS when booting.
        drivemap -s (hd0) (hd1)
        #parttool (hd0,1) hidden-
        #parttool (hd0,2) hidden+

        set root=(hd0)
        #root=(hd0,1)
        #parttool ${root} boot+
        chainloader +1
ENDFILECONTENT

echo "\$FILECONTENT" >> /etc/grub.d/40_custom

if [ -e /boot/grub/grub.cfg ]; then grub-mkconfig -o /boot/grub/grub.cfg; fi
if [ -e /boot/grub2/grub.cfg ]; then grub2-mkconfig -o /boot/grub2/grub.cfg; fi
'

</code>

Example Grub 2 menu entry for boot msdos on /dev/sda3:
<code>
su -c 'cat >> /etc/grub.d/40_custom << EOF
#
# Grub 2 start count partitions from 1 not from 0
# --class determine icon for menuentry from theme

menuentry "MS DOS (on /dev/sda3)" --class windows {
       insmod part_msdos
       insmod ntfs
       set root="hd0,msdos3"
       chainloader +1

       ## Performs a "virtual" swap between your first and second hard drive
       # drivemap -s (hd0) (hd1)
       ## This performs unset hiden flag for partiton
       # parttool (hd0,1) hidden-
       ## This performs set hiden flag for partiton
       # parttool (hd0,2) hidden+
       ## This performs set boot flag for partiton and clear otcher
       # parttool \${root} boot+
       ## boot
       # chainloader +1
       #boot
       }
EOF
cat /etc/grub.d/40_custom

if [ -e /boot/grub/grub.cfg ]; then grub-mkconfig -o /boot/grub/grub.cfg; fi
if [ -e /boot/grub2/grub.cfg ]; then grub2-mkconfig -o /boot/grub2/grub.cfg; fi
'

</code>

 ### --- ###
 Kernel parameters to boot iso from hdd
  This list is not comprehensive.

fromiso=${isofile} from=hd 										# AntiX Parsix
fromiso=$dev_name${isofile}										# Debian ...
fromiso=$dev_name${isofile} boot=live									# Elive 2..
fromiso=${isofile} boot=eli										# Elive
findiso=${isofile}											# BunsenLabs
findiso=${isofile}											# Debian SparkyLinux SolydXK Tails Kali Linux

findiso=${isofile} boot=live config union=overlay noswap noprompt toram=filesystem.squashfs		# GParted live
				                        # copy filesystem.squashfs unlock device
				                        # toram - copy all
bootfrom=$dev_name live-media-path=/$(extractet live) boot=live config union=overlay noswap noprompt ip=frommedia toram=filesystem.squashfs

img_dev=$dev_uuid img_loop=${isofile} misolabel=MJRO1610 misobasedir=manjaro				# Arch Manjaro ...
img_dev=$dev_name img_loop=${isofile} archisolabel=ANTERGOS archisobasedir=arch				# Antergos
* kdeosisobasedir=kdeos kdeosisolabel=KAOS_20170103							# KaOS
img_loop=${isofile} img_dev=$dev_name archisobasedir=arch archisolabel=LinHES_201702			# LinHES

root=$install_folder/system.sfs root=/dev/ram0 androidboot.hardware=android_x86 SRC=$install_folder	# Android

iso-scan/filename=${isofile} file=/preseed/linuxmint.seed boot=casper 					# Mint ...
iso-scan/filename=${isofile} file=/cdrom/preseed/ubuntu.seed boot=casper 				# Zorin
iso-scan/filename=${isofile} file=/cdrom/preseed/ubuntu.seed boot=casper 				# Ubuntu
iso-scan/filename=${isofile} file=/cdrom/preseed/custom.seed boot=casper				# SharkLinux


install_specs=UUID=$uuid:$dev_type:$install_folder							# Xerus
# but you need the "Q_ID" file on your install folder. The content of the "Q_ID" is "201604210401".
# http://www.murga-linux.com/puppy/viewtopic.php?p=906796&sid=2e7bb0c185266151a9b202fe96fdec00

2) Create dir on hdd 'mkdir $distro_dir'
3) mount iso (in puppy click on xerus.iso or use filemnt)
4) copy from iso mount dir initrd.q and vmlinuz
5) in term do:
echo '"201604210401" ' > $distro_dir/Q_ID

iso-scan/filename=${isofile} root=live:CDLABEL=CentOS-7-x86_64-LiveKDE-1611  				# CentOS
iso-scan/filename=${isofile} root=live:CDLABEL=korora-live-kde-25-x86_64				# Korora
iso-scan/filename=${isofile} root=live:CDLABEL=Fedora-WS-Live-25-1-3 3					# Fedora
iso-scan/filename=${isofile} root=live:CDLABEL=SL-73-x86_64-LiveDVDkde					# Scientific
iso-scan/filename=${isofile} root=live:CDLABEL=VOID_LIVE	rd.live.ram				# VOID
iso-scan/filename=${isofile} root=live:CDLABEL=SolusLiveMATE 						# Solus

iso-scan/filename=${isofile} root=live:UUID=2016-12-21-18-39-47-00 					# OpenMandriva
livepath=${isofile} 											# Mageia ???
root=mgalive:LABEL=Mageia-5.1-KDE4-LiveDVD								# Mageia - write iso to an volume and add boot configs lines to yours
iso-scan/filename=${isofile} root=live:CDLABEL=ROSA.FRESH.KDE.R8.i586					# ROSA
iso-scan/filename=${isofile} root=live:LABEL=CLD-20161229 						# Calculate Linux

automatic=method:disk,disk:<hdb>,partition:<hdbX>,directory:<путь_к_каталогу_с_дистрибутивом>		# ALT Linux
automatic=method:disk,uuid:$uuid,directory:${isofile}							# ALT Linux

isoboot=${isofile} looptype=squashfs loop=/livecd.squashfs init=/linuxrc cdroot 			# Sabyon
isoboot=${isofile} looptype=squashfs loop=/image.squashfs init=/linuxrc cdroot				# Gentoo
iso-scan/filename=${isofile}										# Porteus Kiosk
isoloop=$isofile											# System Rescuecd

bootfromiso=${isofile} boot=live 									# PcLinyxOS
bootfrom=$dev_name${isofile}										# KNOPPIX

isofrom_device=/dev/disk/by-uuid/$uuid isofrom_system=${isofile}					# openSuse
install=hd:$isofile
													# slackware based from= - (dir - from=/slax/) (iso from=file.iso)
from=$distro_dir/slax/											# slax from - (dir - from=/slax/)
from=${isofile} 											# NimbleX-2008
from=${isofile} changes=$distro_dir									# porteus - dir with sgn file (porteus-v3.2-i586.sgn)
livemedia=$dev_name:${isofile}										# Wifislax
will search for folder with extracted files from iso 							# puppy-slack
fromiso=${isofile}											# zenwalk
linux16 memdisk bigraw iso initrd16 ${isofile}								# 4MLinux RancherOS

copy from /$iso/cde to /cde 										# Tiny Core
copy from /$iso/all to /$distro_dir psubdir=$distro_dir							# AnitaOS

* if iso-scan/filename=${isofile},,, do not work
  copy all from an /iso/* to an volume "/" and label it like iso label...
  or write to an volume as isohybrid

* If installation fails from iso placed on same device and you have
  enough memory, try add kernel parameter "toram" before "--"
  toram  Copy the whole CD/medium to RAM and run from there
  or toram=filename.squashfs

* Booting from maped .ISO Images
  It is possible to map and boot from some CD/DVD images using Grub4dos
  however it should be noted that this feature is experimental. Remember -
  "The "map" process is implemented using INT 13 - any disk emulation will 
  remain accessible from an OS that uses compatible mode disk access
  e.g. DOS and Windows 9x. The emulation can't however, be accessed from
  an OS which uses protected mode drivers
  (Windows NT/2000/XP/Vista, Linux, FreeBSD) once the protected mode
  kernel file(s) take control."

  This means that there is no way (at present) to install Windows using
  Grub4dos ISO emulation. Also, it is not possible to boot a Windows
  PE (Preinstallation Environment) boot disc image, unless the image is RAM disk
  based. RAM disk based discs include Windows PE 2/2.1 and builds that utilise
  ramdisk.sys and setupldr.bin files from
  windows 2003 server SP1 source (see here and here).

  The majority of Linux based CD images will also fail to work with Grub4dos ISO
  emulation. Linux distributions require kernel and initrd files to be specified
  as soon as these files are loaded the protected mode kernel driver(s)
  take control and the virtual CD will no longer be accessible. If any other
  files are required from the CD/DVD they will be missing
  resulting in boot error(s).

  Linux distributions that only require kernel and initrd files function fully
  via iso emulation, as no other data needs accessing from the virtual CD/DVD
  drive once they have been loaded - INT 13 access works until these files are
  loaded and is then not required.
  Some CD/DVD-ROM (ISO9660) images (see exceptions above) can be mapped as
  the device (hd32), and booted using the following commands
  (replace (device)/path/file.iso with the relevant path/filename) -

 ### --- ###
This list is not comprehensive.
For a complete list of all options, please see the kernel documentation.

http://git.grml.org/?p=grml-live.git;a=blob_plain;f=templates/GRML/grml-cheatcodes.txt;hb=HEAD

parameter		Description
root=			Root filesystem.
rootflags=		Root filesystem mount options.
ro			Mount root device read-only on boot (default1).
rw			Mount root device read-write on boot.
initrd=			Specify the location of the initial ramdisk.
init=			Run specified binary instead of /sbin/init
(symlinked to systemd in Arch) as init process.
init=/bin/sh		Boot to shell.
systemd.unit=		Boot to a specified target.
resume=			Specify a swap device to use when waking from hibernation.
nomodeset		Disable Kernel mode setting.
zswap.enabled		Enable Zswap.
video=<videosetting>	Override framebuffer video defaults.
	
	More help here:
	http://kernel.org/doc/Documentation/kernel-parameters.txt
	https://craftedflash.com/info/live-distro-boot-parameters
#####

 !!! ### ### ### FIXME
 Be absolutely certain that you know the correct drive name <dev> (ex: /dev/sdb)
 data on the device will be erased !!!

 To write image to device
 Make sure the card is inserted but not mounted.

 Execute this in a terminal, in example change <x> on the SD-card/stick:

dd if=$file_name.img of=/dev/sd<x> bs=4M

 Example if image is copresed:
gunzip --stdout $file_name.img.gz | dd of=/dev/sd<x> bs=4M
 and
sync

 Examle: one line for progress and sync along with pv command and dd
pv -tpreb SL-72-x86_64-2016-02-03-LiveDVDkde.iso | dd of=/dev/sd<x>\
bs=4096 conv=notrunc,noerror && sync && sleep 25 && echo 'Done'

comment ()
{
function vdd { sudo sh -c "pv -tpreb $1 | dd of=$2\
bs=4096 conv=notrunc,noerror && sync && echo 'Wait a while..'\
&& sleep 25 && echo 'Done'"; }
vdd $file_name.img /dev/sd<x>
}

 !!! ### ### ### FIXME
 Be absolutely certain that you know the correct drive name <dev> (ex: /dev/sdb)
 data on the device will be erased !!!

 to erased with dd mbr and partition table !!!
 dd if=/dev/zero of=/dev/<dev>  bs=4k count=10
 # zdecydowanie zalecane jest wyczyścić urządzenie poleceniem wipefs(8)

 to create/delete partition/partition table ( do not forget about set boot flag)
 #  device="/dev/<dev>" type="" # fdisk -l
 list known partition types

types=$(echo -e 'l\n'|fdisk /dev/zero)
echo "${types}"

comment=
<<EOF
ls
 0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris        
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden C:  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx         
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data    
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility   
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi eb  BeOS fs        
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT            
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC b
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f1  SpeedStor      
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f4  SpeedStor      
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f2  DOS secondary  
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      fb  VMware VMFS    
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE 
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fd  Linux raid auto
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fe  LANstep        
1c  Hidden W95 FAT3 75  PC/IX           be  Solaris boot    ff  BBT            
1e  Hidden W95 FAT1 80  Old Minix
ls
EOF

Print_volumes_list ()
{
  echo "$Nline$Green Volumes list:$Reset"
  blkid
  echo "$LCyan Tip - You can use mouse to highlight names and then use copy paste in konsole for give answers$Reset"
}
 ### FIXME device="/dev/<dev>"
 Be absolutely certain that you know the correct drive name <dev> (ex: /dev/sdb)
device="/dev/<dev>"
Linux='83'
FAT32='0c'
 # fdisk /dev/<dev>
 !!! trick to create one big linux paritin on <dev> in one line
echo -e "o\nn\np\n1\n\n\nt\n${Linux}\na\np\nw\nq\n"|fdisk ${device}
 !!! trick to create one big fat32 paritin on <dev> in one line
echo -e "o\nn\np\n1\n\n\nt\n${FAT32}\na\np\nw\nq\n"|fdisk ${device}

 to set boot flag on paritin 1
echo -e  "a\n w\n"|fdisk ${device}

 ### --- ###
 Format the writable partitions
 You can use any file system you fancy here 
 (although some systems might complain if the partition type doesn’t match).
 A basic FAT32 file system has broad support across operating systems
 and devices, but doesn’t have *nix features like owners and permissions, links.
 (easy  access to read/write by everybody)
 ext4 is the most popular file system on GNU/Linux systems today
 and it’s suitable for my rescue USB drive. If you want, you can tinker with
 the various options in man mkfs.ext4 and do things like, say,
 disabling journalling, but realistically
 the out-of-the-box settings work fine for this job.

 To make file system on partition $partition
 - (it can be ext2, ext3, or ext4. You can use ext2 on flash drives because
 the lack of journaling means less wear and tear on the drive .
 warning: File system `ext2' doesn't support embedding.)

# FIXME device="/dev/<dev>"  partition="x"
volume_label="LIVE_USB"
device="/dev/<dev>" partition="x"

 To make ext4 file system on partition $partition

mkfs.ext4 -q -m 0 -O ^has_journal -L ${volume_label} -N 400 ${device}${partition}

 To format the partition as fat32

mkfs.vfat -F 32 -n ${volume_label} ${device}${partition}
 ### --- ###

 ### FIXME
<code>

Get_disk_list () {
echo "Possibilities:"
fdisk -l 2>&1|grep -e ":"|grep -e "/dev/"
}

Ask_for_prepare () {
local device="/dev/<dev>" Linux='83' FAT32='0c' os_id_type=${Linux}

Run_fdisk  () {
local os_id_type=${!os_id_type}
fdisk $device <<List_of_Commands
o
n
p
1


t
$os_id_type
a
p

w
q
List_of_Commands
}
read -e -p "Give full Disk name to: Erase and Create new partition table! ?: " device
read -e -p "Give partition os id type.  Possibilities: Linux or FAT32 ?: " os_id_type
read -p "Last chance to abort - are you sure to you want to Erase ${device} [y/N]?: " check
check=$(tr '[:upper:]' '[:lower:]' <<<"$check")
if [[ "$check" =~ ^y(es)?$ ]]
then :
	Run_fdisk
else :
	echo "Aborting."
fi
}
Get_disk_list
Ask_for_prepare
# Ask_for_filesystem

</code>

 Example if you want store iso files on separate ext4 partition
 and have access for everybody: /etc/fstab

# <device>             <dir>         <type>    <options>          <dump> <fsck>
<code>

su -c 'cat >> /etc/fstab <<-EOF
# change /dev/<dev><x> for your device and then write it to fstab
# or by - LABEL=\$Your_Label_of_device
/dev/<dev><x> /ISO ext4 rw,suid,dev,auto,user,exec,async,nofail 0 0
EOF
'

</code>

 ### NOTE: If you intend to use the exec flag with automount, you should remove
 the user flag for it to work properly
 Also, make sure you place the exec option after the user option, or the system
 will still mount your drive as noexec.

 ###
For full access for everybody to any created files
cd "$folder_x"
	find . -type f -exec chmod 666 -- {} +
	find . -type d -exec chmod 777 -- {} +
 ###

 There is a slightly better solution: change the group
 of /media/disk to storage, change permissions to 775
 and add users that need to be able to write to disk
 to the storage group
 (you need to log out and log in that users before changes are visible).
 So, as root:

chgrp storage /media/disk # or ; /media  ; /run/media/$user
chmod 775 /media/disk
passwd -a user_name storage
 This way everyone will be able to read the disk, but still only root
 and users in storage group will be able to write to it.

 ###
 If you want everyone to be able to, read/write.
 The right way to do it is this:

sudo mkfs.ext4 /dev/${device}${partition}
sudo mkdir /media/data
sudo mount /dev/${device}${partition} /media/data
sudo chown -R :users /media/data
sudo chmod -R g+rw /media/data

If you need more info about the fstab
https://wiki.archlinux.org/index.php/fstab
###

:<<'COMMENTEOF'
https://unix.stackexchange.com/questions/32008/mount-an-image-file-without-root-permission
 ###--[ udisksctl utility ]---------------#

## The utility for udisks2 is called udisksctl. It uses /run/media/$USERNAME/<label>
udisksctl mount -b /dev/sda1

## Mounted /dev/sdc1 at /run/media/t-8ch/<label>.
udisksctl unmount -b /dev/sda1

## You might need to run
udisksctl loop-setup -r -f $PATH_TO_IMAGE
udisksctl mount -b /dev/loop0p1

## You can look at files on the disk
ls -l /media/$USER/$IMAGE_NAME/

## You can unmount it when you're done
udisksctl unmount -b /dev/loop0p1

 ###--[ udisks utility ]---------------#
## Mounted /org/freedesktop/UDisks/devices/sdc1 at /media/<label>
udisks --unmount /dev/sda1

 ###--[ Mount net fs and resources utility ]----------------#
## install smbnetfs bindfs
mkdir -p ~/win ~/winsrc
smbnetfs ~/win
bindfs ~/win/BRANDON-PC/project/src ~/winsrc
cd ~/winsrc

 ###--[ guestmount utility ]----------------#
mkdir dvd
guestmount -a image.iso -r -i dvd 
## df will show image.iso mounted
df
## to umount we have :
 guestunmount dvd

 ###------------------#
Here are two very short (5 lines + comments) Bash scripts that will do the job:

for mounting

#!/bin/sh
# usage: usmount device dir
# author: babou 2013/05/17 on https://unix.stackexchange.com/questions/32008/mount-an-loop-file-without-root-permission/76002#76002
# Allows normal user to mount device $1 on mount point $2
# Use /etc/fstab entry :
#       /tmp/UFS/drive /tmp/UFS/mountpoint  auto users,noauto 0 0
# and directory /tmp/UFS/
# Both have to be created (as superuser for the /etc/fstab entry)
rm -f /tmp/UFS/drive /tmp/UFS/mountpoint
ln -s `realpath -s $1` /tmp/UFS/drive
ln -s `realpath -s $2` /tmp/UFS/mountpoint
mount /tmp/UFS/drive || mount /tmp/UFS/mountpoint
# The last statement should be a bit more subtle
# Trying both is generally not useful.
and for dismounting

#!/bin/sh
# usage: usumount device dir
# author: babou 2013/05/17 on https://unix.stackexchange.com/questions/32008/mount-an-loop-file-without-root-permission/76002#76002
# Allows normal user to umount device $1 from mount point $2
# Use /etc/fstab entry :
#       /tmp/UFS/drive /tmp/UFS/mountpoint  auto users,noauto 0 0
# and directory /tmp/UFS/
# Both have to be created (as superuser for the /etc/fstab entry)
rm -f /tmp/UFS/drive /tmp/UFS/mountpoint
ln -s `realpath -s $1` /tmp/UFS/drive
ln -s `realpath -s $2` /tmp/UFS/mountpoint
umount /tmp/UFS/drive || umount /tmp/UFS/mountpoint
# One of the two umounts may fail because it is ambiguous
# Actually both could fail, with careless mounting organization :-)
The directory /tmp/UFS/ is created to isolate the links and avoid clashes. But the symlinks can be anywhere in user space, as long as they stay in the same place (same path). The /etc/fstab entry never changes either.
###------------------#
COMMENTEOF

install old grub (1)
https://www.gnu.org/software/grub/manual/legacy/grub.html
http://wiki.osdev.org/El-Torito
http://www.rodsbooks.com/efi-bootloaders/grub_legacy.html

:<<'COMMENTEOF'
"install /boot/grub/stage1 (hd1) (hd1)1+26 p (hd1,0)/boot/grub/stage2
/boot/grub/menu.lst"
The official version of GRUB Legacy doesnt support EFI booting; however,
through version 17, Fedora used a greatly modified version that includes
EFI support. This page therefore describes this variant of GRUB Legacy
Installing GRUB Legacy

GRUB Legacy installation works just as described in EFI Boot Loader 
Installation.
If you're using a Fedora 17 or earlier system, GRUB Legacy should have been
automatically installed for you, so you might not need to do anything else.
(Fedora 18 has switched to GRUB 2 for EFI-mode booting.)
If you're not using a Fedora system, here are links to some relevant package
files from Fedora 17:

grub-0.97-93.fc17.src.rpm
—The source code RPM for Fedora 17's patched version of GRUB Legacy.
grub-efi-0.97-93.fc17.x86_64.rpm
—The x86-64 binary RPM for Fedora 17's patched EFI version of GRUB Legacy.
(Usable on x86-64 UEFI systems and modern Macintoshes.)
grub-efi-0.97-93.fc17.i686.rpm
—The x86 binary RPM for Fedora 17's patched EFI version of GRUB Legacy.
(Usable on early Intel-based Macs with EFI firmware.)
grub-efi-0.97-93.fc17.x86_64.tgz
—An x86-64 binary tarball containing Fedora's patched version of GRUB Legacy.
I created this tarball by passing the binary RPM through Debian's alien program,
so it contains all the same files as Fedora's original RPM, but you can unpack
it and install it on any x86-64 system. When unpacked, this tarball creates
boot and sbin subdirectories under the current directory, so I recommend you
unpack it in a "scratch" directory.
grub-efi-0.97-93.fc17.i686.tgz
—An x86 binary tarball containing Fedora's patched version of GRUB Legacy.
This should work like the x86-64 tarball, but on older Intel-based
Macs with 32-bit EFIs.
Fedora 17's grub package installs only the EFI version of GRUB Legacy.
This package places the grub.efi file in the /boot/efi/EFI/redhat directory.
Thus, if you installed this package with the ESP unmounted, you should copy
this file out before you mount the ESP at /boot/efi,
then copy it back to its proper location.

GRUB Legacy normally installs a grub.efi file to the ESP and reads its
configuration file, grub.conf, from the same directory as the grub.efi file.
(The configuration file's name should be the same as the boot loader's filename
but with a .conf extension, so if you rename the boot loader, you should rename
its configuration file, too.) GRUB Legacy reads the Linux kernel, the initial
RAM disk, and other support files from Linux's /boot directory.
This directory must be on a filesystem that GRUB Legacy supports, such as 
ext2fs, ext3fs, ext4fs, ReiserFS, XFS, JFS, Btrfs, or FAT.
If your computer uses a Linux RAID or Logical Volume Manager (LVM) setup, you
must place the /boot directory on a regular partition outside of the RAID
or LVM setup.

http://www.rodsbooks.com/efi-bootloaders/grub_legacy.html
"
COMMENTEOF



<code>
su
grub --device-map=/boot/grub/device.map --batch <<EOF
root (hd1,0)
setup --stage2=/boot/grub/stage2 (hd1,0)
quit
EOF

</code>

 ###
 Grub 2 memdisk small iso to fit in memory - /etc/grub.d/40_custom
<code>
su
cat <<EOF >> "/etc/grub.d/40_custom"
menuentry '\$file_name_1 memdisk' --class dvd_boot {
        search --file --no-floppy --set=root \$install_folder/\$file_name_1
        linux16  \$grub_root_dev\$memdisk_folder/memdisk bigraw iso
        initrd16 \$grub_root_dev\$install_folder/\$file_name_1
}
EOF

command1=$(whereis -b grub-mkconfig|awk '{print $2}')
command2=$(whereis -b grub2-mkconfig|awk '{print $2}')
if [[ -f $command1 ]]; then $command1 -o /boot/grub/grub.cfg	# update-grub
elif [[ -f $command2 ]]; then $command2 -o /boot/grub2/grub.cfg	# update-grub2
else echo "no grub-mkconfig command"
fi

</code>

 If the image is a so-called ISOHYBRID image
 you can also treat it as a hard disk image.
 This is possible because such an image also contains a Master Boot Record (MBR)
 ###

 LABEL memdisk_PM
 MENU LABEL Boot Parted Magic with MEMDISK
 LINUX http://webserver/memdisk iso
 INITRD http://webserver/pmagic-5.8.iso
 ###
 # initrd=http://192.168.1.100/images/pmagic/pmagic-4.2.iso
 ###
 More help here:
 http://www.syslinux.org/wiki/index.php?title=MEMDISK

 ###
 Install grub2 in patition - vbr in chroot environment
 - https://en.wikipedia.org/wiki/Chroot
 ###
<code>

./chroot.dev.sh /dev/<dev><$x> grub-install --recheck --force /dev/<dev><$x>
./chroot.dev.sh /dev/<dev><$x> /bin/bash

</code>

 ### Grub 1
 # cp -r /usr/lib/grub /dev/<dev><$x>/boot/
 # cp /usr/sbin/grub /dev/<dev><$x>/boot/grub/grub
 Load grub on sda3 menu.lst sda3
 #############
title boot grub on sda3 menu.lst sda3
    root (hd0,2)
    configfile /boot/grub/menu.lst
    chainloader +1

title boot menu.lst sda3
    root (hd0,2)
    configfile /boot/grub/menu.lst

 Load grub4dos from grub
 #############
 # copy the grub.exe file from the grub4dos to the boot path
title Grub4dos
  # configfile (hd0,2)/boot/grub/menu.lst
  root (hd0,2)
  kernel (hd0,2)/boot/grub/grub.exe


title Grub4dos menu_grub4dos.lst
  kernel (hd0,2)/boot/grub/grub.exe --config-file="configfile (hd0,2)/boot/grub/menu_grub4dos.lst"

title Grub4dos abc.iso
  # File for drive emulation must be in one cotiguous disk area
  kernel (hd0,2)/boot/grub/grub.exe --config-file="map (hd0,2)/images/abc.iso (0xff);map --hook;chainloader (0xff)"

 Load grub 2 from grub
 #############

title Grub 2
  root (hd0,2)
  kernel /boot/grub2/i386-pc/core.img

title Windows 7
        root (hd0,0)
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi


read -r -d "" FILECONTENT <<"ENDFILECONTENT"
# Config file for GRUB - The GNU GRand Unified Bootloader
# /boot/grub/menu.lst

# DEVICE NAME CONVERSIONS
#
#  Linux           Grub
# -------------------------
#  /dev/fd0        (fd0)
#  /dev/sda        (hd0)
#  /dev/sdb2       (hd1,1)
#  /dev/sda3       (hd0,2)
#

#  FRAMEBUFFER RESOLUTION SETTINGS
#     +-------------------------------------------------+
#          | 640x480    800x600    1024x768   1280x1024
#      ----+--------------------------------------------
#      256 | 0x301=769  0x303=771  0x305=773   0x307=775
#      32K | 0x310=784  0x313=787  0x316=790   0x319=793
#      64K | 0x311=785  0x314=788  0x317=791   0x31A=794
#      16M | 0x312=786  0x315=789  0x318=792   0x31B=795
#     +-------------------------------------------------+
#  for more details and different resolutions see
#  https://wiki.archlinux.org/index.php/GRUB#Framebuffer_resolution

# GRUB recognized value
# This is an easy way to find the resolution code using only GRUB itself.
# On the kernel line, specify that the kernel should ask you which mode to use.
# kernel /vmlinuz-linux root=/dev/sda1 ro vga=ask
# Now reboot. GRUB will now present a list of suitable codes to use and the
# option to scan for even more.
# You can pick the code you would like to use
# (do not forget it, it is needed for the next step) and boot using it.
# Now replace ask in the kernel line with the correct one you have picked.
# e.g. the kernel line for [369] 1680x1050x32 would be:
# kernel /vmlinuz-linux root=/dev/sda1 ro vga=0x369

# general configuration:

timeout   8
default   0
##color light-blue/black light-cyan/blue
##splashimage=(hd0,6)/boot/grub/splash.xpm.gz
##gfxmenu /boot/gfx_message.cpio

# boot sections follow
# each is implicitly numbered from 0 in the order of appearance below
#
# TIP: If you want a 1024x768 framebuffer, add "vga=773" to your kernel line.
#
#-*

title "Boot mbr /dev/sda (hd0)
  root=(hd0)
  chainloader +1

title "Boot mbr /dev/sdb (hd1)
  root=(hd1)
  chainloader +1

title boot menu.lst on /dev/sda1
    root (hd0,0)
    configfile /boot/grub/menu.lst

title Grub4dos
  # copy the grub.exe file from the grub4dos to the boot path
  # configfile /boot/grub/menu.lst
  kernel /boot/grub/grub.exe

title Grub4dos menu_grub4dos.lst
  kernel /boot/grub/grub.exe --config-file="configfile /boot/grub/menu_grub4dos.lst"

title Grub4dos ${isofile}
  # File for drive emulation must be in one cotiguous disk area
  kernel /boot/grub/grub.exe --config-file="map (hd0,$x)/${isofile} (hd32);map --hook;chainloader (hd32) "

title Grub4dos boot sda2 as ISO partition
  ###
  # (hdx,x)0+sisze in sectors (blocks*2) /but seem limited some less than 9000000/
  # If you get the size wrong but enough to grub catch rest of code to boot
  # it can work, but if init procedure will have own way then will fail..
  # - for example for antiX you have to add 'from=hd' to kernel options
  # and then antix init procedure will scan hdd devices for source..
  # Map assignment is take full effect after 
  # 1. - map --hook command
  # 2. after finish title sequence and / or boot command.
  # So before those commands, files are still under original paths.
  # When mapping a partition the syntax (hdm,n)+1 is used to represent the whole
  # partition (where m=disk number, and n=partition number),
  # not just the first sector.

  # Memory mapping uses the same command syntax as the direct mapping
  # examples above, with the addition of the --mem switch.
  # and then it work as memdisk.
  ###

  kernel /boot/grub/grub.exe --config-file="rootnoverify (hd0,1);map --heads=0 --sectors-per-track=0 (hd0,1)+1 (0xff);map --hook;chainloader (0xff) "

title Load Grub 2 from Grub
  root (hd0,$x)
  kernel /boot/grub2/i386-pc/core.img

title System restart
  reboot

title System shutdown
  halt

ENDFILECONTENT
echo -e "${FILECONTENT}" >"/mnt/install_grub/boot/grub/menu.lst"

        
### Grub4dos


 Load grub4dos from lilo ("/etc/lilo.conf")

 Installing LILO to a partitions boot sector
 Create a simple /etc/lilo.conf or edit your existing one like the following.
 The format is explained in $ man lilo.conf.

read -r -d "" FILECONTENT <<"ENDFILECONTENT"
# LILO configuration file
# /etc/lilo.conf

# It is important to specify your Linux boot partition or device here
 boot=/dev/hda2
 map=/boot/map
 install=/boot/boot.b
 default=Linux
 lba32

image=/boot/vmlinuz
       label=Linux
       root=/dev/hda2
       read-only

# copy grub.exe to root of lilo boot partition
image = /boot/grub/grub.exe
  label = Grub4dos
  append = "--config-file=configfile /boot/grub/menu_grub4dos.lst"

# copy grub to root of lilo boot partition
#image = /boot/grub2/i386-pc/core.img
image = /boot/grub2/g2ldr
 label = Grub2

# chainloader other partition
other = /dev/sda2
 label = Other

ENDFILECONTENT

 Run the # lilo command to write lilo to the boot sector of /dev/hda2.

 ###
isolinux

 You need to make sure that you copy the grub.exe file from
 the grub4dos (featured) download to the boot path.

label Grub4dos
  menu label Grub4dos
  linux /boot/grub/grub.exe
  text help
  Start Grub4dos
  endtext


 You can also specify the menu file using an additional line of
 append --config-file=/abc/yyy.txt
 or even specify grub4dos commands, for example
 append --config-file="map /images/abc.iso (0xff);map --hook;chainloader (0xff)"

 Load grub from syslinux
 #############
 You need to make sure that you copy the grub file

label Grub
  linux /boot/grub/grub
  append root (hd0,2)
  menu label Grub
  text help
  Start Grub
  endtext

#############
Load GRUB 2 from syslinux

LABEL GRUB
  MENU LABEL Grub2 chainload
  COM32 CHAIN.C32
  APPEND file=/boot/grub/boot.img

LABEL Other Linux (Linux installed on sda3 & Syslinux installed on sda)
  MENU LABEL Grub2 chainload
  COM32 chain.c32
  APPEND boot 3

 ###
 
 syslinux-install_update -i -a -m -c /mnt/
 

Load grub4dos from grub2

menuentry "Grub4dos" {
          setroot=(hd0,1)
          linux /grub.exe
}

menuentry "Boot mycd.iso" {
set opts='map /test/mycd.iso (0xff); map --hook; chainloader (0xff);'
linux /boot/grub/grub4dos.exe --config-file=${opts}
}



menuentry "OS using grub2" {
   insmod xfs
   search --set=root --label OS1 --hint hd0,msdos8
   configfile /boot/grub/grub.cfg
}

menuentry "OS using grub2-legacy" {
   insmod ext2
   search --set=root --label OS2 --hint hd0,msdos6
   legacy_configfile /boot/grub/menu.lst
}
menuentry "FreeBSD" {
          insmod zfs
          search --set=root --label freepool --hint hd0,msdos7
          kfreebsd /freebsd@/boot/kernel/kernel
          kfreebsd_module_elf /freebsd@/boot/kernel/opensolaris.ko
          kfreebsd_module_elf /freebsd@/boot/kernel/zfs.ko
          kfreebsd_module /freebsd@/boot/zfs/zpool.cache type=/boot/zfs/zpool.cache
          set kFreeBSD.vfs.root.mountfrom=zfs:freepool/freebsd
          set kFreeBSD.hw.psm.synaptics_support=1
}

menuentry "experimental GRUB" {
          search --set=root --label GRUB --hint hd0,msdos5
          multiboot /experimental/grub/i386-pc/core.img
}
menuentry "BSD" {
insmod part_bsd
set root=(hd0,netbsd1)
knetbsd /netbsd
#knetbsd /netbsd -s -v
#knetbsd_module_elf /stand/amd64/6.0/modules/ffs/ffs.kmod
}

# cp -a /usr/lib/grub/i386-pc/* /boot/grub



read -r -d "" FILECONTENT <<"ENDFILECONTENT"
Here's how I was able to do it using Grub4DOS (last official build):

Grub4DOS can boot iso images, so it should be able to do it for partitions.
We'd want to map the iso partition to a new drive and boot from it with:

title Boot ISO Partition
    map (hd0,7) (0xff)
    map --hook
    chainloader (0xff)
But this doesn't work, the whole disk is getting mapped.

Fortunately map can take a "file or blocklist" as first argument.

Find out how many blocks your partition takes:

$ sudo fdisk -l /dev/sda

   Device Boot      Start         End      Blocks   Id  System
/dev/sda8            5948        6087     1124518+   b  W95 FAT32
I created a 1.1Gb partition, so I need to use 1124518 * 2 = 2249036 here.
(technically it's 2249037 but doesn't matter)
Now pass the blocklist to grub:

title Boot ISO Partition
    map --heads=0 --sectors-per-track=0 (hd0,7)0+2249036 (0xff)
    map --hook
    chainloader (0xff)
And it works !
Notes:

If you get the size wrong grub will catch it
(map command will fail beyond the partition boundary).
If it's too small it likely won't boot.
Can use (hd32) instead of (0xff) also.
Haven't tried the 4.5b version, issue might be fixed there.

http://diddy.boot-land.net/grub4dos/files/README_GRUB4DOS.txt

To chainload Grub4DOS from Grub2:

menuentry "Boot ISO Partition" {
        root (hd0,1)
        set opts='map --heads=0 --sectors-per-track=0 (hd0,7)0+2249036 (0xff);
                  map --hook;
                  chainloader (0xff) '
        linux16 /boot/grub4dos/grub.exe --config-file=$opts
}


ENDFILECONTENT


Load grub2 from grub4dos

kernel /g2ldr

http://download.gna.org/grub4dos/
  chainloader (hd2,1)/grldr.mbr

OR

Find the core.img file...

title Boot grub2 from partition 3 \n Boot to core.img
root (hd0,2)
if exist /boot/grub/i386-pc/core.img kernel /boot/grub/i386-pc/core.img && boot
if exist /boot/grub/core.img kernel /boot/grub/core.img && boot
if exist /grub2/core.img kernel /grub2/core.img && boot
if exist /boot/grub2/i386-pc/core.img kernel /boot/grub2/i386-pc/core.img && boot
# grub - e.g. bitdefender
if exist /boot/grubi386.pc kernel /boot/grubi386.pc && boot

title Find and boot menu.lst
find --set-root /boot/grub/menu.lst
config-file /boot/grub/menu.lst

title Booy second disk
chainloader (hd2)+1
rootnoverify hd2

Runtu
label normal=Normal
append normal=
label driverupdates=Use driver update disc
append driverupdates=debian-installer/driver-update=true
applies driverupdates=live live-install
label oem=OEM install (for manufacturers)
append oem=oem-config/enable=true
applies oem=live live-install install

#####
Find boot files from grub shell

set root=(hd(press the tab key here))
linux /boot/vml(press the tab key here) ro root=/dev/sda<x>
initrd /boot/ini(press the tab key here)
boot
#####

64bit – The Modern Choice
This is the platform standard for desktop and work station computers created in
the last decade. If your processor is capable of running a 64bit operating
system, you should be using this release.

32bit - Old Computer, with lots of RAM
This is the release you should use if you have a computer that is too old
to support a 64bit operating system, but still supports the PAE memory extension.

Legacy – Non-PAE kernel
The Legacy image utilizes the older 3.2 Linux kernel that is optimized for old
(15+ years old) hardware. This kernel also does not include the PAE extension
which is not supported on many older systems. If your computer does not support
the PAE kernel extension or is well over a decade old
then this is the right image for you.

i386 or 80386 – Intel 386 and AMD 386 CPUs.
These were the 1st Generation of 32-bit CPUs.

i486 or 80486 – Intel 486,  and AMD 486
along with other less known brands of 2nd Generation of 32-bit CPUs.

i586 – The First Intel Pentiums MMX,  AMD-K5.
Intel went away from the ix86 names in favor of Pentium because
they could not trademark numbers.

i686 – Intel Pentium Pro/II/III, AMD K6/Athlon/T-Bird/T-Bred/Duron/

i786 – This is really where the ix86 thing stops.
Some call the Pentium 4 an i786 and others call the AMD K7/Athlon an i786
but they are really different cores.

x86-64, AMD64, Intel 64 – These are compatible with old 32-bit
and 16-bit x86 programs, but also support new programs written for 64-bit.
If the program is written to take advantage of 64-bit address space
it will perform better.

IA-64 or Itanium – IA-64 is NOT x86-64.
It is not compatible with the x86 or x86-64.
# More infos
https://myonlineusb.wordpress.com/2011/06/08/what-is-the-difference-between-i386-i486-i586-i686-i786/

#######
http://www.elivecd.org/ufaqs/how-to-tell-the-computer-to-boot-from-another-device/
If your computer uses those newer BIOS that ships with Windows 8 with
the restriction to use other operating systems
you need to enter in your BIOS setup and basically:
disable “secure boot“
disable “UEFI mode“
enable “legacy boot“
enable “CSM“
If you need more info about the UEFI and “Secure Boot”
of the bios make a look to our other FAQ article
#######
The Boot Device Menu is called with the function keys as soon as the computer
is started and before the system starts. Depending on the equipment most
often used: Esc, F8, F9, F10, F12. Boot Device Menu is sometimes incorrectly
referred to as Boot Menu.
#######
http://www.ultimatedeployment.org/download.html
 ### --- ###

 Different kinds of entries :

Scanning...

title     GParted live
    root      (hd0,3)
    kernel    /live-hd/vmlinuz boot=live config union=overlay noswap noprompt vga=788 ip=frommedia live-media-path=/live-hd bootfrom=/dev/hda4 toram=filesystem.squashfs
    initrd    /live-hd/initrd.img
    boot

menuentry "GParted live" {
      set root=(hd0,4)
      linux /live-hd/vmlinuz boot=live config union=overlay noswap noprompt vga=788 ip=frommedia live-media-path=/live-hd bootfrom=/dev/hda4 toram=filesystem.squashfs
      initrd /live-hd/initrd.img
    }
menuentry "Gparted live" {
      set isofile="/home/isos/gparted-live-0.5.2-9.iso"
      loopback loop $isofile
      linux (loop)/live/vmlinuz boot=live config union=overlay noswap noprompt vga=788 ip=frommedia toram=filesystem.squashfs findiso=$isofile
      initrd (loop)/live/initrd.img
    }
GRUB4DOS and WINGRUB
If your grub is grub4dos, edit your grub config file menu.lst, and append the following:

    title gparted 11.0 live
    find --set-root /gparted-live-0.11.0-10.iso
    map /gparted-live-0.11.0-10.iso (0xff) || map --mem /gparted-live-0.11.0-10.iso (0xff)
    map --hook
    root (0xff)
    kernel /live/vmlinuz  boot=live config union=overlay noswap noprompt vga=788 ip=frommedia findiso=/gparted-live-0.11.0-10.iso toram=filesystem.squashfs
    initrd /live/initrd.img

Edit the /etc/lilo.conf file and add a section for gparted.

For this example, let us assume that the /gparted-live directory resides on the /dev/sda4 partition.

    # GParted bootable partition config begins

    image  = /gparted-live/live/vmlinuz
    root   = /dev/sda4  # make sure this matches the bootfrom= below ...
    label  = gparted
    append = "boot=live config union=overlay noswap noprompt ip=frommedia live-media-path=/gparted-live/liveoverlay" vga=788
    initrd = /gparted-live/live/initrd.img
# kernel=kernel root=your_iso_image ro [ isoloop=$isofile fancy loopback options here] ]kernel options]
# If you use lilo, alter accordingly. Your kernel will have to be filesystem happy and iso9660 happy with both modules compiled in

Following boot entries could be added to Grub menu:

# Ubuntu 10.10 (10.10) on /dev/sda6
title Ubuntu 10.10 (maverick) - kernel 2.6.35-30-generic
    root (hd0,5)
    kernel /boot/vmlinuz-2.6.35-30-generic root=UUID=5adac0e4-5c27-4292-a8dc-cd86cb806951 ro vga=794
    initrd /boot/initrd.img-2.6.35-30-generic

# Ubuntu 10.10 (10.10) on /dev/sda6
title Ubuntu 10.10 (maverick) - kernel 2.6.35-28-generic
    root (hd0,5)
    kernel /boot/vmlinuz-2.6.35-28-generic root=UUID=5adac0e4-5c27-4292-a8dc-cd86cb806951 ro vga=794
    initrd /boot/initrd.img-2.6.35-28-generic

# openSUSE 11.4 (x86_64) on /dev/sda11
title openSUSE 11.4 (Celadon) - kernel 2.6.37.6-0.5 (Desktop)
    root (hd0,10)
    kernel /boot/vmlinuz-2.6.37.6-0.5-desktop root=/dev/disk/by-uuid/86949758-5b38-4f29-9f03-da0b2c055b8e resume=/dev/disk/by-uuid/ba9db764-a47e-48d9-b6f9-b627b57c0287 splash=silent quiet showopts vga=0x31a
    initrd /boot/initrd-2.6.37.6-0.5-desktop

# Mandriva Linux 2010.2 (2010.2) on /dev/sdb6
title Mandriva 2010.2 (Farman) - kernel 2.6.38.8
    root (hd1,5)
    kernel /boot/vmlinuz BOOT_IMAGE=linux root=UUID=4ecf3517-c7e9-47a1-8930-13a4e188e730 resume=UUID=ba9db764-a47e-48d9-b6f9-b627b57c0287 splash=silent vga=794
    initrd /boot/initrd.img

# Mandriva Linux 2010.2 (2010.2) on /dev/sdb6
title Mandriva 2010.2 (Farman) - kernel 2.6.38.8 (desktop)
    root (hd1,5)
    kernel /boot/vmlinuz-2.6.38.8-desktop-69mib BOOT_IMAGE=2.6.38.8-desktop-69mib root=UUID=4ecf3517-c7e9-47a1-8930-13a4e188e730 resume=UUID=ba9db764-a47e-48d9-b6f9-b627b57c0287 splash=silent vga=794
    initrd /boot/initrd-2.6.38.8-desktop-69mib.img

# Debian GNU/Linux (squeeze/sid) on /dev/sda19
title Debian GNU/Linux - kernel 2.6.32-trunk-amd64
    root (hd0,18)
    kernel /boot/vmlinuz-2.6.32-trunk-amd64 root=UUID=30eac80e-8574-46fb-a4ee-ec2a2ee453f9 ro
    initrd /boot/initrd.img-2.6.32-trunk-amd64

# Debian GNU/Linux (squeeze/sid) on /dev/sda19
title Debian GNU/Linux - kernel 2.6.32-3-amd64
    root (hd0,18)
    kernel /boot/vmlinuz-2.6.32-3-amd64 root=UUID=30eac80e-8574-46fb-a4ee-ec2a2ee453f9 ro
    initrd /boot/initrd.img-2.6.32-3-amd64

# Windows NT/2000/XP (loader) on /dev/sda1
title Windows NT/2000/XP (loader) - added by updategrub
    rootnoverify (hd0,0)
    chainloader +1

# Windows NT/2000/XP (loader) on /dev/sdb1
title Windows NT/2000/XP (loader) - added by updategrub
    map (hd1) (hd0)
    map (hd0) (hd1)
    rootnoverify (hd1,0)
    chainloader +1


# Grub on sda MBR
title Grub2 in sda MBR
    rootnoverify (hd0)
    chainloader +1

# Grub on sdb MBR
title Legacy Grub in sdb MBR
    rootnoverify (hd1)
    chainloader +1

# suse-Grub on /dev/sda11
title suse Grub on /dev/sda11
    root (hd0,10)
    chainloader +1

# mandrivalinux-Grub on /dev/sdb6
title mandrivalinux Grub on /dev/sdb6
    root (hd1,5)
    chainloader +1

# debian-Grub on /dev/sda19
title debian Grub on /dev/sda19
    root (hd0,18)
    chainloader +1

# Legacy Grub on /dev/sdb4
title Legacy Grub on /dev/sdb4
    root (hd1,3)
    chainloader +1

# Legacy Grub on /dev/sda4
title Legacy Grub on /dev/sda4
    root (hd0,3)
    chainloader +1

# Grub2 on /dev/sda6
title Grub2 on /dev/sda6
    root (hd0,5)
    kernel /boot/grub/core.img
    boot

# OpenBSD on (hd0,1) - /dev/sda25
title OpenBSD 4.7
    rootnoverify (hd0,1)
    makeactive
    chainloader +1

# NetBSD on (hd0,2) - /dev/sda31
title NetBSD 5.0.2
    rootnoverify (hd0,2)
    makeactive
    chainloader +1

# FreeBSD on (hd0,2) /dev/sda28
title FreeBSD 8.1
    rootnoverify (hd0,2)
    makeactive
    chainloader +1

# DragonflY on (hd0,1)
title DragonFly 2.4.1 
    rootnoverify (hd0,1)
    makeactive
    chainloader +1

# FreeBSD on (hd0,1) 
title FreeBSD 8.0 - alt
    rootnoverify (hd0,1)
    makeactive
    chainloader +1

# FreeBSD on (hd1,2) /dev/sdb20 
title FreeBSD 7.2 - alt
    rootnoverify (hd1,2)
    makeactive
    chainloader +1

# OpenBSD on (hd1,1) - /dev/sdb17
title OpenBSD 4.7 - alt
    rootnoverify (hd1,1)
    makeactive
    chainloader +1

# NetBSD on (hd1,2) - /dev/sdb24
title NetBSD 5.0.2 - alt
    rootnoverify (hd1,2)
    makeactive
    chainloader +1

 ###
#
#!/bin/bash
# ---------------------------------------------------
# Script to create bootable ISO in Linux
# usage: make_iso.sh [ /tmp/porteus.iso ]
# author: Tomas M. <http://www.linux-live.org>
# updated for Porteus by fanthom <http://www.porteus.org>
# ---------------------------------------------------

if [ "$1" = "--help" -o "$1" = "-h" ]; then
  echo "This script will create bootable ISO from files in curent directory."
  echo "Current directory must be writable."
  echo "example: $0 /mnt/sda5/porteus.iso"
  exit
fi

CDLABEL="Porteus"
ISONAME=$(readlink -f "$1")

cd $(dirname $0)

if [ "$ISONAME" = "" ]; then
   SUGGEST=$(readlink -f ../../$(basename $(pwd)).iso)
   echo -ne "Target ISO file name [ Hit enter for $SUGGEST ]: "
   read ISONAME
   if [ "$ISONAME" = "" ]; then ISONAME="$SUGGEST"; fi
fi

mkisofs -o "$ISONAME" -v -l -J -joliet-long -R -D -A "$CDLABEL" \
-V "$CDLABEL" -no-emul-boot -boot-info-table -boot-load-size 4 \
-b boot/syslinux/isolinux.bin -c boot/syslinux/isolinux.boot ../.
 ###

Other similar projects/solutions

UNetbootin
https://unetbootin.github.io

LinuxLive USB Creator
https://www.linuxliveusb.com

grml-rescueboot
https://wiki.grml.org/doku.php?id=rescueboot

easy2boot
http://www.easy2boot.com/

Rufus Create bootable USB drives the easy way
https://rufus.akeo.ie/

Etcher is a powerful OS image flasher
https://etcher.io/

ROSA ImageWriter
http://wiki.rosalab.ru/en/index.php/ROSA_ImageWriter#Where_can_I_take_it.3F

https://en.wikipedia.org/wiki/List_of_tools_to_create_Live_USB_systems

https://en.wikipedia.org/wiki/List_of_live_CDs
https://livecdlist.com/
http://linuxfreedom.com/Distros/
http://distrowatch.com/
https://www.linuxquestions.org/questions/linux-distributions-5/
https://sourceforge.net/projects/archiveos/
https://archiveos.org/
