{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # focus navigation
        (hypr.mkBind {
          key = ctl.combos.mod "H";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.left;
          };
          flags = {
            description = "move focus left";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "J";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.down;
          };
          flags = {
            description = "move focus down";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "K";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.up;
          };
          flags = {
            description = "move focus up";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "L";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.right;
          };
          flags = {
            description = "move focus right";
          };
        })

        # window swap
        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "H";
          dispatcher = hl.dsp.window.swap {
            direction = ctl.directions.left;
          };
          flags = {
            description = "swap window left";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "J";
          dispatcher = hl.dsp.window.swap {
            direction = ctl.directions.down;
          };
          flags = {
            description = "swap window down";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "K";
          dispatcher = hl.dsp.window.swap {
            direction = ctl.directions.up;
          };
          flags = {
            description = "swap window up";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "L";
          dispatcher = hl.dsp.window.swap {
            direction = ctl.directions.right;
          };
          flags = {
            description = "swap window right";
          };
        })

        # window resize
        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.ctrl
          ] "H";
          dispatcher = hl.dsp.window.resize {
            x = -10;
            y = 0;
            relative = true;
          };
          flags = {
            repeating = true;
            description = "resize window left";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.ctrl
          ] "J";
          dispatcher = hl.dsp.window.resize {
            x = 0;
            y = 10;
            relative = true;
          };
          flags = {
            repeating = true;
            description = "resize window down";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.ctrl
          ] "K";
          dispatcher = hl.dsp.window.resize {
            x = 0;
            y = -10;
            relative = true;
          };
          flags = {
            repeating = true;
            description = "resize window up";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.ctrl
          ] "L";
          dispatcher = hl.dsp.window.resize {
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
}
