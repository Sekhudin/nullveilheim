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
        inherit (inputs.self.nullveilheim.nixpkgs) config;
      };
    };
in
{
  flake.overlays.branches =
    _: prev:

    let
      branches = mkBranches prev.stdenv.hostPlatform.system;
    in
    {
      inherit branches;

      inherit (branches.stable)
        nixd
        nixf
        nixt
        ;

      inherit (branches.unstable)
        discord
        obsidian
        slack
        wpsoffice

        claude-code
        gemini-cli
        opencode

        androidenv
        android-tools
        android-studio
        android-studio-full
        ;
    };
}
