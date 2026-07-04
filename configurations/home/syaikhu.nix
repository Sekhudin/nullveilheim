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
    homeDirectory = extraLib.getHomeDir { inherit username osConfig; };
    packages = [
    ];
  };

  homeCoreModules = {
    enable = true;
  };
}
