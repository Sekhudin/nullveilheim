{
  inputs,
  ...
}:

let
  shared = import ../shared;
in
{
  imports = [
    ./ez-config.nix
    ./overlays.nix
  ];

  perSystem =
    {
      system,
      lib,
      ...
    }:

    let
      shareable = shared.mkShareable { inherit lib; };
    in
    {
      _module.args = {
        inherit (shareable)
          color
          icon
          font
          extraLib
          ;

        extraModuleArgs = {
          inherit (shareable)
            color
            icon
            font
            extraLib
            ;
        };

        pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (shareable.extraNixpkgs) config;
          overlays = lib.attrValues inputs.self.overlays ++ [ ];
        };
      };
    };
}
