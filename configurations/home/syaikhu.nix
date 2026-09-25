{
  inputs,
  pkgs,
  lib,
  ezModules,
  osConfig,
  extraLib,
  ...
}:

let
  enableConfig = path: lib.attrByPath path false osConfig;
in
{
  imports = lib.attrValues ezModules ++ [ ];

  home = rec {
    username = "syaikhu";
    stateVersion = "26.05";
    homeDirectory = extraLib.getHomeDir {
      inherit pkgs username osConfig;
    };
    packages = [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];
    sessionVariables = {
      EDITOR = (lib.getExe' inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvim "nvim");
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
