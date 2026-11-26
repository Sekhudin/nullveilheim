{ icon, ... }:

{
  plugins.which-key.settings.spec = [
    # common
    {
      __unkeyed-1 = "<Esc><Esc>";
      __unkeyed-2 = "<C-\\><C-n>";
      desc = "normal mode";
      mode = [ "t" ];
    }
    {
      __unkeyed-1 = "<leader><Esc>";
      __unkeyed-2 = "<cmd>nohlsearch<cr>";
      desc = "clear search highlight";
      mode = [ "n" ];
    }
    {
      __unkeyed-1 = "<leader>q";
      __unkeyed-2 = "<cmd>q<cr>";
      desc = "quit window";
      icon = icon.cross;
    }
    {
      __unkeyed-1 = "<leader>Q";
      __unkeyed-2 = "<cmd>qa!<cr>";
      desc = "quit all";
      icon = icon.cross;
    }
    {
      __unkeyed-1 = "<leader>w";
      __unkeyed-2 = "<cmd>write<cr>";
      desc = "write buffer";
    }

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
      desc = "move to below window";
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

    # window size
    {
      __unkeyed-1 = "<A-.>";
      __unkeyed-2 = "<cmd>vertical resize -5<cr>";
      desc = "narrow window";
      mode = "n";
    }
    {
      __unkeyed-1 = "<A-,>";
      __unkeyed-2 = "<cmd>vertical resize +5<cr>";
      desc = "widen window";
      mode = "n";
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
}
