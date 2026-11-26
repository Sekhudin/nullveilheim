{
  config,
  icon,
  ...
}:

let
  cfg = config.nixvimUI;
  enableIndent-blankline = cfg.indent == "indent-blankline";
in
{
  plugins.indent-blankline = {
    enable = enableIndent-blankline;
    settings = {
      indent.char = icon.vertical;
      whitespace.highlight = [ "Whitespace" ];
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
}
