{ config, pkgs, ... }:
{
  services.restic.server = {
    enable = true;
    dataDir = "/srv/restic";
    extraFlags = [ "--no-auth" ];
  };

  users.users.restic.extraGroups = [ "data" ];

  sops.secrets."restic/password" = { };
  services.restic.backups.daily = {
    repository = "rest:http://cabinet:8000/cabinet";
    passwordFile = "/run/secrets/restic/password";
    inhibitsSleep = true;
    paths = [
      "/home/reed"
      "/srv/9"
    ];
    exclude = [
      "/tmp"
      "/var/cache"
    ];
    timerConfig = {
      OnCalendar = "01:00";
      RandomizedDelaySec = "2h";
      Persistent = true;
    };
  };
}
