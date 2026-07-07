{ inputs, lib, ... }:

let
  shared = import ../shared;
  shareable = shared.mkShareable { inherit lib; };
in
{
  imports = [
    ./overlays
    ./ez-config.nix
  ];

  flake = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
        contentAddressedByDefault = false;
        tarball-ttl = 0;
      };
      overlays = lib.attrValues inputs.self.overlays ++ [
      ];
    };

    inherit (shareable)
      color
      icon
      font
      extraLib
      ;
  };

  perSystem =
    {
      system,
      inputs',
      ...
    }:

    let
      formatter = inputs'.nixpkgs.legacyPackages.nixfmt;
    in
    {
      inherit formatter;

      _module.args = {
        inherit (inputs.self)
          color
          icon
          font
          extraLib
          ;

        extraModuleArgs = {
          inherit (inputs.self)
            color
            icon
            font
            extraLib
            ;
        };

        pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (inputs.self.nixpkgs) config overlays;
        };
      };
    };
}
