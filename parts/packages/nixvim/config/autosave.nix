{ config, lib, ... }:

let
  cfg = config.nixvimConfig;
in
{
  options.nixvimConfig = {
    autosave = lib.mkOption {
      type = lib.types.bool;
      description = "enable autosave";
      default = false;
    };
  };

  config = lib.mkIf cfg.autosave {
    autoCmd = [
      {
        event = [
          "InsertLeave"
          "CursorHoldI"
        ];
        command = "silent update";
        pattern = [
          "*.css"
          "*.go"
          "*.js"
          "*.jsx"
          "*.md"
          "*.nix"
          "*.ts"
          "*.tsx"
        ];
      }
    ];
  };
}
