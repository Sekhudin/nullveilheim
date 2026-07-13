{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.configModules.usercommands;
  inherit (extraLib.nixvim) mkLuaFun;
in
{
  options.configModules.usercommands = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable autocmd";
      default = false;
    };

    commands = lib.mkOption {
      type = lib.types.attrs;
      description = "extracommands";
      default = { };
    };

  };

  config = lib.mkIf cfg.enable {
    userCommands = lib.mkMerge [
      {
        LspInlay = {
          desc = "toggle inlay hints";
          command = {
            __raw = mkLuaFun ''
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            '';
          };
        };
      }
      cfg.commands
    ];
  };
}
