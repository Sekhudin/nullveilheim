{ inputs, ... }:

{
  imports = [
    inputs.ez-configs.flakeModule
  ];

  ezConfigs.root = ./.;
  ezConfigs.earlyModuleArgs = { };
  ezConfigs.globalArgs = {

  };

  ezConfigs.nixos = {
    modulesDirectory = ../modules/nixos;
    configurationsDirectory = ../configurations/nixos;
    hosts = {
      acer-swift.userHomeModules = [ "syaikhu" ];
    };
  };

  ezConfigs.darwin = { };

  ezConfigs.home = {
    modulesDirectory = ../modules/home;
    configurationsDirectory = ../configurations/home;
  };

}
