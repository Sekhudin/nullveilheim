{ lib, ... }:

{

  imports = [
    ./hypr
  ];

  options.homeDesktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable desktop modules";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "noctalia"
            ];
            description = "choose desktop shell";
            default = "noctalia";
          };
        };
      };
    };
  };
}
