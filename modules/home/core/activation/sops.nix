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
    mkSecretAttrs
    mkGPGKeySecrets
    mkSSHKeySecrets
    mkGitIdentitySecrets
    ;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = lib.mkIf activation.enable (
    with pkgs;
    [
      sops
      gnupg
    ]
  );

  sops = lib.mkIf activation.enable {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    gnupg = {
      home = "${homeDirectory}/.gnupg";
      sshKeyPaths = [ ];
    };
    secrets = lib.mkMerge [
      (mkGPGKeySecrets activation.gpgKeys)
      (mkSSHKeySecrets activation.sshKeys)
      (mkGitIdentitySecrets activation.gitIdentities)
      (mkSecretAttrs {
        path = "tokens.personal";
        fields = [ "nullveilheim_mcp" ];
      })
    ];
  };

  programs.git.settings.diff.sopsdiffer = lib.mkIf activation.enable {
    textconv = "sops -d --config /dev/null";
  };
}
