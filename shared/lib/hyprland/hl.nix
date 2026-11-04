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

    config =
      p:
      mkCallAttrs {
        func = "hl.config";
        attrs = p;
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

    cycle_next =
      p:
      mkCallAttrs {
        func = "hl.dsp.window.cycle_next";
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

    pin =
      p:
      mkCallAttrs {
        func = "hl.dsp.window.pin";
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

  hl.plugin = {
    hyprexpo = {
      expo =
        p:
        luaLib.mkLuaFunc (mkCall {
          func = "hl.plugin.hyprexpo.expo";
          args = [
            p.cmd
          ];
        });

      kb_focus =
        p:
        luaLib.mkLuaFunc (mkCall {
          func = "hl.plugin.hyprexpo.kb_focus";
          args = [
            p.direction
          ];
        });

      kb_confirm =
        _:
        luaLib.mkLuaFunc (mkCall {
          func = "hl.plugin.hyprexpo.kb_confirm";
          args = [ ];
        });
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

    toggle_pin =
      p:
      luaLib.mkLuaFunc ''
        local resize = ${luaLib.toLua (p.resize or false)}
        local offset_x = ${luaLib.toLua (p.x or 0)}
        local offset_y = ${luaLib.toLua (p.y or 0)}

        local window = hl.get_active_window()

        if not window then
            return
        end

        local monitor = window.monitor

        if not monitor then
            return
        end

        local width = monitor.width / monitor.scale
        local height = monitor.height / monitor.scale

        local window_width = math.floor(width / 3)
        local window_height = math.floor(height / 3)

        local target_x = math.floor(width - window_width) + offset_x
        local target_y = offset_y

        local function resize_and_move()
            hl.dispatch(hl.dsp.window.resize({
                window = window,
                x = window_width,
                y = window_height,
                relative = false,
            }))

            hl.dispatch(hl.dsp.window.move({
                window = window,
                x = target_x,
                y = target_y,
            }))
        end

        if window.floating and window.pinned then
            local at = window.at

            local at_target =
                at
                and at.x == target_x
                and at.y == target_y

            if resize and not at_target then
                resize_and_move()
                return
            end

            hl.dispatch(hl.dsp.window.pin({
                window = window,
            }))

            hl.dispatch(hl.dsp.window.float({
                action = "toggle",
                window = window,
            }))

            return
        end

        if not window.floating then
            hl.dispatch(hl.dsp.window.float({
                action = "set",
                window = window,
            }))
        end

        if not window.pinned then
            hl.dispatch(hl.dsp.window.pin({
                window = window,
            }))
        end

        if resize then
            resize_and_move()
        end
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
