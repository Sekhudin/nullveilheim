{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isBufferline = (cfg.tab.use == "bufferline");
in
{
  plugins = lib.mkIf (cfg.enable && isBufferline) {
    bufferline = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [
            "BufReadPost"
            "BufEnter"
          ];
        };
      };
      settings = {
        options = {
          mode = "buffers";
          always_show_bufferline = true;
          show_buffer_close_icons = false;
          show_close_icon = false;
          color_icons = true;
          separator_style = "slope";
          custom_filter = ''
            function(buf_number, buf_numbers)
              return not vim.tbl_contains({
                "help",
              }, vim.bo[buf_number].filetype)
            end
          '';
          offsets = [
            {
              filetype = "neo-tree";
              text.__raw = ''
                function()
                  local icon = "${icon.withRightSpace "folder_root_open"}"
                  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                  return icon .. cwd
                end
              '';
              text_align = "center";
              highlight = "NeoTreeRootName";
              padding = 2;
              separator = false;
            }
          ];
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<Tab>";
            __unkeyed-2 = "<cmd>BufferLineCycleNext<cr>";
            group = "buffer";
            desc = "first buffer";
          }
          {
            __unkeyed-1 = "<S-Tab>";
            __unkeyed-2 = "<cmd>BufferLineCyclePrev<cr>";
            group = "buffer";
            desc = "prev buffer";
          }
          {
            __unkeyed-1 = "<leader>bf";
            __unkeyed-2 = "<cmd>BufferLineGoToBuffer 1<cr>";
            desc = "first buffer";
          }
          {
            __unkeyed-1 = "<leader>bl";
            __unkeyed-2 = "<cmd>BufferLineGoToBuffer -1<cr>";
            desc = "last buffer";
          }
          {
            __unkeyed-1 = "<leader>bo";
            __unkeyed-2 = "<cmd>BufferLineCloseOthers<cr>";
            desc = "close other buffers";
          }
          {
            __unkeyed-1 = "<leader>w";
            __unkeyed-2 = "gt";
            desc = "next workspace";
          }
          {
            __unkeyed-1 = "<leader>W";
            __unkeyed-2 = "gT";
            desc = "prev workspace";
          }
        ];
      };
    };
  };
}
