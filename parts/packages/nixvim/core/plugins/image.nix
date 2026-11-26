{ lib, ... }:

{
  plugins.image = {
    enable = lib.mkDefault true;
    settings = { };
  };
}
