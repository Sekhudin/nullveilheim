{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.sidebar;
  isNeotree = (cfg.use == "neo-tree");
in
{
  plugins = lib.mkIf (cfg.enable && isNeotree) {
    neo-tree = {
      enable = true;
      settings = {
        hide_root_node = true;
        log_to_file = false;
        close_if_last_window = false;
        default_component_configs = {
          indent = {
            indent_size = 2;
            padding = 1;
            with_markers = true;
            indent_marker = icon.box_drawing_up;
            last_indent_marker = icon.box_drawing_up_right;
            highlight = "NeoTreeIndentMarker";
            with_expanders = true;
            expander_collapsed = icon.chevron_right;
            expander_expanded = icon.chevron_down;
            expander_highlight = "NeoTreeExpander";
          };
          icon = {
            default = icon.file_text;
            folder_empty = icon.folder_empty;
          };
          file_size = {
            enabled = true;
            width = 12;
            required_width = 40;
          };
        };
        window = {
          position = "left";
          width = 30;
          auto_expand_width = false;
          mapping_options = {
            noremap = true;
            nowait = true;
          };
          mappings = {
            "<space>" = {
              command = "toggle_node";
              config.nowait = false;
            };
            "<C-space>" = {
              command = "toggle_node";
              config.nowait = true;
            };
            "<C-u>" = {
              command = "scroll_preview";
              config.direction = 10;
            };
            "<C-d>" = {
              command = "scroll_preview";
              config.direction = -10;
            };
            "a" = {
              command = "add";
              config.show_path = "relative";
            };
            "A" = {
              command = "add_directory";
              config.show_path = "relative";
            };
          };
        };
        filesystem = {
          follow_current_file = {
            enabled = false;
            leave_dirs_open = false;
          };
          filtered_items = {
            hide_dotfiles = true;
            hide_gitignored = true;
            hide_by_name = [
              ".cache"
              ".DS_Store"
              ".envrc"
              ".gradle"
              ".idea"
              ".next"
              ".turbo"
              ".vscode"
              "build"
              "dist"
              "node_modules"
              "README.md"
              "target"
            ];
            hide_by_pattern = [
              "*.lock"
              "*.log"
              "*.tmp"
              ".env.*"
              "biome.*"
              "components.*"
              "postcss.*"
              "tsconfig.*"
            ];
            always_show_by_pattern = [
              "trax.*"
            ];
          };
        };
        git_status = {
          window = {
            mappings = {
              "A" = {
                command = "git_add_all";
              };
            };
          };
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>v";
            __unkeyed-2 = "<cmd>Neotree toggle<cr>";
            desc = "neotree toggle";
            icon = icon.toggle;
          }
        ];
      };
    };
  };
}
