#!/bin/bash

################################################################
# 
# Autostart setting
# 
# usage: ./autostart.sh --on/--off
#
#
# @author Dr. Takeyuki UEDA
# @copyright Copyright© Atelier UEDA 2018 - All rights reserved.
#
CMD=view
SCRIPT_DIR=$(cd $(dirname $0); pwd)
#echo $cwd

usage_exit(){
  echo "Usage: $0 [--on]/[--off]" 1>&2
  echo "  [--on]:               Set autostart as ON. " 			1>&2
  echo "  [--off]:              Set autostart as OFF. " 		1>&2
  echo "  [--status]:           Show current status. " 		  1>&2
  exit 1
}

on(){
	sed -i "s@^ExecStart=.*@ExecStart=${SCRIPT_DIR}/${CMD}.sh@" ${SCRIPT_DIR}/view.service
	sudo ln -s ${SCRIPT_DIR}\/view.service /etc/systemd/system/view.service
	sudo systemctl daemon-reload
	sudo systemctl enable view.service
	sudo systemctl start view.service
	sudo ln -s ${SCRIPT_DIR}\/view.timer /etc/systemd/system/view.timer
	sudo systemctl enable view.timer
	sudo systemctl start view.timer
}

off(){
	sudo systemctl stop view.service
	sudo systemctl disable view.service
	sudo systemctl stop view.timer
	sudo systemctl disable view.timer
}

status(){
	sudo systemctl status ${CMD}.service
	sudo systemctl status ${CMD}.timer
}

while getopts ":-:" OPT
do
  case $OPT in
    -)
				case "${OPTARG}" in
					on)
								on
								;;
					off)
								off
								;;
					status)
								status
								;;
				esac
				;;
    \?) usage_exit
        ;;
  esac
done
