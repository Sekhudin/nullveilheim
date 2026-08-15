{
  mkRofi,
  pkgs,
  menus,
  ...
}:

let
  name = menus.apps;

  runtimeInputs = with pkgs; [
    hyprland
  ];

  text = mkRofi {
    args = [
      "-show"
      "drun"
    ];
  };
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
