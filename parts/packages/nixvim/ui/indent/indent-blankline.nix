{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimUI;
in
{
  plugins = lib.mkIf (cfg.indent == "indent-blankline") {
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
