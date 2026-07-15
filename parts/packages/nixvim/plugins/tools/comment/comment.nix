{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isComment = (cfg.comment.use == "comment");
in
{
  plugins = lib.mkIf (cfg.enable && isComment) {
    comment = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };
      settings = { };
    };

    which-key = {
      settings = {
        spec = [
        ];
      };
    };
  };
}
