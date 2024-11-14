{ lib, ... }:
{
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "64.227.96.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "64.227.109.162";
            prefixLength = 20;
          }
          {
            address = "10.48.0.6";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::4494:a1ff:fe1b:b75a";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "64.227.96.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "";
            prefixLength = 128;
          }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          {
            address = "10.124.0.3";
            prefixLength = 20;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::68ac:5ff:fe7e:a88e";
            prefixLength = 64;
          }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="46:94:a1:1b:b7:5a", NAME="eth0"
    ATTR{address}=="6a:ac:05:7e:a8:8e", NAME="eth1"
  '';
}
