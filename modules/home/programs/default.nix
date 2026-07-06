{ lib, ... }:

{

  imports = [
    ./multimedia.nix
    ./productivity.nix
  ];

  options.homeProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = false;
    };

    openGL = lib.mkOption {
      type = lib.types.enum [
        "default"
        "nixGLMesa"
        "nixGLIntel"
      ];
      description = "choose opengl";
      default = "default";
    };
  };
}
