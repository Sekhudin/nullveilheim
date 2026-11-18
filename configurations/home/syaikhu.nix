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
    multiplexer = "herdr";
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
      dock.enable = false;
      bar.label.enable = false;
      desktop = {
        widgets.enable = false;
        wallpaper.automation.enable = false;
        backdrop.enable = true;
      };
    };
  };
}
