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

      ftMatches = fs: ''
        function()
          for _, v in ipairs({${builtins.concatStringsSep ", " (map (b: "\"${b}\"") fs)}}) do
            if vim.bo.filetype == v then
              return true
            end
          end
          return false
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
