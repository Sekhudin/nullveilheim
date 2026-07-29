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
            flags = {
              repeating = true;
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
            flags = {
              repeating = true;
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
            flags = {
              repeating = true;
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
            flags = {
              repeating = true;
            };
          })
        ];
      };
    };
  };
}
