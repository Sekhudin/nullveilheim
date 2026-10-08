{ ... }:

{
  flake.overlays.vim =
    final: _:

    {
      vimPlugins = final.branches.unstable.vimPlugins.extend (
        _: __: {
        }
      );
    };
}
