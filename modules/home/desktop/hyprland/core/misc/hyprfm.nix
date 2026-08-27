{
  inputs,
  pkgs,
  config,
  lib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  toml = pkgs.formats.toml { };
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        inputs.hyprfm.packages.${pkgs.stdenv.system}.default
      ];
    };

    xdg.configFile = {
      "hyprfm/config.toml" = {
        source = toml.generate "config.toml" {
          general = {
            icon_theme = config.homeCoreModules.iconTheme.name;
            font_family = font.family.sans_serif;
            default_view = "grid";
            show_hidden = false;
            dependency_startup_check = true;
            sort_by = "name";
            sort_ascending = true;
            remember_sort_per_folder = true;
          };
        };
      };
    };
  };
}
