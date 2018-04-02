cat <<EOF
# That creates the files.xz archive 	: tar --xz -cf example.tar.xz file1 file2 file3 ;	or : tar --use-compress-program xz -cf example.tar.xz file1 file2 file3
# Which you can then unpack using	: tar --xz -xf example.tar.xz ;				or : tar --use-compress-program xz -xf example.tar.xz
# That creates the files.lzma archive 	: tar -cf files.lzma --lzma file* file* # -v  verbose option
# Which you can then unpack using	: tar -xf files.lzma
# That creates the files.tar.gz archive	: tar -czf files.tar.gz file* file*
# Which you can then unpack using	: tar -xzf files.tar.gz

# Backup witch preserve file atributes (do as root)	: cd Monunted_Partition; date; tar -cpzf /Destination/Distro.tar.gz *; date; echo " # Done #" 
# Restore witch preserve file atributes (do as root)	: cd Monunted_Partition; date; tar -xpzf /Destination/Distro.tar.gz; date; echo " # Done #"
# That creates the files.zip archive	: zip -r files.zip file* file*
# Which you can then unpack using	: unzip  files.zip
# That creates the files.cpio archive	: ls | cpio -ov > filws.cpio
# Which you can then unpack using	: cpio -idv < files.cpio
EOF
read -r -N1 -s -p "$Magenta Press key: continue $Reset" Sleep_key