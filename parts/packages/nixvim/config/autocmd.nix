{ config, lib, ... }:

let
  cfg = config.configModules.autocmd;
  mkAutosave =
    { enable, pattern }:

    lib.mkIf enable {
      event = [
        "InsertLeave"
        "CursorHoldI"
      ];
      command = "silent update";
      pattern = lib.lists.unique (
        [
          "*.css"
          "*.go"
          "*.js"
          "*.jsx"
          "*.md"
          "*.nix"
          "*.ts"
          "*.tsx"
        ]
        ++ pattern
      );
    };
in
{
  options.configModules.autocmd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable autocmd";
      default = false;
    };

    autosave = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "enable autosave";
          };

          pattern = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "file patterns";
            default = [ ];
          };
        };
      };
      description = "colorschemes settings";
      default = { };
    };

    commands = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "commands";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    autoCmd = [ (mkAutosave cfg.autosave) ] ++ cfg.commands;
  };
}
