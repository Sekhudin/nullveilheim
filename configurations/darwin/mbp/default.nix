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
      shell = pkgs.fish;
    };
  };

  darwinCoreModules = {
    nix = {
      settings = {
        trusted-users = [ "syaikhu" ];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };
  };
}
