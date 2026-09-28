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
      ];
    };
  };
}
