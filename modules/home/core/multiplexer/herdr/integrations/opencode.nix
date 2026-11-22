{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.programs.herdr;
  jsonFormat = pkgs.formats.json { };

  h = extraLib.activation.mkHelper {
    context = "herdr-opencode-integration";
    inherit pkgs;
  };
in
{
  config = lib.mkIf (cfg.enable && cfg.enableOpencodeIntegration) {
    programs.opencode = {
      tui.plugin = [ "./herdr-tui-session.js" ];
    };

    xdg.configFile = {
      "opencode/cli.json" = {
        force = true;
        source = jsonFormat.generate "opencode-cli.json" {
          "$schema" = "https://opencode.ai/v2/cli.json";
          plugins = [ "./herdr-opencode" ];
          theme.name = config.programs.opencode.tui.theme or "tokyonight";
        };
      };
    };

    home.file = {
      ".config/opencode/plugins/herdr-agent-state.js" = {
        force = true;
        source = "${cfg.assets}/opencode/herdr-agent-state.js";
      };

      ".config/opencode/herdr-tui-session.js" = {
        force = true;
        source = "${cfg.assets}/opencode/herdr-tui-session.js";
      };

      ".config/opencode/herdr-opencode/tui.js" = {
        force = true;
        source = "${cfg.assets}/opencode/herdr-opencode/tui.js";
      };
    };

    home.activation = {
      ${h.context} = h.makeMutableHomeFiles {
        paths = [
          ".config/opencode/cli.json"
          ".config/opencode/tui.json"
        ];
        mode = "600";
        inherit lib;
      };
    };
  };
}
