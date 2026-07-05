{
  config,
  pkgs,
  lib,
  osConfig,
  extraLib,
  ...
}:

let
  masterEnable = config.homeCoreModules.enable;
  isStandalone = extraLib.isStandalone osConfig;
in
{
  options.homeCoreModules.linux = { };

  config = lib.mkIf (masterEnable && pkgs.stdenv.isLinux) {
    home = {
      packages =
        with pkgs;
        [
          fswatch
          copyq
          xsel
          (writeScriptBin "copy" "xsel -ib")
          (writeScriptBin "paste" "xsel -ob")
        ]
        ++ lib.optionals (!isStandalone) (
          with pkgs;
          [
            docker
          ]
        );
    };
  };
}
