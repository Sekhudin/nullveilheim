{
  mkExtraLib =
    { lib }:

    let
      inherit (builtins) toFile toJSON;

      layouts = {
        tiled = "tiled";
        even-horizontal = "even-horizontal";
        even-vertical = "even-vertical";
        main-horizontal = "main-horizontal";
        main-vertical = "main-vertical";
      };

      mkTmuxColor = f: b: "fg=${f},bg=${b}";

      mkTmuxpFile = name: ws: toFile "tmuxp-${name}.json" (toJSON ws);
    in
    {
      inherit layouts mkTmuxColor mkTmuxpFile;

      mkShellAliases =
        wss:

        let
          names = lib.attrNames wss;
        in
        builtins.listToAttrs (
          map (name: {
            name = "tmux-${name}";
            value = "tmuxp load ${mkTmuxpFile name wss.${name}}";
          }) names
        );

      mkWindow =
        {
          start_directory,
          panes ? [ ],
          overrides ? { },
        }:

        {
          inherit start_directory;
          window_name = "services";
          layout = layouts.main-vertical;
          panes = [
            {
              focus = true;
            }
            { }
            { }
          ]
          ++ panes;
        }
        // overrides;

      mkEditorWindow =
        {
          editor,
          start_directory,
          panes ? [ ],
          overrides ? { },
        }:

        {
          inherit start_directory;
          window_name = "editor";
          layout = layouts.tiled;
          panes = [
            {
              focus = true;
              shell_command = [ "${editor} ." ];
            }
          ]
          ++ panes;
        }
        // overrides;
    };
}
