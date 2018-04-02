#!/bin/bash
# run_themes.sh script for Easy Monitor

################# Variables for color terminal
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/Color_terminal_variables.sh"
Color_terminal_variables
#################
Themes_Prefix="$HOME/.superkaramba/"
Easy_Monitor_Work_Dir="EasyMonitor"
Easy_Monitor_Backup="Easy_Monitor_$(date +%Y_%m_%d-%H_%M_%S)"
Easy_Monitor_Package="EasyMonitor.skz"
##################

cd "$Themes_Prefix$Easy_Monitor_Work_Dir"

if [ $? = 0 ]; then # If success
	
	####################################################
	# Init SuperKaramba themes
	
	############
	# Big themes
	
	killall superkaramba
	superkaramba
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Script_Runner.theme EM_Script_Runner.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Script_Runner.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_File_System_Backup.theme EM_File_System_Backup.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_File_System_Backup.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Edit_System_Files.theme EM_Edit_System_Files.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Edit_System_Files.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Qemu_Install_Systems.theme EM_Qemu_Install_Systems.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Qemu_Install_Systems.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Big_Areo_0.theme EM_Big_Areo_0.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Big_Areo_0.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Big_Areo_1.theme EM_Big_Areo_1.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Big_Areo_1.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Big_Areo_2.theme EM_Big_Areo_2.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Big_Areo_2.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Big_Tech_1.theme EM_Big_Tech_1.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Big_Tech_1.theme
	
	###############
	# Single themes
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_System.theme EM_System.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_System.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Cpu_Single_All.theme EM_Cpu_Single_All.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Cpu_Single_All.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Cpu_Single_Core.theme EM_Cpu_Single_Core.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Cpu_Single_Core.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Cpu_Multi_Core.theme EM_Cpu_Multi_Core.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Cpu_Multi_Core.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Cpu_Octa_Thread.theme EM_Cpu_Octa_Thread.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Cpu_Octa_Thread.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Cpu_Core_0.theme EM_Cpu_Core_0.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Cpu_Core_0.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Cpu_Core_1.theme EM_Cpu_Core_1.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Cpu_Core_1.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Memory.theme EM_Memory.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Memory.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Gpu.theme EM_Gpu.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Gpu.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Gpu_Ati.theme EM_Gpu_Ati.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Gpu_Ati.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Filesystem.theme EM_Filesystem.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Filesystem.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Net_Eth0_Interface.theme EM_Net_Eth0_Interface.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Net_Eth0_Interface.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Net_Eth1_Interface.theme EM_Net_Eth1_Interface.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Net_Eth1_Interface.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Net_Wlan0_Interface.theme EM_Net_Wlan0_Interface.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Net_Wlan0_Interface.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Net_WlanX_Interface.theme EM_Net_WlanX_Interface.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Net_WlanX_Interface.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Netstat_TCP.theme EM_Netstat_TCP.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Netstat_TCP.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Netstat_UDP.theme EM_Netstat_UDP.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Netstat_UDP.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Top.theme EM_Top.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Top.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Battery.theme EM_Battery.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Battery.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Hardware.theme EM_Hardware.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Hardware.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Scan.theme EM_Scan.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Scan.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Amarok.theme EM_Amarok.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Amarok.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Net_Connections.theme EM_Net_Connections.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Net_Connections.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_Notes.theme EM_Notes.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_Notes.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_About.theme EM_About.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EM_About.theme.theme
	
	qdbus org.kde.superkaramba /MainApplication openNamedTheme ./EasyMonitor.theme EasyMonitor.theme 0
	qdbus org.kde.superkaramba /MainApplication closeTheme EasyMonitor.theme
	
	qdbus org.kde.superkaramba /SuperKaramba quitSuperKaramba
	
	nohup superkaramba ./themes/EM_About.theme

	#qdbus org.kde.superkaramba /MainApplication openNamedTheme ./themes/EM_About.theme EM_About.theme 0
	
else
	echo $Yellow$Blink
	echo "No EasyMonitor in $Easy_Monitor_Work_Dir directory"
	echo $Reset
fi

echo $Green "Done" $Reset

