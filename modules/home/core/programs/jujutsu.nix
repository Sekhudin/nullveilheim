{
  config,
  lib,
  ...
}:

let
  cfg = config.homeCore.programs.jujutsu;
in
{
  options.homeCore.programs.jujutsu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable gh";
      default = true;
    };

    user = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Jujutsu user name.";
          };

          email = lib.mkOption {
            type = lib.types.str;
            description = "Jujutsu user email.";
          };
        };
      };
      default = { };
    };
  };

  config = {
    programs.jujutsu = {
      enable = cfg.enable;
      settings = {
        inherit (cfg) user;
      };
    };
  };
}
