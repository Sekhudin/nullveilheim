{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  configHome = config.xdg.configHome;
  template = "noctalia";
in
{

  wayland.windowManager.hyprland = lib.mkIf cfg.enable {
    extraConfig = ''
      require("noctalia").apply_theme()
    '';
  };

  qt = lib.mkIf cfg.enable {
    platformTheme.name = "qtct";
    qt5ctSettings.Appearance.color_scheme_path = "${configHome}/qt5ct/colors/${template}.conf";
    qt6ctSettings.Appearance.color_scheme_path = "${configHome}/qt6ct/colors/${template}.conf";
  };

  programs = lib.mkIf cfg.enable {
    alacritty.settings.general.import = [
      "${configHome}/alacritty/themes/${template}.toml"
    ];
    btop.settings.color_theme = template;
    ghostty.settings.theme = template;
    #starship: auto apply
    noctalia.settings.theme.templates = {
      enable_builtin_templates = true;
      builtin_ids = [
        "alacritty"
        "btop"
        "ghostty"
        "gtk3"
        "gtk4"
        "hyprland"
        "qt"
        "starship"
      ];
    };
  };
}
