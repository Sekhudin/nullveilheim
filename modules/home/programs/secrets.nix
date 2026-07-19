{
  inputs,
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeProgramsModules.secrets;
  masterEnable = config.homeProgramsModules.enable;
  inherit (extraLib.sops) mkSecretAttrs;
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
      defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
      gnupg = {
        home = "${config.home.homeDirectory}/.gnupg";
        sshKeyPaths = [ ];
      };
      secrets = lib.mkMerge [
        (mkSecretAttrs {
          path = "gpg_keys.personal";
          fields = [
            "email"
            "private_key"
            "owner_trust"
          ];
        })
        (mkSecretAttrs {
          path = "ssh_keys.personal";
          fields = [
            "path"
            "private_key"
          ];
        })
        (mkSecretAttrs {
          path = "git_identities.personal";
          fields = [
            "name"
            "email"
            "signing_key"
            "ssh_key"
            "gitdirs/projects"
            "gitdirs/opensource"
          ];
        })
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
