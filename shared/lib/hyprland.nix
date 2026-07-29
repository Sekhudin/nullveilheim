{
  mkExtraLib =
    { lib }:

    let
      inherit (lib.generators) mkLuaInline;

      mkLua = lib.generators.toLua { };

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

      dsp.extra = {
        layout_toggle =
          p:
          mkLuaFunc ''
            local workspace =
                hl.get_active_special_workspace()
                or hl.get_active_workspace()

            if not workspace then
                return
            end

            local next_layout = ${p.var_layouts}[1]

            for i, layout in ipairs(${p.var_layouts}) do
                if layout == workspace.tiled_layout then
                    next_layout = ${p.var_layouts}[(i % #${p.var_layouts}) + 1]
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
        mkLuaInline
        mkLuaFunc
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
