{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) mkWorkspaceRule getVar;

  edp_1 = getVar "monitors.edp_1";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      workspace_rule = mkWorkspaceRule {
        workspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
        ];
        rules = {
          persistent = true;
          monitor = edp_1;
        };
        extraWorkspaceRule = [ ];
      };
    };
  };
}
