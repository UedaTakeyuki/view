# view
Take a Camera Image &amp; send to [MONITOR](https://monitor.uedasoft.com) server

<img src="https://2.bp.blogspot.com/-8CMvYEOuTHQ/W5TLvCskH2I/AAAAAAAAAlU/Sa6NpowqP6c4LHc9ugB4ptble9jM8v9kQCLcBGAs/s1600/2018-09-09%2B14.32.32.jpg" width="18%">
<img src="https://1.bp.blogspot.com/-d4U3cNRTDnw/W5TUf6tNFZI/AAAAAAAAAmI/ouhvzpklIf0W9Xv2TOC8gv5_cd1ip6GKQCEwYBhgL/s1600/2018-09-09%2B14.35.28.jpg" width="48%">
<img src="https://2.bp.blogspot.com/-YK5AM3oT8ko/W5TMuSoknsI/AAAAAAAAAls/ZP3Fk2QNLKU86yiXuqkW6Lei1OVcGFA3QCEwYBhgL/s1600/2018-09-09%2B14.37.10.png" width="28%">

This ***view*** module provide 3 features:
- view.sh: Take Camera Image & send to the [MONITOR](https://monitor.uedasoft.com) server
- autostart.sh: RUn view.sh at 5 minutes interval.
- hdc_autostart.sh: Run view.sh with outside event by GPIO, like PIR(Passive Infra-Red) Human detection Sensor.

## 1. install
download from [release](https://github.com/UedaTakeyuki/view/releases)

or 

```
git clone https://github.com/UedaTakeyuki/view.git
```

## 2. setup
Setup environment & install prerequired modules by

```
./setup.sh 
```

## 3. set view_id
Make sure your view_id on your account of the MONITOR, let's say it was ABCDEF, set it by setid.sh as

```
./setid.sh ABCDEF
```

## 4. test

```
./view.sh
```

In case everything succeeded, expected response is consist of the log of taking photo, sending it, and {"ok":true} as follows:

```
--- Opening /dev/video0...
Trying source module v4l2...
/dev/video0 opened.
No input was specified, using the first.
Delaying 1 seconds.
--- Capturing frame...
Skipping 20 frames...
Capturing 1 frames...
Captured 21 frames in 0.67 seconds. (31 fps)
--- Processing captured image...
Writing JPEG image to '/tmp/20180823190339.jpg'.
{"ok":true}
```

In case something wrong, response finished with {"ok":false,"reason":"XXX"}. For Example:

```
{"ok":false,"reason":"ViewID not valid"}
```

In case, you should make sure if correct view_is was set by setid.sh command.

## 5. setting for automatically run view.sh at 5 minute interval

You can do it both by setting crontab if you're used to do so, or you can use autostart.sh command as follows:

```
# set autostart on
./autostart.sh --on

# set autostart off
./autostart.sh --off
```

Tecknically speaking, autostart.sh doesn't use crontab, instead, prepare service for interval running of view.sh named view.service .
You can confirm current status of view.service with following command:

```
sudo systemctl status view.service
```

In case view.service is running, you can see the log of current status and taking & sending photo as follows:
```
pi@raspberrypi:~/view-v_1.1.1 $ sudo systemctl status view.service 
● view.service - Take photos & Post to the monitor
   Loaded: loaded (/home/pi/view-v_1.1.1/view.service; enabled; vendor preset: e
   Active: active (running) since Thu 2018-08-23 19:07:24 JST; 4min 40s ago
 Main PID: 777 (loop.sh)
   CGroup: /system.slice/view.service
           ├─777 /bin/bash /home/pi/view-v_1.1.1/loop.sh
           └─820 sleep 5m

Aug 23 19:07:26 raspberrypi loop.sh[777]: --- Capturing frame...
Aug 23 19:07:26 raspberrypi loop.sh[777]: Skipping 20 frames...
Aug 23 19:07:28 raspberrypi loop.sh[777]: Capturing 1 frames...
Aug 23 19:07:28 raspberrypi loop.sh[777]: Captured 21 frames in 1.73 seconds. (1
Aug 23 19:07:28 raspberrypi loop.sh[777]: --- Processing captured image...
Aug 23 19:07:29 raspberrypi loop.sh[777]: Writing JPEG image to '/tmp/2018082319
Aug 23 19:07:29 raspberrypi loop.sh[777]:   % Total    % Received % Xferd  Avera
Aug 23 19:07:29 raspberrypi loop.sh[777]:                                  Dload
Aug 23 19:07:53 raspberrypi loop.sh[777]: [2.0K blob data]
Aug 23 19:07:53 raspberrypi loop.sh[777]:      0
lines 1-18/18 (END)
```

In case afte service set as off, you can see followings:
```
pi@raspberrypi:~/view-v_1.1.1 $ sudo systemctl status view.service 
Unit view.service could not be found.
```
## 6. setting for automatically run view.sh with outside event by GPIO, like PIR(Passive Infra-Red) Human detection Sensor.

Instead of periodical running menttioned above step 5, you can set [GPIO Event trigger](https://github.com/UedaTakeyuki/view/wiki/GPIO-Event-trigger)  by ***hdc.sh***. hdc.sh runs as event loop to wach GPIO level change and kick ***view.sh***. You can also set hdc.sh as service by ***hdc_autostart.sh*** as follows. 

```
# set autostart on
./hdc_autostart.sh --on

# set autostart off
./hdc_autostart.sh --off
```

You can confirm current status of view.service with following command:

```
sudo systemctl status hdc.service 
```

In case hdc.service is running, you can see the log of current status and taking & sending photo as follows:
```
pi@raspberrypi:~ $ sudo systemctl status hdc.service 
● hdc.service - Take photos & Post to the monitor
   Loaded: loaded (/home/pi/view-v_1.2.1/hdc.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-09-18 21:17:28 JST; 13h ago
 Main PID: 388 (hdc.sh)
   CGroup: /system.slice/hdc.service
           ├─ 388 /bin/sh /home/pi/view-v_1.2.1/hdc.sh
           └─7256 sleep 1s

Sep 19 10:18:06 raspberrypi hdc.sh[388]: Delaying 1 seconds.
Sep 19 10:18:07 raspberrypi hdc.sh[388]: --- Capturing frame...
Sep 19 10:18:07 raspberrypi hdc.sh[388]: Skipping 20 frames...
Sep 19 10:18:08 raspberrypi hdc.sh[388]: Capturing 1 frames...
Sep 19 10:18:08 raspberrypi hdc.sh[388]: Captured 21 frames in 0.66 seconds. (31 fps)
Sep 19 10:18:08 raspberrypi hdc.sh[388]: --- Processing captured image...
Sep 19 10:18:09 raspberrypi hdc.sh[388]: Writing JPEG image to '/tmp/20180919101806.jpg'.
Sep 19 10:18:09 raspberrypi hdc.sh[388]:   % Total    % Received % Xferd  Average Speed   Ti
Sep 19 10:18:09 raspberrypi hdc.sh[388]:                                  Dload  Upload   To
Sep 19 10:18:13 raspberrypi hdc.sh[388]: [474B blob data]```

In case afte service set as off, you can see followings:
```
pi@raspberrypi:~/view-v_1.2.1 $ sudo systemctl status hdc.service 
Unit hdc.service could not be found.
```

### 6.1 Example usage of PIR (Passive Infrared Ray) Human Detection Sensor
- [Blog Post](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-human-detection-security.html).
- [wiki](https://github.com/UedaTakeyuki/view/wiki/PIR-(Passive-Infrared-Ray)-Human-Detection-Sensor)


## Blog posts
- [How to make Security camera with 2$ USB Webam & Raspberry Pi](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-security-camera-with-2-usb.html)
- [How to make Security camera with 2$ USB Webam & Beagle Bone Green](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-security-camera-with-2-usb_18.html)
- [What is MONITOR?](https://monitorserviceatelierueda.blogspot.com/p/monitor.html)

## Q&A
Any questions, suggestions, reports are welcome! Please make [issue](https://github.com/UedaTakeyuki/view/issues) without hesitation! 

