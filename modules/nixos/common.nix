{
  inputs,
  lib,
  ...
}:

{
  imports = lib.attrValues inputs.nullveilheim.modules.common;
}
