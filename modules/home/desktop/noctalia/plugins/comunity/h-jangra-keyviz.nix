{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";
in
{
  home = lib.mkIf cfg.enable {
    packages = with pkgs; [
      python3
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "h-jangra/keyviz" ];

    plugin_settings."h-jangra/keyviz" = {
      enabled_by_default = false;
      show_modifiers_only = true;
      padding = styles.margin_in;
      margin = styles.margin_out;
      timeout_ms = 2000;
      max_keys = 4;
      font_size = "medium";
      badge_style = "solid";
    };
  };
}
