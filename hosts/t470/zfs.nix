{ config, pkgs, ... }:
{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "b6b8d3e8";
  boot.zfs.extraPools = [ "tank" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  services.zfs.autoScrub.enable = true;

  # mount points
  systemd.tmpfiles.rules = [
    "d /srv/backup 0770 restic restic -"
    "d /srv/data 0770 root data -"
    "d /srv/data/archive 0770 root data -"
    "d /srv/data/doc 0770 root data -"
    "d /srv/data/lib 0770 root data -"
    "d /srv/data/software 0770 root data -"
  ];

  users.groups.data.members = [ "reed" ];
}
