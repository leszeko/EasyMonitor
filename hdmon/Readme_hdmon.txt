hdmon, a superkaramba theme that displays I/O disks activity 
and temperatures of drives

by iten (iten at free dot fr) 2004
--------------------------------------------------------------------------------
Requirements: 

1. a 2.6 kernel (with /sys directory)

2. hddtemp (http://coredump.free.fr/linux/hddtemp.php)
   Note that not all drives are supported and that hddtemp used in this theme
   will prevent monitored hardrives to enter in sleep mode.

   WARNING: Don't change the intervall value for hddtemp calls in the theme file
            too many hddtemp requests at a too high frequence could maybe 
	    have wrong eifects.
   
   hddtemp is normally run as root. To be allowed to use hddtemp as a normal
   user, root needs to: chmod a+s /usr/sbin/hddtemp. 
   Please note that this is probably not a good security practice.
   
   to test if your hardrive is supported, try: hddtemp /dev/hdx
   
3. if using qt-3.3, a superkaramba with fix of "bar" bug 
   (see at the end of this file how to fix it)
--------------------------------------------------------------------------------
Setup:

1. compile the hdmon binary with the following command:
    make

2. edit hdmon.theme and setup the path of the hdmon binary with the current
   directory.
   
3. put the drive names you want to be monitored
--------------------------------------------------------------------------------
Setup example:
 
 1. mkdir -p $HOME/utils/superkaramba-themes
 
 2. cp 11814-hdmon.tgz $HOME/utils/superkaramba-themes
 
 3. cd $HOME/utils/superkaramba-themes
 
 4. tar zxvf 11814-hdmon.tgz
 
 5. cd hdmon
 
 6. make
 
 7. edit hdmon.theme and replace all occurences of:
     ./hdmon 
    with 
      $HOME/utils/superkaramba-themes/hdmon/hdmon

    ( replace in the last sentence $HOME with the explicit path of your 
     home directory, since I'm not sure that superkaramba knows to substitute 
     shell variables )
 
 8. replace all occurences of hde, hdf, hdh with the drives 
    names to be monitored
 
 9. if your hardrive is not supported by hddtemp, or if you don't want 
    temperatures to be displayed, comment the two lines of each blocks that
    are preceeded by: # temp
 
 10. superkaramba $HOME/utils/superkaramba-themes/hdmon/hdmon.theme

--------------------------------------------------------------------------------
There is a qt3.3 superkaramba-33 bug with "bars" widget.
 
 The fix is to edit the superkaramba-0.33/src/bar.cpp and at line 88 add:

 v.remove('\n');

 like this:

 void Bar::setValue( QString v )
 {
 v.remove('\n');
 setValue( (int) (v.toDouble() + 0.5 ) );
 }

