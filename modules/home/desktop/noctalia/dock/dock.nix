{ config, extraLib, ... }:

let
  cfg = config.homeDesktop.noctalia;
  core = config.homeCore;
  svgs = config.homeDesktop.svgs;
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";
  pinnedApps =
    let
      browser = core.browser;
      terminal =
        if core.terminal == "ghostty" then
          "com.mitchellh.ghostty"
        else if core.terminal == "alacritty" then
          "Alacritty"
        else
          "terminal";
    in
    [
      browser
      terminal
    ];
in
{
  programs.noctalia.settings.dock = {
    enabled = cfg.enable;
    position = "bottom";
    icon_size = 28;
    radius = styles.border_radius;
    radius_top_left = styles.border_radius;
    radius_top_right = styles.border_radius;
    radius_bottom_left = styles.border_radius;
    radius_bottom_right = styles.border_radius;
    main_axis_padding = styles.margin_in;
    cross_axis_padding = styles.margin_in;
    item_spacing = styles.margin_in;
    margin_ends = 0;
    margin_edge = styles.margin_in;
    launcher_position = "start";
    launcher_custom_image = svgs.nix-white;
    pinned = pinnedApps;
  };
}
