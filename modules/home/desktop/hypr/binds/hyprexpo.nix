{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;

  bindGroup = "overview";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.mod "O";
          dispatcher = hl.plugin.hyprexpo.expo {
            cmd = "toggle";
          };
          flags = {
            description = "workspace overview";
          };
        })
      ];

      define_submap = [
        (hypr.mkSubmap {
          group = bindGroup;
          name = "hyprexpo";
          escape = false;
          bind = [
            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.mod "O";
              dispatcher = hl.plugin.hyprexpo.expo {
                cmd = "toggle";
              };
              flags = {
                description = "workspace overview";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain "H";
              dispatcher = hl.plugin.hyprexpo.kb_focus {
                direction = "left";
              };
              flags = {
                description = "focus workspace left";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain "J";
              dispatcher = hl.plugin.hyprexpo.kb_focus {
                direction = "down";
              };
              flags = {
                description = "focus workspace down";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain "K";
              dispatcher = hl.plugin.hyprexpo.kb_focus {
                direction = "up";
              };
              flags = {
                description = "focus workspace up";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain "L";
              dispatcher = hl.plugin.hyprexpo.kb_focus {
                direction = "right";
              };
              flags = {
                description = "focus workspace right";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain ctl.keys.enter;
              dispatcher = hl.plugin.hyprexpo.kb_confirm { };
              flags = {
                description = "enter workspace";
              };
            })
          ];
        })
      ];
    };
  };
}
