#!/bin/bash
#your_view_id=evpgqxwj
your_view_id=yplwnrwx

path=/tmp/`date +%Y%m%d%H%M%S`.jpg

function take_photo() {
	filepath=$1
	videodevice=$2
	width=$3
	hight=$4

	fswebcam $filepath -d $videodevice -D 1 -S 20 -r ${width}x${hight}	
}

if [[ $1 = "test" ]]; then
	take_photo $path TEST 320 240
else
	take_photo $path /dev/video0 320 240
fi
curl https://monitor3.uedasoft.com/postpic.php -F viewid=$your_view_id -F upfile=@$filepath
#curl https://klingsor.uedasoft.com/tools/dev/monitor3/postpic.php -F viewid=$your_view_id -F upfile=@$filepath

if [[ $1 != "keep" ]]; then
	rm $path
fi
exit 0
