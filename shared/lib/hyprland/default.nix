{
  mkExtraLib =
    { lib }:

    let
      luaLib = {
        toLua = lib.generators.toLua { };

        mkLuaInline =
          value:
          if lib.isAttrs value && value ? _type && value._type == "lua-inline" then
            value
          else
            lib.generators.mkLuaInline value;

        mkLuaFunc =
          p:
          if builtins.isString p then
            ''
              function()
                ${p}
              end
            ''
          else
            ''
              ${p.header or "function()"}
                ${p.lua}
              end
            '';
      };

      mkCall =
        {
          func,
          args ? [ ],
        }:
        let
          args' = builtins.filter (arg: arg != null) args;
          luaArgs = map luaLib.toLua args';
        in
        "${func}(${lib.concatStringsSep ", " luaArgs})";

      mkCallAttrs =
        {
          func,
          attrs ? { },
        }:
        let
          attrs' = lib.filterAttrs (_: value: value != null) attrs;
        in
        if attrs' == { } then "${func}()" else "${func}(${luaLib.toLua attrs'})";

      events = import ./events.nix {
        inherit luaLib;
      };

      hl = import ./hl.nix {
        inherit
          luaLib
          mkCall
          mkCallAttrs
          ;
      };

      hypr = import ./hypr.nix {
        inherit lib luaLib;
      };

      vars = import ./variables-ctl.nix {
        inherit
          lib
          luaLib
          ;

        inherit (hypr)
          mkVar
          getVarRefs
          ;
      };
    in
    {
      inherit
        events
        hl
        hypr
        ;

      inherit (vars)
        variables
        ctl
        ;
    };
}
