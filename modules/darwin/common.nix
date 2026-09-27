{
  inputs,
  lib,
  ...
}:

{
  imports = lib.attrValues inputs.self.nullveilheim.modules.common;
}
