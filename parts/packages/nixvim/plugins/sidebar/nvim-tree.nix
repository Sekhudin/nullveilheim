{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.sidebar;
in
{
  globals = lib.mkIf (cfg.use == "nvim-tree") {
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  plugins = lib.mkIf (cfg.enable && cfg.use == "nvim-tree") {
    nvim-tree = {
      enable = true;
      settings = {
        view = {
          side = "left";
        };
        view = {
          width = 25;
        };
        git = {
          enable = true;
        };
        filters = {
          dotfiles = true;
        };
      };
    };

    lz-n = {
      plugins = [
        {
          __unkeyed-1 = "nvim-tree.lua";
          cmd = [
            "NvimTreeToggle"
            "NvimTreeOpen"
            "NvimTreeClose"
            "NvimTreeRefresh"
            "NvimTreeFindFile"
          ];
        }
      ];
    };
  };
}
