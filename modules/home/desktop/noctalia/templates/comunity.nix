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
    opencode.tui.theme = "matugen";
    obsidian.defaultSettings.appearance.enabledCssSnippets = [ template ];
    firefox.policies.ExtensionSettings = {
      "pywalfox@frewacom.org" = {
        default_area = "menupanel";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
    };
    tmux.extraConfig = "set -g @noctalia_inactive_tabs_use_background off";
    yazi.theme.flavor = {
      light = template;
      dark = template;
    };

    noctalia.settings.theme.templates = {
      enable_community_templates = true;
      community_ids = [
        "claude-code"
        "codex"
        "opencode"
        "obsidian"
        "pywalfox"
        "tmux"
        "yazi"

        # applied
        "neovim"
        "obs"
        "telegram"
        "fastfetch"
        "papirus-icons"
      ];
    };
  };
}
