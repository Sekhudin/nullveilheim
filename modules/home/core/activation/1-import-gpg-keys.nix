{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  core = config.homeCore;
  inherit (core.programs) secrets;

  gpg = lib.getExe' pkgs.gnupg "gpg";
  h = extraLib.activation.mkHelper {
    context = "1-import-gpg-keys";
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
  home = lib.mkIf core.activation {
    activation = {
      ${h.context} = lib.hm.dag.entryAfter [ "0-install-ssh-keys" ] ''
        ${h.libScript}

        # Pastikan direktori GNUPGHOME ada dengan izin yang aman (cross-platform safe)
        gnupg_dir="''${GNUPGHOME:-$HOME/.gnupg}"
        ${h.cu.mkdir} -p "$gnupg_dir"
        ${h.cu.chmod} 700 "$gnupg_dir"

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

          # Menggunakan readSecret untuk fail-fast validation jika secret hilang/kosong
          local email
          email="$(${h.readSecret} "$email_file")"
          ${h.readSecret} "$key_file" >/dev/null
          ${h.readSecret} "$trust_file" >/dev/null

          ${h.fmt.log} "Checking GPG identity: $email"
          if ${gpg} --list-secret-keys "$email" >/dev/null 2>&1; then
            ${h.fmt.log} "GPG identity already exists: $email"
            return 0
          fi

          ${h.fmt.log} "Importing GPG identity: $email"

          import_key "$key_file"
          import_ownertrust "$trust_file"
        }

        ${(lib.concatMapStringsSep "\n" mkIdentity secrets.gpgKeys)}
      '';
    };
  };
}
