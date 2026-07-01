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
    name:

    let
      formatColorLine = index: color: "${toString index}=${color}";
      formatColorScheme = index: color: {
        name = "base${if index < 16 then "0${lib.toHexString index}" else lib.toHexString index}";
        value = color;
      };

      toColorLines = lib.lists.imap0 formatColorLine;
      toColorScheme = (lib.flip lib.pipe) [
        (lib.lists.imap0 formatColorScheme)
        lib.attrsets.listToAttrs
      ];

      mkTheme = name: {
        scheme = toColorScheme themes.${name};
        lines = toColorLines themes.${name};
      };
    in
    (mkTheme name) // { inherit mkTheme; };
}
