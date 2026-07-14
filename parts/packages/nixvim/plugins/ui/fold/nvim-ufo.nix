{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isNvimUfo = (cfg.fold.use == "nvim-ufo");
in
{
  plugins = lib.mkIf (cfg.enable && isNvimUfo) {
    nvim-ufo = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [ "BufEnter" ];
        };
      };
      settings = {
        provider_selector = ''
          function(bufnr, filetype, buftype)
            if buftype == "nofile" or buftype == "prompt" then
              return ""
            end

            local exclude = {
              "alpha",
              "dashboard",
              "dbui",
              "dbout",
              "help",
              "lazy",
              "mason",
              "neo-tree",
              "neo-tree-popup",
              "noice",
              "notify",
              "spectre_panel",
              "sql",
              "qf",
              "toggleterm",
              "Outline",
              "TelescopePrompt",
              "TelescopeResults",
              "Trouble",
            }
            if vim.tbl_contains(exclude, filetype) then
              return ""
            end
            return { "treesitter", "indent" }
          end
        '';
      };
    };
  };
}
