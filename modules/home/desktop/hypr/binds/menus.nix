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

  menus = hypr.getVarRefs config "menus";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.slash;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.help;
          };
          flags = {
            description = "keybind reference and help";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.space;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.launcher;
          };
          flags = {
            description = "application launcher";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "S";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.control;
          };
          flags = {
            description = "system control and status";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.comma;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.settings;
          };
          flags = {
            description = "desktop settings";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.tab;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.window;
          };
          flags = {
            description = "window switcher";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.poweroff;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.session;
          };
          flags = {
            description = "session actions";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.print;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.screenshot;
          };
          flags = {
            description = "capture screenshot";
          };
        })
      ];
    };
  };
}
