let
  themes = {
    edge = [
      "#2B2D3A" # base00
      "#EC7279" # base01
      "#A0C980" # base02
      "#EF9F76" # base03
      "#6CB6EB" # base04
      "#D38AEA" # base05
      "#5DBBC1" # base06
      "#E1E5ED" # base07
      "#3D3D40" # base08
      "#F17E84" # base09
      "#B1D48B" # base0A
      "#F5B083" # base0B
      "#7EC1F5" # base0C
      "#DE95F5" # base0D
      "#68C7CD" # base0E
      "#F0F4FA" # base0F
    ];

    carbon = [
      "#161616" # base00
      "#EE5396" # base01
      "#42BE65" # base02
      "#EF9F76" # base03
      "#6CB6EB" # base04
      "#BE95FF" # base05
      "#33B1FF" # base06
      "#f2f4f8" # base07
      "#3D3D40" # base08
      "#F17E84" # base09
      "#B1D48B" # base0A
      "#F5B083" # base0B
      "#7EC1F5" # base0C
      "#DE95F5" # base0D
      "#68C7CD" # base0E
      "#F0F4FA" # base0F
    ];

    zenwritten_dark = [
      "#191919" # base00
      "#de6e7c" # base01
      "#819b69" # base02
      "#b77e64" # base03
      "#6099c0" # base04
      "#b279a7" # base05
      "#66a5ad" # base06
      "#bbbbbb" # base07
      "#3d3839" # base08
      "#e8838f" # base09
      "#8bae68" # base0A
      "#d68c67" # base0B
      "#61abda" # base0C
      "#cf86c1" # base0D
      "#65b8c1" # base0E
      "#8e8e8e" # base0F
    ];
  };
in
{
  mkColor =
    { lib }:

    let
      formatColorLine = i: color: "${toString i}=${color}";
      formatColorScheme = i: color: {
        name = "base" + (if i < 16 then "0${lib.toUpper (lib.toHexString i)}" else lib.toHexString i);
        value = color;
      };

      toColorLines = lib.lists.imap0 formatColorLine;
      toColorScheme = (lib.flip lib.pipe) [
        (lib.lists.imap0 formatColorScheme)
        lib.attrsets.listToAttrs
      ];

      isRgba = color: builtins.match "^#[0-9A-Fa-f]{8}$" color != null;

      mkOpacity =
        color: opacity:
        let
          alpha = lib.toHexString (builtins.floor (opacity * 255));
          alpha' = if lib.stringLength alpha == 1 then "0${alpha}" else alpha;
        in
        "${color}${alpha'}";

      mkRgb =
        color:
        let
          cleanColor = lib.removePrefix "#" color;
        in
        "rgb(${cleanColor})";

      mkRgba =
        color: opacity:
        let
          cleanColor = lib.removePrefix "#" color;
        in
        "rgba(${cleanColor}${mkOpacity "" opacity})";

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

      toGtkTokenCss =
        tokens:
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "@define-color ${name} ${mkGtkColor value};") tokens
        );

      mkTheme = name: {
        scheme = toColorScheme themes.${name};
        lines = toColorLines themes.${name};
      };

      mkTokens =
        theme:

        let
          theme' = if builtins.isString theme then mkTheme theme else theme;
          inherit (theme') scheme;
        in
        {
          bg = scheme.base00;
          fg = scheme.base07;

          primary = scheme.base05;
          primary_fg = scheme.base07;

          secondary = scheme.base06;
          secondary_fg = scheme.base07;

          muted = scheme.base08;
          muted_fg = scheme.base0F;

          accent = scheme.base0D;
          accent_fg = scheme.base07;

          destructive = scheme.base01;
          destructive_fg = scheme.base07;

          success = scheme.base02;
          success_fg = scheme.base07;

          warning = scheme.base03;
          warning_fg = scheme.base07;

          info = scheme.base04;
          info_fg = scheme.base07;

          border = scheme.base08;
          active_border = scheme.base05;

          input = scheme.base08;
          ring = scheme.base05;
        };
    in
    {
      inherit
        themes
        mkTheme
        mkTokens
        mkOpacity
        mkRgb
        mkRgba
        mkGtkColor
        toGtkTokenCss
        ;

      opacity = 0.9;
    };
}
