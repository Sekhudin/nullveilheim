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

      mkAsciiHeader = ascii: lib.strings.splitString "\n" ascii;

      mkAsciiFooter = ascii: lib.strings.splitString "\n" ascii;
    };
}
