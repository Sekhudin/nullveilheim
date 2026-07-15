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

    comment = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "comment"
            ];
            description = "choose comment";
            default = "none";
          };
        };
      };
    };

    encrypt = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "sops"
            ];
            description = "choose encrypt";
            default = "none";
          };
        };
      };
    };

    markdown = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "markdown-preview"
            ];
            description = "choose markdown";
            default = "none";
          };
        };
      };
    };

    media = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "image"
            ];
            description = "choose media";
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

    picker = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "telescope"
            ];
            description = "choose picker";
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

    vcs = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "git"
            ];
            description = "choose vcs";
            default = "none";
          };
        };
      };
    };
  };
}
