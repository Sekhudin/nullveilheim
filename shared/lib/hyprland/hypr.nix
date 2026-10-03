{ lib, luaLib, ... }:

let
  hypr = {
    mkVar = value: {
      _var = value;
    };

    mkEnv = key: value: {
      _args = [
        key
        value
      ];
    };

    mkAnimation = p: {
      _args = [ p ];
    };

    mkCurve = p: {
      _args = [
        p.name
        p.options
      ];
    };

    mkWindowRule = p: {
      _args = [ p ];
    };

    mkLayerRule = p: {
      _args = [ p ];
    };

    mkWorkspaceRule =
      {
        workspaces,
        rules ? { },
        extraWorkspaceRule ? [ ],
      }:
      (map (
        workspace:
        rules
        // {
          inherit workspace;
        }
      ) workspaces)
      ++ extraWorkspaceRule;

    mkBind =
      {
        key,
        dispatcher,
        group ? "other",
        flags ? { },
      }:
      let
        finalFlags = flags // {
          description = "[${group}] ${flags.description or ""}";
        };
      in
      {
        _args = [
          (luaLib.mkLuaInline key)
          (luaLib.mkLuaInline dispatcher)
          finalFlags
        ];
      };

    mkSubmap =
      {
        name,
        bind,
        group ? "other",
        escape ? true,
      }:
      let
        bind' = if builtins.isList bind then lib.concatStringsSep "\n" bind else bind;
      in
      {
        _args = [
          name
          (luaLib.mkLuaInline (
            luaLib.mkLuaFunc (
              if !escape then
                bind'
              else
                ''
                  ${bind'}
                  hl.bind("escape", hl.dsp.submap("reset"), { description = "[${group}] exit from submap" })
                ''
            )
          ))
        ];
      };

    mkSubmapBind =
      {
        key,
        dispatcher,
        group ? "other",
        flags ? { },
      }:
      let
        description = flags.description or "";
        finalFlags = flags // {
          description = if description == "" then "[${group}]" else "[${group}] ${description}";
        };
      in
      "hl.bind(${key}, ${dispatcher}, ${luaLib.toLua finalFlags})";

    mkEvent =
      {
        event,
        action,
      }:
      let
        event' = event {
          lua = if builtins.isList action then lib.concatStringsSep "\n" action else action;
        };
      in
      {
        _args = [
          (builtins.elemAt event' 0)
          (luaLib.mkLuaInline (builtins.elemAt event' 1))
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
      lib.foldl' lib.recursiveUpdate { } [
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

    getVarRefs =
      config: select:
      let
        settings = config.wayland.windowManager.hyprland.settings;
        getRef =
          path: value:
          if lib.isAttrs value then
            if value ? _var then
              getRef path value._var
            else
              lib.mapAttrs (name: value: getRef "${path}.${name}" value) value
          else
            luaLib.mkLuaInline path;
      in
      getRef select settings.${select};

    getVarValues =
      config: select:
      let
        settings = config.wayland.windowManager.hyprland.settings;
        getValue =
          value:
          if value ? _var then
            getValue value._var
          else if lib.isAttrs value then
            lib.mapAttrs (_: getValue) value
          else
            value;
      in
      getValue settings.${select};
  };
in
hypr
