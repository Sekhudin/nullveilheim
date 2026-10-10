{ config, ... }:

let
  theme = config.homeCore.themeConfig;
in
{
  programs.noctalia.settings.theme = {
    mode = "dark";
    shell_mode = "follow";
    source = "wallpaper";
    builtin = "Nord";
    community_palette = "ADW";
    wallpaper_scheme = "m3-monochrome";
    custom_palette = theme.name;
  };
}
