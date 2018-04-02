#!/bin/bash
# vga_query.sh script

Begin () {
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	mkdir -p $TMPDIR/EasyMonitor-$USER
	case "$1" in
		"GPU_Info" ) GPU_Info ;;
		"GPU_Temp" ) GPU_Temp ;;
		"GPU_Fan"  ) GPU_Fan ;;
		* ) GPU_Info; echo -n "Temp: "; GPU_Temp;  echo -n "Fan: "; GPU_Fan;;
	esac
}

GPU_Info () {
	Glx_Info_String=`glxinfo`
	OpenGL_vendor_string=$(echo "$Glx_Info_String"|grep 'OpenGL vendor string:'|sed -e 's/.*: //')
	
	case "$OpenGL_vendor_string" in
	"nouveau")
		GPU_Info_Line=$(cat /sys/class/drm/card0/device/pstate | grep '*'| sed -e 's/.*: //'| sed -e 's/MHz//' -e  's/MHz//' | tr 'c' 'C')
		GPU_Info_Line+=$(ls -lh /sys/class/drm/card0/device/resource*wc |awk '{print $5}')
		Driver=" nouveau"
		;;
	"NVIDIA Corporation"	)
		Cloks=$(nvidia-settings -q GPUCurrentClockFreqsString -t |tr -d ' '| tr ',' '\n')
		Core=$(echo "$Cloks"|grep 'nvclock='|sed -e 's/nvclock=//'|head -n1)
		Shader=$(echo "$Cloks"|grep 'processorclock='|sed -e 's/processorclock=//'|head -n1)
		Mem=$(echo "$Cloks"|grep 'memclock='|sed -e 's/memclock=//'|head -n1)
		GPU_Info_Line='Core: '$Core' Shader: '$Shader' Memory: '$Mem' MHz / '
		GPU_Info_Line+=$(ls -lh /sys/class/drm/card0/device/resource*wc |awk '{print $5}')
		Driver=""
		;;
	"AMD"	)
		#echo "GPU Load: $(aticonfig --adapter=0 --od-getclocks | grep 'GPU load :' | sed -e s/'GPU load :'// | awk '{print $1}')"
		#echo "GPU Clock: $(aticonfig --adapter=0 --od-getclocks | grep 'Current Clocks' | awk '{print $4}' | sed -e 's/$/&'\ MHz'/')"
		#echo "MEM Clock: $(aticonfig --adapter=0 --od-getclocks | grep 'Current Clocks' | awk '{print $5}' | sed -e 's/$/&'\ MHz'/')"
		;;
	*	)
		GPU_Info_Line=$(whereis -b lspci | awk '{print $2}')
		GPU_Info_Line=$($GPU_Info_Line -nnk | grep -i "vga" -A2 | grep -i "driver")
		GPU_Info_Line=${GPU_Info_Line#*\	}
		GPU_Info_Line+=" / Video memory "
		GPU_Info_Line+=$(ls -lh /sys/class/drm/card0/device/resource*wc |awk '{print $5}')
		#Graphics_Memory=$(dmesg | grep -i "Memory usable by graphics device")
		#Graphics_Memory=${Graphics_Memory#*\=}
		#GPU_Info_Line+=$Graphics_Memory
		;;
	esac

	GPU_Info_Line+=$(echo "$Glx_Info_String" | grep 'OpenGL renderer string:' | sed  -s 's/OpenGL renderer string:/\nOpenGL:/')$Driver$'\n'
	GPU_Info_Line+=$(echo -n "$Glx_Info_String" | grep 'OpenGL version string:' | head -n1 | sed -e 's/.*: //' | awk '{print "VersionGL:", $1 }')
	GPU_Info_Line+=$(echo -n "$Glx_Info_String" | grep 'GLX version' | head -n1 | awk '{print " "$1$2$3 }')
	GPU_Info_Line+=$(echo "$Glx_Info_String" | grep 'OpenGL version string:' | head -n1 | sed -e 's/.*: //' | awk '{print " "$2, $3 }')
	
	echo "$GPU_Info_Line"
}

GPU_Temp () {
	GPU_module=`ls /sys/class/drm/card0/device/driver/module/drivers`
	case "$GPU_module" in
		"pci:nouveau"	) echo "$(sensors nouveau-* | grep 'temp1:' | awk '{print $2}'|head -n1| tr -s '.,+' ' ' |sed -e 's/.*: //'| awk '{print $1}')";;
		"pci:nvidia"	) nvidia-settings -q gpucoretemp -t|head -n1;;
		"pci:fglrx"	) echo "$(aticonfig --adapter=0 --od-gettemperature | grep 'Sensor' | awk $NF '{print$(NF-1)}' | sed 's/.$//')";;
		"pci:radeon"	) echo "$(sensors | sed -n -e '/radeon/,/temp/ p' | grep temp1 | awk '{print $2}' | sed -e 's/+//g')";;
		*		) echo "N/A" ;;
	esac
}


GPU_Fan() {
	GPU_module=`ls /sys/class/drm/card0/device/driver/module/drivers`
	case "$GPU_module" in
		"pci:nouveau"	) echo "N/A" ;;
		"pci:nvidia"	) echo "$(nvidia-settings -q fans|head -n1) %" ;;
		"pci:fglrx"	) echo "$(aticonfig --pplib-cmd 'get fanspeed 0' | grep 'Result' | awk '{print $4}')" ;;
		"pci:radeon"	) echo "N/A" ;;
		*		) echo "N/A" ;;
	esac
}

Begin $@
