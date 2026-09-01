{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimLsp;
in
{
  plugins = lib.mkIf (cfg.interaction == "lspsaga") {
    lspsaga = {
      enable = true;
      settings = {
        lightbulb = {
          sign = false;
          virtualText = true;
          debounce = 40;
        };
        ui = {
          codeAction = icon.gear_sm;
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "K";
            __unkeyed-2 = "<cmd>Lspsaga hover_doc<cr>";
            desc = "hover documentation";
          }
          {
            __unkeyed-1 = "[e";
            __unkeyed-2 = "<cmd>Lspsaga diagnostic_jump_prev<cr>";
            desc = "previous diagnostic";
          }
          {
            __unkeyed-1 = "[E";
            __unkeyed-2 = "<cmd>Lspsaga diagnostic_jump_prev<cr><cmd>Lspsaga show_line_diagnostics<cr>";
            desc = "previous diagnostic (focus)";
          }
          {
            __unkeyed-1 = "]e";
            __unkeyed-2 = "<cmd>Lspsaga diagnostic_jump_next<cr>";
            desc = "next diagnostic";
          }
          {
            __unkeyed-1 = "]E";
            __unkeyed-2 = "<cmd>Lspsaga diagnostic_jump_next<cr><cmd>Lspsaga show_line_diagnostics<cr>";
            desc = "next diagnostic (focus)";
          }
          {
            __unkeyed-1 = "gd";
            __unkeyed-2 = "<cmd>Lspsaga peek_definition<cr>";
            desc = "peek definition";
          }
          {
            __unkeyed-1 = "gD";
            __unkeyed-2 = "<cmd>Lspsaga goto_definition<cr>";
            desc = "go to definition";
          }
          {
            __unkeyed-1 = "ga";
            __unkeyed-2 = "<cmd>Lspsaga code_action<cr>";
            desc = "code action";
          }
          {
            __unkeyed-1 = "gr";
            __unkeyed-2 = "<cmd>Lspsaga rename<cr>";
            desc = "rename symbol";
          }
          {
            __unkeyed-1 = "gF";
            __unkeyed-2 = "<cmd>Lspsaga finder<cr>";
            desc = "LSP finder";
          }
          {
            __unkeyed-1 = "<leader>lo";
            __unkeyed-2 = "<cmd>Lspsaga outline<cr>";
            desc = "[LSP] outline";
          }
          {
            __unkeyed-1 = "<leader>lc";
            __unkeyed-2 = "<cmd>Lspsaga incoming_calls<cr>";
            desc = "[LSP] incoming calls";
          }
          {
            __unkeyed-1 = "<leader>lC";
            __unkeyed-2 = "<cmd>Lspsaga outgoing_calls<cr>";
            desc = "[LSP] outgoing calls";
          }
        ];
      };
    };
  };
}
