{
  lib,
  pkgs,
  ezModules,
  ...
}:

{
  imports = lib.attrValues ezModules ++ [
    ./hardware-configuration.nix
  ];

  system.stateVersion = 6;
  system.primaryUser = "syaikhu";

  users.users = {
    syaikhu = {
      home = "/Users/syaikhu";
    };
  };

  commonModules = {
    enable = true;
    nixpkgs = {
      enableOverlays = true;
    };

    nix = {
      settings = {
        trusted-users = [ "syaikhu" ];
      };
    };
  };

  darwinCoreModules = {
    enable = true;
  };
}
