{

  # File Stystems
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/03F19DAF20B3F598";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/FE561FA7561F5FA7";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/win10" = {
    device = "/dev/disk/by-uuid/4660E7FF60E7F419";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/win10_old" = {
    device = "/dev/disk/by-uuid/CE46DCF546DCDEF1";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/win7" = {
    device = "/dev/disk/by-uuid/19BBE1D72C7D6D07";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/linuxApps" = {
    device = "/dev/disk/by-uuid/35e4a507-0c0b-4524-86fb-796ea9684aab";
    fsType = "ext4";
  };
  fileSystems."/mnt/btrfs" = {
    device = "/dev/disk/by-uuid/62b8795c-2ef9-4976-1034-60d00a275f8f";
    fsType = "btrfs";
  };
  fileSystems."/mnt/BACKUP" = {
    device = "/dev/disk/by-uuid/78525CB8525C7CB6";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/BACKUP1" = {
    device = "/dev/disk/by-uuid/DA22C96F22C95165";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/WindowsApps" = {
    device = "/dev/disk/by-uuid/1FDC889B1C3ED0B2";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };
  fileSystems."/mnt/BACKUP_SSD" = {
    device = "/dev/disk/by-uuid/4EAE54E9AE54CADB";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=100" ];
  };

  # bind mounts
  fileSystems."/home/tayou/Downloads" = {
    device = "/mnt/BACKUP_SSD/Downloads";
    fsType = "none";
    options = [ "bind" "uid=1000" "gid=100" ];
  };
  fileSystems."/home/tayou/Music" = {
    device = "/mnt/media/Music";
    fsType = "none";
    options = [ "bind" "uid=1000" "gid=100" ];
  };
  fileSystems."/home/tayou/Pictures" = {
    device = "/mnt/media/Pictures";
    fsType = "none";
    options = [ "bind" "uid=1000" "gid=100" ];
  };
  fileSystems."/home/tayou/Videos" = {
    device = "/mnt/media/videos";
    fsType = "none";
    options = [ "bind" "uid=1000" "gid=100" ];
  };

}
