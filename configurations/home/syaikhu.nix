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
  selfPkgs = inputs.self.packages.${pkgs.stdenv.system};
  enableConfig = path: lib.attrByPath path false osConfig;

  enableHyprland = (
    pkgs.stdenv.isLinux
    && enableConfig [
      "programs"
      "hyprland"
      "enable"
    ]
  );
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
      selfPkgs.nvim
    ];
    sessionVariables = {
      EDITOR = (lib.getExe' selfPkgs.nvim "nvim");
    };
  };

  activationModules = {
    enable = true;
  };

  homeCoreModules = {
    enable = true;
    enableStandalone = (extraLib.isStandalone osConfig);
    theme = "zenwritten_dark";
    openGL = {
      use = "default";
    };
  };

  homeDesktopModules = {
    hyprland = {
      enable = enableHyprland;
    };
  };

  homeProgramsModules = {
    enable = true;
    secrets = {
      secretProfiles = rec {
        gpgKeys = [ "personal" ];
        sshKeys = gpgKeys;
        gitIdentities = gpgKeys;
      };
    };

    ssh = {
      enableShellAliases = true;
    };

    vcs = {
      jujutsu = {
        settings = {
          user = {
            name = "sekhudin";
            email = "sekhudinuap@gmail.com";
          };
        };
      };
    };
  };

  homeShellModules = {
    enable = true;
    use = "fish";
  };

  homeTerminalModules = {
    enable = true;
    use = "ghostty";
    enableCustomWM = enableHyprland;
  };
}
