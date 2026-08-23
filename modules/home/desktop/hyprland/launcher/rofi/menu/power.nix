{
  pkgs,
  mkRofi,
  joinPipe,
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

      shutdown=" "
      reboot=" "
      suspend=" "
      hibernate="󰤄 "
      logout="󰈆 "
      lock=" "

      options="$lock\n$suspend\n$hibernate\n$reboot\n$shutdown\n$logout"

      chosen="$(echo -e "$options" | rofi_cmd)"

      case $chosen in
          "$shutdown")
              systemctl poweroff
              ;;
          "$reboot")
              systemctl reboot
              ;;
          "$suspend")
              systemctl suspend
              ;;
          "$hibernate")
              systemctl hibernate
              ;;
          "$logout")
              hyprctl dispatch exit
              ;;
          "$lock")
              hyprlock
              ;;
      esac
    ''
  ];
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
