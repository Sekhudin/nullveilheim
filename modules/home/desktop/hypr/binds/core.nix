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

  actions = hypr.getVarRefs config "actions";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod "Q";
          dispatcher = hl.dsp.window.close { };
          flags = {
            description = "close current window";
          };
        })

        (hypr.mkBind {
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
          key = ctl.combos.mod "V";
          dispatcher = hl.dsp.window.float {
            action = "toggle";
          };
          flags = {
            description = "toggle window floating";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] ctl.keys.space;
          dispatcher = hl.extra.layout_toggle {
            layouts = [
              "dwindle"
              "master"
              "scrolling"
              "monocle"
            ];
          };
          flags = {
            description = "cycle window layout";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "R";
          dispatcher = hl.dsp.exec_cmd {
            cmd = "hyprctl reload config-only";
          };
          flags = {
            description = "reload configuration only";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "R";
          dispatcher = hl.dsp.exec_cmd {
            cmd = "hyprctl reload";
          };
          flags = {
            description = "reload configuration";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "Z";
          dispatcher = hl.extra.zen_mode { };
          flags = {
            description = "toggle zen mode";
          };
        })

        (hypr.mkBind {
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
      ];
    };
  };
}
