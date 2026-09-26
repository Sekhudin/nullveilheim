let
  sharedLib = import ./lib;
  sharedColors = import ./colors.nix;
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
      };

      icon = sharedIcons.mkIcon;
    };
}
