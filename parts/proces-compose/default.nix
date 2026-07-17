{ inputs, ... }:

{
  imports = [
    inputs.process-compose-flake.flakeModule
    ./mail-sandbox.nix
    ./pg-sandbox.nix
  ];
}
