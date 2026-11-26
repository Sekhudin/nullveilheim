{ ... }:

{
  plugins.mini-bufremove = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" ];
    settings.silent = false;
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>x";
      __unkeyed-2 = "<cmd>lua require('mini.bufremove').wipeout()<cr>";
      desc = "close buffer";
    }
  ];
}
