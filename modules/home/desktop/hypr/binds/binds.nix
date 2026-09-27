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
  menus = hypr.getVarRefs config "menus";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod "SPACE";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.apps;
          };
          flags = {
            description = "show apps";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "SLASH";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.binds;
          };
          flags = {
            description = "show key bindings";
          };
        })

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
            description = "window fullscreen toggle";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "V";
          dispatcher = hl.dsp.window.float {
            action = "toggle";
          };
          flags = {
            description = "window float toggle";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "SPACE";
          dispatcher = hl.extra.layout_toggle {
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

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "O";
          dispatcher = hl.dsp.dpms {
            action = "enable";
          };
          flags = {
            locked = true;
            description = "display on";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "R";
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.reload;
          };
          flags = {
            description = "reload config";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "Z";
          dispatcher = hl.extra.zen_mode { };
          flags = {
            description = "zen mode toggle";
          };
        })
      ];
    };
  };
}
