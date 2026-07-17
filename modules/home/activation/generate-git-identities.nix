{
  config,
  lib,
  ...
}:

let
  cfg = config.activationModules.generate-git-identities;
  masterEnable = config.activationModules.enable;
in
{
  options.activationModules.generate-git-identities = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = false;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      activation = {
        generateGitIdentities = lib.hm.dag.entryAfter [ "writeBoundary" "setupSecrets" ] ''

        '';
      };
    };
  };
}
