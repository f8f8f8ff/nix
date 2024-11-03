{ config, pkgs, ... }:
{
  networking.hostId = "1eca4176";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  #boot.zfs.extraPools = [ "tank" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  services.zfs.autoScrub.enable = true;

  users.groups.data.members = [ "reed" ];
  services.devmon.enable = true;

  systemd.tmpfiles.rules = [
    "d /srv/9 0770 root data -"
    "d /srv/restic 0770 root data -"
    "d /srv/data 0770 root data -"
    "d /srv/data/backup 0770 root data -"
    "d /srv/data/archive 0770 root data -"
    "d /srv/data/media 0770 root data -"
    "d /srv/data/software 0770 root data -"
    "d /srv/data/lib 0770 root data -"
    "d /srv/data/doc 0770 root data -"
  ];

  fileSystems."/srv/restic" = {
    device = "tank/ds0/backup/restic";
    fsType = "zfs";
    options = [ "nofail" ];
  };

  fileSystems."/srv/data/backup" = {
    device = "tank/ds0/backup";
    fsType = "zfs";
    options = [ "nofail" ];
  };

  fileSystems."/srv/data/archive" = {
    device = "tank/ds0/archive";
    fsType = "zfs";
    options = [ "nofail" ];
  };

  fileSystems."/srv/data/doc" = {
    device = "tank/ds0/doc";
    fsType = "zfs";
    options = [ "nofail" ];
  };

  fileSystems."/srv/data/lib" = {
    device = "tank/ds0/lib";
    fsType = "zfs";
    options = [ "nofail" ];
  };

  fileSystems."/srv/data/media" = {
    device = "tank/ds0/media";
    fsType = "zfs";
    options = [ "nofail" ];
  };

  fileSystems."/srv/data/software" = {
    device = "tank/ds0/software";
    fsType = "zfs";
    options = [ "nofail" ];
  };
}
