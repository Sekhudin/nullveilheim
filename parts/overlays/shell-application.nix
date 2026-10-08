{ ... }:

{
  flake.overlays.shellApplication = final: _: {
    shellApplication = {
      copy = final.writeShellApplication {
        name = "copy";
        runtimeInputs = with final; [
          wl-clipboard
          xsel
        ];
        text = ''
          if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            exec wl-copy "$@"
          fi

          if [ -n "''${DISPLAY:-}" ]; then
            exec xsel -ib "$@"
          fi

          echo "No supported clipboard backend found." >&2
          exit 1
        '';
      };

      paste = final.writeShellApplication {
        name = "paste";
        runtimeInputs = with final; [
          wl-clipboard
          xsel
        ];
        text = ''
          if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            exec wl-paste "$@"
          fi

          if [ -n "''${DISPLAY:-}" ]; then
            exec xsel -ob "$@"
          fi

          echo "No supported clipboard backend found." >&2
          exit 1
        '';
      };

      fuck-systemctl = final.writeShellApplication {
        name = "fuck-systemctl";
        runtimeInputs = [ final.sysz ];
        text = "sysz";
      };
    };
  };
}
