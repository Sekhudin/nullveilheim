{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.programs.herdr;

  h = extraLib.activation.mkHelper {
    context = "herdr-claude-code-integration";
    inherit pkgs;
  };

  hookPath = "${config.home.homeDirectory}/.claude/hooks/herdr-agent-state.sh";
in
{
  config = lib.mkIf (cfg.enable && cfg.enableClaudeIntegration) {
    programs.claude-code = {
      hooksDir = "${cfg.assets}/claude";
      settings.hooks.SessionStart = [
        {
          matcher = "^(startup|resume|clear|compact|fork)$";
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

    home.file = {
      ".claude/skills/herdr" = {
        source = "${cfg.assets}/skills/herdr";
        recursive = true;
      };
    };

    home.activation = {
      ${h.context} = h.makeMutableHomeFiles {
        paths = [ ".claude/settings.json" ];
        mode = "600";
        inherit lib;
      };
    };
  };
}
