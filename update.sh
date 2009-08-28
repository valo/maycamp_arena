#!/bin/bash -verbose
cd /home/spoj0
sudo -u spoj0 svn update
./spoj0-control.pl stop
/etc/init.d/apache2 force-reload
./spoj0-control.pl start