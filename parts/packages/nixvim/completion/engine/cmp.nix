{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimCompletion;
in
{
  plugins = lib.mkIf (cfg.engine == "cmp") {
    cmp = {
      enable = true;
      autoEnableSources = true;
      cmdline = {
        "/" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [ { name = "buffer"; } ];
        };
        "?" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [ { name = "buffer"; } ];
        };
        ":" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
            { name = "async_path"; }
          ];
        };
      };
      settings = {
        experimental = {
          ghost_text = false;
        };
        window = {
          documentation = {
            border = "rounded";
          };
          completion = {
            border = "rounded";
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            col_offset = -3;
            side_padding = 0;
          };
        };
        perfomance = {
          debounce = 60;
          fetching_timeout = 200;
          max_view_entries = 30;
        };
        snippet = {
          expand = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
        };
        formatting = {
          expandable_indicator = true;
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
        };
        mapping = {
          "<C-l>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
        sources = [
          {
            name = "nvim_lsp";
            group_index = 1;
          }
          {
            name = "nvim_lsp_signature_help";
            group_index = 1;
          }
          {
            name = "luasnip";
            group_index = 1;
          }
          {
            name = "vim-dadbod-completion";
            group_index = 1;
          }
          {
            name = "nvim_lsp_document_symbol";
            group_index = 2;
          }
          {
            name = "buffer";
            group_index = 2;
          }

          {
            name = "async_path";
            group_index = 3;
          }

          {
            name = "npm";
            keyword_length = 4;
            group_index = 4;
          }
          {
            name = "emoji";
            trigger_characters = [ ":" ];
            group_index = 4;
          }
          {
            name = "calc";
            group_index = 4;
          }
          {
            name = "yanky";
            group_index = 4;
          }
        ];
      };
    };

    which-key = {
      settings = {
        spec = [
        ];
      };
    };
  };
}
