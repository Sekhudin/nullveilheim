{ config, icon, ... }:

let
  cfg = config.nixvimUI;
  enableLualine = cfg.status == "lualine";
in
{
  plugins.lualine = {
    enable = enableLualine;
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
      };
      sections = {
        lualine_a = [
          "mode"
        ];
        lualine_b = [
          "branch"
          "diff"
        ];
        lualine_c = [
          "diagnostics"
        ];
        lualine_x = [
          "searchcount"
          "selectcount"
        ];
        lualine_y = [
          "lsp_status"
        ];
        lualine_z = [
          "location"
        ];
      };
    };
  };
}
