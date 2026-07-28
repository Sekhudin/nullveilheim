{
  mkExtraLib =
    { lib }:

    let
      inherit (lib.generators) mkLuaInline;

      mkVar = v: {
        _var = v;
      };

      mkDispatcher =
        {
          type ? "plain",
          raw ? false,
          dispatcher,
        }:
        let
          value = if raw then dispatcher else ''"${dispatcher}"'';
        in
        if type == "exec_cmd" then
          mkLuaInline "hl.dsp.exec_cmd(${value})"
        else if type == "submap" then
          mkLuaInline "hl.dsp.submap(${value})"
        else
          mkLuaInline dispatcher;

      mkBind =
        {
          key,
          dispatcher,
          type ? "plain",
          raw ? false,
          flags ? { },
        }:
        {
          _args = [
            key
            (mkDispatcher {
              inherit type raw dispatcher;
            })
            flags
          ];
        };

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
    in
    {
      inherit
        mkVar
        mkBind
        variables
        keys
        combos
        ;
    };
}
