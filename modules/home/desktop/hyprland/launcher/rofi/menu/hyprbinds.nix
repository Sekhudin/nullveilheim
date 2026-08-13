{
  mkBind,
  mkRofi,
  mkJq,
  joinPipe,
  pkgs,
  tokens,
  styles,
  combos,
  dsp,
  ...
}:

let
  name = "rofi-hyprbinds";

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
            "SPACE": "␣",
            "RETURN": "↵",
            "TAB": "Tab",
            "SLASH": "/",
            "BACKSPACE": "⌫",
            "DELETE": "Del",
            "LEFT": "←",
            "RIGHT": "→",
            "UP": "↑",
            "DOWN": "↓",
            "escape": "Esc",
            "mouse:272": "ML",
            "mouse:273": "MR"
          }[.] // .;

        def key_shortcut:
          {
          "escape": "Escape",
            "mouse:272": "Mouse Left",
            "mouse:273": "Mouse Right"
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
          | select(.description != "")
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
          horizontal-align: 0.0;
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
  bind = mkBind {
    key = combos.mod "SLASH";
    dispatcher = dsp.exec_cmd {
      cmd = name;
    };
    flags = {
      description = "show key bindings";
    };
  };

  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
