#!/bin/bash
# netstat.sh script

watch 'netstat -r; netstat |grep tcp'
