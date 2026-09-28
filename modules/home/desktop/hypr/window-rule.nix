{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) hypr;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      window_rule = [
      ];
    };
  };
}
