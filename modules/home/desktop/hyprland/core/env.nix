{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) mkLuaInline mkEnv;

  cursorTheme = (mkLuaInline "cursor_theme");
  cursorSize = (mkLuaInline "cursor_size");
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        bibata-cursors
      ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        env = [
          (mkEnv "HYPRCURSOR_THEME" cursorTheme)
          (mkEnv "HYPRCURSOR_SIZE" cursorSize)

          (mkEnv "XCURSOR_THEME" cursorTheme)
          (mkEnv "XCURSOR_SIZE" cursorSize)
        ];
      };
    };
  };
}
