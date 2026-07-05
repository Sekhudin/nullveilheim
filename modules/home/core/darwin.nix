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
  options.homeCoreModules.darwin = { };

  config = lib.mkIf (masterEnable && pkgs.stdenv.isDarwin) {
    home = {
      packages =
        with pkgs;
        [
          mas
          m-cli
          clipy
          (writeScriptBin "copy" "pbcopy")
          (writeScriptBin "paste" "pbpaste")
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
