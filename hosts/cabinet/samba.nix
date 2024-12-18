{ config, pkgs, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "security" = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "cabinet";
        "netbios name" = "cabinet";
        "hosts allow" = "100. 192.168.1. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";

        "deadtime" = "30";
        "getwd cache" = "yes";
        "min receivefile size" = "16384";
        "use sendfile" = "yes";
        "socket options" = "IPTOS_LOWDELAY TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072";

        "min protocol" = "SMB2";
        "ea support" = "yes";
        "vfs objects" = "crossrename catia fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "fruit:posix_rename" = "yes";
        "readdir_attr:aapl_rsize" = "no";
        "readdir_attr:appl_finder_info" = "no";
        "readdir_attr:appl_max_access" = "no";

        "crossrename:sizelimit" = "102400";
      };

      "reed" = {
        "valid users" = "reed";
        "path" = "/srv/smb/reed";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "2770";
      };

      "keyan" = {
        "valid users" = "keyan";
        "path" = "/srv/smb/keyan";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "2770";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
