{
  pkgs,
  lib,
  color,
  ...
}:

let
  themeNames = lib.attrNames color.themes;
in
{
  imports = [
    ./cross.nix
    ./darwin.nix
    ./linux.nix
    ./opengl.nix
  ];

  options.homeCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable packages modules";
      default = false;
    };

    enableStandalone = lib.mkOption {
      type = lib.types.bool;
      description = "enable standalone";
      default = false;
    };

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      description = "theme settings";
      default = builtins.elemAt themeNames 0;
    };

    iconTheme = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "name of icon theme.";
          };

          package = lib.mkOption {
            type = lib.types.package;
            description = "icon theme package";
          };
        };
      };

      default = {
        name = "Papirus Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };

  config = {
    programs.home-manager = {
      enable = true;
    };
  };
}
