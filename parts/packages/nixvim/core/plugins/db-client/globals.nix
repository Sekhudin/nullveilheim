{ icon, ... }:

{
  globals = {
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
}
