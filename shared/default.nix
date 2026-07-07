let
  sharedColors = import ./colors.nix;
  sharedFonts = import ./fonts.nix;
  sharedIcons = import ./icons.nix;
  sharedLib = import ./lib.nix;
in
{
  mkShareable =
    { lib }:

    {
      color = sharedColors.mkColor { inherit lib; } "carbon";
      icon = sharedIcons;
      font = sharedFonts;
      extraLib = sharedLib.mkExtraLib { inherit lib; };
    };
}
