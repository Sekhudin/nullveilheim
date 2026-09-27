{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) hypr;

  cursor = hypr.getVarRefs config "cursor";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        (hypr.mkEnv "HYPRCURSOR_THEME" cursor.theme)
        (hypr.mkEnv "HYPRCURSOR_SIZE" cursor.size)

        (hypr.mkEnv "XCURSOR_THEME" cursor.theme)
        (hypr.mkEnv "XCURSOR_SIZE" cursor.size)
      ];
    };
  };
}
