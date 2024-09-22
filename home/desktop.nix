{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./neovim
    ./documents.nix
    ./media.nix
  ];
}
