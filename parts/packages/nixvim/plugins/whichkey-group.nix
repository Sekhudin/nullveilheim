{ icon, ... }:

{
  plugins = {
    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>a";
            group = "ai";
            icon = icon.robot_face;
          }
          {
            __unkeyed-1 = "<leader>d";
            icon = icon.database;
            group = "database";
          }
          {
            __unkeyed-1 = "<leader>l";
            group = "lsp";
            icon = icon.code;
          }
          {
            __unkeyed-1 = "<leader>m";
            group = "mode";
            icon = icon.linux;
          }
          {
            __unkeyed-1 = "<leader>q";
            group = "quit";
            icon = icon.cross;
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
        ];
      };
    };
  };
}
