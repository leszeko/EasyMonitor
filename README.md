# Easy Monitor README.md
Easy Monitor is set of SuperKaramba themes and simple linux/gnu bash scripts.
by Leszek Ostachowski

1. Description

==============

Easy Monitor is set of SuperKaramba themes and simple linux/gnu bash scripts
Any of these themes you can edit and configure by lock its position and click on top frame of it
Most of scripts you can edit and configure by click on corresponding configure script button
My idea to give users very fast and easy access to change and fix code
Most of those bash scripts for tools can be used independently
So you can suit it to your system.

2. Important

============

If your theme based on my please, in accordance with licence GPL
in thanks to list write Mihael Simonic mention.
Easy Monitor theme is based on Crystal Monitor by Mihael Simonic (smihael@gmail.com)
Crystal Monitor by Mihael Simonic is theme based on Super-Cyber System Monitor
Thanks to icons, backgrounds and Super-Cyber System Monitor authors!
Speciality thanks to Tilman Vogel for pythonised Guess distro.
Thanks to Nicolas Perret for support ATI graphics card
Thanks to Iten (iten at free dot fr) 2004 hdmon.c source
Of course tanks to all Linux creators and open source writers
Thanks to all bugs reporting.

3. Installation

===============

Themes need SuperKaramba 0.37 and KDE 3.5x or higher or even any linux desktop

Can't find superkaramba package. Try install it manually !

Superkaramba is considered to be "legacy" and some new distros don't provide it in standard repos
So you have to look for it on your own.

Example:

https://pkgs.org/

https://software.opensuse.org/package/superkaramba

https://www.rpmfind.net/linux/rpm2html/search.php?query=superkaramba&submit=Search+...

http://rpm.pbone.net/index.php3/stat/2/simple/2

http://archive.archlinux.org/packages/k/kdeutils-superkaramba/

http://packages.linuxmint.com/search.php?release=any&section=any&keyword=superkaramba

http://ftp.de.debian.org/debian/pool/main/s/superkaramba/

https://packages.debian.org/unstable/kde/plasma-scriptengine-superkaramba

Or if you want to install it from the source package

http://netdragon.sourceforge.net/ssuperkaramba.html

__________________________________

* Fast installation - copy below lines to linux/gnu terminal for run.
__________________________________

Example installation EasyMonitor theme from sourceforge.net:
__________________________________

mkdir EasyMonitor_install

cd EasyMonitor_install

wget -O EasyMonitor.zip https://sourceforge.net/projects/easy-monitor/files/latest/download

unzip EasyMonitor.zip

rm -f EasyMonitor.zip

bash install_easy_monitor.sh

__________________________________

Example installation EasyMonitor from github.com
__________________________________

# * download/clone/update

mkdir -p ~/.superkaramba

mv ~/.superkaramba/EasyMonitor ~/.superkaramba/Easy_Monitor_$(date +%Y_%m_%d-%H_%M_%S)

cd ~/.superkaramba

git clone https://github.com/leszeko/EasyMonitor.git


# * if first time full install

cd EasyMonitor

bash install_easy_monitor.sh

__________________________________

Manuals are in ./doc folder

===========================

4. How you can help

===================

If you have idea comment
(easy.monitor.theme@gmail.com)
Or if you are irritated at my charming bugs :)
