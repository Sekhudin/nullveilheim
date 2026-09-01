{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimTools;
in
{
  plugins = lib.mkIf (cfg.markdown == "markdown-preview") {
    markdown-preview = {
      enable = true;
      settings = {
        auto_start = 0;
        theme = "dark";
        port = "8686";
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>mm";
            __unkeyed-2 = "<cmd>MarkdownPreviewToggle<cr>";
            icon = icon.markdown;
            desc = "markdown preview";
          }
        ];
      };
    };
  };
}
