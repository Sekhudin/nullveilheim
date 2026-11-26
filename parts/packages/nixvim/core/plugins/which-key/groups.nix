{ icon, ... }:

{
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>d";
      group = "database";
      icon = icon.database;
    }
    {
      __unkeyed-1 = "<leader>g";
      group = "git";
    }
    {
      __unkeyed-1 = "<leader>l";
      group = "lsp";
      icon = icon.code;
    }
    {
      __unkeyed-1 = "<leader>n";
      group = "noice";
    }
    {
      __unkeyed-1 = "<leader>t";
      group = "toggle";
    }
    {
      __unkeyed-1 = "[";
      group = "backward";
    }
    {
      __unkeyed-1 = "]";
      group = "forward";
    }
    {
      __unkeyed-1 = "g";
      group = "goto";
    }
    {
      __unkeyed-1 = "s";
      group = "seek";
    }
    {
      __unkeyed-1 = "z";
      group = "fold";
    }
  ];
}
