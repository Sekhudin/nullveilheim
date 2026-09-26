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

  includesFile = config.programs.git.settings.include.path;
  h = extraLib.activation.mkHelper {
    context = "2-generate-git-identities";
    inherit pkgs;
  };

  gitdirPaths =
    profile:
    lib.pipe (builtins.attrNames config.sops.secrets) [
      (builtins.filter (name: lib.hasPrefix "git_identities_${profile}_gitdirs_" name))
      (names: builtins.sort (a: b: a < b) names)
      (map (name: config.sops.secrets.${name}.path))
    ];

  gpgEmailPath = profile: config.sops.secrets."gpg_keys_${profile}_email".path;

  sshPath = profile: config.sops.secrets."ssh_keys_${profile}_path".path;

  mkIdentity = profile: ''
    generate_identity \
      "${profile}" \
      "${config.sops.secrets."git_identities_${profile}_name".path}" \
      "${config.sops.secrets."git_identities_${profile}_email".path}" \
      "${config.sops.secrets."git_identities_${profile}_signing_key".path}" \
      "${config.sops.secrets."git_identities_${profile}_ssh_key".path}" \
      ${lib.concatMapStringsSep " \\\n      " (path: ''"${path}"'') (gitdirPaths profile)}
  '';
in
{
  home = lib.mkIf core.activation {
    activation = {
      ${h.context} = lib.hm.dag.entryAfter [ "1-import-gpg-keys" ] ''
        ${h.libScript}

        INCLUDES_FILE="$(${h.expandHome} "${includesFile}")"
        GITCONFIG_D="$(${h.cu.dirname} "$INCLUDES_FILE")/config.d"

        reset_configs() {
          ${h.ensureParent} "$INCLUDES_FILE"

          ${h.cu.mkdir} -p "$GITCONFIG_D"

          : > "$INCLUDES_FILE"
          ${h.cu.rm} -f "$GITCONFIG_D"/*.conf 2>/dev/null || true
        }

        read_gpg_email() {
          local profile="$1"

          case "$profile" in
        ${lib.concatMapStringsSep "\n" (profile: ''
          ${profile})
            ${h.readSecret} "${gpgEmailPath profile}"
            ;;
        '') secrets.gpgKeys}
            *)
              ${h.fmt.fatal} "Unknown GPG profile: $profile"
              ;;
          esac
        }

        read_ssh_path() {
          local profile="$1"

          case "$profile" in
        ${lib.concatMapStringsSep "\n" (profile: ''
          ${profile})
            ${h.readSecret} "${sshPath profile}"
            ;;
        '') secrets.sshKeys}
            *)
              ${h.fmt.fatal} "Unknown SSH profile: $profile"
              ;;
          esac
        }

        write_git_config() {
          local name="$1"
          local email="$2"
          local signing_key="$3"
          local ssh_key="$4"

          printf '%s\n' \
            "[user]" \
            "    name = $name" \
            "    email = $email" \
            "    signingKey = $signing_key" \
            "" \
            "[core]" \
            "    sshCommand = ssh -i $(${h.expandHome} "$ssh_key") -o IdentitiesOnly=yes"
        }

        generate_config() {
          local profile="$1"
          local name="$2"
          local email="$3"
          local signing_key="$4"
          local ssh_key="$5"

          local config_file="$GITCONFIG_D/$profile.conf"

          ${h.ensureParent} "$config_file"
          write_git_config \
            "$name" \
            "$email" \
            "$signing_key" \
            "$ssh_key" \
            > "$config_file"

          ${h.fmt.log} "Generated config: $config_file"
        }

        write_include_config() {
          local gitdir="$1"
          local profile="$2"

          # Memakai gitdir/i: untuk mendukung filesystem case-insensitive di macOS (APFS)
          printf '%s\n' \
            "[includeIf \"gitdir/i:$gitdir\"]" \
            "    path = $GITCONFIG_D/$profile.conf" \
            ""
        }

        append_include() {
          local profile="$1"
          local gitdir="$2"

          ${h.fmt.log} "Registering gitdir '$gitdir' -> $profile"

          gitdir="$(${h.expandHome} "$gitdir")"
          gitdir="''${gitdir%/}/"

          ${h.cu.mkdir} -p "$gitdir"

          write_include_config \
            "$gitdir" \
            "$profile" \
            >> "$INCLUDES_FILE"
        }

        generate_identity() {
          local profile="$1"
          local name_file="$2"
          local email_file="$3"
          local signing_key_file="$4"
          local ssh_key_file="$5"

          shift 5

          (($# > 0)) || ${h.fmt.fatal} "No gitdir configured for profile: $profile"

          ${h.fmt.log} "Generating Git identity: $profile"

          local signing_key_profile
          local ssh_key_profile

          local name
          local email
          local signing_key
          local ssh_key

          signing_key_profile="$(${h.readSecret} "$signing_key_file")"
          ssh_key_profile="$(${h.readSecret} "$ssh_key_file")"

          name="$(${h.readSecret} "$name_file")"
          email="$(${h.readSecret} "$email_file")"
          signing_key="$(read_gpg_email "$signing_key_profile")"
          ssh_key="$(read_ssh_path "$ssh_key_profile")"

          generate_config \
            "$profile" \
            "$name" \
            "$email" \
            "$signing_key" \
            "$ssh_key"

          while (($#)); do
            append_include \
              "$profile" \
              "$(${h.readSecret} "$1")"

            shift
          done

          ${h.fmt.log} "Git identity '$profile' generated"
        }

        reset_configs

        ${lib.concatMapStringsSep "\n" mkIdentity secrets.gitIdentities}
      '';
    };
  };
}
