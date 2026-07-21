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
    in
    {
      inherit (stable) nixd nixf nixt;
      inherit branches;

      slack = unstable.slack;
      discord = unstable.discord;
      wpsoffice = unstable.wpsoffice;

      android-studio-full = unstable.android-studio-full;

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
