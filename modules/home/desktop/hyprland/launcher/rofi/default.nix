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

  inherit (extraLib) importModules;
  inherit (extraLib.hyprland)
    mkBind
    getVarRef
    dsp
    combos
    ;

  joinPipe = parts: lib.concatStringsSep " | " (map lib.strings.trim parts);

  mkRofi =
    {
      args ? [ ],
      theme-str ? "",
    }:
    "rofi ${lib.concatStringsSep " " args} -theme-str '${theme-str}'";

  mkJq =
    {
      args ? [ ],
      query ? ".",
    }:
    "jq ${lib.concatStringsSep " " args} '${lib.strings.trim query}'";

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";

  menuModules = importModules {
    dir = ./menu;
    recursive = false;
    excludeDefault = true;
    args = {
      inherit
        mkBind
        mkRofi
        mkJq
        joinPipe
        pkgs
        lib
        tokens
        styles
        combos
        dsp
        ;
    };
  };

  terminal = pkgs.${config.homeTerminalModules.use};
  menu = {
    apps = map (module: module.app) menuModules;
    binds = map (module: module.bind) menuModules;
  };
in
{
  imports = [
    ./bindings.nix
    ./pass.nix
    ./theme.nix
  ];

  config = lib.mkIf (cfg.enable && enableRofi) {
    home = {
      packages = menu.apps ++ [ ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        bind = menu.binds ++ [
          (mkBind {
            key = combos.mod "D";
            dispatcher = dsp.exec_cmd {
              cmd = "rofi -show drun";
            };
            flags = {
              description = "open app launcher";
            };
          })
        ];
      };
    };

    programs = {
      rofi = {
        enable = true;
        location = "center";
        xoffset = 0;
        yoffset = 0;
        font = font.family.monospace;
        terminal = lib.getExe terminal;
        plugins = [ ];
        modes = [
          "drun"
        ];
        extraConfig = {
          global-kb = true;
          steal-focus = true;
          show-icons = true;
          hover-select = true;
          drun-display-format = "{name}";
        };
      };
    };
  };
}
