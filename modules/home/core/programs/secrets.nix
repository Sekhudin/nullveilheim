{
  inputs,
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeCore.programs.secrets;

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

  options.homeCore.programs.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable secrets";
      default = true;
    };

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

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      sops
      gnupg
    ];

    sops = {
      defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
      gnupg = {
        home = "${config.home.homeDirectory}/.gnupg";
        sshKeyPaths = [ ];
      };
      secrets = lib.mkMerge [
        (mkGPGKeySecrets cfg.gpgKeys)
        (mkSSHKeySecrets cfg.sshKeys)
        (mkGitIdentitySecrets cfg.gitIdentities)
      ];
    };

    programs.git.settings.diff.sopsdiffer = {
      textconv = "sops -d --config /dev/null";
    };
  };
}
