#!/bin/bash

SECONDS=0

source_folder=/media/BACKUP/urbackup
dest=uz@joaopaulomenegatti.ddns.net
dest_folder=/mnt/UZ

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
     echo "rsync -aAv --delete-delay --exclude=emails_desligados --exclude=emails_semuso $source_folder/$volume/${backupList[-1]}/ $dest:$dest_folder/$volume"
     # removi a compressao -aAvz pois a versao nova do rsync da origem estava dando problema com a versao velha do destino
     rsync -aAv --delete-delay --exclude=emails_desligados --exclude=emails_semuso $source_folder/$volume/${backupList[-1]}/ $dest:$dest_folder/$volume
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
