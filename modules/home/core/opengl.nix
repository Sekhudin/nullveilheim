{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeCoreModules.openGL;
  isOpenGL = (cfg.use != "default");
in
{
  options.homeCoreModules.openGL = {
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

  config = lib.mkIf isOpenGL {
    home = {
      packages = [
        pkgs.nixgl.${cfg.use}
      ];
    };
  };
}
