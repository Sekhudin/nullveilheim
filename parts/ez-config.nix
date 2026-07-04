{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  shareable = (import ../shared).mkShareable { inherit pkgs lib; };
in
{
  imports = [
    inputs.ez-configs.flakeModule
  ];

  ezConfigs = {
    root = ./.;
    globalArgs = {
      inherit (shareable)
        color
        icon
        font
        extraLib
        nixpkgsConfig
        ;
      inherit
        inputs
        ;
    };
  };

  ezConfigs.nixos = {
    modulesDirectory = ../modules/nixos;
    configurationsDirectory = ../configurations/nixos;
    hosts = {
      acer-swift.userHomeModules = [ "syaikhu" ];
    };
  };

  ezConfigs.darwin = {
    modulesDirectory = ../modules/darwin;
    configurationsDirectory = ../configurations/darwin;
  };

  ezConfigs.home =
    let
      overlays = lib.attrValues inputs.self.overlays ++ [
        inputs.nixgl.overlay
      ];
    in
    {
      modulesDirectory = ../modules/home;
      configurationsDirectory = ../configurations/home;
      users = {
        syaikhu = {
          standalone = {
            enable = true;
            pkgs = import inputs.nixpkgs {
              system = "x86_64-linux";
              inherit overlays;
            };
          };
        };
      };
    };

}
