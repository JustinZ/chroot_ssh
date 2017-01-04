#!/bin/bash
#script checks DRBD status on a host
drbd_status=`/sbin/drbdsetup status |sed -n '1 p'|cut -d : -f2`
if [ $drbd_status ];then
  if [ $drbd_status=='Primary' ] || [ $drbd_status=='Secondary' ]; then
    echo "drbd_node_status=$drbd_status";
  fi
  else
    echo 'unknown DRBD status, please verify DRBD service is functioning properly';
fi
