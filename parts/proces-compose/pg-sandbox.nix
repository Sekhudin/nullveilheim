{
  inputs,
  ...
}:

let
  username = "syaikhu";
  password = "syaikhu";
  dataDirectory = "$HOME/process-compose";
in
{
  perSystem =
    { ... }:

    {
      process-compose = {
        pg-sandbox = {
          imports = [ inputs.services-flake.processComposeModules.default ];

          services = {
            postgres = {
              postgress-sandbox = {
                enable = true;
                dataDir = dataDirectory;
                port = 5432;
                listen_addresses = "127.0.0.1";
                superuser = username;
                createDatabase = false;
                initialScript = {
                  before = ''
                    SET password_encryption = 'scram-sha-256';

                    CREATE USER ${username} WITH
                        LOGIN 
                        CREATEDB 
                        CREATEROLE 
                        REPLICATION
                        PASSWORD '${password}';
                  '';
                };
                hbaConf = [
                  {
                    type = "local";
                    database = "all";
                    user = username;
                    address = "";
                    method = "scram-sha-256";
                  }
                  {
                    type = "host";
                    database = "all";
                    user = username;
                    address = "127.0.0.1/32";
                    method = "scram-sha-256";
                  }
                  {
                    type = "host";
                    database = "all";
                    user = username;
                    address = "::1/128";
                    method = "scram-sha-256";
                  }
                  {
                    type = "local";
                    database = "replication";
                    user = username;
                    address = "";
                    method = "scram-sha-256";
                  }
                  {
                    type = "host";
                    database = "replication";
                    user = username;
                    address = "127.0.0.1/32";
                    method = "scram-sha-256";
                  }
                  {
                    type = "host";
                    database = "replication";
                    user = username;
                    address = "::1/128";
                    method = "scram-sha-256";
                  }
                ];
              };
            };
          };
        };
      };
    };
}
