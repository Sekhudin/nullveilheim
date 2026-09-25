{
  inputs,
  ...
}:

let
  inherit (inputs.self.nullveilheim) nixpkgs;
in
{
  nixpkgs = {
    inherit (nixpkgs)
      config
      overlays
      ;
  };
}
