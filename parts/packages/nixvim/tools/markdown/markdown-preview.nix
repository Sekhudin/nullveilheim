{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimTools;
  enableMarkdown-preview = cfg.markdown == "markdown-preview";
in
{
  plugins.markdown-preview = {
    enable = enableMarkdown-preview;
    settings = {
      auto_start = 0;
      theme = "dark";
      port = "8686";
    };
  };

  plugins.which-key = lib.mkIf enableMarkdown-preview {
    settings.spec = [
      {
        __unkeyed-1 = "<leader>M";
        __unkeyed-2 = "<cmd>MarkdownPreviewToggle<cr>";
        icon = icon.markdown;
        desc = "markdown preview";
      }
    ];
  };
}
