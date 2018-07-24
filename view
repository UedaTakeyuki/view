#!/bin/bash
your_view_id=

filepath=/tmp/`date +%Y%m%d%H%M%S`.jpg
fswebcam $filepath -d /dev/video0 -D 1 -S 20 -r 320x240
curl https://monitor3.uedasoft.com/postpic.php -F viewid=$your_view_id -F upfile=@$filepath
rm $filepath
