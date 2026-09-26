{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  core = config.homeCore;
  h = extraLib.activation.mkHelper {
    context = "3-systemd-cleanup";
    inherit pkgs;
  };

  isLinux = pkgs.stdenv.isLinux;
  find = lib.getExe' pkgs.findutils "find";
  systemctl = lib.optionalString isLinux (lib.getExe' pkgs.systemd "systemctl");
in
{
  home = lib.mkIf (core.activation && isLinux) {
    activation = {
      ${h.context} = lib.hm.dag.entryAfter [ "2-generate-git-identities" ] ''
        ${h.libScript}

        ${h.fmt.log} "Cleaning up broken symlinks in systemd user units..."

        systemd_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

        if [ -d "$systemd_dir" ]; then
          $DRY_RUN_CMD ${find} "$systemd_dir" -xtype l -delete 2>/dev/null || true
        fi

        if [ -n "''${XDG_RUNTIME_DIR:-}" ] && [ -S "$XDG_RUNTIME_DIR/systemd/private" ]; then
          ${h.fmt.log} "Reloading systemd user daemon..."
          $DRY_RUN_CMD ${systemctl} --user daemon-reload || true
          $DRY_RUN_CMD ${systemctl} --user reset-failed || true
        else
          ${h.fmt.warn} "Systemd user session is inactive, skipping daemon-reload."
        fi
      '';
    };
  };
}
