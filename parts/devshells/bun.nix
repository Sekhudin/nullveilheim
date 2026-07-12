{ ... }:

{
  perSystem =
    { pkgs, extraLib, ... }:

    let
      inherit (extraLib.devshell) fmt;

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
