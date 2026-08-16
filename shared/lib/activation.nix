{
  mkExtraLib =
    { lib }:

    let
      mkFmt =
        { context }:

        {
          shell = ''
            log() {
              echo "[INFO][${context}] $*"
            }

            warn() {
              echo "[WARN][${context}] $*"
            }

            fatal() {
              echo "[ERROR][${context}] $*" >&2
              exit 1
            }
          '';

          log = "log";
          warn = "warn";
          fatal = "fatal";
        };
    in
    {
      inherit mkFmt;

      mkHelper =
        {
          context,
          pkgs,
        }:

        let
          coreutils = lib.getExe' pkgs.coreutils;
          cat = coreutils "cat";
          chmod = coreutils "chmod";
          dirname = coreutils "dirname";
          mkdir = coreutils "mkdir";
          rm = coreutils "rm";

          fmt = mkFmt { inherit context; };
        in
        {
          shell = ''
            ${fmt.shell}

            expand_home() {
              printf '%s\n' "''${1/#\~/$HOME}"
            }

            ensure_parent() {
              ${mkdir} -p "$(${dirname} "$1")"
            }

            read_secret() {
              local file="$1"

              [[ -f "$file" ]] || fatal "Missing secret: $file"

              local value
              value="$(<"$file")"

              [[ -n "$value" ]] || fatal "Empty secret: $file"

              printf '%s' "$value"
            }
          '';

          inherit (fmt) log warn fatal;
          inherit
            cat
            chmod
            dirname
            mkdir
            rm
            ;

          expandHome = "expand_home";
          ensureParent = "ensure_parent";
          readSecret = "read_secret";
        };
    };
}
