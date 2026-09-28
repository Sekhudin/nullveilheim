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
          key = ctl.combos.mod "SLASH";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.binds;
          };
          flags = {
            description = "keybind reference and help";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "SLASH";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.control_center;
          };
          flags = {
            description = "system control and status";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "SPACE";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.launcher;
          };
          flags = {
            description = "application launcher";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain "XF86PowerOff";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.power;
          };
          flags = {
            description = "power and session actions";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "S";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.settings;
          };
          flags = {
            description = "desktop settings";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "SLASH";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.screenshot;
          };
          flags = {
            description = "screenshot and screen capture";
          };
        })
      ];
    };
  };
}
