{
  mkRofi,
  joinPipe,
  pkgs,
  menus,
  ...
}:

let
  name = menus.power;

  runtimeInputs = with pkgs; [
    hyprland
    rofi
  ];

  text = joinPipe [
    ''
      rofi_cmd(){
        ${mkRofi {
          args = [
            "-dmenu"
            "-markup"
            "-markup-rows"
          ];
          theme-str = ''
            listview {
              columns: 6;
              lines: 1;
            }
          '';
        }}
      }
    ''
  ];
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
