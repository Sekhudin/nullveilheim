{
  self,
  lib,
  ...
}:

{
  imports = lib.attrValues self.nullveilheimModules.common;
}
