#!/bin/bash
###########################################################################
# Easy Monitor Makefile ; make zip archive in parent directory            #
# and rename to EasyMonitor.skz for SuperKaramba                          #
# * to run type - bash skz_make.sh in this directory                      #
###########################################################################
echo ""
cd $HOME/.superkaramba/EasyMonitor
cd themes

COMMAND=$(whereis -b ip | awk '{print $2}')
if [ -x "$COMMAND" ]; then
	interface=$($COMMAND route | head -n1 | awk '{print $5}')
else
	COMMAND=$(whereis -b route | awk '{print $2}')
	if [ -x "$COMMAND" ]; then
	interface=$($COMMAND -n | grep 'UG' | awk '{print $8}'| head -n1)
	fi
fi
if [[ $interface = "" ]]; then
	interface="wlan0"
fi


interface_themes="EM_Big_Areo_0.theme EM_Big_Areo_1.theme EM_Big_Areo_2.theme EM_Big_Tech_1.theme EM_Net_WlanX_Interface.theme"

device=$(sed -n "s|network device=*[ \t]*|&|p" $interface_themes)
device="${device##*device=}"
device="${device%% *}"

echo "old interface is: "$device""
echo "new interface is: "wlan0" replace in: $interface_themes"
echo "sed -i -e \"s|device=$device|device=wlan0|\" $interface_themes"
sed -i -e "s|device=$device|device=wlan0|" $interface_themes

cd ..
echo""
exclude_skz_lst=$( . exclude_skz.lst)

zip -9 -r ../EasyMonitor . $exclude_skz_lst

Save_File_skz=$( kdialog --title "Save theme" --getsavefilename "$HOME/EasyMonitor.skz" )
mv ../EasyMonitor.zip $Save_File_skz
echo ""
cd themes
echo "old interface is: "wlan0""
echo "new interface is: "$interface" replace in: $interface_themes"
sed -i -e "s|device=wlan0|device=$interface|" $interface_themes
echo "# Done #"