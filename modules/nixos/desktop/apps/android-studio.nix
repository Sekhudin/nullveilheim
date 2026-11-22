{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nixosDesktop.android-studio;

  sdk = pkgs.androidenv.composeAndroidPackages {
    inherit (cfg.settings)
      cmdLineToolsVersion
      platformToolsVersion

      buildToolsVersions
      platformVersions

      includeCmake
      cmakeVersions

      includeNDK
      ndkVersions

      includeEmulator
      includeSystemImages
      systemImageTypes
      abiVersions
      useGoogleAPIs
      useGoogleTVAddOns

      includeSources
      ;
  };
in
{
  config = lib.mkIf (cfg.enable && config.nixosDesktop.enable) {
    environment = {
      systemPackages = with pkgs; [
        android-tools
        (android-studio.withSdk sdk.androidsdk)
      ];

      sessionVariables = rec {
        ANDROID_HOME = "$HOME/Android/Sdk";
        ANDROID_NDK_HOME = "${ANDROID_HOME}/ndk-bundle";
      };
    };
  };
}
