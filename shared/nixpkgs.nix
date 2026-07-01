{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      contentAddressedByDefault = false;
      tarball-ttl = 0;
    };
  };
}
