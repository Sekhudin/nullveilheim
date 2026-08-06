{
  self,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableHyprpaper = (cfg.wallpaper.use == "hyprpaper");
  inherit (extraLib.hyprland)
    getVarRef
    ;

  wp = p: "${self.outPath}/modules/home/desktop/wallpapers/${p}";

  var = getVarRef config;
  monitors = var "monitors";
in
{
  config = lib.mkIf (cfg.enable && enableHyprpaper) {
    services = {
      hyprpaper = {
        enable = true;
        settings = {
          splash = false;
          ipc = true;
          wallpaper = [
            {
              monitor = monitors.edp_1;
              path = wp "10.webp";
              fit_mode = "cover";
            }
            {
              monitor = monitors.hdmia_1;
              path = wp "02.png";
              fit_mode = "cover";
            }
          ];
        };
      };
    };
  };
}
