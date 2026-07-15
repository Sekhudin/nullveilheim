{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isTsAutotag = (cfg.tag.use == "ts-autotag");
in
{
  plugins = lib.mkIf (cfg.enable && isTsAutotag) {
    ts-autotag = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [ "InsertEnter" ];
        };
      };
      settings = {
        opts = {
          enable_close = true;
          enable_close_on_slash = true;
          enable_rename = true;
        };
        aliases = {
          astro = "html";
          blade = "html";
          eruby = "html";
          handlebars = "glimmer";
          hbs = "glimmer";
          htmldjango = "html";
          javascript = "typescriptreact";
          "javascript.jsx" = "typescriptreact";
          javascriptreact = "typescriptreact";
          markdown = "html";
          php = "html";
          rescript = "typescriptreact";
          rust = "rust";
          twig = "html";
          typescript = "typescriptreact";
          "typescript.tsx" = "typescriptreact";
          vue = "html";
        };
      };
    };
  };
}
