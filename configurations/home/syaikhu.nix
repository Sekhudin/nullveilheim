{
  lib,
  ezModules,
  extraLib,
  osConfig ? { },
  ...
}:

{
  imports = lib.attrValues ezModules ++ [ ];

  home = rec {
    username = "syaikhu";
    stateVersion = "26.05";
    homeDirectory = osConfig.users.users.${username}.home or (extraLib.getHomeDir username);
    packages = [
    ];
  };

  homePackagesModules = {
    enable = true;
  };
}
