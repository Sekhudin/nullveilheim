{ inputs, ... }:

let
  inherit (inputs.services-flake.lib) multiService;
in
{
  perSystem =
    { ... }:

    {
      process-compose = {
        mail-sandbox = {
          imports = [
            (multiService ./services/mailpit.nix)
          ];

          services = {
            mailpit = {
              mailpit-sandbox = {
                enable = true;
              };
            };
          };
        };
      };
    };
}
