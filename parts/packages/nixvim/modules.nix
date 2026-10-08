{ extraLib, ... }:

let
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = true;
    excludeDefault = true;
    dirs = [
      ./completion
      ./config
      ./lsp
      ./plugins
      ./tools
      ./ui
    ];
  };
}
