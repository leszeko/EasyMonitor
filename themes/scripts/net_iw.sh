#!/bin/bash 
# net_iw.sh script

interface=$(iw dev|grep "Interface"|head -n1|awk '{print $2}')
iw dev $interface link
echo 
info=$(iw dev $interface link);ssid=$(echo "$info" |grep -E -i "SSID:|signal")
echo $ssid 
Tx_Rx=$(echo "$info" |grep -E -i "TX:|RX:")
echo $Tx_Rx
R=$(echo "$info" |grep "tx bitrate:")
echo $R
# iw dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]
# iw dev wlan0 set power_save on
# iw wlan0 set bitrates legacy-2.4 12 18 24