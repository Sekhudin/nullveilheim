{
  lib,
  ...
}:

{
  imports = [
    ./cross.nix
    ./darwin.nix
    ./linux.nix
    ./opengl.nix
  ];

  options.homeCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable packages modules";
      default = false;
    };

    enableStandalone = lib.mkOption {
      type = lib.types.bool;
      description = "enable standalone";
      default = false;
    };
  };

  config = {
    programs.home-manager = {
      enable = true;
    };
  };
}
