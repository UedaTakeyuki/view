#!/bin/bash

function usage() {
cat <<_EOT_
Usage:
  $0 [your_view_id]
Description:
  Set [your_view_id]
Options:
_EOT_
exit 1
}

if [ $# -ne 1 ]; then
  usage
fi

sed -i "s/^your_view_id=.*/your_view_id=$1/" view.sh
#sed -i "s#^ExecStart=.*#ExecStart=`pwd`/loop.sh#" view.service 
#sed -i "s#^ExecStart=.*#ExecStart=`pwd`/hdc.sh#" hdc.service 
