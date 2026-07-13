{
  mkExtraLib =
    { lib }:

    let
      importAsAttrs =
        { lib, src }:

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

      splitAscii = ascii: lib.lists.filter (s: s != "") (lib.strings.splitString "\n" ascii);
    in
    {
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
        inherit lib;
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
