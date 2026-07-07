{
  description = "A void where configurations take shape.";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "nixpkgs-stable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    ez-configs.url = "github:ehllie/ez-configs";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";
    ez-configs.inputs.flake-parts.follows = "flake-parts";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixvim.inputs.flake-parts.follows = "flake-parts";

    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";

    services-flake.url = "github:juspay/services-flake";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    nix-env.url = "github:lilyball/nix-env.fish";
    nix-env.flake = false;
  };

  outputs =
    inputs@{ flake-parts, ... }:
    (flake-parts.lib.mkFlake { inherit inputs; }) {
      imports = [ ./parts ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
}
