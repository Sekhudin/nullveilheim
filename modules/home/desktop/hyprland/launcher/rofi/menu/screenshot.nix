{
  pkgs,
  mkRofi,
  joinPipe,
  actions,
  menus,
  styles,
  font,
  ...
}:

let
  name = menus.screenshot;

  runtimeInputs = with pkgs; [
    rofi
  ];

  button_border_radius = (styles.rounding * 2.0) - styles.gaps_in;

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
            window {
              enabled: true;
              fullscreen: false;
              border-color: @border;
              width: 376px;
              margin: 0px;
              padding: 0px;
              spacing: 0px;
              border-radius: ${toString (styles.rounding * 2.0)}px;
              children: [ "mainbox" ];
            }

            mainbox {
              enabled: true;
              margin: 0px;
              padding: ${toString styles.gaps_in}px;
              spacing: 0px;
              children: [ "listview" ];
            }

            listview {
              enabled: true;
              columns: 3;
              lines: 1;
              margin: 0px;
              padding: 0px;
              spacing: ${toString styles.gaps_in}px;
              children: [ "element" ];
            }

            element {
              enabled: true;
              margin: 0px;
              padding: 10px 10px 10px 0px;
              spacing: 0px;
              border-radius: ${toString button_border_radius}px;
              children: [ "element-text" ];
            }

            element normal.normal {
            }

            element selected.normal {
              background-color: @primary-selected;
              border-color: @primary;
            }

            element-text {
              highlight: inherit;
              font: "${font.family.sans_serif} 32";
              padding: 0px;
            }
          '';
        }}
      }

      region="󰩭"
      fullscreen="󰹑"
      window=""

      options="$region\n$fullscreen\n$window"

      chosen="$(echo -e "$options" | rofi_cmd)"

      case $chosen in
          "$region")
              sleep 0.2 && ${actions.screenshot_region}
              ;;
          "$fullscreen")
              sleep 0.2 && ${actions.screenshot_fullscreen}
              ;;
          "$window")
              sleep 0.2 && ${actions.screenshot_window}
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
