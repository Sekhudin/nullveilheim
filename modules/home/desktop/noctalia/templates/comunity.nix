{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  template = "noctalia";
in
{
  programs = lib.mkIf cfg.enable {
    claude-code.settings.theme = template;
    obsidian.defaultSettings.appearance.enabledCssSnippets = [ template ];
    opencode.tui.theme = "matugen";

    firefox.policies.ExtensionSettings = {
      "pywalfox@frewacom.org" = {
        default_area = "menupanel";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
    };

    noctalia.settings.theme.templates = {
      enable_community_templates = true;
      community_ids = [
        "claude-code"
        "obs"
        "obsidian"
        "opencode"
        # "papirus-icons"
        "pywalfox"
        # "steam"
        # "telegram"
        # "tmux"
        # "yazi"
      ];
    };
  };
}
