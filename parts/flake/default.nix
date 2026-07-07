{ ... }:

{
  imports = [
    ./auto-modules.nix
  ];

  autoModules = {
    commonModules = {
      dir = ../../modules/common;
    };
  };
}
