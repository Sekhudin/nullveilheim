{ inputs, ... }:

let
  inherit (inputs.self.nullveilheimConfigurations) extraLib-ds;
in
{
  perSystem =
    { pkgs, ... }:

    let
      mkShell =
        {
          name,
          extraPackages ? [ ],
        }:

        pkgs.mkShell {
          name = "${name}-dev-shell";
          packages = [ pkgs.${name} ] ++ extraPackages;
          shellHook = ''
            echo "Entering ${name} development environment..."

            corepack enable --install-directory=$PWD/.corepack
            export PATH=$PWD/.corepack:$PATH
          '';
        };
    in
    {
      devShells = extraLib-ds.mkShells {
        inherit pkgs mkShell;
        name = "nodejs_";
      };
    };
}
