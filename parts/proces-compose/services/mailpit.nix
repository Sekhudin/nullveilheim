{
  pkgs,
  config,
  lib,
  name,
  ...
}:

let
  cfg = config;
  mkEnvironment =
    env:
    let
      sysEnv = builtins.listToAttrs (
        map (key: {
          name = key;
          value = builtins.getEnv key;
        }) (builtins.attrNames env)
      );
      validSysEnv = lib.filterAttrs (_: v: v != "") sysEnv;
    in
    env // validSysEnv;

  mkAuth =
    {
      username,
      password,
      port,
    }:
    {
      auth = "${username}:${password}";
      bindAddr = "0.0.0.0:${toString port}";
    };

  auth_web_ui = mkAuth {
    inherit (cfg.web_ui) username password port;
  };

  auth_smtp = mkAuth {
    inherit (cfg.smtp) username password port;
  };
in
{
  options = {
    package = lib.mkPackageOption pkgs "mailpit" { };
    smtp = lib.mkOption {
      type = lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            description = "smtp username";
            default = "root";
          };

          password = lib.mkOption {
            type = lib.types.str;
            description = "smtp password";
            default = "root";
          };

          port = lib.mkOption {
            type = lib.types.port;
            description = "smtp port";
            default = 1025;
          };
        };
      };
      default = { };
    };

    web_ui = lib.mkOption {
      type = lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            description = "web_ui username";
            default = "root";
          };

          password = lib.mkOption {
            type = lib.types.str;
            description = "web_ui password";
            default = "root";
          };

          port = lib.mkOption {
            type = lib.types.port;
            description = "web_ui port";
            default = 8025;
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    outputs.settings = {
      processes.${name} = {
        command = "${lib.getExe cfg.package}";
        availability = {
          restart = "on_failure";
        };
        environment = mkEnvironment {
          MP_UI_AUTH = auth_web_ui.auth;
          MP_UI_BIND_ADDR = auth_web_ui.bindAddr;

          MP_SMTP_AUTH = auth_smtp.auth;
          MP_SMTP_BIND_ADDR = auth_smtp.bindAddr;
          MP_SMTP_AUTH_ALLOW_INSECURE = "true";
        };
      };
    };
  };
}
