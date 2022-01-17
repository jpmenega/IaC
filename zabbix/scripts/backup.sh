#!/bin/bash +x
BACKUP_MOUNT_POINT=/mnt/backup
BACKUP_MYSQL=$BACKUP_MOUNT_POINT/zabbix_mysql.sql.gz
BACKUP_ZABBIX=$BACKUP_MOUNT_POINT/zabbix_zabbix.sql.gz

BACKUP_LOG=/var/lib/mysql/backup_zabbix.log

MOUNT_BKP="//192.168.20.6/Backup"
MOUNT_USERNAME=zabbix
MOUNT_PASSWORD=Z@bbixBkp

BACKUP_RETENTION=7
MYSQL_IP_ADDRESS=<mysql_vip_ip>

# ------------------------
ERROR_COUNT=0

rotate_backup()
{
  bkp_file=$1
  bkp_retention=$2
  bkp_log=$3

  #Removing out of retention files
  c=$bkp_retention
  while [ -f "$bkp_file.$c" ]
  do
     echo "$(date): Removing out of retention file: $bkp_file.$c" >> $bkp_log
     rm $bkp_file.$c
     c=$((c+1))
  done

  #Rotating retention files
  for (( c=$bkp_retention-1; c>0 ; c-- ))
  do
     if [ -f "$bkp_file.$c" ]; then
       echo "$(date): Rotating retention file: $bkp_file.$c" >> $bkp_log
       cNew=$((c+1))
       mv $bkp_file.$c $bkp_file.$cNew
     fi
  done

  #Rotating last retention file
  if test -f "$bkp_file"; then
    echo "$(date): Rotating retention file: $bkp_file" >> $bkp_log
    cNew=1
    mv $bkp_file $bkp_file.$cNew
  fi

}

#MAIN

#Create folder, if not exist
mkdir -p $BACKUP_MOUNT_POINT

#Check if is the active MySQL server
if ip addr show | grep -q "$MYSQL_IP_ADDRESS"; then
  echo "$(date): Start backup" > $BACKUP_LOG
  if (grep -qs '$BACKUP_MOUNT_POINT ' /proc/mounts;) then
    umount $BACKUP_MOUNT_POINT
  fi
  mount -t cifs -o username=$MOUNT_USERNAME,password=$MOUNT_PASSWORD $MOUNT_BKP $BACKUP_MOUNT_POINT
  if [ $? = 0 ];then
    #Start zabbix database backup
    echo "$(date): Backup zabbix database" >> $BACKUP_LOG
    /usr/bin/mysqldump -u root zabbix | gzip > $BACKUP_ZABBIX.temp
    if [ $? = 0 ];then
      #Rotate zabbix database backups
      rotate_backup $BACKUP_ZABBIX $BACKUP_RETENTION $BACKUP_LOG

      mv $BACKUP_ZABBIX.temp $BACKUP_ZABBIX
    else
      echo "$(date): ERROR backup zabbix database" >> $BACKUP_LOG
      ERROR_COUNT=$((ERROR_COUNT+1))
    fi

    #Start mysql database backup
    echo "$(date): Backup mysql database" >> $BACKUP_LOG
    /usr/bin/mysqldump -u root mysql | gzip > $BACKUP_MYSQL.temp
    if [ $? = 0 ];then
      #Rotate mysql database backups
      rotate_backup $BACKUP_MYSQL $BACKUP_RETENTION $BACKUP_LOG

      mv $BACKUP_MYSQL.temp $BACKUP_MYSQL
    else
      echo "$(date): ERROR backup mysql database" >> $BACKUP_LOG
      ERROR_COUNT=$((ERROR_COUNT+1))
    fi

    umount $BACKUP_MOUNT_POINT
  else
    echo "$(date): Can't mount backup destination" >> $BACKUP_LOG
    ERROR_COUNT=$((ERROR_COUNT+1))
  fi

  #Results
  if [ $ERROR_COUNT = 0 ]; then
    echo "$(date): Random $[ 1 + $[ RANDOM % 1000 ]]" >> $BACKUP_LOG
    echo "$(date): Status = OK" >> $BACKUP_LOG
  else
    echo "$(date): Random $[ 1 + $[ RANDOM % 1000 ]]" >> $BACKUP_LOG
    echo "$(date): Status = ERROR" >> $BACKUP_LOG
  fi
fi
