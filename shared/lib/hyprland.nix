{
  mkExtraLib =
    { lib }:

    let
      inherit (lib.generators) mkLuaInline;

      mergeAttrs = attrs: lib.foldl' lib.recursiveUpdate { } attrs;

      mkLua = lib.generators.toLua { };

      mkLuaStr = value: ''"${value}"'';

      mkLuaFunc = lua: ''
        function()
          ${lua}
        end
      '';

      mkCall =
        {
          func,
          args ? [ ],
        }:
        let
          args' = builtins.filter (arg: arg != null) args;
          luaArgs = map mkLua args';
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
        if attrs' == { } then "${func}()" else "${func}(${mkLua attrs'})";

      mkVar = value: {
        _var = value;
      };

      mkAttrVarRef =
        {
          variables,
          select ? null,
        }:
        let
          mkRef =
            path: value:
            if lib.isAttrs value then lib.mapAttrs (name: value: mkRef "${path}.${name}" value) value else path;
        in
        if select == null then variables else mkRef select variables.${select}._var;

      getVar = name: mkLuaInline name;

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
            (mkLuaInline key)
            (mkLuaInline dispatcher)
            flags
          ];
        };

      mkWorkspaceBind =
        {
          count,
          extraBind ? [ ],
        }:
        (lib.flatten (
          lib.genList (
            i:
            let
              workspace = i + 1;
              key = toString workspace;
            in
            [
              (mkBind {
                key = combos.mod key;
                dispatcher = dsp.focus {
                  inherit workspace;
                };
              })

              (mkBind {
                key = combos.of [
                  keys.mod
                  keys.shift
                ] key;
                dispatcher = dsp.window.move {
                  inherit workspace;
                };
              })
            ]
          ) count
        ))
        ++ extraBind;

      mkSubmap =
        {
          name,
          bind,
          escape ? true,
        }:

        let
          bind' = if builtins.isList bind then lib.concatStringsSep "\n" bind else bind;
        in
        {
          _args = [
            name
            (mkLuaInline (
              mkLuaFunc (
                if !escape then
                  bind'
                else
                  ''
                    ${bind'}
                    hl.bind("escape", hl.dsp.submap("reset"))
                  ''
              )
            ))
          ];
        };

      mkSubmapBind =
        {
          key,
          dispatcher,
          flags ? { },
        }:
        "hl.bind(${key}, ${dispatcher}, ${mkLua flags})";

      mkMonitor =
        {
          output,
          mode ? "preferred",
          position ? "auto",
          scale ? 1,
          settings ? { },
        }:
        mergeAttrs [
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
          mkLuaStr key
        else
          let
            prefix = lib.concatStringsSep ''.. " + " .. '' modifiers;
          in
          if key == null then prefix else ''${prefix} .. " + ${key}"'';

      variables = {
        mouse = mkVar {
          left = "mouse:272";
          right = "mouse:273";
          middle = "mouse:274";
          back = "mouse:275";
          forward = "mouse:276";
        };

        keys = mkVar {
          mod = "SUPER";
          alt = "ALT";
          ctrl = "CTRL";
          shift = "SHIFT";
        };
      };

      keys = mkAttrVarRef {
        inherit variables;
        select = "keys";
      };

      mouse = mkAttrVarRef {
        inherit variables;
        select = "mouse";
      };

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

        exit =
          _:
          mkCall {
            func = "hl.dsp.exit";
            args = [ ];
          };

        focus =
          p:
          mkCallAttrs {
            func = "hl.dsp.focus";
            attrs = p;
          };

        submap =
          p:
          mkCall {
            func = "hl.dsp.submap";
            args = [
              p.name
            ];
          };
      };

      dsp.window = {
        close =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.close";
            attrs = p;
          };

        drag =
          _:
          mkCall {
            func = "hl.dsp.window.drag";
            args = [ ];
          };

        float =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.float";
            attrs = p;
          };

        fullscreen =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.fullscreen";
            attrs = p;
          };

        move =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.move";
            attrs = p;
          };

        resize =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.resize";
            attrs = p;
          };

        swap =
          p:
          mkCallAttrs {
            func = "hl.dsp.window.swap";
            attrs = p;
          };
      };

      dsp.workspace = {
        change_id =
          p:
          mkCallAttrs {
            func = "hl.dsp.workspace.change_id";
            attrs = p;
          };

        move =
          p:
          mkCallAttrs {
            func = "hl.dsp.workspace.move";
            attrs = p;
          };

        rename =
          p:
          mkCallAttrs {
            func = "hl.dsp.workspace.rename";
            attrs = p;
          };

        swap_monitors =
          p:
          mkCallAttrs {
            func = "hl.dsp.workspace.swap_monitors";
            attrs = p;
          };

        toggle_special =
          p:
          mkCallAttrs {
            func = "hl.dsp.workspace.toggle_special";
            attrs = p;
          };
      };

      dsp.extra = {
        layout_toggle =
          p:
          mkLuaFunc ''
            local layouts = ${mkLua p.layouts}
            local workspace =
                hl.get_active_special_workspace()
                or hl.get_active_workspace()

            if not workspace then
                return
            end

            local next_layout = layouts[1]

            for i, layout in ipairs(layouts) do
                if layout == workspace.tiled_layout then
                    next_layout = layouts[(i % #layouts) + 1]
                    break
                end
            end

            hl.workspace_rule({
                workspace = tostring(workspace.special and workspace.name or workspace.id),
                layout = next_layout,
            })
          '';

        zen_mode =
          p:
          let
            config = {
              decoration = {
                shadow = {
                  enabled = false;
                };
                blur = {
                  enabled = false;
                };
              };
              animations = {
                enabled = false;
              };
            };
          in
          mkLuaFunc ''
            local zen_mode = (hl.get_config("animations.enabled") == false)

            if zen_mode then
                hl.exec_cmd("hyprctl reload")
                return
            end

            hl.config(${mkLua (p // config)})
          '';
      };
    in
    {
      inherit
        mkLuaStr
        mkVar
        mkEnv
        mkBind
        mkWorkspaceBind
        mkSubmap
        mkSubmapBind
        mkMonitor
        getVar
        variables
        keys
        mouse
        combos
        directions
        dsp
        ;
    };
}
