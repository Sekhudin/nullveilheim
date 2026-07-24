{
  config,
  pkgs,
  lib,
  ...
}:

let
  master = config.homeCoreModules;
in
{
  options.homeCoreModules.darwin = { };

  config = lib.mkIf (master.enable && pkgs.stdenv.isDarwin) {
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
        ++ lib.optionals (!master.enableStandalone) (
          with pkgs;
          [
            docker
          ]
        );
    };
  };
}
