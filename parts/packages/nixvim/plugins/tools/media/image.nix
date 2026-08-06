{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isImage = (cfg.media.use == "image");
in
{
  plugins = lib.mkIf (cfg.enable && isImage) {
    image = {
      enable = lib.mkDefault true;
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
