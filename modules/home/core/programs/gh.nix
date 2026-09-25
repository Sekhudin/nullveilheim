{
  config,
  lib,
  ...
}:

let
  cfg = config.homeCore.programs.gh;
in
{
  options.homeCore.programs.gh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable gh";
      default = true;
    };
  };

  config = {
    programs.gh = {
      enable = cfg.enable;
      settings = {
        git_protocol = "ssh";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    programs.gh-dash = {
      enable = cfg.enable;
    };
  };
}
