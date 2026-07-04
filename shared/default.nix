let
  sharedColors = import ./colors.nix;
  sharedFonts = import ./fonts.nix;
  sharedIcons = import ./icons.nix;
  sharedLib = import ./lib.nix;
  sharedNixpkgs = import ./nixpkgs.nix;
in
{
  mkShareable =
    { pkgs, lib }:

    {
      color = sharedColors.mkColor { inherit lib; } "carbon";
      icon = sharedIcons;
      font = sharedFonts.mkFont { inherit pkgs; };
      extraLib = sharedLib.mkExtraLib { inherit pkgs lib; };
      nixpkgsConfig = sharedNixpkgs.config;
    };
}
