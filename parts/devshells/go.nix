{ inputs, ... }:

let
  inherit (inputs.self.nullveilheimConfigurations.extraLib.devshell) fmt mkShells;
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
            echo -e "${fmt.green "${name}"} ready!"
          '';
        };
    in
    {
      devShells = mkShells {
        inherit pkgs mkShell;
        prefix = "go_";
        excludes = [
          "go_1_23"
        ];
        extends = {
          go = mkShell {
            name = "go";
          };
        };
      };
    };
}
