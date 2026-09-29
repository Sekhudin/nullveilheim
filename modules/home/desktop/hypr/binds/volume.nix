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

  volume = hypr.getVarRefs config "volume";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.volume_up;
          dispatcher = hl.dsp.exec_cmd {
            cmd = volume.up;
          };
          flags = {
            repeating = true;
            description = "increase system volume";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.volume_down;
          dispatcher = hl.dsp.exec_cmd {
            cmd = volume.down;
          };
          flags = {
            repeating = true;
            description = "decrease system volume";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.volume_toggle;
          dispatcher = hl.dsp.exec_cmd {
            cmd = volume.toggle;
          };
          flags = {
            repeating = true;
            description = "toggle system volume mute";
          };
        })
      ];
    };
  };
}
