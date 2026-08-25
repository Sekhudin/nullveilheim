{
  pkgs,
  mkRofi,
  menus,
  ...
}:

let
  name = menus.apps;

  runtimeInputs = with pkgs; [
    rofi
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
