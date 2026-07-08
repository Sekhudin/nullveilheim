{ ... }:

{
  imports = [
    ./auto-modules.nix
  ];

  autoModules = {
    common = {
      dir = ../../modules/common;
    };
  };
}
