{
  inputs,
  pkgs,
  lib,
  ezModules,
  extraLib,
  osConfig,
  ...
}:

let
  selfPkgs = inputs.self.packages.${pkgs.stdenv.system};
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
    theme = "zenwritten_dark";
  };

  homeOpenGLModules = {
    enable = true;
    use = "default";
  };
}
