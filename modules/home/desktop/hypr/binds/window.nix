{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;

  styles = hypr.getVarValues config "styles";
  offset = styles.margin_out + styles.border_size;

  bindGroup = "window";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # basic
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "Q";
          dispatcher = hl.dsp.window.close { };
          flags = {
            description = "close current window";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "F";
          dispatcher = hl.dsp.window.fullscreen {
            mode = "maximized";
            action = "toggle";
            layout_aware = true;
          };
          flags = {
            description = "toggle window fullscreen";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "P";
          dispatcher = hl.extra.toggle_pin {
            resize = false;
          };
          flags = {
            description = "toggle window pin";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "P";
          dispatcher = hl.extra.toggle_pin {
            resize = true;
            x = 0 - offset;
            y = offset + 36;
          };
          flags = {
            description = "toggle resized window pin";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "V";
          dispatcher = hl.dsp.window.float {
            action = "toggle";
          };
          flags = {
            description = "toggle window floating";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.mouse.left
          ] null;
          dispatcher = hl.dsp.window.drag { };
          flags = {
            description = "drag window";
            drag = true;
          };
        })

        # window cycle
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "N";
          dispatcher = hl.dsp.window.cycle_next {
            next = true;
          };
          flags = {
            description = "focus next window";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "N";
          dispatcher = hl.dsp.window.cycle_next {
            next = false;
          };
          flags = {
            description = "focus previous window";
          };
        })

        # focus navigation
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "H";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.left;
          };
          flags = {
            description = "focus window left";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "J";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.down;
          };
          flags = {
            description = "focus window down";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "K";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.up;
          };
          flags = {
            description = "focus window up";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "L";
          dispatcher = hl.dsp.focus {
            direction = ctl.directions.right;
          };
          flags = {
            description = "focus window right";
          };
        })

        # window swap
        (hypr.mkBind {
          group = bindGroup;
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
          group = bindGroup;
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
          group = bindGroup;
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
          group = bindGroup;
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
          group = bindGroup;
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
          group = bindGroup;
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
          group = bindGroup;
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
          group = bindGroup;
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
