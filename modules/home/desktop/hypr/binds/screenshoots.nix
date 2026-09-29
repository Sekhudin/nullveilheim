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

  screenshots = hypr.getVarRefs config "screenshots";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.print;
          dispatcher = hl.dsp.exec_cmd {
            cmd = screenshots.region;
          };
          flags = {
            description = "capture selected screen region";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] ctl.keys.print;
          dispatcher = hl.dsp.exec_cmd {
            cmd = screenshots.fullscreen;
          };
          flags = {
            description = "capture fullscreen screenshot";
          };
        })
      ];
    };
  };
}
