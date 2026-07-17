{
  lib,
  ...
}:

{
  imports = [
    ./generate-git-identities.nix
    ./import-gpg-key.nix
  ];

  options.activationModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = false;
    };
  };
}
