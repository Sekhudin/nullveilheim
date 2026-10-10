let
  themes = {
    aurora = [
      "#202633" # base00
      "#D9788B" # base01
      "#91B987" # base02
      "#A99AE0" # base03
      "#80B5D6" # base04
      "#B8A2D4" # base05
      "#78BDB8" # base06
      "#DCE4EF" # base07
      "#394354" # base08
      "#F18C9D" # base09
      "#A6CA9A" # base0A
      "#C0B4EF" # base0B
      "#96C8E5" # base0C
      "#CEB9E8" # base0D
      "#8BD0CA" # base0E
      "#F2F5FA" # base0F
    ];

    obsidian = [
      "#191D24" # base00
      "#D96C78" # base01
      "#83B77D" # base02
      "#8A9FCB" # base03
      "#6FA8D8" # base04
      "#AB91D5" # base05
      "#54ADB7" # base06
      "#D7DEE8" # base07
      "#343B47" # base08
      "#EF818B" # base09
      "#9BCB91" # base0A
      "#A6B8E0" # base0B
      "#85BCE5" # base0C
      "#C2A9E8" # base0D
      "#6CC5CC" # base0E
      "#F0F3F8" # base0F
    ];

    nocturne = [
      "#22201F" # base00
      "#CD7882" # base01
      "#91A77A" # base02
      "#849EAD" # base03
      "#779CB8" # base04
      "#AD91AB" # base05
      "#78AAA5" # base06
      "#D4D0CC" # base07
      "#403A39" # base08
      "#E28B95" # base09
      "#A8BC8D" # base0A
      "#A0B4C1" # base0B
      "#8CB3CA" # base0C
      "#C3A8C1" # base0D
      "#89BDB7" # base0E
      "#EAE6E1" # base0F
    ];
  };
in
{
  mkColor =
    { lib }:

    let
      toPalette = i: color: "${toString i}=${color}";

      toScheme = i: color: {
        name = "base" + (if i < 16 then "0${lib.toUpper (lib.toHexString i)}" else lib.toHexString i);
        value = color;
      };

      mkPalette = lib.lists.imap0 toPalette;

      mkScheme = lib.flip lib.pipe [
        (lib.lists.imap0 toScheme)
        lib.attrsets.listToAttrs
      ];

      mkTheme =
        name:
        let
          colors = themes.${name};
          palette = mkPalette colors;
          scheme = mkScheme colors;
          tokens = {
            bg = scheme.base00;
            fg = scheme.base07;

            primary = scheme.base0D;
            primary_fg = scheme.base00;

            secondary = scheme.base0C;
            secondary_fg = scheme.base00;

            muted = scheme.base03;
            muted_fg = scheme.base04;

            accent = scheme.base0E;
            accent_fg = scheme.base07;

            destructive = scheme.base08;
            destructive_fg = scheme.base07;

            success = scheme.base0B;
            success_fg = scheme.base00;

            warning = scheme.base0A;
            warning_fg = scheme.base00;

            info = scheme.base0D;
            info_fg = scheme.base07;

            border = scheme.base02;
            active_border = scheme.base0D;

            input = scheme.base01;
            ring = scheme.base0D;

            surface = scheme.base01;
            surface_alt = scheme.base02;
            surface_hover = scheme.base03;

            disabled = scheme.base03;
            disabled_fg = scheme.base04;

            link = scheme.base0D;
            selection = scheme.base02;
            selection_fg = scheme.base07;
          };

          apps.ghostty = {
            background = tokens.bg;
            foreground = tokens.fg;
            cursor-color = tokens.secondary;
            cursor-text = tokens.secondary_fg;
            selection-background = tokens.muted;
            selection-foreground = tokens.muted_fg;
            palette = palette;
          };

          opacity = 0.9;
        in
        {
          inherit
            name
            colors
            palette
            scheme
            tokens
            apps
            opacity
            ;
        };

      isRgba = color: builtins.match "^#[0-9A-Fa-f]{8}$" color != null;
      mkGtkColor =
        color:
        if isRgba color then
          let
            rgb = lib.substring 0 7 color;
            alphaHex = lib.substring 7 2 color;
            alpha = lib.fromHexString alphaHex;
            opacity100 = builtins.floor ((alpha / 255.0) * 100 + 0.5);
            integer = builtins.div opacity100 100;
            fractional = lib.fixedWidthString 2 "0" (toString (opacity100 - integer * 100));
          in
          "alpha(${rgb}, ${toString integer}.${fractional})"
        else
          color;

      mkGtkTokenCss =
        tokens:
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "@define-color ${name} ${mkGtkColor value};") tokens
        );

      withOpacity =
        color: opacity:
        let
          alpha = lib.toHexString (builtins.floor (opacity * 255));
          alpha' = if lib.stringLength alpha == 1 then "0${alpha}" else alpha;
        in
        "${color}${alpha'}";
    in
    {
      inherit
        themes
        mkTheme
        mkGtkColor
        mkGtkTokenCss
        withOpacity
        ;
    };
}
