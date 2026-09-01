{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimUI;
in
{
  globals = lib.mkIf (cfg.sidebar == "nvim-tree") {
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  plugins = lib.mkIf (cfg.sidebar == "nvim-tree") {
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
