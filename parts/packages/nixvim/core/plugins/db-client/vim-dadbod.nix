{ pkgs, extraLib, ... }:

let
  inherit (extraLib.nixvim) ftMatches;
in
{
  extraPackages = with pkgs; [
    postgresql
  ];

  plugins.vim-dadbod.enable = true;
  plugins.vim-dadbod-ui.enable = true;
  plugins.vim-dadbod-completion.enable = true;

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>dt";
      __unkeyed-2 = "<cmd>DBUIToggle<cr>";
      desc = "db toggle";
    }
    {
      __unkeyed-1 = "<leader>da";
      __unkeyed-2 = "<cmd>DBUIAddConnection<cr>";
      desc = "add connection";
    }
    {
      __unkeyed-1 = "<leader>di";
      __unkeyed-2 = "<cmd>DBUILastQueryInfo<cr>";
      desc = "last query info";
    }
    {
      __unkeyed-1 = "<leader>ds";
      __unkeyed-2 = "<Plug>(DBUI_SaveQuery)";
      desc = "save query";
    }
    {
      __unkeyed-1 = "<leader>dr";
      __unkeyed-2 = "<Plug>(DBUI_ToggleResultLayout)";
      desc = "toggle result";
    }
    {
      __unkeyed-1 = "<leader>de";
      __unkeyed-2 = "<Plug>(DBUI_ExecuteQuery)";
      desc = "execute query";
      mode = [ "v" ];
      cond = ftMatches [ "sql" ];
    }
    {
      __unkeyed-1 = "<M-x>";
      __unkeyed-2 = "<Plug>(DBUI_ExecuteQuery)";
      desc = "execute query";
      mode = [ "v" ];
      cond = ftMatches [ "sql" ];
    }
  ];
}
