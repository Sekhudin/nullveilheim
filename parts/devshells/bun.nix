{ inputs, ... }:

let
  inherit (inputs.self.nullveilheimConfigurations.extraLib.devshell) fmt;
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
      devShells = {
        bun = mkShell {
          name = "bun";
        };
      };
    };
}
