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

  ssh_keygen = lib.getExe' pkgs.openssh "ssh-keygen";
  h = extraLib.activation.mkHelper {
    context = "0-install-ssh-keys";
    inherit pkgs;
  };

  mkSSHKey = profile: ''
    install_ssh_key \
      "${profile}" \
      "${config.sops.secrets."ssh_keys_${profile}_path".path}" \
      "${config.sops.secrets."ssh_keys_${profile}_private_key".path}"
  '';

  entryList = [
    "installPackages"
    "sops-nix"
    "onFilesChange"
  ];
in
{
  home = lib.mkIf core.activation {
    activation = {
      ${h.context} = lib.hm.dag.entryAfter entryList ''
        ${h.libScript}

        if tty -s 2>/dev/null; then
          export GPG_TTY="$(tty)"
        fi

        install_ssh_key() {
          local profile="$1"
          local path_file="$2"
          local private_key_file="$3"

          ${h.fmt.log} "Installing SSH key: $profile"

          local path
          path="$(${h.readSecret} "$path_file")"
          path="$(${h.expandHome} "$path")"

          ${h.readSecret} "$private_key_file" >/dev/null

          ${h.ensureParent} "$path"

          ${h.cu.cat} "$private_key_file" > "$path"

          ${h.cu.chmod} 700 "$(${h.cu.dirname} "$path")"
          ${h.cu.chmod} 600 "$path"

          ${ssh_keygen} -y -f "$path" > "$path.pub"

          ${h.cu.chmod} 644 "$path.pub"

          ${h.fmt.log} "SSH key installed: $profile"
        }

        ${(lib.concatMapStringsSep "\n" mkSSHKey secrets.sshKeys)}
      '';
    };
  };
}
