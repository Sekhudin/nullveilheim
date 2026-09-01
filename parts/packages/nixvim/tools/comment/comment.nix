{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimTools;
in
{
  plugins = lib.mkIf (cfg.comment == "comment") {
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
