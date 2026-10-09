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
    codex.settings.tui.theme = template;
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

    tmux.extraConfig = "set -g @noctalia_inactive_tabs_use_background off";

    noctalia.settings.theme.templates = {
      enable_community_templates = true;
      community_ids = [
        "claude-code"
        "codex"
        "fastfetch"
        "hyprtoolkit"
        "obs"
        "obsidian"
        "opencode"
        "papirus-icons"
        "pywalfox"
        "telegram"
        "tmux"
        "yazi"
      ];
    };
  };
}
