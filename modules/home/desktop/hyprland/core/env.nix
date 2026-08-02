{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) getVar mkEnv;

  cursor_theme = (getVar "cursor.theme");
  cursor_size = (getVar "cursor.size");
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        env = [
          (mkEnv "HYPRCURSOR_THEME" cursor_theme)
          (mkEnv "HYPRCURSOR_SIZE" cursor_size)

          (mkEnv "XCURSOR_THEME" cursor_theme)
          (mkEnv "XCURSOR_SIZE" cursor_size)
        ];
      };
    };
  };
}
