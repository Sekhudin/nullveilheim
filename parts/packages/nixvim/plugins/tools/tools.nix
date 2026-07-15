{ lib, ... }:

{
  options.pluginsModules.tools = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable tools";
      default = true;
    };

    buffer = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "mini-bufremove"
            ];
            description = "choose buffer";
            default = "none";
          };
        };
      };
    };

    motion = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hop"
            ];
            description = "choose motion";
            default = "none";
          };
        };
      };
    };

    pairs = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "nvim-autopairs"
            ];
            description = "choose diagnostic";
            default = "none";
          };
        };
      };
    };

    tag = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "ts-autotag"
            ];
            description = "choose tag";
            default = "none";
          };
        };
      };
    };
  };
}
