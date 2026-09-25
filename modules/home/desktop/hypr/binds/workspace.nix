{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    mkWorkspaceBind
    ;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = mkWorkspaceBind {
        count = 9;
        extraBind = [ ];
      };
    };
  };
}
