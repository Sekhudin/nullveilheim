{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) hypr;

  monitors = hypr.getVarRefs config "monitors";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      workspace_rule = hypr.mkWorkspaceRule {
        workspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
        ];
        rules = {
          persistent = true;
          monitor = monitors.primary;
        };
        extraWorkspaceRule = [ ];
      };
    };
  };
}
