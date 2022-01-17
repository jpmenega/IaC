#!/bin/bash

SECONDS=0

source_folder=/media/BACKUP/urbackup
dest=btrfs@joaopaulomenegatti.ddns.net
dest_folder=/mnt/UZ

#First sync UrBackup structure and own backup
echo "**************"
echo `date +%y-%m-%d_%H:%M` "Syncing UrBackup structure and own backup"
rsync -aAvz --delete-delay $source_folder/clients $dest:$dest_folder
[[ $? != 0 ]] && exit 1
rsync -aAvz --delete-delay $source_folder/urbackup $dest:$dest_folder
[[ $? != 0 ]] && exit 1
#rsync -aAvz --delete-delay $source_folder/urbackup_tmp_files $dest:$dest_folder
#[[ $? != 0 ]] && exit 1


# Volumes list
volumes=( $(ls -lah $source_folder|awk '{print $NF}'|grep -v total|grep -v clients|grep -v urbackup|grep -v PST) )
n_vol=0

# Sync each BTRS backup volume
for volume in "${volumes[@]}"
do
   #ignore . and ..
   if [[ $volume != "." && $volume != ".." ]]; then
     #check if volume is realy a folder
     if [ -d "$source_folder/$volume" ]; then
        #create folder in destiny if not exist
        ssh $dest mkdir -p $dest_folder/$volume

        #Sync BTFS volume
        echo "**************"
        echo `date +%y-%m-%d_%H:%M` "Syncing $volume volume"
        #/usr/local/sbin/btrfs-sync -d -v -Z $source_folder/$volume $dest:$dest_folder/$volume
        /usr/local/sbin/btrfs-sync -d -v $source_folder/$volume $dest:$dest_folder/$volume
        [[ $? != 0 ]] && exit 1
        ((n_vol+=1))
     fi
   fi
done
[[ $n_vol == 0 ]] && exit 1

# ----------------------

# Volumes list (PST)
volumes=( $(ls -lah $source_folder|awk '{print $NF}'|grep "[PST]") )

# Sync each BTRS backup volume
for volume in "${volumes[@]}"
do
   #check if volume is realy a folder
   if [ -d "$source_folder/$volume" ]; then
     # Get backup list to retrieve the last backup to sync
     backupList=( $(ls -lah $source_folder/$volume|awk '{print $NF}'|grep -v '^[.]') )

     #create folder in destiny if not exist
     ssh $dest mkdir -p $dest_folder/$volume

     echo "**************"
     echo `date +%y-%m-%d_%H:%M` "Syncing $volume last backup ${backupList[-1]}"
     rsync -aAvz --delete-delay --exclude=emails_desligados --exclude=emails_semuso $source_folder/$volume/${backupList[-1]}/ $dest:$dest_folder/$volume
     [[ $? != 0 ]] && exit 1
     ((n_vol+=1))
   fi
done
[[ $n_vol == 0 ]] && exit 1
echo "**************"
echo `date +%y-%m-%d_%H:%M` "Synced $n_vol with success!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo "Status = OK"
exit 0
