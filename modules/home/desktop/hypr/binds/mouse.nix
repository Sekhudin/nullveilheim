{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.mouse.left
          ] null;
          dispatcher = hl.dsp.window.drag { };
          flags = {
            description = "swap window";
            drag = true;
          };
        })
      ];
    };
  };
}
