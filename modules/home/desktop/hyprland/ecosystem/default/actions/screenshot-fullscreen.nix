{
  pkgs,
  actions,
  ...
}:

let
  name = actions.screenshot_fullscreen;

  runtimeInputs = with pkgs; [
    hyprshot
  ];

  text = "hyprshot -m output -m active -z";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
