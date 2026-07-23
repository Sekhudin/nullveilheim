{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.activationModules.installSSHKeys;
  masterEnable = config.activationModules.enable;
  inherit (config.homeProgramsModules.secrets) secretProfiles; # untuk dapetin profile secretProfiles.sshKeys

  ssh_keygen = "${pkgs.openssh}/bin/ssh-keygen";
  h = extraLib.activation.mkHelper {
    context = "install-ssh-keys";
    inherit pkgs;
  };

  mkSSHKey = profile: ''
    install_ssh_key \
      "${profile}" \
      "${config.sops.secrets."ssh_keys_${profile}_path".path}" \
      "${config.sops.secrets."ssh_keys_${profile}_private_key".path}"
  '';
in
{
  options.activationModules.installSSHKeys = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      activation = {
        installSSHKeys = lib.hm.dag.entryAfter [ "installPackages" "sops-nix" ] ''
            set -euo pipefail

            ${h.shell}

            install_ssh_key() {
            local profile="$1"
            local path_file="$2"
            local private_key_file="$3"

            ${h.log} "Installing SSH key: $profile"

            local path
            path="$(${h.readSecret} "$path_file")"
            path="$(${h.expandHome} "$path")"

            local private_key
            private_key="$(${h.readSecret} "$private_key_file")"

            ${h.ensureParent} "$path"

            cat "$private_key_file" > "$path"

            ${h.chmod} 700 "$(${pkgs.coreutils}/bin/dirname "$path")"
            ${h.chmod} 600 "$path"

            ${ssh_keygen} -y -f "$path" > "$path.pub"

            ${h.chmod} 644 "$path.pub"

            ${h.log} "SSH key installed: $profile"
          }

          ${(lib.concatMapStringsSep "\n" mkSSHKey secretProfiles.sshKeys)}
        '';
      };
    };
  };
}
