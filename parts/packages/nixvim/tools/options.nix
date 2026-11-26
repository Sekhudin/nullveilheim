{ lib, ... }:

{
  options.nixvimTools = {
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

    picker = lib.mkOption {
      type = lib.types.enum [
        "telescope"
      ];
      description = "choose picker";
      default = "telescope";
    };
  };
}
