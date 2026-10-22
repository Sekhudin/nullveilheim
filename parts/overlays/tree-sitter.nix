{ ... }:

{
  flake.overlays.tree-sitter =
    final: _:

    {
      tree-sitter-grammars = final.branches.unstable.tree-sitter-grammars // {
      };
    };
}
