{
  luaLib,
  mkCall,
  mkCallAttrs,
  ...
}:

let
  hl = {
    exec_cmd =
      p:
      mkCall {
        func = "hl.exec_cmd";
        args = [
          p.cmd
          (p.rules or null)
        ];
      };
  };

  hl.dsp = {
    dpms =
      p:
      mkCallAttrs {
        func = "hl.dsp.dpms";
        attrs = p;
      };

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

  hl.dsp.window = {
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

  hl.dsp.workspace = {
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

  hl.extra = {
    layout_toggle =
      p:
      luaLib.mkLuaFunc ''
        local layouts = ${luaLib.toLua p.layouts}
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
      luaLib.mkLuaFunc ''
        local zen_mode = (hl.get_config("animations.enabled") == false)

        if zen_mode then
            hl.exec_cmd("hyprctl reload")
            return
        end

        hl.config(${luaLib.toLua (p // config)})
      '';
  };
in
hl
