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

  panels = hypr.getVarRefs config "panels";
  bindGroup = "panels";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod ctl.keys.space;
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.launcher;
          };
          flags = {
            description = "application launcher";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "S";
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.control;
          };
          flags = {
            description = "system control and status";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod ctl.keys.comma;
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.settings;
          };
          flags = {
            description = "desktop settings";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod ctl.keys.tab;
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.window;
          };
          flags = {
            description = "window switcher";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.plain ctl.keys.poweroff;
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.session;
          };
          flags = {
            description = "session actions";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.plain ctl.keys.print;
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.screenshot;
          };
          flags = {
            description = "capture screenshot";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "V";
          dispatcher = hl.dsp.exec_cmd {
            cmd = panels.clipboard;
          };
          flags = {
            description = "clipboard panel";
          };
        })
      ];
    };
  };
}
