{
  self,
  inputs,
  ...
}:

{
  imports = [
    inputs.pre-commit-hooks.flakeModule
    ./bun.nix
    ./go.nix
    ./node.nix
  ];

  perSystem =
    { config, pkgs, ... }:

    {
      pre-commit = {
        devShell = self.devShells.default;
        check = {
          enable = true;
        };
        settings = {
          hooks = {
            check-secrets-encrypted = {
              enable = true;
              name = "Check if secrets are encrypted";
              description = "make sure the file include sops metadata";
              entry = "${pkgs.gnugrep}/bin/grep -q 'sops_version'";
              files = "^secrets/.*";
              pass_filenames = true;
            };
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
