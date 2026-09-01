{ lib, ... }:

{
  options.nixvimTools = {
    comment = lib.mkOption {
      type = lib.types.enum [
        "comment"
      ];
      description = "choose comment";
      default = "comment";
    };

    markdown = lib.mkOption {
      type = lib.types.enum [
        "markdown-preview"
      ];
      description = "choose markdown";
      default = "markdown-preview";
    };

    motion = lib.mkOption {
      type = lib.types.enum [
        "hop"
      ];
      description = "choose motion";
      default = "hop";
    };

    pairs = lib.mkOption {
      type = lib.types.enum [
        "nvim-autopairs"
      ];
      description = "choose pairs";
      default = "nvim-autopairs";
    };

    picker = lib.mkOption {
      type = lib.types.enum [
        "telescope"
      ];
      description = "choose picker";
      default = "telescope";
    };
  };
}
