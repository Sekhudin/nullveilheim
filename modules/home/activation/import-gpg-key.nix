{
  config,
  lib,
  ...
}:

let
  cfg = config.activationModules.import-gpg-key;
  masterEnable = config.activationModules.enable;
in
{
  options.activationModules.import-gpg-key = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = false;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      activation = {
        importGPGKey = lib.hm.dag.entryAfter [ "writeBoundary" "setupSecrets" ] ''

        '';
      };
    };
  };
}
