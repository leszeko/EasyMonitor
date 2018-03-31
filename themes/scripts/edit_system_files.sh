#!/bin/bash
# edit_system_files.sh script

################# Variables for color terminal
Color_terminal_variables() {
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[01;34m'"" Magenta=""$'\033[00;35m'""
LGreen=""$'\033[01;32m'"" LRed=""$'\033[01;31m'"" LWhite=""$'\033[01;37m'"" LYellow=""$'\033[01;33m'"" LCyan=""$'\033[01;36m'"" LBlue=""$'\033[00;34m'"" LMagenta=""$'\033[01;35m'""
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[0;38;5;225m'"";Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[01;38;5;111m'"";LCream=""$'\033[1;38;5;225m'"";LOrange=""$'\033[1;38;5;202m'"";Blink=""$'\033[5m'""
if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
fi
Nline=""$'\n'"" Reset=""$'\033[0;0m'"" EraseR=""$'\033[K'"" Back=""$'\b'"" Creturn=""$'\033[\r'"" Ctabh=""$'\033[\t'"" Ctabv=""$'\033[\v'"" SaveP=""$'\033[s'"" RestoreP=""$'\033[u'""
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
}
Color_terminal_variables
#################
#if ! [ $(id -u) = 0 ]; then echo "$n$Orange This script must be run with root privileges.$Reset$n";exit 1;fi

echo "$n$Red Give administration password to edit: $Yellow$*$Reset"
bak_dir="/bak/$(whoami)"
echo "$n$Green Oginal copy will be in $Orange$bak_dir -$Yellow $*$Magenta -.org$n$Green Copy before this edit session is in $Orange$bak_dir -$Yellow $*$Magenta -.bak$Reset$n"

su -c "for file_name in $*; do \
if ! [ -d \$file_name ];\
then \
dest_dir=\$(dirname \$file_name);\
if ! [ -d \$dest_dir ];\
then echo \$(ls \$dest_dir);\
{ read -p \"Create \$dest_dir [y]es or [N]o:? \" -n 1;\
case \$(echo \$REPLY | tr '[A-Z]' '[a-z]') in y|yes) echo \" - Yes \"; mkdir -vp \$dest_dir ;; *) echo \" - No \" ;; esac ;};\
fi;\
fi;\
done;\
for file_name in $*; do \
if ! [ -d \$file_name ];\
then \
dest_dir=\$(dirname \$file_name);\
if [ -d \$dest_dir ]; then \
mkdir -p $bak_dir\$dest_dir;\
if [ \"\$(basename \$file_name)\" = '*' ]; then copy_files+=\$(ls \$(dirname \"\$file_name\"));else copy_files+=\"\$file_name \"; fi; else echo \$(ls \$dest_dir); exit 1;fi;\
fi;\
done;\
echo \$copy_files > $bak_dir/copy_files; chmod 666 $bak_dir/copy_files;\
for file_name in \$copy_files; do \
if [ -f \$file_name ]; then \
{ \
if ! [ -f $bak_dir\$file_name.org ]; then cp -fax \$file_name $bak_dir\$file_name.org; fi;\
cp -fax \$file_name $bak_dir\$file_name.bak;
cat \$file_name > $bak_dir\$file_name.edit; chmod 666 $bak_dir\$file_name.edit;\
};\
fi;\
if ! [ -f \$file_name ]; then echo \"$n$Orange file \$file_name do not exist, create !$Reset$n\"; echo \"## file \$file_name do not exist in system - create !\">$bak_dir\$file_name.edit; chmod 666 $bak_dir\$file_name.edit; fi;\
done"
[ $? = 0 ] || { sleep 8; exit;}

for file_name in $(cat $bak_dir/copy_files); do
edit_files+="$bak_dir$file_name.edit "
done

kate -b $edit_files >/dev/null 2>&1

echo "$n$Red Give administration password to write back file:$n $Cyan$edit_files$Reset$n to:$n $Yellow$(cat $bak_dir/copy_files)$Reset$n"

su -c "for file_name in $(cat $bak_dir/copy_files); do \
cat $bak_dir\$file_name.edit > \$file_name; rm -f $bak_dir\$file_name.edit;\
done"
[ $? = 0 ] || { sleep 8; exit;}
echo "Done"
sleep 8
exit

