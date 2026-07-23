{ inputs, lib, ... }:

let
  mkChannels =
    {
      inputs,
      lib,
      nixpkgsArgs,
      prefix ? "nixpkgs-",
    }:
    lib.pipe inputs [
      (lib.filterAttrs (name: _channel: lib.strings.hasPrefix prefix name))
      (lib.mapAttrs' (
        name: channel: lib.nameValuePair (lib.strings.removePrefix prefix name) (import channel nixpkgsArgs)
      ))
    ];

  mkBranches =
    system:
    mkChannels {
      inherit inputs lib;
      nixpkgsArgs = {
        inherit system;
        inherit (inputs.self.nullveilheimConfigurations.nixpkgs) config;
      };
    };
in
{
  flake.overlays.default =
    _: prev:

    let
      branches = mkBranches prev.stdenv.hostPlatform.system;
      stable = branches.stable;
      unstable = branches.unstable;

      vimPlugins = unstable.vimPlugins;
      tree-sitter-grammars = stable.tree-sitter-grammars;
    in
    {
      inherit branches;

      inherit (stable) nixd nixf nixt;

      inherit (unstable)
        slack
        discord
        wpsoffice

        claude-code
        gemini-cli
        opencode

        androidenv
        android-tools
        android-studio
        android-studio-full
        ;

      fishPlugins = prev.fishPlugins // {
        nix-env = {
          name = "nix-env";
          src = inputs.nix-env;
        };
      };

      vimPlugins = vimPlugins.extend (
        _: __: {
        }
      );

      tree-sitter-grammars = tree-sitter-grammars // {
      };
    };
}
