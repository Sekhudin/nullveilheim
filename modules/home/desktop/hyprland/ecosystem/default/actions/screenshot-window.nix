{
  pkgs,
  actions,
  ...
}:

let
  name = actions.screenshot_window;

  runtimeInputs = with pkgs; [
    hyprshot
  ];

  text = "hyprshot -m window -z";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
