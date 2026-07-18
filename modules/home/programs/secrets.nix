{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeProgramsModules.secrets;
  masterEnable = config.homeProgramsModules.enable;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.homeProgramsModules.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable secrets";
      default = true;
    };

    secrets = lib.mkOption {
      type = lib.types.attrs;
      description = "secrets";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      packages = with pkgs; [
        sops
        gnupg
      ];
    };

    sops = {
      defaultSopsFile = "${inputs.self}/secrets/default.yaml";
      gnupg = {
        home = "~/.gnupg";
        sshKeyPaths = [ ];
      };
      secrets = lib.mkMerge [
        {

        }
        cfg.secrets
      ];
    };

    programs = {
      git = {
        settings = {
          diff = {
            sopsdiffer = {
              textconv = "sops -d --config /dev/null";
            };
          };
        };
      };
    };
  };
}
