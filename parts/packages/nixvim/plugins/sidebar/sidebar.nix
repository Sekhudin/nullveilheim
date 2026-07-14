{ lib, ... }:

{
  options.pluginsModules.sidebar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable sidebar";
      default = true;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "neo-tree"
        "nvim-tree"
      ];
      description = "enable sidebar";
      default = true;
    };
  };
}
