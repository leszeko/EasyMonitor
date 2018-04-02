#!/bin/bash
# net_ethtool.sh script

INTERFACE=$1

if [ -x /usr/sbin/ethtool ]; then
/usr/sbin/ethtool $INTERFACE | grep 'Speed' | awk '{print $1, $2}'
exit 0
fi

if [ -x /sbin/ethtool ]; then
sudo /sbin/ethtool $INTERFACE | grep 'Speed' | awk '{print $1, $2}'
exit 0
fi

ETHTOOL_COMMAND=`whereis -b ethtool | awk '{print $2}'`
if [ -x "$ETHTOOL_COMMAND" ]; then
$ETHTOOL_COMMAND $INTERFACE | grep 'Speed' | awk '{print $1, $2}'
exit 0
fi

echo "install ethtool"
exit 0