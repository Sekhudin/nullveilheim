{ ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs) lib;
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
      generalPackages =
        with pkgs;
        [
          gcc
          gnumake
          cmake
          ninja
          pkg-config
          gdb
        ]
        ++ lib.optionals isLinux (
          with pkgs;
          [
            valgrind
          ]
        );
    in
    {
      devShells = {
        c-general = pkgs.mkShell {
          packages = generalPackages;
        };
      }
      // lib.optionalAttrs isLinux {
        c-linux = pkgs.mkShell {
          packages =
            generalPackages
            ++ (with pkgs; [
              strace
              ltrace
              binutils
              linuxHeaders
              iproute2
              file
              procps
              util-linux
            ]);
        };
      };
    };
}
