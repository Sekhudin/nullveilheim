{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.activationModules.importGPGKeys;
  masterEnable = config.activationModules.enable;
  inherit (config.homeProgramsModules.secrets) secretProfiles;

  gpg = "${pkgs.gnupg}/bin/gpg";
  f = extraLib.activation.mkHelper {
    context = "import-gpg-keys";
    inherit pkgs;
  };

  mkIdentity = profile: ''
    import_identity \
      "${config.sops.secrets."gpg_keys_${profile}_email".path}" \
      "${config.sops.secrets."gpg_keys_${profile}_private_key".path}" \
      "${config.sops.secrets."gpg_keys_${profile}_owner_trust".path}"
  '';
in
{
  options.activationModules.importGPGKeys = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      activation = {
        importGPGKeys = lib.hm.dag.entryAfter [ "installSSHKeys" ] ''
          set -euo pipefail

          ${f.shell}

          import_key() {
            local key_file="$1"

            ${gpg} --batch --import "$key_file"
          }

          import_ownertrust() {
            local trust_file="$1"

            ${gpg} --batch --import-ownertrust "$trust_file"
          }

          import_identity() {
            local email_file="$1"
            local key_file="$2"
            local trust_file="$3"

            [[ -f "$email_file" ]] || {
              ${f.fatal} "Missing email secret: $email_file" >&2
            }

            [[ -f "$key_file" ]] || {
              ${f.fatal} "Missing private key secret: $key_file" >&2
            }

            [[ -f "$trust_file" ]] || {
              ${f.fatal} "Missing ownertrust secret: $trust_file" >&2
            }

            local email
            email="$(<"$email_file")"

            [[ -n "$email" ]] || {
              ${f.fatal} "Missing email value" >&2
            }

            ${f.log} "Checking GPG identity: $email"
            if ${gpg} --list-secret-keys "$email" >/dev/null 2>&1; then
              ${f.log} "GPG identity already exists: $email"
              return
            fi

            ${f.log} "Importing GPG identity: $email"

            import_key "$key_file"
            import_ownertrust "$trust_file"
          }

          ${(lib.concatMapStringsSep "\n" mkIdentity secretProfiles.gpgKeys)}
        '';
      };
    };
  };
}
