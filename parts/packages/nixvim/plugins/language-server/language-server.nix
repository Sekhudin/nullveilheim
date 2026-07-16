{ lib, ... }:

{
  options.pluginsModules.language-server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable language server";
      default = false;
    };

    formatter = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "conform"
            ];
            description = "choose formatter";
            default = "none";
          };
        };
      };
    };
  };
}
