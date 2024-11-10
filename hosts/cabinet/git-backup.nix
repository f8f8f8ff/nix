{
  config,
  lib,
  pkgs,
  ...
}:
let
  root = "/srv/smb/reed/software/src";
in
{
  systemd.services.git-backup = {
    description = "backup all git repos";
    after = [ "network.target" ];
    path = [
      pkgs.gh
      pkgs.git
      config.programs.ssh.package
    ];
    unitConfig = {
      RequiresMountsFor = root;
    };
    script = ''
      gh repo list --no-archived | sed -r 's/.*\/([^ \t]*).*/\1/' | while read -r repo; do
        gh repo clone "$repo" -- --mirror 2>/dev/null || (
          cd "$repo.git"
          git fetch --all &
        )
      done
    '';
    serviceConfig = {
      Type = "exec";
      WorkingDirectory = root;
      User = "reed";
    };
  };
  systemd.timers.git-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
      Unit = "git-backup.service";
    };
  };
}
