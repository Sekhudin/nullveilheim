{ lib, ... }:

let
  androidStudioType = lib.types.submodule {
    options = {
      cmdLineToolsVersion = lib.mkOption {
        type = lib.types.str;
        default = "19.0";
        description = "android sdk command-line tools version.";
      };
      platformToolsVersion = lib.mkOption {
        type = lib.types.str;
        default = "latest";
        description = "android sdk platform-tools version.";
      };
      buildToolsVersions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "34.0.0"
          "35.0.0"
          "36.0.0"
          "37.0.0"
        ];
        description = "android sdk build tools versions to install.";
      };
      platformVersions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "34"
          "35"
          "36"
          "37"
        ];
        description = "android platform api versions to install.";
      };
      includeCmake = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "include cmake in the android sdk.";
      };
      cmakeVersions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "latest" ];
        description = "cmake versions to install.";
      };
      includeNDK = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "include the android native development kit (ndk).";
      };
      ndkVersions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "latest" ];
        description = "android ndk versions to install.";
      };
      includeEmulator = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "include the android emulator.";
      };
      includeSystemImages = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "include android emulator system images.";
      };
      systemImageTypes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "default"
          "google_apis_playstore"
        ];
        description = "android system image types to install.";
      };
      abiVersions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "x86_64" ];
        description = "android system image abi versions to install.";
      };
      useGoogleAPIs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "include google apis for selected platform versions.";
      };
      useGoogleTVAddOns = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "include google tv add-ons for selected platform versions.";
      };
      includeSources = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "include android sdk sources.";
      };
    };
  };
in
{
  options.nixosDesktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable desktop";
      default = true;
    };

    android-studio = lib.mkOption {
      type = androidStudioType;
      description = "android-studio-settings";
      default = { };
    };
  };
}
