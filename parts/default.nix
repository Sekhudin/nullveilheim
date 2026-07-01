{
  inputs,
  ...
}:

let
  sharedColors = import ../shared/colors.nix;
  sharedIcons = import ../shared/icons.nix;
  sharedFonts = import ../shared/fonts.nix;
  sharedNixpkgs = import ../shared/nixpkgs.nix;
in
{
  imports = [
    ./overlays.nix
  ];

  perSystem =
    {
      system,
      pkgs,
      lib,
      ...
    }:

    let
      color = sharedColors.mkColor { inherit lib; } "carbon";
      icons = sharedIcons;
      fonts = sharedFonts.mkFont { inherit pkgs; };
    in
    {
      _module.args = {
        inherit color icons fonts;

        extraModuleArgs = {
          inherit color icons fonts;
        };

        pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (sharedNixpkgs) config;
          overlays = (lib.attrValues inputs.self.overlays) ++ [ ];
        };
      };
    };
}
