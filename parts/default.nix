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
    ./ez-config.nix
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
      extraLib = {
        getHomeDir = username: if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
      };
    in
    {
      _module.args = {
        inherit
          color
          icons
          fonts
          extraLib
          ;

        extraModuleArgs = {
          inherit
            color
            icons
            fonts
            extraLib
            ;
        };

        pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (sharedNixpkgs) config;
          overlays = lib.attrValues inputs.self.overlays ++ [ ];
        };
      };
    };
}
