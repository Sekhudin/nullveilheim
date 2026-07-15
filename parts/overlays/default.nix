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
          allowBroken = false;
          contentAddressedByDefault = false;
          tarball-ttl = 0;
        };
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
    in
    {
      inherit (stable) nixd nixf nixt;
      inherit branches;

      slack = stable.slack;
      discord = stable.discord;
      wpsoffice = stable.wpsoffice;

      claude-code = unstable.claude-code;
      gemini-cli = unstable.gemini-cli;
      opencode = unstable.opencode;

      fishPlugins = prev.fishPlugins // {
        nix-env = {
          name = "nix-env";
          src = inputs.nix-env;
        };
      };

      vimPlugins = unstable.vimPlugins.extend (
        _: __: {
        }
      );

      tree-sitter-grammars = stable.tree-sitter-grammars // {
      };

    };
}
