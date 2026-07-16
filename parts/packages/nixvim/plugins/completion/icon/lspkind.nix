{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.completion;
  isLspKind = (cfg.icon.use == "lspkind");
in
{
  plugins = lib.mkIf (cfg.enable && isLspKind) {
    lspkind = {
      enable = true;
      settings = {
        symbolMap = {
          Codeium = icon.code;
          Copilot = icon.robot_face;
          Suggestion = icon.wand;
          TabNine = icon.face;
          Supermaven = icon.star;
          Error = icon.cross_4;
          Hint = icon.hint;
          Info = icon.info_2;
          Warn = icon.warning_2;
          DiagnosticSignError = icon.cross_4;
          DiagnosticSignHint = icon.hint;
          DiagnosticSignInfo = icon.info_2;
          DiagnosticSignWarn = icon.warning_2;
        };
        cmp = {
          enable = true;
          maxWidth = 24;
          after = ''
            function(entry, vim_item, kind)
              local strings = vim.split(kind.kind, "%s", { trimempty = true })
              kind.kind = " " .. (strings[1] or "") .. " "
              kind.menu = "   ⌈" .. (strings[2] or "") .. "⌋"
              return kind
            end
          '';
        };
      };
    };

    which-key = {
      settings = {
        spec = [
        ];
      };
    };
  };
}
