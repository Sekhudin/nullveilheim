{ ... }:

{
  flake.overlays.tree-sitter =
    final: _:

    {
      tree-sitter-grammars = final.branches.stable.tree-sitter-grammars // {
      };
    };
}
