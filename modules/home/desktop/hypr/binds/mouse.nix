{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    mkBind
    dsp
    combos
    keys
    mouse
    ;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (mkBind {
          key = combos.of [
            keys.mod
            mouse.left
          ] null;
          dispatcher = dsp.window.drag { };
          flags = {
            description = "swap window";
            drag = true;
          };
        })
      ];
    };
  };
}
