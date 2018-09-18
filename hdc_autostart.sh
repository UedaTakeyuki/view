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
  exit 1
}

on(){
	sed -i "s@^ExecStart=.*@ExecStart=${SCRIPT_DIR}/hdc.sh@" ${SCRIPT_DIR}/hdc.service
	sudo ln -s ${SCRIPT_DIR}\/hdc.service /etc/systemd/system/hdc.service
	sudo systemctl daemon-reload
	sudo systemctl enable hdc.service
	sudo systemctl start hdc.service
}

off(){
	sudo systemctl stop hdc.service
	sudo systemctl disable hdc.service
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
				esac
				;;
    \?) usage_exit
        ;;
  esac
done
