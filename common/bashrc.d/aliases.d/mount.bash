alias lsblk='lsblk -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINT'
alias lsblk+u='lsblk -o NAME,MODEL,SIZE,FSTYPE,LABEL,UUID,TYPE,MOUNTPOINT'
alias lsblk+t='lsblk -o NAME,TRAN,HOTPLUG,RO,SIZE,FSTYPE,LABEL,MODEL,MOUNTPOINT'
alias disks='lsblk -d -o NAME,TRAN,ROTA,SIZE,MODEL'
alias lsrem='lsblk -o NAME,HOTPLUG,TRAN,SIZE,MODEL,MOUNTPOINT | awk "$2==1"'
alias mnt='findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS,SIZE,USED,AVAIL'
alias mount='mount | grep -v "/docker/"'
alias uuid='blkid -o full'
alias uuids='blkid -o value -s UUID'
alias labels='lsblk -o NAME,LABEL,UUID'
usbdrives()   { lsblk -o NAME,TRAN,SIZE,MODEL | grep usb; }
nvmedrives()  { lsblk -o NAME,TRAN,SIZE,MODEL | grep nvme; }
satadrives()  { lsblk -o NAME,TRAN,SIZE,MODEL | grep sata; }

# alias mount-missing='sudo awk '"'"'
#   # Skip comments and empty lines
#   $1 !~ /^#/ && NF >= 2 {
#     device=$1
#     mountpoint=$2
#     # Check if mountpoint exists
#     if (system("[ -d \"" mountpoint "\" ]") == 0) {
#       # Check if already mounted
#       if (system("findmnt -rno TARGET \"" mountpoint "\" >/dev/null 2>&1") != 0) {
#         print "Mounting " device " on " mountpoint
#         system("mount \"" mountpoint "\"")
#       }
#     }
#   }
# '"'"' /etc/fstab'
mount-missing() {
  sudo awk '
    # Skip comments and empty lines; require at least device + mountpoint
    $1 !~ /^#/ && NF >= 2 {
      device=$1
      mountpoint=$2

      # Check if mountpoint exists
      if (system("[ -d \"" mountpoint "\" ]") == 0) {

        # Check if already mounted
        if (system("findmnt -rno TARGET \"" mountpoint "\" >/dev/null 2>&1") != 0) {
          print "Mounting " device " on " mountpoint
          system("mount \"" mountpoint "\"")
        }
      }
    }
  ' /etc/fstab
}
