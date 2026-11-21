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
    context = "herdr-codex-integration";
    inherit pkgs;
  };

  hookPath = "${config.home.homeDirectory}/.codex/herdr-agent-state.sh";
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCodexIntegration) {
    programs.codex = {
      settings.features.hooks = true;
    };

    home.file = {
      ".codex/herdr-agent-state.sh" = {
        force = true;
        executable = true;
        source = "${cfg.assets}/codex/herdr-agent-state.sh";
      };

      ".codex/hooks.json" = {
        force = true;
        source = jsonFormat.generate "codex-hooks.json" {
          hooks.SessionStart = [
            {
              hooks = [
                {
                  type = "command";
                  command = "bash ${hookPath} session";
                  timeout = 10;
                }
              ];
            }
          ];
        };
      };
    };

    home.activation = {
      ${h.context} = h.makeMutableHomeFiles {
        paths = [ ".codex/config.toml" ];
        mode = "600";
        inherit lib;
      };
    };
  };
}
