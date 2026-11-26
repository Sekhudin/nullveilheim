{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimUI;
  enableNvim-tree = cfg.sidebar == "nvim-tree";
in
{
  plugins.nvim-tree = {
    enable = enableNvim-tree;
    settings = {
      view.side = "left";
      view.width = 25;
      git.enable = true;
      filters.dotfiles = true;
    };
  };

  globals = lib.mkIf enableNvim-tree {
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  plugins.lz-n = lib.mkIf enableNvim-tree {
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
}
