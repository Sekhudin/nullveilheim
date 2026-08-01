{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        workspace_rule = [
          {
            workspace = "r[1-5]";
            persistent = true;
          }
        ];
      };
    };
  };
}
