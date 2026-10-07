{
  inputs,
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  activation = config.homeCore.activation;
  homeDirectory = config.home.homeDirectory;

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

  home.packages = with pkgs; [
    sops
    gnupg
  ];

  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    gnupg = {
      home = "${homeDirectory}/.gnupg";
      sshKeyPaths = [ ];
    };
    secrets = lib.mkMerge [
      (mkGPGKeySecrets activation.gpgKeys)
      (mkSSHKeySecrets activation.sshKeys)
      (mkGitIdentitySecrets activation.gitIdentities)
    ];
  };

  programs.git.settings.diff.sopsdiffer = {
    textconv = "sops -d --config /dev/null";
  };
}
