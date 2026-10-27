{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.programs.yakc;
  inherit (extraLib.hyprland) hypr;

  ipc = hypr.getVarValues config "ipc";

  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.yakc = {
    enable = lib.mkEnableOption "yakc";

    package = lib.mkPackageOption pkgs "yakc" {
      nullable = true;
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Configuration for yakc, serialized to JSON.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.optionals (cfg.package != null) [
      cfg.package
      (pkgs.writeShellApplication {
        name = ipc.keyviz;
        runtimeInputs = [
          cfg.package
          pkgs.procps
          pkgs.coreutils
        ];
        text = ''
          if pgrep -x .yakc-wrapped >/dev/null 2>&1; then
            pkill -TERM -x .yakc-wrapped
            printf '%s\n' "YAKC stopped."
          else
            nohup yakc >/dev/null 2>&1 </dev/null &
            printf '%s\n' "YAKC started."
          fi
        '';
      })
    ];

    xdg.configFile."dev.iammodev.yakc/config.backup.json" = {
      source = jsonFormat.generate "yakc.toml" cfg.settings;
    };

    wayland.windowManager.hyprland = {
      settings = {
        window_rule = [
          (hypr.mkWindowRule {
            name = "yakc";
            match.class = "^Yakc$";
            match.xwayland = true;
            no_blur = true;
            float = true;
            pin = true;
            size = [
              "(monitor_w*0.25)"
              "(monitor_h*0.22)"
            ];
            move = [
              "(monitor_w*0.75)"
              "(monitor_h*0.78)"
            ];
          })
        ];
      };
    };
  };
}
