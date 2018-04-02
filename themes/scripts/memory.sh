#!/bin/bash
# memory.sh script

sudo /usr/sbin/dmidecode --type 17 | grep 'Size' | awk '{print NR":",$2,$3;}' | awk 'BEGIN {RS="\n\n"; FS="\n";} {print $1,$2,$3,$4;}'