{
  inputs,
  ...
}:

let
  mkChannels =
    {
      prev,
      nixpkgs,
      prefix ? "nixpkgs-",
    }:
    prev.pipe inputs [
      (prev.filterAttrs (name: _channel: prev.strings.hasPrefix prefix name))
      (prev.mapAttrs' (
        name: channel:
        prev.nameValuePair (prev.strings.removePrefix prefix name) (
          import channel {
            inherit (prev.stdenv.hostPlatform) system;
            inherit (nixpkgs) config;
          }
        )
      ))
    ];
in
{
  flake.overlays.default =
    final: prev:

    let
      stdenvHostPlatform = (inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system});
      branches = mkChannels {
        inherit prev;
        inherit (inputs.self) nixpkgs;
      };
    in
    {
      inherit (stdenvHostPlatform) nixd nixf nixt;
      inherit branches;

      nixfmt = prev.nixfmt-rfc-style;
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
