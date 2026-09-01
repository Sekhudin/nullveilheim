{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimLsp;
in
{
  extraPackages = lib.mkIf (cfg.formatter == "conform-nvim") (
    with pkgs;
    [
      biome
      gofumpt
      gotools
      prettier
      nixfmt
      prettierd
      ruff
      rustfmt
      shfmt
      sqruff
      stylua
    ]
  );

  plugins = lib.mkIf (cfg.formatter == "conform-nvim") {
    conform-nvim = {
      enable = true;
      settings = {
        default_format_opts = {
          stop_after_first = true;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          css = [ "prettierd" ];
          go = {
            __unkeyed-1 = "gofumpt";
            __unkeyed-2 = "goimports";
            stop_after_first = false;
          };
          html = [ "prettierd" ];
          javascript = [
            "biome"
            "prettierd"
          ];
          json = [
            "biome"
          ];
          lua = [ "stylua" ];
          markdown = [ "prettierd" ];
          python = [ "ruff_format" ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
          sql = [ "sqruff" ];
          typescript = [
            "biome"
            "prettierd"
          ];
          javascriptreact = [
            "biome"
            "prettierd"
          ];
          typescriptreact = [
            "biome"
            "prettierd"
          ];
          yaml = [ "prettierd" ];
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>lf";
            __unkeyed-2 = "<cmd>lua require('conform').format({ async = false }); vim.cmd('update')<cr>";
            desc = "[LSP] format buffer";
          }
        ];
      };
    };
  };
}
