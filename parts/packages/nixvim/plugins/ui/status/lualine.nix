{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isLualine = (cfg.status.use == "lualine");
in
{
  plugins = lib.mkIf (cfg.enable && isLualine) {
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          icon_enabled = true;
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = icon.circle_right;
            right = icon.circle_left;
          };
          disabled_filetypes = {
            statusline = [ ];
          };
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            "diff"
          ];
          lualine_c = [ "diagnostics" ];
          lualine_x = [
            "searchcount"
            "selectcount"
          ];
          lualine_y = [ "lsp_status" ];
          lualine_z = [ "location" ];
        };
      };
    };
  };
}
