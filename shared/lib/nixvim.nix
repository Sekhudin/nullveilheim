{
  mkExtraLib = {
    mkLuaFun = lua: ''
      function()
        ${lua}
      end
    '';

    mkLuaNamedFun = name: lua: ''
      function ${name}()
        ${lua}
      end
    '';
  };
}
