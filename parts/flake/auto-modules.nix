{ lib, config, ... }:

let
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

in
{
  options.autoModules = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.dir = lib.mkOption { type = lib.types.path; };
      }
    );
    default = { };
    description = "auto import module based on directory";
  };

  config = lib.mkIf (config.autoModules != { }) {
    flake = {
      nullveilheimModules = lib.mapAttrs' (
        name: value: lib.nameValuePair name (readModules value.dir)
      ) config.autoModules;

    };
  };
}
