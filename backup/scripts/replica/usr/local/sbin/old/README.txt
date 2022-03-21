SERVIDOR DESTINO
- Criar usuario para o cliente (exemplo uz)
- Montar disco do cliente em /mnt/<cliente>
- Dar permissao na raiz do disco (exemplo chown <cliente>:<cliente> .)
- Adicionar usuario do cliente no sudoers para executar o btrfs (exemplo: uz      ALL=(ALL) NOPASSWD: /usr/bin/btrfs)




https://ownyourbits.com/2018/03/09/easy-sync-of-btrfs-snapshots-with-btrfs-sync/
https://blogs.oracle.com/linux/post/btrfs-sendreceive-helps-to-move-and-backup-your-data (NO FINAL TEM UM BLOCO POSSIVELMENTE MOSTRANDO UM SYNC INCREMENTAL)
https://davidshomelab.com/a-simple-unix-backup-script-utilising-rsync-and-btrfs/ (Dica Zabbix para script do sync)

SOURCE
sudo wget https://raw.githubusercontent.com/nachoparker/btrfs-sync/master/btrfs-sync -O /usr/local/sbin/btrfs-sync
sudo chmod +x /usr/local/sbin/btrfs-sync
apt install pv (progress view)


BOTH
sudo adduser btrfs
apt install pbzip2 (compress)

SOURCE
sudo -u btrfs ssh-keygen
sudo -u btrfs ssh-copy-id btrfs@<ip_remote>

BOTH
visudo /etc/sudoers.d/90_btrfs-sync
  btrfs ALL=(root:nobody) NOPASSWD:NOEXEC: /bin/btrfs

SOURCE
*Add btrfs user to urbackup group
su - urbackup
cd /media/BACKUP/urbackup/
------

==>>> /usr/local/sbin

rsync -aAvz --delete-delay /media/BACKUP/urbackup/clients btrfs@192.168.20.5:/mnt/UZ
rsync -aAvz --delete-delay /media/BACKUP/urbackup/urbackup btrfs@192.168.20.5:/mnt/UZ
rsync -aAvz --delete-delay /media/BACKUP/urbackup/urbackup_tmp_files btrfs@192.168.20.5:/mnt/UZ
/usr/local/sbin/btrfs-sync -d -v -Z '/media/BACKUP/urbackup/firebird' btrfs@192.168.20.5:'/mnt/UZ/urbackup/firebird'

------
mkdir .snapshots

btrfs subvolume snapshot -r /media/BACKUP/urbackup /media/BACKUP/urbackup/.snapshots/urbackup
/usr/local/sbin/btrfs-sync -d -v -Z '/media/BACKUP/urbackup/.snapshots/urbackup' btrfs@192.168.20.5:'/mnt/UZ/'
btrfs subvolume delete /media/BACKUP/urbackup/.snapshots/urbackup
(rodar no destino) btrfs property set -ts /mnt/UZ/urbackup ro false

/usr/local/sbin/btrfs-sync -d -v -Z '/media/BACKUP/urbackup/firebird' btrfs@192.168.20.5:'/mnt/UZ/urbackup/firebird'


//btrfs property set -ts /media/BACKUP/urbackup/ ro true
/usr/local/sbin/btrfs-sync -d -v -Z '/media/BACKUP/urbackup/' btrfs@192.168.20.5:'/mnt/UZ/'
//btrfs property set -ts /media/BACKUP/urbackup/ ro false
btrfs subvolume list /media/BACKUP/urbackup|awk '{print $NF}'|cut -d'/' -f 2

btrfs subvolume list /media/BACKUP/urbackup|awk '{print $NF}'|cut -d'/' -f 2

------------------------------




/usr/local/sbin/btrfs-sync --quiet --keep 1 --xz /media/BACKUP/urbackup/ btrfs@192.168.20.5:/mnt/UZ
/usr/local/sbin/btrfs-sync -v --xz /media/BACKUP/urbackup/.snapshots btrfs@192.168.20.5:/mnt/UZ
/usr/local/sbin/btrfs-sync -d -v -Z /media/BACKUP/urbackup/.snapshots btrfs@192.168.20.5:/mnt/UZ


btrfs subvolume delete /media/BACKUP/urbackup/.snapshots/replica
==> rsync -aAvz --delete-delay /media/BACKUP/urbackup/ btrfs@192.168.20.5:/mnt/UZ
==> rsync -aAvz --delete-delay /media/BACKUP/urbackup/.snapshots/replica/ btrfs@192.168.20.5:/mnt/UZ
==> rsync -aAvz --delete-before /media/BACKUP/urbackup/.snapshots/replica/ btrfs@192.168.20.5:/mnt/UZ
/usr/local/sbin/btrfs-sync -d -v -Z '/media/BACKUP/urbackup/Samba System/210903-0804' btrfs@192.168.20.5:'/mnt/UZ/teste'
btrfs subvolume list /media/BACKUP/urbackup|grep 210903-0804

btrfs subvolume create /media/BACKUP/urbackup/firebird-subvolume
mkdir /media/BACKUP/urbackup/firebird-subvolume/.snapshots
TF=`mktemp` && wget "http://192.168.1.245:55414/x?a=download_client&lang=en&clientid=18&authkey=oEVCqd4NFi&os=linux" -O $TF && sudo sh $TF; rm -f $TF

----------------------------------------
btrfs subvolume snapshot -r /media/BACKUP/urbackup/firebird-subvolume /media/BACKUP/urbackup/firebird-subvolume/.snapshots/replica_2021_09_11

