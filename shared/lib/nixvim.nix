{
  mkExtraLib =
    { lib }:

    let
      importAsAttrs =
        { src }:

        lib.pipe (builtins.readDir src) [
          (lib.mapAttrsToList (
            name: type:
            let
              path = "${src}/${name}";
            in
            if type == "directory" then
              { ${name} = importAsAttrs path; }
            else if type == "regular" && lib.hasSuffix ".nix" name then
              { ${lib.removeSuffix ".nix" name} = import path; }
            else
              { }
          ))
          (lib.foldl lib.recursiveUpdate { })
        ];

      importModules =
        { modules }:
        let
          scan =
            src:
            let
              files = builtins.readDir src;
            in
            lib.concatMap (
              name:
              let
                path = "${src}/${name}";
              in
              if builtins.match ".*\.nix" name != null then
                [ (import path) ]
              else if builtins.pathExists "${path}/default.nix" then
                [ (import path) ]
              else if builtins.pathExists path && builtins.readDir path != { } then
                scan path
              else
                [ ]
            ) (builtins.attrNames files);
        in
        lib.concatMap scan modules;

      splitAscii = ascii: lib.lists.filter (s: s != "") (lib.strings.splitString "\n" ascii);
    in
    {
      inherit importModules;

      mkLuaFun = lua: ''
        function()
          ${lua}
        end
      '';

      mkLuaNamedFun = name: lua: ''
        function ${name}()
          ${lua}
        end
      '';

      asciiArts = importAsAttrs {
        src = ./ascii;
      };

      mkAsciiHeader =
        {
          ascii,
          head ? null,
        }:
        let
          list = splitAscii ascii;
        in
        if head != null then lib.take head list else list;

      mkAsciiFooter =
        {
          ascii,
          tail ? null,
        }:
        let
          list = splitAscii ascii;
        in
        if tail != null then lib.lists.reverseList (lib.take tail (lib.lists.reverseList list)) else list;
    };
}
