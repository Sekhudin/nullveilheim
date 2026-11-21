{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.herdr;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.herdr = {
    enable = lib.mkEnableOption "herdr terminal multiplexer";

    enableClaudeIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to install the Herdr agent integration for Claude Code.";
    };

    enableCodexIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to install the Herdr agent integration for Codex.";
    };

    enableOpencodeIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to install the Herdr agent integration for OpenCode.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.herdr;
      description = "Package to use for Herdr.";
    };

    skipConfigFile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to skip creating the Herdr configuration file.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Herdr TOML configuration settings.";
    };

    assets = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      internal = true;
      description = "Agent integration assets extracted from the installed Herdr package.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.wl-clipboard
      pkgs.xsel
    ];

    programs.herdr.assets = pkgs.runCommandLocal "herdr-agent-integration-assets" { } ''
      export HOME=$TMPDIR/home
      mkdir -p "$HOME/.claude" "$HOME/.codex" "$HOME/.config/opencode"

      ${lib.getExe cfg.package} integration install claude
      ${lib.getExe cfg.package} integration install codex
      ${lib.getExe cfg.package} integration install opencode

      mkdir -p $out/claude $out/codex $out/opencode/herdr-opencode

      install -m755 "$HOME/.claude/hooks/herdr-agent-state.sh" $out/claude/herdr-agent-state.sh
      install -m755 "$HOME/.codex/herdr-agent-state.sh" $out/codex/herdr-agent-state.sh
      install -m644 "$HOME/.config/opencode/plugins/herdr-agent-state.js" $out/opencode/herdr-agent-state.js
      install -m644 "$HOME/.config/opencode/herdr-tui-session.js" $out/opencode/herdr-tui-session.js
      install -m644 "$HOME/.config/opencode/herdr-opencode/tui.js" $out/opencode/herdr-opencode/tui.js
    '';

    xdg.configFile."herdr/config.toml" = lib.mkIf (!cfg.skipConfigFile) {
      source = tomlFormat.generate "herdr-config.toml" cfg.settings;
    };
  };
}
