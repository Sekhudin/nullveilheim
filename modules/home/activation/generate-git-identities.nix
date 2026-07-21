{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.activationModules.generate-git-identities;
  masterEnable = config.activationModules.enable;

  inherit (config.homeProgramsModules.secrets) secretProfiles;

  includesFile = config.programs.git.settings.include.path;
  dirname = "${pkgs.coreutils}/bin/dirname";
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  rm = "${pkgs.coreutils}/bin/rm";

  gitdirPaths =
    profile:
    lib.pipe (builtins.attrNames config.sops.secrets) [
      (builtins.filter (name: lib.hasPrefix "git_identities_${profile}_gitdirs_" name))
      (names: builtins.sort (a: b: a < b) names)
      (map (name: config.sops.secrets.${name}.path))
    ];

  gpgEmailPath = profile: config.sops.secrets."gpg_keys_${profile}_email".path;

  sshPath = profile: config.sops.secrets."ssh_keys_${profile}_path".path;

  mkGenerate = profile: ''
      generate_identity \
        "${profile}" \
        "${config.sops.secrets."git_identities_${profile}_name".path}" \
        "${config.sops.secrets."git_identities_${profile}_email".path}" \
        "${config.sops.secrets."git_identities_${profile}_signing_key".path}" \
        "${config.sops.secrets."git_identities_${profile}_ssh_key".path}" \
    ${lib.concatMapStringsSep " \\\n    " (path: ''"${path}"'') (gitdirPaths profile)}
  '';
in
{
  options.activationModules.generate-git-identities = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      activation = {
        generateGitIdentities = lib.hm.dag.entryAfter [ "writeBoundary" "setupSecrets" "importGPGKey" ] ''
          set -euo pipefail

          log() {
            echo "[INFO][generate-git-identities] $*"
          }

          warn() {
            echo "[WARN][generate-git-identities] $*"
          }

          fatal() {
            echo "[ERROR][generate-git-identities] $*" >&2
            exit 1
          }

          expand_home() {
            printf '%s\n' "''${1/#\~/$HOME}"
          }

          ensure_parent() {
            ${mkdir} -p "$(${dirname} "$1")"
          }

          reset_configs() {
            ensure_parent "$INCLUDES_FILE"

            ${mkdir} -p "$GITCONFIG_D"

            : > "$INCLUDES_FILE"
            ${rm} -f "$GITCONFIG_D"/*.conf 2>/dev/null || true
          }

          INCLUDES_FILE="$(expand_home "${includesFile}")"
          GITCONFIG_D="$(${dirname} "$INCLUDES_FILE")/config.d"

          read_secret() {
            local file="$1"

            [[ -f "$file" ]] || fatal "Missing secret: $file"

            local value
            value="$(<"$file")"

            [[ -n "$value" ]] || fatal "Empty secret: $file"

            printf '%s' "$value"
          }

          read_gpg_email() {
            local profile="$1"

            case "$profile" in
          ${lib.concatMapStringsSep "\n" (profile: ''
            ${profile})
              read_secret "${gpgEmailPath profile}"
              ;;
          '') secretProfiles.gpgKey}
              *)
                fatal "Unknown GPG profile: $profile"
                ;;
            esac
          }

          read_ssh_path() {
            local profile="$1"

            case "$profile" in
          ${lib.concatMapStringsSep "\n" (profile: ''
            ${profile})
              read_secret "${sshPath profile}"
              ;;
          '') secretProfiles.sshKey}
              *)
                fatal "Unknown SSH profile: $profile"
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
              "    sshCommand = ssh -i $(expand_home "$ssh_key") -o IdentitiesOnly=yes"
          }

          generate_config() {
            local profile="$1"
            local name="$2"
            local email="$3"
            local signing_key="$4"
            local ssh_key="$5"

            local config_file="$GITCONFIG_D/$profile.conf"

            ensure_parent "$config_file"
            write_git_config \
             "$name" \
             "$email" \
             "$signing_key" \
             "$ssh_key" \
             > "$config_file"

            log "Generated config: $config_file"
          }

          write_include_config() {
            local gitdir="$1"
            local profile="$2"

            printf '%s\n' \
              "[includeIf \"gitdir:$gitdir\"]" \
              "    path = $GITCONFIG_D/$profile.conf" \
              ""
          }

          append_include() {
            local profile="$1"
            local gitdir="$2"

            log "Registering gitdir '$gitdir' -> $profile"

            gitdir="$(expand_home "$gitdir")"
            gitdir="''${gitdir%/}/"

            ${mkdir} -p "$gitdir"

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

            (($# > 0)) || fatal "No gitdir configured for profile: $profile"

            log "Generating Git identity: $profile"

            local signing_key_profile
            local ssh_key_profile

            local name
            local email
            local signing_key
            local ssh_key

            signing_key_profile="$(read_secret "$signing_key_file")"
            ssh_key_profile="$(read_secret "$ssh_key_file")"

            name="$(read_secret "$name_file")"
            email="$(read_secret "$email_file")"
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
                "$(read_secret "$1")"
            
              shift
            done

            log "Git identity '$profile' generated"
          }

          reset_configs

          ${lib.concatMapStringsSep "\n" mkGenerate secretProfiles.gitIdentity}
        '';
      };
    };
  };
}
