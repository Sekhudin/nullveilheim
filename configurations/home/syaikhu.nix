{
  pkgs,
  lib,
  ezModules,
  extraLib,
  osConfig,
  ...
}:

{
  imports = lib.attrValues ezModules ++ [ ];

  home = rec {
    username = "syaikhu";
    stateVersion = "26.05";
    homeDirectory = extraLib.getHomeDir {
      inherit pkgs username osConfig;
    };
    packages = [
    ];
  };

  homeCoreModules = {
    enable = true;
  };

  homeProgramsModules = {
    enable = true;
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
    ghostty = {
      theme = "zenwritten_dark";
    };
  };

  homeOpenGLModules = {
    enable = true;
    use = "default";
  };
}
