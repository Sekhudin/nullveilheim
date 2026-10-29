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
      inherit (inputs.self.nullveilheim)
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
      acerswift = {
        userHomeModules = {
          syaikhu = "syaikhu";
        };
      };

      t14 = {
        userHomeModules = {
          syaikhu = "syaikhu";
        };
      };
    };
  };

  ezConfigs.darwin = {
    modulesDirectory = ../modules/darwin;
    configurationsDirectory = ../configurations/darwin;
    hosts = {
      mbp = {
        userHomeModules = {
          syaikhu = "syaikhu";
        };
      };
    };
  };

  ezConfigs.home = {
    modulesDirectory = ../modules/home;
    configurationsDirectory = ../configurations/home;
    users = {
      syaikhu = { };
      syaikhu-sa = {
        standalone = {
          enable = true;
          pkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
            inherit (inputs.self.nullveilheim.nixpkgs)
              config
              overlays
              ;
          };
        };
      };
    };
  };
}
