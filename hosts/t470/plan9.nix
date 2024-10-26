{config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.plan9;
in {
  options.services.plan9 = {
    enable = mkEnableOption "9front file+auth+cpu";

    openFirewall = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.plan9 = {
      enable = true;
      description = "9front file+auth+cpu";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.qemu];
      serviceConfig = {
        WorkingDirectory="/home/reed/9front-vm";
        ExecStart = "/home/reed/9front-vm/run.sh";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      17019
      17020
      564
      5356
    ];
  };
}
