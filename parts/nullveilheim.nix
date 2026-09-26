{
  inputs,
  lib,
  ...
}:

let
  shared = import ../shared;
  shareable = shared.mkShareable { inherit lib; };

  toModuleEntry =
    dir: name: type:
    let
      path = "${dir}/${name}";
      isNixFile = type == "regular" && lib.strings.hasSuffix ".nix" name;
      isDirWithDefault = type == "directory" && builtins.pathExists "${path}/default.nix";
    in
    if isNixFile then
      {
        name = lib.strings.removeSuffix ".nix" name;
        value = path;
      }
    else if isDirWithDefault then
      {
        inherit name;
        value = "${path}/default.nix";
      }
    else
      null;

  readModules =
    dir:
    if !builtins.pathExists dir then
      { }
    else
      let
        entries = builtins.readDir dir;
        modules = lib.mapAttrsToList (toModuleEntry dir) entries;
      in
      lib.listToAttrs (lib.filter (x: x != null) modules);

  mkAutoModules =
    modules: lib.mapAttrs' (name: value: lib.nameValuePair name (readModules value.dir)) modules;
in
{
  flake = {
    nullveilheim = {
      inherit (shareable)
        color
        icon
        extraLib
        ;

      nixpkgs = {
        config = {
          allowUnfree = true;
          allowBroken = false;
          contentAddressedByDefault = false;
          tarball-ttl = 86400;
          android_sdk = {
            accept_license = true;
          };
        };

        overlays = lib.attrValues inputs.self.overlays ++ [
          inputs.nixgl.overlay
        ];
      };

      modules = mkAutoModules {
        common.dir = ../modules/common;
      };
    };
  };
}
