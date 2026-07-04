{
  lib,
  ...
}:

{
  imports = [
    ./cross.nix
    ./darwin.nix
    ./linux.nix
  ];

  options.homeCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable packages modules";
      default = false;
    };
  };

  config = {
    programs.home-manager = {
      enable = true;
    };
  };
}
