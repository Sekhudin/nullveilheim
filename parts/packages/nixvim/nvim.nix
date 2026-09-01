{ lib, ... }:

let
  mkImports =
    dirs:
    let
      scan =
        src:
        let
          files = builtins.readDir src;
        in
        lib.concatMap (
          name:
          let
            path = "${src}/${name}";
          in
          if builtins.match ".*\.nix" name != null then
            [ (import path) ]
          else if builtins.pathExists "${path}/default.nix" then
            [ (import path) ]
          else if builtins.pathExists path && builtins.readDir path != { } then
            scan path
          else
            [ ]
        ) (builtins.attrNames files);
    in
    lib.concatMap scan dirs;
in
{
  imports = mkImports [
    ./completion
    ./config
    ./lsp
    ./plugins
    ./tools
    ./ui
  ];

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
    colorscheme = "kanagawa";
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
