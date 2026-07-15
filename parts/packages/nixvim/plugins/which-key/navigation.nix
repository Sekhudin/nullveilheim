{ ... }:

{
  plugins = {
    which-key = {
      settings = {
        replace = {
          desc = [
            [
              "<C-h>"
              "Ctrl+h"
            ]
            [
              "<C-l>"
              "Ctrl+l"
            ]
            [
              "<C-j>"
              "Ctrl+j"
            ]
            [
              "<C-k>"
              "Ctrl+k"
            ]
          ];
        };
        spec = [
          # window
          {
            __unkeyed-1 = "<C-h>";
            __unkeyed-2 = "<cmd>wincmd h<cr>";
            desc = "move to left window";
            mode = [
              "n"
              "t"
            ];
          }
          {
            __unkeyed-1 = "<C-l>";
            __unkeyed-2 = "<cmd>wincmd l<cr>";
            desc = "move to right window";
            mode = [
              "n"
              "t"
            ];
          }
          {
            __unkeyed-1 = "<C-j>";
            __unkeyed-2 = "<cmd>wincmd j<cr>";
            desc = "move to bellow window";
            mode = [
              "n"
              "t"
            ];
          }
          {
            __unkeyed-1 = "<C-k>";
            __unkeyed-2 = "<cmd>wincmd k<cr>";
            desc = "move to upper window";
            mode = [
              "n"
              "t"
            ];
          }

          # workspace
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

          # move code line
          {
            __unkeyed-1 = "<A-j>";
            __unkeyed-2 = "<cmd>m .+1<cr>==";
            desc = "move line down";
            mode = "n";
          }
          {
            __unkeyed-1 = "<A-k>";
            __unkeyed-2 = "<cmd>m .-2<cr>==";
            desc = "move line up";
            mode = "n";
          }
          {
            __unkeyed-1 = "<A-j>";
            __unkeyed-2 = ":m '>+1<cr>gv=gv";
            desc = "move selection down";
            mode = "v";
          }
          {
            __unkeyed-1 = "<A-k>";
            __unkeyed-2 = ":m '<-2<cr>gv=gv";
            desc = "move selection up";
            mode = "v";
          }
        ];
      };
    };
  };
}
