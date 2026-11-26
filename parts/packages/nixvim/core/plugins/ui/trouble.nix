{ icon, ... }:

{
  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = [ "Trouble" ];
    settings = { };
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>lx";
      __unkeyed-2 = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      desc = "buffer diagnostics";
      icon = icon.warning;
    }
    {
      __unkeyed-1 = "<leader>lX";
      __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
      desc = "workspace diagnostics";
    }
  ];
}
