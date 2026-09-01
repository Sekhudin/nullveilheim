{
  pkgs,
  actions,
  ...
}:

let
  name = actions.screenshot_region;

  runtimeInputs = with pkgs; [
    hyprshot
  ];

  text = "hyprshot -m region -m active -z";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
