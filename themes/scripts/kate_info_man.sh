#!/bin/bash
# kate_info_man.sh
# play script

Kate_info_man ()
{
	local Command="$1" Command_info_pages=$(mktemp -d) || return 1
	trap "echo -e '\033[00;36m SIGHUP - \033[0;0m'; Cleanup" SIGHUP # 1
	function Cleanup ()
	{
		if [ -d "$Command_info_pages" ]
		then :
			rm -vrf "$Command_info_pages"
			# sleep 3
		fi
	}
	info "$Command" >"$Command_info_pages/$Command.info" && kate -b "$Command_info_pages/$Command.info" >/dev/null 2>&1
	Cleanup
}

Ask_comand_name ()
{
	kdialog --inputbox "Enter name of command for general info manual"
}

Comman_name=$(Ask_comand_name)
if [ "$Comman_name" = "" ]
then :
	Comman_name="info"
else :
Kate_info_man "$Comman_name"
fi