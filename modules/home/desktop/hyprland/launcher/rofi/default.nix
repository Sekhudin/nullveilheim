{
  pkgs,
  config,
  lib,
  extraLib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableRofi = (cfg.launcher.use == "rofi");

  inherit (extraLib)
    importModules
    mkJq
    joinPipe
    ;

  inherit (extraLib.hyprland) getVarRef;

  mkRofi =
    {
      args ? [ ],
      theme-str ? "",
    }:
    "rofi ${lib.concatStringsSep " " args} -theme-str '${theme-str}'";

  var = getVarRef config;
  menus = var "menus";
  styles = var "styles";
  tokens = var "tokens";

  terminal = config.homeTerminalModules.use;
in
{
  imports = [
    ./bindings.nix
    ./pass.nix
    ./theme.nix
  ];

  config = lib.mkIf (cfg.enable && enableRofi) {
    home = {
      packages = map (module: module.app) (importModules {
        dir = ./menu;
        recursive = false;
        excludeDefault = true;
        args = {
          inherit
            mkRofi
            mkJq
            joinPipe
            pkgs
            lib
            menus
            styles
            tokens
            ;
        };
      });
    };

    programs = {
      rofi = {
        enable = true;
        location = "center";
        xoffset = 0;
        yoffset = 0;
        font = font.family.monospace;
        terminal = terminal;
        plugins = [ ];
        modes = [
          "drun"
          "window"
        ];
        extraConfig = {
          global-kb = true;
          steal-focus = true;
          show-icons = true;
          icon-theme = config.homeCoreModules.iconTheme.name;
          hover-select = true;
          window-format = "{t}";
          drun-display-format = "{name}";
        };
      };
    };
  };
}
