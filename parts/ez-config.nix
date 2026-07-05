{
  inputs,
  lib,
  ...
}:

let
  shareable = (import ../shared).mkShareable { inherit lib; };
in
{
  imports = [
    inputs.ez-configs.flakeModule
  ];

  ezConfigs = rec {
    root = ./.;
    globalArgs = {
      inherit inputs;
      inherit (shareable)
        color
        icon
        extraLib
        ;
    };
    earlyModuleArgs = globalArgs;
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
