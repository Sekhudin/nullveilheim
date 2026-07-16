{ lib, ... }:

{
  options.pluginsModules.sidebar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable sidebar";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "none"
        "neo-tree"
        "nvim-tree"
      ];
      description = "enable sidebar";
      default = "none";
    };
  };
}
