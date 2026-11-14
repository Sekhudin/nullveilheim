{ config, lib, ... }:

{
  programs.herdr.enable = lib.mkDefault (config.homeCore.multiplexer == "herdr");
}
