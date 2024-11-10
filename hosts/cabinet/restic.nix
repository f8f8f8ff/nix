{ config, pkgs, ... }:
{
  services.restic.server = {
    enable = true;
    dataDir = "/srv/restic";
    extraFlags = [ "--no-auth" ];
  };

  users.users.restic.extraGroups = [ "data" ];

  sops.secrets."discord/webhook" = { };
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
    backupCleanupCommand = ''
      export DISCORD_HOOK_URL=$(cat /run/secrets/discord/webhook)
      export DISCORD_USERNAME="$HOSTNAME: restic"
      export DISCORD_STATUS=info
      if [[ $SERVICE_RESULT != "success" ]]; then
        export DISCORD_STATUS=error
      fi
      journalctl _SYSTEMD_INVOCATION_ID=`systemctl show --value -p InvocationID restic-backups-daily.service` --output cat|\
        ${pkgs.discordsend}/bin/discordsend
    '';
  };
}
