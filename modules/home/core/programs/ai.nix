{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeCore.programs.ai;
in
{
  options.homeCore.programs.ai = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable ai";
      default = true;
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = with pkgs; [
        opencode
        gemini-cli
        claude-code
      ];
    };
  };
}
