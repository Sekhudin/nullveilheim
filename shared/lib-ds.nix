{
  mkExtraLib =
    { lib }:
    let
      shellColors = {
        reset = "\\033[0m";
        bold = "\\033[1m";
        red = "\\033[31m";
        green = "\\033[32m";
        blue = "\\033[34m";
        cyan = "\\033[36m";
        yellow = "\\033[33m";
      };

      mkFmt =
        cs:
        builtins.mapAttrs (
          _: c: text:
          "${c}${text}${cs.reset}"
        ) cs;

      mkFmtOut =
        cs:
        builtins.mapAttrs (
          _: c: text:
          "echo -e ${c}${text}${cs.reset}"
        ) cs;

      mapFirst = f: s: if s == "" then "" else f (lib.substring 0 1 s) + lib.substring 1 (-1) s;

      toCamelCase =
        s:
        let
          parts = builtins.filter (x: x != "") (
            lib.splitString " " (builtins.replaceStrings [ "-" "_" "." ] [ " " " " " " ] s)
          );
        in
        lib.concatStrings (
          lib.imap0 (i: part: if i == 0 then lib.toLower part else mapFirst lib.toUpper part) parts
        );
    in
    {
      fmt = (mkFmt shellColors) // {
        out = (mkFmtOut shellColors);
      };

      mkShells =
        {
          pkgs,
          prefix,
          excludes ? [ ],
          mkShell,
        }:
        builtins.listToAttrs (
          map
            (name: {
              name = toCamelCase name;
              value = (mkShell { inherit name; });
            })
            (
              builtins.filter (
                pkgName: lib.hasPrefix prefix pkgName && !(lib.any (ex: lib.hasPrefix ex pkgName) excludes)
              ) (builtins.attrNames pkgs)
            )
        );
    };
}
