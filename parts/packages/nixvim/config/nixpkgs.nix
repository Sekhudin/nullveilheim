{ inputs, lib, ... }:

{

  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnfree = true;
      contentAddressedByDefault = false;
      tarball-ttl = 0;
    };

    overlays = (lib.attrValues inputs.self.overlays);
  };
}
