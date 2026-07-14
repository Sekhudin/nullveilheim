{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isIndentBlanklinne = (cfg.indent.use == "indent-blankline");
in
{
  plugins = lib.mkIf (cfg.enable && isIndentBlanklinne) {
    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = icon.vertical;
        };
        whitespace = {
          highlight = [ "Whitespace" ];
        };
        scope = {
          enabled = false;
          char = icon.indent;
        };
        exclude = {
          buftypes = [
            "nofile"
            "terminal"
            "neorg"
          ];
          filetypes = [
            "norg"
            "NeoTree"
            "sagaoutline"
            "help"
            "terminal"
            "dashboard"
            "lspinfo"
            "TelescopePrompt"
            "TelescopeResults"
          ];
        };
      };
    };
  };
}
