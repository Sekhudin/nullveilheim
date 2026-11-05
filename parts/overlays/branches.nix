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
      system = prev.stdenv.hostPlatform.system;
      branches = mkBranches system;
    in
    {
      inherit branches;

      inherit (branches.stable)
        nixd
        nixf
        nixt
        ;

      inherit (branches.unstable)
        firefox
        discord
        obsidian
        slack
        wpsoffice

        antigravity-cli
        claude-code
        opencode

        androidenv
        android-tools
        android-studio
        android-studio-full
        ;

      # yazi related
      yazi = branches.unstable.yazi;
      exiftool = branches.unstable.yazi;
      yaziPlugins = branches.unstable.yaziPlugins // {
        yatline = branches.unstable.yaziPlugins.yatline.overrideAttrs (_: {
          version = "unstable-2026-10-06";
          src = branches.unstable.fetchFromGitHub {
            owner = "imsi32";
            repo = "yatline.yazi";
            rev = "dc44b737791c07a8e2de54d8838cfe304853d780";
            hash = "sha256-U7MAZSc0iPiRvLZM8tKbNd749pblarB1Y48lH13uLuU=";
          };
        });
      };
    };
}
