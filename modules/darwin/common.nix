{
  inputs,
  lib,
  ...
}:

let
  inherit (inputs.self.nullveilheim) modules;
in
{
  imports = lib.attrValues modules.common;
}
