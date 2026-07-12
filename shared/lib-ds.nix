{
  mkExtraLib =
    { lib }:
    let
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
      mkShells =
        {
          pkgs,
          name,
          mkShell,
        }:
        builtins.listToAttrs (
          map (pkgName: {
            name = toCamelCase pkgName;
            value = (mkShell { inherit name; }) pkgName;
          }) (builtins.filter (pkgName: lib.hasPrefix name pkgName) (builtins.attrNames pkgs))
        );
    };
}
