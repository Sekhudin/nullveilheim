{
  mkExtraLib =
    { lib }:

    let
      inherit (lib.generators) mkLuaInline;

      mkLua = lib.generators.toLua { };

      mkCall =
        {
          func,
          args ? [ ],
        }:
        let
          args' = builtins.filter (arg: arg != null) args;
        in
        "${func}(${lib.concatStringsSep ", " args'})";

      mkCallAttrs =
        {
          func,
          attrs ? { },
        }:
        let
          attrs' = lib.filterAttrs (_: value: value != null) attrs;
        in
        if attrs' == { } then "${func}()" else "${func}(${mkLua attrs'})";

      mkVar = value: {
        _var = value;
      };

      mkEnv = key: value: {
        _args = [
          key
          value
        ];
      };

      mkBind =
        {
          key,
          dispatcher,
          flags ? { },
        }:
        {
          _args = [
            key
            (mkLuaInline dispatcher)
            flags
          ];
        };

      mkMonitor =
        {
          output,
          mode ? "preferred",
          position ? "auto",
          scale ? 1,
          settings ? { },
        }:
        lib.mkMerge [
          {
            inherit
              output
              mode
              position
              scale
              ;
          }
          settings
        ];

      mkComboKey =
        modifiers: key:
        if lib.length modifiers == 0 then
          mkLuaInline ''"${key}"''
        else
          let
            prefix = lib.concatStringsSep ''.. " + " .. '' modifiers;
          in
          mkLuaInline ''${prefix} .. " + ${key}"'';

      variables = {
        mod = (mkVar "SUPER");
        alt = (mkVar "ALT");
        ctrl = (mkVar "CTRL");
        shift = (mkVar "SHIFT");
      };

      keys = lib.mapAttrs (name: _: name) variables;

      combos = {
        plain = mkComboKey [ ];

        of = mkComboKey;

        mod = mkComboKey [ keys.mod ];
        alt = mkComboKey [ keys.alt ];
        ctrl = mkComboKey [ keys.ctrl ];
        shift = mkComboKey [ keys.shift ];
      };

      directions = {
        left = "l";
        right = "r";
        up = "u";
        down = "d";
      };

      dsp = {
        exec_cmd =
          p:
          mkCall {
            func = "hl.dsp.exec_cmd";
            args = [
              p.cmd
              (p.rules or null)
            ];
          };

        submap =
          p:
          mkCall {
            func = "hl.dsp.submap";
            args = [ p.name ];
          };
      };

      dsp.window = {
        close =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.close";
            attrs = p;
          };

        fullscreen =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.fullscreen";
            attrs = p;
          };
      };
    in
    {
      inherit
        mkLuaInline
        mkVar
        mkEnv
        mkBind
        mkMonitor
        variables
        keys
        combos
        directions
        dsp
        ;
    };
}
