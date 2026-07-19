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
  secretProfiles = cfg.secretProfiles;

  inherit (extraLib.sops)
    mkGPGKeySecrets
    mkSSHKeySecrets
    mkGitIdentitySecrets
    ;
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

    secretProfiles = lib.mkOption {
      type = lib.types.submodule {
        options = {
          gpgKey = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "gpg key profiles";
            default = [ ];
          };

          sshKey = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "ssh key profiles";
            default = [ ];
          };

          gitIdentity = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "git identity profiles";
            default = [ ];
          };
        };
      };
      description = "gpg profiles";
      default = { };
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
        (mkGPGKeySecrets secretProfiles.gpgKey)
        (mkSSHKeySecrets secretProfiles.sshKey)
        (mkGitIdentitySecrets secretProfiles.gitIdentity)
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
