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
        config = {
          allowUnfree = true;
        };
      };
    };
in
{
  flake.overlays.default =
    final: prev:

    let
      branches = mkBranches prev.stdenv.hostPlatform.system;
      mainBranch = branches.stable;
    in
    {
      inherit (mainBranch) nixd nixf nixt;
      inherit branches;

      claude-code = branches.unstable.claude-code;
      gemini-cli = branches.unstable.gemini-cli;
      opencode = branches.unstable.opencode;

      fishPlugins = prev.fishPlugins // {
        nix-env = {
          name = "nix-env";
          src = inputs.nix-env;
        };
      };

      vimPlugins = branches.unstable.vimPlugins.extend (
        _: __: {
        }
      );

      tree-sitter-grammars = prev.tree-sitter-grammars // {
      };

    };
}
