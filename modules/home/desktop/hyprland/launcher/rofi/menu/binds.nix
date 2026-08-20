{
  pkgs,
  mkRofi,
  mkJq,
  joinPipe,
  menus,
  styles,
  tokens,
  ...
}:

let
  name = menus.binds;

  runtimeInputs = with pkgs; [
    hyprland
    rofi
    jq
  ];

  text = joinPipe [
    "hyprctl binds -j"
    (mkJq {
      args = [ "-r" ];
      query = ''
        def key_label:
          {
            "BACKSPACE": "⌫",
            "DELETE": "Del",
            "RETURN": "↵",
            "SLASH": "/",
            "SPACE": "󱁐",
            "SUPER": "⌘",
            "SUPER_L": "⌘",
            "TAB": " ",
            "LEFT": "←",
            "RIGHT": "→",
            "UP": "↑",
            "DOWN": "↓",
            "escape": "Esc",
            "mouse:272": "󰍽",
            "mouse:273": "󰍽",
            "XF86MonBrightnessDown": "",
            "XF86MonBrightnessUp": "󰌵",
            "XF86AudioNext": "󰒭",
            "XF86AudioPrev": "󰒮",
            "XF86AudioPlay": "󰐊",
            "XF86AudioMicMute": "󰍭",
            "XF86AudioLowerVolume": "󰝞",
            "XF86AudioRaiseVolume": "󰝝",
            "XF86AudioMute": "󰝟",
            "Caps_Lock": "󰘲",
            "Num_Lock": "󰎠"
          }[.] // .;

        def key_shortcut:
          {
            "RETURN": "Enter",
            "SLASH": "/",
            "SPACE": "Space",
            "SUPER_L": "",
            "escape": "Escape",
            "mouse:272": "Mouse Left",
            "mouse:273": "Mouse Right",
            "XF86MonBrightnessDown": "Brightness Down",
            "XF86MonBrightnessUp": "Brightness Up",
            "XF86AudioNext": "Audio Next",
            "XF86AudioPrev": "Audio Prev",
            "XF86AudioPlay": "Audio Play",
            "XF86AudioMicMute": "Mic Mute",
            "XF86AudioLowerVolume": "Volume Down",
            "XF86AudioRaiseVolume": "Volume Up",
            "XF86AudioMute": "Volume Mute",
            "Caps_Lock": "Caps Lock",
            "Num_Lock": "Num Lock"
          }[.] // .;

        def modifier:
          [
            if ((.modmask / 64 | floor) % 2) == 1 then "Super" else empty end,
            if ((.modmask / 8  | floor) % 2) == 1 then "Alt" else empty end,
            if ((.modmask / 4  | floor) % 2) == 1 then "Ctrl" else empty end,
            if ((.modmask / 1  | floor) % 2) == 1 then "Shift" else empty end
          ]
          | join(" + ");

        [
          .[]
          | select(
              .description != ""
              and (.modmask != 0 or .key != "escape")
            )
          | (
              .key | key_label
            ) as $key
          | (
              [
                modifier,
                (.key | key_shortcut)
              ]
              | map(select(. != ""))
              | join(" + ")
            ) as $shortcut
          | "<b>\($shortcut)</b>\n<small>\(.description)</small>\u0000icon\u001f<span size=\"30000\" foreground=\"${tokens.fg}\">\($key)</span>"
        ]
        | join("|")
      '';
    })
    (mkRofi {
      args = [
        "-dmenu"
        "-markup"
        "-markup-rows"
        "-sep '|'"
        "-kb-accept-entry ''"
        "-me-accept-entry ''"
      ];
      theme-str = ''
        listview {
          enabled: true;
          columns: 4;
          lines: 4;
        }

        element {
          enabled: true;
          spacing: 8px;
          padding: ${toString styles.padding_y}px ${toString styles.padding_x}px;
          orientation: horizontal;
          children: [ element-icon, element-text ];
        }

        element selected.normal {
          background-color: transparent;
          border: 0px;
        }

        element-icon {
          size: 36px;
          vertical-align: 0.5;
          horizontal-align: 0.5;
          padding: ${toString styles.gaps_in}px;
          background-color: @muted-selected;
          border: ${toString styles.border_size}px solid;
          border-radius: ${toString styles.rounding}px;
          border-color: @border;
        }

        element-text {
          vertical-align: 0.5;
          horizontal-align: 0.0;
          markup: true;
        }
      '';
    })
  ];
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
