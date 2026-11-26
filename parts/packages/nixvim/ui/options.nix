{ lib, ... }:

{
  options.nixvimUI = {
    cursor = lib.mkOption {
      type = lib.types.enum [
        "none"
        "smear-cursor"
      ];
      description = "choose motion";
      default = "smear-cursor";
    };

    focus = lib.mkOption {
      type = lib.types.enum [
        "none"
        "zen-mode"
      ];
      description = "choose focus";
      default = "zen-mode";
    };

    indent = lib.mkOption {
      type = lib.types.enum [
        "none"
        "indent-blankline"
      ];
      description = "choose indent";
      default = "indent-blankline";
    };

    overlay = lib.mkOption {
      type = lib.types.enum [
        "none"
        "noice"
      ];
      description = "choose overlay";
      default = "noice";
    };

    sidebar = lib.mkOption {
      type = lib.types.enum [
        "neo-tree"
        "nvim-tree"
      ];
      description = "choose sidebar";
      default = "neo-tree";
    };

    status = lib.mkOption {
      type = lib.types.enum [
        "none"
        "lualine"
      ];
      description = "choose status";
      default = "lualine";
    };

    tab = lib.mkOption {
      type = lib.types.enum [
        "none"
        "bufferline"
      ];
      description = "choose tab";
      default = "bufferline";
    };
  };
}
