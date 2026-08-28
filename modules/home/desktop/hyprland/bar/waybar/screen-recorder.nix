{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  actions = var "actions";

  baseModule = {
    interval = 1;
    on-click = actions.screenrec;
    exec = ''
      state_file="''${XDG_RUNTIME_DIR}/wf-recorder"

      if [ -f "$state_file" ]; then
        pid="$(sed -n '1p' "$state_file")"

        if [ -n "$pid" ] &&
           [[ "$pid" =~ ^[0-9]+$ ]] &&
           kill -0 "$pid" 2>/dev/null
        then
          printf '{"text":"Recording...","alt":"recording","class":"recording"}\n'
          exit
        fi
      fi

      printf '{"text":"Rec","alt":"idle","class":"idle"}\n'
    '';
  };
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "group/screen-recorder" = {
            orientation = "horizontal";
            modules = [
              "custom/screen-recorder-icon"
              "custom/screen-recorder-text"
            ];
          };

          "custom/screen-recorder-icon" = {
            inherit (baseModule)
              exec
              interval
              on-click
              ;

            return-type = "json";
            format = ''<span size="150%">{icon}</span>'';
            format-icons = {
              idle = "󰑊";
              recording = "󰓛";
            };
          };

          "custom/screen-recorder-text" = {
            inherit (baseModule)
              exec
              interval
              on-click
              ;

            return-type = "json";
            format = "{text}";
          };
        };
        secondary = primary;
      };
    };
  };
}
