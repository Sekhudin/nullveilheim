{ ... }:

{
  plugins.gitsigns = {
    enable = true;
    lazyLoad.settings.event = [ "BufReadPost" ];
    settings = {
      numhl = true;
      linehl = false;
      current_line_blame = false;
      watch_gitdir.follow_files = true;
      current_line_blame_opts = {
        virt_text = true;
        delay = 500;
        ignore_whitespace = false;
      };
    };
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>ts";
      __unkeyed-2 = "<cmd>Gitsigns toggle_signs<cr>";
      desc = "toggle signs";
    }
    {
      __unkeyed-1 = "<leader>tn";
      __unkeyed-2 = "<cmd>Gitsigns toggle_numhl<cr>";
      desc = "toggle number highlights";
    }
    {
      __unkeyed-1 = "<leader>tl";
      __unkeyed-2 = "<cmd>Gitsigns toggle_linehl<cr>";
      desc = "toggle line highlights";
    }
    {
      __unkeyed-1 = "<leader>tw";
      __unkeyed-2 = "<cmd>Gitsigns toggle_word_diff<cr>";
      desc = "toggle word diff";
    }
    {
      __unkeyed-1 = "<leader>td";
      __unkeyed-2 = "<cmd>Gitsigns toggle_deleted<cr>";
      desc = "toggle deleted";
    }
    {
      __unkeyed-1 = "<leader>tb";
      __unkeyed-2 = "<cmd>Gitsigns toggle_current_line_blame<cr>";
      desc = "toggle blame";
    }
  ];
}
