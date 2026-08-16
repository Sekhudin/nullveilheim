{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland)
    mkBind
    dsp
    keys
    combos
    ;
in
{
  imports = [
    ./application.nix
    ./luncher.nix
    ./mouse.nix
    ./session.nix
    ./window.nix
    ./workspace.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "Q";
            dispatcher = dsp.window.close { };
            flags = {
              description = "close current window";
            };
          })

          (mkBind {
            key = combos.mod "F";
            dispatcher = dsp.window.fullscreen {
              mode = "maximized";
              action = "toggle";
              layout_aware = true;
            };
            flags = {
              description = "window fullscreen toggle";
            };
          })

          (mkBind {
            key = combos.mod "V";
            dispatcher = dsp.window.float {
              action = "toggle";
            };
            flags = {
              description = "window float toggle";
            };
          })

          (mkBind {
            key = combos.mod "SPACE";
            dispatcher = dsp.extra.layout_toggle {
              layouts = [
                "dwindle"
                "master"
                "scrolling"
                "monocle"
              ];
            };
            flags = {
              description = "change layout toggle";
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "O";
            dispatcher = dsp.dpms {
              action = "enable";
            };
            flags = {
              locked = true;
              description = "display on";
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "R";
            dispatcher = dsp.exec_cmd {
              cmd = "hyprctl reload";
            };
            flags = {
              description = "reload config";
            };
          })

          (mkBind {
            key = combos.mod "Z";
            dispatcher = dsp.extra.zen_mode { };
            flags = {
              description = "zen mode toggle";
            };
          })
        ];
      };
    };
  };
}
