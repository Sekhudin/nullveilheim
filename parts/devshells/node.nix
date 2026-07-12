{ ... }:

{
  perSystem =
    { pkgs, extraLib, ... }:

    let
      inherit (extraLib.devshell) fmt mkShells;

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
        prefix = "nodejs_";
        excludes = [
          "nodejs_20"
          "nodejs_25"
        ];
      };
    };
}
