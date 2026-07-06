{ config, lib, ... }:

let
  cfg = config.nixosProgramsModules.steam;
  masterEnable = config.nixosProgramsModules.enable;
in
{
  options.nixosProgramsModules.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable steam";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "steam settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs.steam = lib.mkMerge [
      {
        enable = true;
        remotePlay = {
          openFirewall = lib.mkDefault true;
        };
        dedicatedServer = {
          openFirewall = lib.mkDefault true;
        };
      }
      cfg.settings
    ];
  };
}
