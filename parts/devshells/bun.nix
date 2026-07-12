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
            echo -e "${extraLib-ds.fmt.green "${name}"} ready!"
          '';
        };
    in
    {
      devShells = {
        bun = mkShell {
          name = "bun";
        };
      };
    };
}
