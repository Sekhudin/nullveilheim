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
          # focus navigation
          (mkBind {
            key = combos.mod "H";
            dispatcher = dsp.focus {
              direction = directions.left;
            };
            flags = {
              description = "move focus left";
            };
          })

          (mkBind {
            key = combos.mod "J";
            dispatcher = dsp.focus {
              direction = directions.down;
            };
            flags = {
              description = "move focus down";
            };
          })

          (mkBind {
            key = combos.mod "K";
            dispatcher = dsp.focus {
              direction = directions.up;
            };
            flags = {
              description = "move focus up";
            };
          })

          (mkBind {
            key = combos.mod "L";
            dispatcher = dsp.focus {
              direction = directions.right;
            };
            flags = {
              description = "move focus right";
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
            flags = {
              description = "swap window left";
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
            flags = {
              description = "swap window down";
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
            flags = {
              description = "swap window up";
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
            flags = {
              description = "swap window right";
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
              description = "resize window left";
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
              description = "resize window down";
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
              description = "resize window up";
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
              description = "resize window right";
            };
          })
        ];
      };
    };
  };
}
