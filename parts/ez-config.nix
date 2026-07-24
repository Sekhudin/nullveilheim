{
  inputs,
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
      acer-swift = {
        userHomeModules = [ "syaikhu" ];
      };
    };
  };

  ezConfigs.darwin = {
    modulesDirectory = ../modules/darwin;
    configurationsDirectory = ../configurations/darwin;
    hosts = {
      mbp = {
        userHomeModules = [ "syaikhu" ];
      };
    };
  };

  ezConfigs.home =
    let
      standalone = {
        enable = true;
        pkgs = import inputs.nixpkgs {
          inherit (inputs.self.nullveilheimConfigurations.nixpkgs)
            config
            overlays
            ;
        };
      };
    in
    {
      modulesDirectory = ../modules/home;
      configurationsDirectory = ../configurations/home;
      users = {
        syaikhu = {
          inherit standalone;
        };
      };
    };

}
