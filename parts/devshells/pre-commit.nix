{ inputs, ... }:

{
  imports = [
    inputs.pre-commit-hooks.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:

    {
      pre-commit = {
        devShell = inputs.self.devShells.default;
        check = {
          enable = true;
        };
        settings = {
          hooks = {
            actionlint = {
              enable = true;
            };
            shellcheck = {
              enable = true;
            };
            stylua = {
              enable = true;
            };
            luacheck = {
              enable = false;
            };
            deadnix = {
              enable = true;
            };
            nixfmt = {
              enable = true;
            };
          };
        };
      };

      devShells = {
        default = pkgs.mkShell {
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
