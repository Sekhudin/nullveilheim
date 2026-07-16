{ lib, ... }:

{
  options.pluginsModules.completion = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable completion";
      default = false;
    };

    engine = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "cmp"
            ];
            description = "choose engine";
            default = "none";
          };
        };
      };
    };

    icon = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "lspkind"
            ];
            description = "choose icon";
            default = "none";
          };
        };
      };
    };

    snippet = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "luasnip"
            ];
            description = "choose snippet";
            default = "none";
          };
        };
      };
    };
  };
}
