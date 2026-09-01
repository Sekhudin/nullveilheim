{ lib, ... }:

{
  options.nixvimCompletion = {
    engine = lib.mkOption {
      type = lib.types.enum [
        "cmp"
      ];
      description = "choose engine";
      default = "cmp";
    };

    icon = lib.mkOption {
      type = lib.types.enum [
        "lspkind"
      ];
      description = "choose icon";
      default = "lspkind";
    };

    snippet = lib.mkOption {
      type = lib.types.enum [
        "luasnip"
      ];
      description = "choose snippet";
      default = "luasnip";
    };
  };
}
