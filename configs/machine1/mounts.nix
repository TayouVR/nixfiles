{

  # File Stystems
  fileSystems."/mnt/data" =
   { device = "/dev/disk/by-uuid/03F19DAF20B3F598";
     fsType = "ntfs";
   };
  fileSystems."/mnt/media" =
   { device = "/dev/disk/by-uuid/FE561FA7561F5FA7";
     fsType = "ntfs";
   };
  fileSystems."/mnt/win10" =
   { device = "/dev/disk/by-uuid/4660E7FF60E7F419";
     fsType = "ntfs";
   };
  fileSystems."/mnt/win10_old" =
   { device = "/dev/disk/by-uuid/CE46DCF546DCDEF1";
     fsType = "ntfs";
   };
  fileSystems."/mnt/win7" =
   { device = "/dev/disk/by-uuid/19BBE1D72C7D6D07";
     fsType = "ntfs";
   };
  fileSystems."/mnt/linuxApps" =
   { device = "/dev/disk/by-uuid/35e4a507-0c0b-4524-86fb-796ea9684aab";
     fsType = "ext4";
   };
  fileSystems."/mnt/btrfs" =
   { device = "/dev/disk/by-uuid/62b8795c-2ef9-4976-1034-60d00a275f8f";
     fsType = "btrfs";
   };
  fileSystems."/mnt/BACKUP" =
   { device = "/dev/disk/by-uuid/78525CB8525C7CB6";
     fsType = "ntfs";
   };
  fileSystems."/mnt/BACKUP1" =
   { device = "/dev/disk/by-uuid/DA22C96F22C95165";
     fsType = "ntfs";
   };
  fileSystems."/mnt/WindowsApps" =
   { device = "/dev/disk/by-uuid/4EAE54E9AE54CADB";
     fsType = "ntfs";
   };
}