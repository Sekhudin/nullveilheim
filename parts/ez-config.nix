{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.ez-configs.flakeModule
  ];

  ezConfigs = rec {
    root = ./.;
    globalArgs = {
      inherit inputs;
      inherit (inputs) self;
      inherit (inputs.self.nullveilheimConfigurations)
        color
        icon
        font
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

  ezConfigs.home = {
    modulesDirectory = ../modules/home;
    configurationsDirectory = ../configurations/home;
    users = {
      syaikhu = {
        standalone = {
          inherit pkgs;
          enable = true;
        };
      };
    };
  };

}
