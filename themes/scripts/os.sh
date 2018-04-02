#!/bin/bash
# os.sh script

DISTRO="Unkown"
CODENAME=""
LSB_RELASE_COMMAND=`which lsb_release`


if [ -x "$LSB_RELASE_COMMAND" ]; then
	DISTRO=`"$LSB_RELASE_COMMAND" -d |awk -F'\t' '{print $2} '`; CODENAME=`"$LSB_RELASE_COMMAND" -c |awk -F'\t' '{print $2}'`
else
	test -r "/etc/sabayon-release"		&& DISTRO=`cat "/etc/sabayon-release"`
	test -r "/etc/SuSE-release"		&& DISTRO=`cat "/etc/SuSE-release"`
	test -r "/etc/redhat-release"		&& DISTRO=`cat "/etc/redhat-release"`
	test -r "/etc/mandrake-release"		&& DISTRO=`cat "/etc/mandrake-release"`
	test -r "/etc/slackware-version"	&& DISTRO=`cat "/etc/slackware-version"`
	test -r "/etc/debian_version"		&& DISTRO=`cat "/etc/debian_version"`
	test -r "/etc/vector-version"		&& DISTRO="Vector" && CODENAME=`cat "/etc/vector-version"`
	#test -r "/etc/os-release"		&& DISTRO=`cat "/etc/os-release"`
fi

echo "$DISTRO $CODENAME"
