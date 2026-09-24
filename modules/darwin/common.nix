{
  self,
  lib,
  ...
}:

{
  imports = lib.attrValues self.nullveilheim.modules.common;
}
