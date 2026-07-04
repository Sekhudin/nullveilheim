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
      pkgs,
      lib,
      ...
    }:

    let
      shareable = shared.mkShareable { inherit pkgs lib; };
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
          config = shareable.nixpkgsConfig;
          overlays = lib.attrValues inputs.self.overlays ++ [ ];
        };
      };
    };
}
