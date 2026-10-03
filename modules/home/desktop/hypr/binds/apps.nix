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
  bindGroup = "apps";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod ctl.keys.enter;
          dispatcher = hl.dsp.exec_cmd {
            cmd = apps.terminal;
          };
          flags = {
            description = "open terminal";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
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
