make:
	###########################################################################
	# Easy Monitor Makefile ; make zip archive in parent directory            #
	# and rename to EasyMonitor.skz for SuperKaramba                          #
	# * to run type - make in this directory * for clean type - make clean    #
	###########################################################################
	
	#rm -f ../EasyMonitor/Sudoers_Entries_for_Easy_Monitor.txt
	#rm -rf ../EasyMonitor/.jftgwh
	#zip -r ../EasyMonitor . 
	#mv ../EasyMonitor.zip ../EasyMonitor.skz
	bash ./skz_make.sh
clean:
	rm -f ../EasyMonitor.skz