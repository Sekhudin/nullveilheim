let
  sharedLib = import ./lib;
  sharedColors = import ./colors.nix;
  sharedFonts = import ./fonts.nix;
  sharedIcons = import ./icons.nix;
in
{
  mkShareable =
    { lib }:

    {
      extraLib = sharedLib.mkExtraLib {
        inherit lib;
      };

      color = sharedColors.mkColor {
        inherit lib;
        theme = "carbon";
      };

      icon = sharedIcons.mkIcon;

      font = sharedFonts.mkFont;
    };
}
