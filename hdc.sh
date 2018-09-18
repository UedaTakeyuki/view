#!/bin/sh

#path
SCRIPT_DIR=$(cd $(dirname $0); pwd)

#Const
gpio=18       # use GPIO18
dulation=1    # poling interval (sec)

# gpio initialize
if [ ! -d /sys/class/gpio/gpio${gpio} ]
then
    echo $gpio > /sys/class/gpio/export
fi
value=/sys/class/gpio/gpio${gpio}/value # the value of the gpio
prev_value=`cat $value`

while :
do
  current_value=`cat $value`
  if [ ${prev_value} -eq 0 ]
  then
    if [ $current_value -eq 1 ]
    then
     $SCRIPT_DIR/view.sh
    fi
  fi
  prev_value=${current_value}
  sleep ${dulation}s
done
