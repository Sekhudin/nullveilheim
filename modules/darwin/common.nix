{
  self,
  lib,
  config,
  ...
}:

{
  imports = lib.attrValues self.nullveilheimModules.common;

  commonModules = {
    osConfig = config;
  };
}
