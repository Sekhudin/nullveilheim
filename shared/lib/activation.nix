{
  mkExtraLib =
    { lib }:

    {
      mkHelper =
        {
          context,
          pkgs,
        }:

        let
          coreutils = lib.getExe' pkgs.coreutils;
          cu = {
            cat = coreutils "cat";
            chmod = coreutils "chmod";
            dirname = coreutils "dirname";
            mkdir = coreutils "mkdir";
            rm = coreutils "rm";
            tr = coreutils "tr";
          };

          fmt = {
            log = "log";
            warn = "warn";
            fatal = "fatal";
          };

          expandHome = "expand_home";
          ensureParent = "ensure_parent";
          readSecret = "read_secret";

          libScript = ''
            set -euo pipefail

            ${fmt.log}() {
              echo "[INFO][${context}] $*"
            }

            ${fmt.warn}() {
              echo "[WARN][${context}] $*"
            }

            ${fmt.fatal}() {
              echo "[ERROR][${context}] $*" >&2
              exit 1
            }

            ${expandHome}() {
              printf '%s\n' "''${1/#\~/$HOME}"
            }

            ${ensureParent}() {
              ${cu.mkdir} -p "$(${cu.dirname} "$1")"
            }

            ${readSecret}() {
              local file="$1"

              [[ -f "$file" ]] || ${fmt.fatal} "Missing secret: $file"

              local value
              value="$(<"$file")"
              value="$(printf '%s' "$value" | ${cu.tr} -d '\r')"

              [[ -n "$value" ]] || ${fmt.fatal} "Empty secret: $file"

              printf '%s' "$value"
            }
          '';
        in
        {
          inherit
            cu
            fmt
            expandHome
            ensureParent
            readSecret
            context
            libScript
            ;
        };
    };
}
