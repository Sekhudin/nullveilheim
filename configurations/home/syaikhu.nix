{ pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  imports = [
    ./syaikhu-mini.nix
  ];

  homeCore = {
    standalone = false;
    shell = "fish";
    terminal = "ghostty";
    theme = "aurora";
    activation = rec {
      enable = true;
      gpgKeys = [ "personal" ];
      sshKeys = gpgKeys;
      gitIdentities = gpgKeys;
    };
  };

  homeDesktop = {
    enable = isLinux;
    noctalia = {
      desktop.backdrop.enable = true;
    };
  };
}
