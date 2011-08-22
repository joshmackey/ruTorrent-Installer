#!/bin/bash

apt-get install -y screen subversion gcc build-essential libtool lighttpd php5-cgi automake1.11 openssl libcurl3 libcurl3-dev libsigc++-2.0-0c2a libsigc++-2.0-dev libncurses5 libncurses5-dev php-xml-rss

svn co http://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/advanced xmlrpc-c
cd xmlrpc-c
./configure
make
make install
cd ..
rm xmlrpc-c -rf

wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.12.9.tar.gz
tar zxvf libtorrent-0.12.9.tar.gz
cd libtorrent-0.12.9
./configure
make
make install

cd ..
rm libtorrent-0.12.9 -rf
rm libtorrent-0.12.9.tar.gz

wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.8.9.tar.gz
tar zxvf rtorrent-0.8.9.tar.gz
cd rtorrent-0.8.9
./configure --with-xmlrpc-c=/usr/local/bin/xmlrpc-c-config
make
make install

cd ..
rm rtorrent-0.8.9 -rf
rm rtorrent-0.8.9.tar.gz

adduser -q --disabled-login --gecos rt rt
usermod -aG tty rt

cd /home/rt/
wget https://raw.github.com/joshmackey/ruTorrent-Installer/master/rtorrent.rc
mv rtorrent.rc .rtorrent.rc
mkdir .rtsession
mkdir torrents
cd torrents
mkdir done
mkdir doing

chown -R rt:rt /home/rt

lighty-enable-mod fastcgi 
lighty-enable-mod fastcgi-php

cd /var/www
svn co http://rutorrent.googlecode.com/svn/trunk/rutorrent

cd rutorrent
mv ./* ../
cd ..
rmdir rutorrent

chown www-data:www-data * -R

wget https://raw.github.com/joshmackey/ruTorrent-Installer/master/lighttpd.conf
mv lighttpd.conf /etc/lighttpd/

service lighttpd restart


echo "include /usr/local/lib" >> /etc/ld.so.conf
ldconfig

wget https://raw.github.com/joshmackey/ruTorrent-Installer/master/rtorrent
mv rtorrent /etc/init.d/
update-rc.d rtorrent defaults 25

chmod +x /etc/init.d/rtorrent
/etc/init.d/rtorrent start
