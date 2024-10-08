{ config, lib, ... }:

let
  adguardPort = 3000;
in
{
  networking.firewall = {
    allowedTCPPorts = [ adguardPort ];
    allowedUDPPorts = [ 53 ];
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    port = adguardPort;
  };
}
