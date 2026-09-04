{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;

  toml = pkgs.formats.toml { };
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim
        wayscriber
      ];
    };

    xdg.configFile = {
      "wayscriber/config.toml" = {
        source = toml.generate "config.toml" {
          config_revision = 3;
          keybindings = {
            exit = [ "Escape" ];
          };
        };
      };
    };
  };
}
