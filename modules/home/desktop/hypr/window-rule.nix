{ extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;
in
{
  wayland.windowManager.hyprland = {
    settings.window_rule = [
      (hypr.mkWindowRule {
        name = "float-screen";
        match.float = true;
        no_blur = true;
        no_shadow = true;
      })
    ];
  };
}
