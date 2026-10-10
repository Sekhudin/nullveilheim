{
  options,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop;
  homeDirectory = config.home.homeDirectory;
  noctaliaBarType = lib.types.submodule {
    options = {
      label.enable = lib.mkOption {
        type = lib.types.bool;
        description = "enable noctalia bar";
        default = false;
      };
    };
  };

  noctaliaDockType = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "enable noctalia dock";
        default = true;
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

  filesType = lib.types.submodule {
    options = {
      files = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = "Files indexed by filename.";
      };
      dir = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.str;
        description = "Directory path.";
      };
      homeFile = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              source = lib.mkOption {
                type = lib.types.path;
              };

              recursive = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            };
          }
        );
        default = { };
        description = "Home Manager file definitions.";
      };
    };
  };

  mkFiles =
    {
      dir,
      exts,
      copy ? false,
      targetDir ? "Copied",
    }:
    let
      files = builtins.readDir dir;

      isFile =
        name:
        let
          ext = lib.toLower (lib.last (lib.splitString "." name));
        in
        files.${name} == "regular" && lib.elem ext exts;

      toName = name: lib.removeSuffix ".${lib.last (lib.splitString "." name)}" name;
      fileAttrs = lib.listToAttrs (
        map (name: {
          name = toName name;
          value = dir + "/${name}";
        }) (lib.filter isFile (builtins.attrNames files))
      );
    in
    {
      files = fileAttrs;
      dir = if copy then "${homeDirectory}/${targetDir}" else dir;
      homeFile = lib.optionalAttrs copy {
        ${targetDir} = {
          source = dir;
          recursive = true;
        };
      };
    };
in
{
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
      type = filesType;
      description = "wallpaper paths indexed by filename";
      readOnly = true;
      internal = true;
    };

    svgs = lib.mkOption {
      type = filesType;
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

    noctalia.dock = lib.mkOption {
      type = noctaliaDockType;
      description = "noctalia dock settings";
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
      noctalia.enable = cfg.enable && cfg.use == "noctalia";
      wallpapers = mkFiles {
        copy = true;
        dir = ./wallpapers;
        targetDir = "Pictures/Wallpapers";
        exts = [
          "png"
          "jpg"
          "jpeg"
          "webp"
        ];
      };
      svgs = mkFiles {
        copy = false;
        dir = ./svgs;
        exts = [ "svg" ];
      };
    };
  };
}
