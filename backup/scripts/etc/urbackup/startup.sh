#!/bin/bash
#iscsiadm --mode node --targetname iqn.2021-09.medlav.intranet:lun1 --portal 192.168.15.10 --login
#sleep 10
#mount -o "noatime" /dev/sda1 /media/BACKUP/urbackup/
[ ! -d "/media/BACKUP/urbackup/urbackup" ] exit 1
service urbackupsrv start
