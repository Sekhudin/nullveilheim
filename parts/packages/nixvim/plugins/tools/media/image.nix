{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isImage = (cfg.markdown.use == "image");
in
{
  plugins = lib.mkIf (cfg.enable && isImage) {
    image = {
      enable = true;
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
