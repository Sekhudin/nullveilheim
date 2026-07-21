{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.activationModules.importGPGKey;
  masterEnable = config.activationModules.enable;

  inherit (config.homeProgramsModules.secrets) secretProfiles;

  gpg = "${pkgs.gnupg}/bin/gpg";
  mkIdentity = profile: ''
    import_identity \
      "${config.sops.secrets."gpg_keys_${profile}_email".path}" \
      "${config.sops.secrets."gpg_keys_${profile}_private_key".path}" \
      "${config.sops.secrets."gpg_keys_${profile}_owner_trust".path}"
  '';
in
{
  options.activationModules.importGPGKey = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      activation = {
        importGPGKey = lib.hm.dag.entryAfter [ "writeBoundary" "setupSecrets" "installSSHKey" ] ''
          set -euo pipefail

          export GPG_TTY="$(tty || true)"

          log() {
            echo "[INFO][import-gpg-key] $*"
          }

          warn() {
            echo "[WARN][import-gpg-key] $*"
          }

          fatal() {
            echo "[ERROR][import-gpg-key] $*" >&2
            exit 1
          }

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
              fatal "Missing email secret: $email_file" >&2
            }

            [[ -f "$key_file" ]] || {
              fatal "Missing private key secret: $key_file" >&2
            }

            [[ -f "$trust_file" ]] || {
              fatal "Missing ownertrust secret: $trust_file" >&2
            }

            local email
            email="$(<"$email_file")"

            [[ -n "$email" ]] || {
              fatal "Missing email value" >&2
            }

            log "Checking GPG identity: $email"
            if ${gpg} --list-secret-keys "$email" >/dev/null 2>&1; then
              log "GPG identity already exists: $email"
              return
            fi

            log "Importing GPG identity: $email"

            import_key "$key_file"
            import_ownertrust "$trust_file"
          }

          ${(lib.concatMapStringsSep "\n" mkIdentity secretProfiles.gpgKey)}
        '';
      };
    };
  };
}
