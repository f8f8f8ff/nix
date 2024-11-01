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

    image = mkOption {
      default = "/srv/9/2.qcow2";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.qemu];
    systemd.services.plan9 = {
      enable = true;
      description = "9front file+auth+cpu";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.qemu];
      serviceConfig = {
        ExecStart = "${pkgs.qemu}/bin/qemu-system-x86_64 -nic user,hostfwd=tcp::17019-:17019,hostfwd=tcp::567-:567,hostfwd=tcp::17020-:17020,hostfwd=tcp::564-:564,hostfwd=tcp::5356-:535 -enable-kvm -m 2G -smp 2 -drive file=${cfg.image},media=disk,if=virtio,index=0 -nographic";
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
