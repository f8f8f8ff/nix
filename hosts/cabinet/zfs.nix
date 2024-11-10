{ config, pkgs, ... }:
let
  zfs-autobackup-passport = pkgs.writeShellScriptBin "zfs-autobackup-passport" ''
    if zpool status passport 1>/dev/null; then
      exec zfs-autobackup -v --clear-mountpoint --encrypt passport passport/enc
    else
      echo "passport not imported" 1>&2
      exit 1
    fi
  '';
in
{
  networking.hostId = "1eca4176";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "tank" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  services.zfs.autoScrub.enable = true;

  users.groups.data.members = [ "reed" ];
  services.devmon.enable = true;

  systemd.tmpfiles.rules = [
    "d /srv/9 0770 root data -"
  ];

  fileSystems."/srv/smb/keyan/share" = {
    device = "/tank/ds0/share";
    options = [
      "bind"
      "x-systemd.after=zfs-mount.service"
    ];
  };
  fileSystems."/srv/smb/reed/share" = {
    device = "/tank/ds0/share";
    options = [
      "bind"
      "x-systemd.after=zfs-mount.service"
    ];
  };

  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 36;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    datasets."tank/ds0" = {
      useTemplate = [ "backup" ];
      recursive = true;
    };
  };

  environment.systemPackages = [
    pkgs.sanoid
    (pkgs.symlinkJoin {
      name = "nix-autobackup";
      paths = [
        zfs-autobackup-passport
        pkgs.zfs-autobackup
      ];
    })
  ];


}
