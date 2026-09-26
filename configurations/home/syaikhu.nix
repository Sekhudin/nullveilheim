{
  inputs,
  pkgs,
  config,
  lib,
  ezModules,
  osConfig,
  extraLib,
  ...
}:

let
  enableConfig = path: lib.attrByPath path false osConfig;
  packages = inputs.self.packages;
  system = pkgs.stdenv.hostPlatform.system;
  homeDirectory = config.home.homeDirectory;
in
{
  imports = lib.attrValues ezModules ++ [ ];

  home = rec {
    username = "syaikhu";
    stateVersion = "26.05";
    homeDirectory = extraLib.getHomeDir {
      inherit pkgs username osConfig;
    };
  };

  homeCore = {
    activation = true;
    standalone = (extraLib.isStandalone osConfig);
    shell = "fish";
    terminal = "ghostty";
    theme = "zenwritten_dark";
    programs = {
      secrets = rec {
        gpgKeys = [ "personal" ];
        sshKeys = gpgKeys;
        gitIdentities = gpgKeys;
      };
      jujutsu = {
        user = {
          name = "sekhudin";
          email = "sekhudinuap@gmail.com";
        };
      };
    };
    packages = [
      packages.${system}.nvim
    ];
    sessionVariables = {
      EDITOR = lib.getExe' packages.${system}.nvim "nvim";
      NH_FLAKE = "${homeDirectory}/.config/nullveilheim";
    };
  };

  homeDesktop = {
    enable = (
      pkgs.stdenv.isLinux
      && enableConfig [
        "programs"
        "hyprland"
        "enable"
      ]
    );
  };
}
