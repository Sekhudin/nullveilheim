{ config, lib, ... }:

let
  cfg = config.homeDesktop;
in
{

  imports = [
    ./hypr
    ./noctalia
  ];

  options.homeDesktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable desktop modules";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "noctalia"
      ];
      description = "choose desktop shell";
      default = "noctalia";
    };

    noctalia.enable = lib.mkOption {
      type = lib.types.bool;
      readOnly = true;
      internal = true;
    };
  };

  config = {
    homeDesktop = {
      noctalia.enable = cfg.enable && cfg.use == "noctalia";
    };
  };
}
