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
          gpgKeys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "gpg key profiles";
            default = [ ];
          };

          sshKeys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "ssh key profiles";
            default = [ ];
          };

          gitIdentities = lib.mkOption {
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
        (mkGPGKeySecrets secretProfiles.gpgKeys)
        (mkSSHKeySecrets secretProfiles.sshKeys)
        (mkGitIdentitySecrets secretProfiles.gitIdentities)
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
