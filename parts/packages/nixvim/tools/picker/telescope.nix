{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimTools;
in
{
  extraPlugins = lib.mkIf (cfg.picker == "telescope") (
    with pkgs.vimPlugins;
    [
      telescope-github-nvim
    ]
  );

  plugins = lib.mkIf (cfg.picker == "telescope") {
    telescope = {
      enable = true;
      lazyLoad = {
        settings = {
          cmd = [ "Telescope" ];
          keys = lib.attrNames config.plugins.telescope.keymaps;
        };
      };
      enabledExtensions = [ "gh" ];
      settings = {
        default = {
          file_ignore_patterns = [
            "%.ipynb"
            "%.lock"
            "%.log"
            "^.cache/"
            "^.devenv/"
            "^.direnv/"
            "^.git/"
            "^.mypy_cache/"
            "^.next/"
            "^.nuxt/"
            "^.pytest_cache/"
            "^.ruff_cache/"
            "^.svelte-kit/"
            "^.venv/"
            "^__pycache__/"
            "^build/"
            "^data/"
            "^dist/"
            "^node_modules/"
            "^out/"
            "^output/"
            "^result/"
            "^target/"
            "^vendor/"
            "^venv/"
          ];
        };
      };
      keymaps = {
        "<leader>f" = {
          action = "find_files";
          options.desc = "find files";
        };
        "<leader>/" = {
          action = "live_grep";
          options.desc = "live grep";
        };
        "<leader>*" = {
          action = "grep_string";
          options.desc = "grep word under cursor";
        };
        "<leader>b" = {
          action = "buffers";
          options.desc = "find buffers";
        };
        "<leader>B" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "fuzzy find in buffer";
        };
        "<leader>h" = {
          action = "help_tags";
          options.desc = "help tags";
        };
        "<leader>H" = {
          action = "highlights";
          options.desc = "highlights";
        };
        "<leader>c" = {
          action = "colorscheme";
          options.desc = "colorscheme";
        };
        "<leader>gs" = {
          action = "git_status";
          options.desc = "git status";
        };
        "<leader>gb" = {
          action = "git_branches";
          options.desc = "git branches";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "git commits";
        };
        "<leader>gC" = {
          action = "git_bcommits";
          options.desc = "buffer commits";
        };
        "<leader>gr" = {
          action = "git_bcommits_range";
          options.desc = "commits in range";
        };
        "<leader>gS" = {
          action = "git_stash";
          options.desc = "git stash";
        };
        "<leader>gi" = {
          action = "gh issues";
          options.desc = "github issues";
        };
        "<leader>gp" = {
          action = "gh pull_requests";
          options.desc = "github pull requests";
        };
        "<leader>ga" = {
          action = "gh run";
          options.desc = "github actions";
        };
        "<leader>gg" = {
          action = "gh gist";
          options.desc = "github gists";
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          # keymaps
          {
            __unkeyed-1 = "<leader>lr";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').lsp_references()<cr>";
            desc = "references";
          }
          {
            __unkeyed-1 = "<leader>ld";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>";
            desc = "definitions";
          }
          {
            __unkeyed-1 = "<leader>li";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>";
            desc = "implementations";
          }
          {
            __unkeyed-1 = "<leader>lt";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>";
            desc = "type definitions";
          }
          {
            __unkeyed-1 = "<leader>ls";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>";
            desc = "document symbols";
          }
          {
            __unkeyed-1 = "<leader>lw";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>";
            desc = "workspace symbols";
          }
          {
            __unkeyed-1 = "<leader>lD";
            __unkeyed-2 = "<cmd>lua require('telescope.builtin').diagnostics()<cr>";
            desc = "diagnostics";
          }
        ];
      };
    };
  };
}
