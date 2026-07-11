{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeOpenGLModules;
  isOpenGL = (cfg.openGL != "default");
in
{
  options.homeOpenGLModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable openGL modules";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "default"
        "nixGLMesa"
        "nixGLIntel"
      ];
      description = "choose openGL";
      default = "default";
    };
  };

  config = lib.mkIf (isOpenGL && cfg.enable) {
    home = {
      packages = [
        pkgs.nixgl.${cfg.use}
      ];
    };
  };
}
