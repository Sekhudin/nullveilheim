{ extraLib, ... }:

let
  inherit (extraLib.nixvim) mkLuaFun;
in
{
  userCommands.LspInlay = {
    desc = "toggle inlay hints";
    command = {
      __raw = mkLuaFun ''
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      '';
    };
  };
}
