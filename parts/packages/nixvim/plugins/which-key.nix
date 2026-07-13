{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.which-key;
in
{
  options.pluginsModules.which-key = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable which-key";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "extra settings";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      which-key = lib.mkMerge [
        {
          enable = true;
          settings = {
            delay = lib.mkDefault 0;
            expand = lib.mkDefault 1;
            notify = lib.mkDefault false;
            preset = lib.mkDefault true;
            win = {
              border = lib.mkDefault "single";
            };
            triggers = [
              {
                __unkeyed-1 = "<leader>";
                mode = "n";
              }
              {
                __unkeyed-1 = "g";
                mode = "n";
              }
            ];
            spec = [
              {
                __unkeyed-1 = "<leader>a";
                group = "ai";
                icon = icon.robot_face;
              }
              {
                __unkeyed-1 = "<leader>b";
                group = "buffer";
              }
              {
                __unkeyed-1 = "<leader>c";
                group = "claude";
                icon = icon.robot_face;
              }
              {
                __unkeyed-1 = "<leader>d";
                icon = icon.database;
                group = "database";
              }
              {
                __unkeyed-1 = "<leader>e";
                icon = icon.secret;
                group = "secret";
              }
              {
                __unkeyed-1 = "<leader>f";
                group = "find";
              }
              {
                __unkeyed-1 = "<leader>fg";
                group = "git";
              }
              {
                __unkeyed-1 = "<leader>fG";
                group = "github";
              }
              {
                __unkeyed-1 = "<leader>fl";
                group = "lsp";
              }
              {
                __unkeyed-1 = "<leader>g";
                group = "git";
              }
              {
                __unkeyed-1 = "<leader>gt";
                group = "gitsign";
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
                __unkeyed-1 = "<leader>n";
                group = "ui";
              }
              {
                __unkeyed-1 = "<leader>q";
                group = "quit";
                icon = icon.cross;
              }
              {
                __unkeyed-1 = "<leader>qq";
                __unkeyed-2 = "<cmd>qa!<cr>";
                desc = "quit all";
                icon = icon.cross;
              }
              {
                __unkeyed-1 = "<leader>qw";
                __unkeyed-2 = "<cmd>wqa<cr>";
                desc = "save & quit all";
                icon = icon.cross;
              }
              {
                __unkeyed-1 = "<leader>s";
                group = "replace";
                icon = icon.find_replace;
              }
              {
                __unkeyed-1 = "<leader>t";
                group = "terminal";
              }
              {
                __unkeyed-1 = "<leader>x";
                group = "diagnotics";
                icon = icon.warning;
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
          };
        }
        cfg.settings
      ];
    };
  };
}
