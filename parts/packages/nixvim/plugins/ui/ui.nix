{ lib, ... }:

{
  options.pluginsModules.ui = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable sidebar";
      default = true;
    };

    indent = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "indent-blankline"
            ];
            description = "choose indent";
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
              "smear-cursor"
            ];
            description = "choose motion";
            default = "none";
          };
        };
      };
    };

    status = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "lualine"
            ];
            description = "choose status";
            default = "none";
          };
        };
      };
    };

    syntax = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "rainbow-delimiters"
            ];
            description = "choose syntax highlighting";
            default = "none";
          };
        };
      };
    };

    tab = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "bufferline"
            ];
            description = "choose tab";
            default = "none";
          };
        };
      };
    };

  };
}
