{ ... }:

{
  nixvimDashboard = {
    theme = "hyper";
    configDir = "~/nullveilheim";
    banner = rec {
      header = {
        ascii = "prabski_sawit";
        head = 16;
        gap = 1;
      };
      footer = {
        ascii = header.ascii;
        tail = 5;
        gap = 1;
      };
    };
  };

  nixvimConfig = {
    autosave = true;
    colorscheme = "base16";
  };

  nixvimCompletion = {
    engine = "cmp";
    icon = "lspkind";
    snippet = "luasnip";
  };

  nixvimLsp = {
    formatter = "conform-nvim";
    interaction = "lspsaga";
  };

  nixvimUI = {
    cursor = "smear-cursor";
    diagnostic = "trouble";
    focus = "zen-mode";
    fold = "nvim-ufo";
    indent = "indent-blankline";
    overlay = "noice";
    sidebar = "neo-tree";
    status = "lualine";
    syntax = "rainbow-delimiters";
    tab = "bufferline";
  };

  nixvimTools = {
    comment = "comment";
    markdown = "markdown-preview";
    motion = "hop";
    pairs = "nvim-autopairs";
    picker = "telescope";
  };
}
