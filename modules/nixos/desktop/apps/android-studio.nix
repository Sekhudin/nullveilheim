{
  pkgs,
  config,
  ...
}:

let
  desktop = config.nixosDesktop;
  sdk = pkgs.androidenv.composeAndroidPackages {
    inherit (desktop.android-studio)
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
}
