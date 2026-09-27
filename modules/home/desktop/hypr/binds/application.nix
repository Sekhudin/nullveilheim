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

  apps = hypr.getVarRefs config "apps";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod "RETURN";
          dispatcher = hl.dsp.exec_cmd {
            cmd = apps.terminal;
          };
          flags = {
            description = "open terminal";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "B";
          dispatcher = hl.dsp.exec_cmd {
            cmd = apps.browser;
          };
          flags = {
            description = "open browser";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "M";
          dispatcher = hl.dsp.exec_cmd {
            cmd = apps.filemanager;
          };
          flags = {
            description = "open file manager";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "W";
          dispatcher = hl.dsp.exec_cmd {
            cmd = apps.windowboard;
          };
          flags = {
            description = "windowboard toggle";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "W";
          dispatcher = hl.dsp.exec_cmd {
            cmd = apps.windowboard_freeze;
          };
          flags = {
            description = "freeze windowboard toggle";
          };
        })
      ];
    };
  };
}
