{ luaLib, ... }:

let
  events.config = {
    reloaded = p: [
      "config.reloaded"
      (luaLib.mkLuaFunc {
        header = "function()";
        lua = p.lua;
      })
    ];
  };

  events.hyprland = {
    start = p: [
      "hyprland.start"
      (luaLib.mkLuaFunc {
        header = "function()";
        lua = p.lua;
      })
    ];
  };
in
events
