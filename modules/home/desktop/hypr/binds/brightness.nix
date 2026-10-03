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

  brightness = hypr.getVarRefs config "brightness";
  bindGroup = "brightness";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.plain ctl.keys.brightness_up;
          dispatcher = hl.dsp.exec_cmd {
            cmd = brightness.up;
          };
          flags = {
            repeating = true;
            description = "increase screen brightness";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.plain ctl.keys.brightness_down;
          dispatcher = hl.dsp.exec_cmd {
            cmd = brightness.down;
          };
          flags = {
            repeating = true;
            description = "decrease screen brightness";
          };
        })
      ];
    };
  };
}
