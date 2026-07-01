{
  inputs,
  ...
}:

let
  sharedNixpkgs = import ../shared/nixpkgs.nix;
  mkChannels =
    final: prev:
    prev.pipe inputs [
      (prev.filterAttrs (name: _channel: prev.strings.hasPrefix "nixpkgs-" name))
      (prev.mapAttrs' (
        name: channel:
        prev.nameValuePair (prev.strings.removePrefix "nixpkgs-" name) (
          import channel {
            inherit (prev.stdenv.hostPlatform) system;
            inherit (sharedNixpkgs) config;
          }
        )
      ))
    ];
in
{
  flake.overlays.default = final: prev: {
    inherit (inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}) nixd nixf nixt;

    ##############################
    # Branches
    ##############################
    branches = mkChannels final prev;

    ##############################
    # Packages
    ##############################
    nixfmt = prev.nixfmt-rfc-style;
    claude-code = final.branches.unstable.claude-code;
    gemini-cli = final.branches.unstable.gemini-cli;
    opencode = final.branches.unstable.opencode;

    ##############################
    # Fish plugins
    ##############################
    fishPlugins = prev.fishPlugins // {
      nix-env = {
        name = "nix-env";
        src = inputs.nix-env;
      };
    };

    ##############################
    # Vim plugins
    ##############################
    vimPlugins = final.branches.unstable.vimPlugins.extend (
      _: __: {

      }
    );

    ##############################
    # Tree-sitter grammars
    ##############################
    tree-sitter-grammars = prev.tree-sitter-grammars // {

    };
  };
}
