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
  inherit (extraLib.hyprland)
    mkBind
    dsp
    combos
    ;

  terminal = pkgs.${config.homeTerminalModules.use};
in
{
  imports = [
    ./bindings.nix
    ./pass.nix
    ./theme.nix
  ];

  config = lib.mkIf (cfg.enable && enableRofi) {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "D";
            dispatcher = dsp.exec_cmd {
              cmd = "rofi -show drun";
            };
          })

          (mkBind {
            key = combos.mod "SLASH";
            dispatcher = dsp.exec_cmd {
              cmd = "rofi -show drun";
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
          "ssh"
          "window"
        ];
        extraConfig = {
          global-kb = true;
          steal-focus = true;
          show-icons = true;
          hover-select = true;
          drun-display-format = "{name}";
          combi-modes = [
            "window"
            "drun"
            "run"
          ];
        };
      };
    };
  };
}
