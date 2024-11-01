{config, pkgs, ...}:
{
  services.restic.server = {
    enable = true;
    dataDir = "/srv/restic";
    extraFlags = ["--no-auth"];
  };

  users.users.restic.extraGroups = [ "data" ];
}
