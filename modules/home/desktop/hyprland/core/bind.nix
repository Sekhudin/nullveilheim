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
    combos
    keys
    directions
    ;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "SPACE";
            dispatcher = dsp.extra.layout_toggle {
              var_layouts = "layouts";
            };
          })

          (mkBind {
            key = combos.mod "Z";
            dispatcher = dsp.extra.zen_mode { };
          })

          (mkBind {
            key = combos.mod "Q";
            dispatcher = dsp.window.close { };
            flags = {
              locked = true;
            };
          })

          (mkBind {
            key = combos.mod "F";
            dispatcher = dsp.window.fullscreen {
              mode = "maximized";
              action = "toggle";
              layout_aware = true;
            };
          })

          (mkBind {
            key = combos.mod "V";
            dispatcher = dsp.window.float {
              action = "toggle";
            };
          })

          (mkBind {
            key = combos.mod "RETURN";
            dispatcher = dsp.exec_cmd {
              cmd = "terminal";
            };
          })

          (mkBind {
            key = combos.mod "B";
            dispatcher = dsp.exec_cmd {
              cmd = "browser";
            };
          })

          # focus navigation
          (mkBind {
            key = combos.mod "H";
            dispatcher = dsp.focus {
              direction = directions.left;
            };
          })

          (mkBind {
            key = combos.mod "J";
            dispatcher = dsp.focus {
              direction = directions.down;
            };
          })

          (mkBind {
            key = combos.mod "K";
            dispatcher = dsp.focus {
              direction = directions.up;
            };
          })

          (mkBind {
            key = combos.mod "L";
            dispatcher = dsp.focus {
              direction = directions.right;
            };
          })

          # window swap
          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "H";
            dispatcher = dsp.window.swap {
              direction = directions.left;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "J";
            dispatcher = dsp.window.swap {
              direction = directions.down;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "K";
            dispatcher = dsp.window.swap {
              direction = directions.up;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "L";
            dispatcher = dsp.window.swap {
              direction = directions.right;
            };
          })

          # window resize
          (mkBind {
            key = combos.of [
              keys.mod
              keys.ctrl
            ] "H";
            dispatcher = dsp.window.resize {
              x = -10;
              y = 0;
              relative = true;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.ctrl
            ] "J";
            dispatcher = dsp.window.resize {
              x = 0;
              y = 10;
              relative = true;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.ctrl
            ] "K";
            dispatcher = dsp.window.resize {
              x = 0;
              y = -10;
              relative = true;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.ctrl
            ] "L";
            dispatcher = dsp.window.resize {
              x = 10;
              y = 0;
              relative = true;
            };
          })
        ];
      };
    };
  };
}
