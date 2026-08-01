{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableAshell = (cfg.bar.use == "ashell");
in
{
  config = lib.mkIf (cfg.enable && enableAshell) {
    programs = {
      ashell.settings = {
        CustomModule = [
          {
            name = "Submap";
            type = "Text";
            listen_cmd = ''
              while true; do
                mode="$(hyprctl submap)"

                if [ "$mode" = "default" ]; then
                  mode="normal"
                  alt="normal"
                else
                  alt="normal"
                fi

                printf '{"text":"%s","alt":"%s"}\n' "$mode" "$alt"
                sleep 1
              done
            '';
          }
        ];
      };
    };
  };
}
