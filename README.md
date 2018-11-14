# view
Take a Camera Image &amp; send to [MONITOR](https://monitor.uedasoft.com) server

<img src="https://2.bp.blogspot.com/-8CMvYEOuTHQ/W5TLvCskH2I/AAAAAAAAAlU/Sa6NpowqP6c4LHc9ugB4ptble9jM8v9kQCLcBGAs/s1600/2018-09-09%2B14.32.32.jpg" width="18%">
<img src="https://1.bp.blogspot.com/-d4U3cNRTDnw/W5TUf6tNFZI/AAAAAAAAAmI/ouhvzpklIf0W9Xv2TOC8gv5_cd1ip6GKQCEwYBhgL/s1600/2018-09-09%2B14.35.28.jpg" width="48%">
<img src="https://2.bp.blogspot.com/-YK5AM3oT8ko/W5TMuSoknsI/AAAAAAAAAls/ZP3Fk2QNLKU86yiXuqkW6Lei1OVcGFA3QCEwYBhgL/s1600/2018-09-09%2B14.37.10.png" width="28%">

This ***view*** module provide 3 features:
- view.sh: Take Camera Image & send to the [MONITOR](https://monitor.uedasoft.com) server
- autostart.sh: RUn view.sh at 5 minutes interval.
- hdc_autostart.sh: Run view.sh with outside event by GPIO, like PIR(Passive Infra-Red) Human detection Sensor.

## 1. Install
download from [release](https://github.com/UedaTakeyuki/view/releases)

or 

```
git clone https://github.com/UedaTakeyuki/view.git
```

## 2. 2etup
Install & setup prerequired modules by

```
./setup.sh 
```

## 3. Get free acount of MONITOR™ service
By Web Browser, Sign up to MONITOR™ Service at [here](https://monitor3.uedasoft.com/index.mdl.php). Following Quick Start document of [Sign up to Monitor](https://monitor.uedasoft.com/docs/UserGuide/Signup.html) might be informative.

## 4. confirm your view_id on the MONITOR™
Sign up/in to MONITOR™ and confirm your view_id on the top page as follows:
<img src="https://monitor.uedasoft.com/docs/UserGuide/pics/2018-08-19.12.39.26.png" width="30%">

## 5. set view_id
Return back to view on the console, set view_id mentioned above by ***setid.sh*** command.
Let's say your view_id is axwdjqwy as above picture, set it by setid.sh as

```
./setid.sh axwdjqwy
```

## 6. test

###Test to take & send photo

After view_id setting is finished, you can take & send photo by following command.

```
./view.sh
```

You may see following sequence of log
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

At the last line, ***{"ok":true}*** indicate that take & send photo are successfully finished. By Web Browser, you can see the MONITOR™ display is updated by your taken & sent photo.

<img src="https://monitor.uedasoft.com/docs/UserGuide/pics/2018-09-03.16.32.22.png" width="30%">

In case something wrong, response finished with {"ok":false,"reason":"XXX"}. For Example:

```
{"ok":false,"reason":"ViewID not valid"}
```

In this case, you should make sure if correct view_is was set by setid.sh command.

### Debug

In case your MONITOR™ display is NOT updated, try view.sh command with test option

```bash:
./view.sh test
```

With test option, view.sh doesn't use WebCam. Instead, view.sh send a Rainbow test bars. In case Rainbow bars are shown on your MONITOR™ display, at least network connection between your device and MONITOR™ server is working well. In case still NOT update, please confirm network connection on your device.

Then, try view.sh command again with keep option

```bash:
./view.sh keep
```

With keep option, view.sh doesn't remove a photo even after send and keep it on the folder "/tmp" with the filename consist of date & time like as ***/tmp/20181114201302.jpg***.
So, please check this .jpg file. If this file seems to be broken, also confirm your WebCam device is working well or not.

## 7. setting for automatically run view.sh at 5 minute interval

You can set that view.sh is called repeatedly at 5 minute interval after device is turned on by autostart.sh command as follows:

```
# set autostart on
./autostart.sh --on

# set autostart off
./autostart.sh --off
```

Tecknically speaking, autostart.sh set timer service of systemctl for view.sh. Incase you are familiar with crontab, it's OK to set view.sh on the cron yourself instead of using autostart command.

You can confirm current status with --status option:

```
./autostart.sh --status
```

You may see following sequence:

```
pi@raspberrypi:~/view-v_1.1.1 $ sudo systemctl status view.service 
● view.service - Take photos & Post to the monitor
   Loaded: loaded (/home/pi/view/view.service; enabled; vendor preset: enabled)
   Active: activating (auto-restart) since Wed 2018-11-14 20:42:26 JST; 5s ago
  Process: 7057 ExecStart=/home/pi/view/view.sh (code=exited, status=0/SUCCESS)
 Main PID: 7057 (code=exited, status=0/SUCCESS)
● view.timer - Take photos & Post to the monitor
   Loaded: loaded (/home/pi/view/view.timer; enabled; vendor preset: enabled)
   Active: active (waiting) since Wed 2018-11-14 18:38:51 JST; 2h 3min ago

Nov 14 18:38:51 raspberrypi systemd[1]: Started Take photos & Post to the monito
```

Then please quit this command by type "q" key.

In case afte service set as off, you can see followings:
```
Unit view.service could not be found.
Unit view.timer could not be found.
```

## 8. setting for automatically run view.sh with outside event by GPIO, like PIR(Passive Infra-Red) Human detection Sensor.

Instead of periodical running menttioned above step 5, you can set [GPIO Event trigger](https://github.com/UedaTakeyuki/view/wiki/GPIO-Event-trigger)  by ***hdc.sh***. hdc.sh runs as event loop to wach GPIO level change and kick ***view.sh***. You can also set hdc.sh as service by ***hdc_autostart.sh*** as follows. 

```
# set autostart on
./hdc_autostart.sh --on

# set autostart off
./hdc_autostart.sh --off
```

You can confirm current status with --status option:

```
./hdc_autostart.sh --status
```

You may see following sequence:

```
● view.service - Take photos & Post to the monitor
   Loaded: loaded (/home/pi/view/view.service; enabled; vendor preset: enabled)
   Active: activating (auto-restart) since Wed 2018-11-14 21:01:52 JST; 25s ago
  Process: 7947 ExecStart=/home/pi/view/view.sh (code=exited, status=0/SUCCESS)
 Main PID: 7947 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/view.service
```

In case afte service set as off, you can see followings:
```
pi@raspberrypi:~/view $ ./hdc_autostart.sh --status
Unit view.service could not be found.
```

### 8.1 Example usage of PIR (Passive Infrared Ray) Human Detection Sensor
- [Blog Post](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-human-detection-security.html).
- [wiki](https://github.com/UedaTakeyuki/view/wiki/PIR-(Passive-Infrared-Ray)-Human-Detection-Sensor)


## 9. Blog posts

#### for version 1.2.0 or later
- [How to make Human Detection Security camera with under 1$ Human Detection Senser, 2$ USB Webam & Raspberry Pi](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-human-detection-security.html)

#### for version 1.1.1 or later
- [How to make Security camera with 2$ USB Webam & Raspberry Pi](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-security-camera-with-2-usb.html)
- [How to make Security camera with 2$ USB Webam & Beagle Bone Green 
](https://monitorserviceatelierueda.blogspot.com/2018/09/how-to-make-security-camera-with-2-usb_18.html)

#### for general
- [What is MONITOR?](https://monitorserviceatelierueda.blogspot.com/p/monitor.html)

## 10. Q&A
Any questions, suggestions, reports are welcome! Please make [issue](https://github.com/UedaTakeyuki/view/issues) without hesitation! 

## 11. history
- 1.0.0  2018.08.07  first version self-forked from [read.py](https://github.com/UedaTakeyuki/slider/blob/master/read.py).
- 1.1.1  2018.08.23  Stable version
- 1.2.0  2018.09.18  Add hdc (human detection camera)
- 1.3.0  2018.11.14  Add -test and -keep option to view.sh, --status option to autstart.sh
