{
  mkExtraLib = {
    mkSecretAttrs =
      { path, fields }:

      let
        mkName = a: builtins.replaceStrings [ "." "/" ] [ "_" "_" ] a;
        mkKey = a: builtins.replaceStrings [ "." ] [ "/" ] a;

        namePrefix = mkName path;
        keyPrefix = mkKey path;
      in
      builtins.listToAttrs (
        map (fd: {
          name = "${namePrefix}_${mkName fd}";
          value = {
            key = "${keyPrefix}/${mkKey fd}";
          };
        }) fields
      );
  };
}
