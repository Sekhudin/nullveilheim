{
  pkgs,
  config,
  lib,
  extraLib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.database;
  inherit (extraLib.nixvim) ftMatches;
in
{
  globals = lib.mkIf cfg.enable {
    db_ui_debug = 0;
    db_ui_show_help = 0;
    db_ui_use_nerd_fonts = 1;
    db_ui_execute_on_save = 0;
    db_ui_show_database_icon = 0;
    db_ui_use_nvim_notify = 1;
    db_ui_win_position = "right";
    db_ui_disable_mappings = 0;
    db_ui_disable_mappings_dbui = 0;
    db_ui_disable_mappings_dbout = 1;
    db_ui_disable_mappings_sql = 1;
    db_ui_disable_mappings_javascript = 1;
    db_ui_disable_info_notifications = 1;
    db_ui_icon = {
      saved_query = icon.file_code;
      tables = icon.table_multiple;
      collapsed = {
        db = icon.withCollapsed "database";
        buffers = icon.withCollapsed "folder_close";
        saved_queries = icon.withCollapsed "folder_close";
        schemas = icon.withCollapsed "list_group";
        schema = icon.withCollapsed "file_tree";
        tables = icon.withCollapsed "table_multiple";
        table = icon.withCollapsed "table";
      };
      expanded = {
        db = icon.withExpanded "database";
        buffers = icon.withExpanded "folder_open";
        saved_queries = icon.withExpanded "folder_open";
        schemas = icon.withExpanded "list_group";
        schema = icon.withExpanded "file_tree";
        tables = icon.withExpanded "table_multiple";
        table = icon.withExpanded "table";
      };
    };
  };

  extraPackages = lib.mkIf cfg.enable (
    with pkgs;
    [
      postgresql
    ]
  );

  plugins = lib.mkIf cfg.enable {
    vim-dadbod = {
      enable = true;
    };
    vim-dadbod-ui = {
      enable = true;
    };
    vim-dadbod-completion = {
      enable = true;
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>du";
            __unkeyed-2 = "<cmd>DBUIToggle<cr>";
            desc = "dbui toggle";
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
      };
    };
  };
}
