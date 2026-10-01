{
  options,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop;

  noctaliaBarType = lib.types.submodule {
    options = {
      label.enable = lib.mkOption {
        type = lib.types.bool;
        description = "enable desktop widgets";
        default = false;
      };
    };
  };

  noctaliaDesktopType = lib.types.submodule {
    options = {
      widgets.enable = lib.mkOption {
        type = lib.types.bool;
        description = "enable desktop widgets";
        default = false;
      };

      wallpaper.automation.enable = lib.mkOption {
        type = lib.types.bool;
        description = "enable wallpaper automation";
        default = false;
      };

      backdrop.enable = lib.mkOption {
        type = lib.types.bool;
        description = "enable desktop backdrop";
        default = false;
      };
    };
  };

  mkFiles =
    {
      dir,
      exts,
    }:
    let
      files = builtins.readDir dir;
      isImage =
        name:
        let
          ext = lib.toLower (lib.last (lib.splitString "." name));
        in
        files.${name} == "regular" && lib.elem ext exts;
      toName = name: lib.removeSuffix ".${lib.last (lib.splitString "." name)}" name;
    in
    (
      lib.listToAttrs (
        map (name: {
          name = toName name;
          value = dir + "/${name}";
        }) (lib.filter isImage (builtins.attrNames files))
      )
      // {
        inherit dir;
      }
    );
in
{
  imports = [
    ./hypr
    ./noctalia
  ];

  options.homeDesktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable desktop modules";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "noctalia"
      ];
      description = "choose desktop shell";
      default = "noctalia";
    };

    font = lib.mkOption {
      type = options.homeCore.font.type;
      description = "desktop font settings";
      readOnly = true;
      internal = true;
    };

    wallpapers = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      description = "wallpaper paths indexed by filename";
      readOnly = true;
      internal = true;
    };

    svgs = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      description = "svg paths indexed by filename";
      readOnly = true;
      internal = true;
    };

    noctalia.enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable noctalia";
      readOnly = true;
      internal = true;
    };

    noctalia.bar = lib.mkOption {
      type = noctaliaBarType;
      description = "noctalia bar settings";
      default = { };
    };

    noctalia.desktop = lib.mkOption {
      type = noctaliaDesktopType;
      description = "noctalia desktop settings";
      default = { };
    };
  };

  config = {
    homeDesktop = {
      font = config.homeCore.font;
      wallpapers = mkFiles {
        dir = ./wallpapers;
        exts = [
          "png"
          "jpg"
          "jpeg"
          "webp"
        ];
      };
      svgs = mkFiles {
        dir = ./svgs;
        exts = [ "svg" ];
      };
      noctalia.enable = cfg.enable && cfg.use == "noctalia";
    };
  };
}
