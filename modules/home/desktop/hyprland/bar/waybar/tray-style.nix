{ styles, ... }:

let
  app_width = (styles.min_width * 1.3) - styles.gaps_in;
  app_border_radius = styles.rounding - styles.gaps_in;
in
''
  #tray,
  #tray menu {
    color: @fg;
    background: @bg;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #tray {
    min-width: ${toString styles.min_width}px;
    padding: ${toString styles.gaps_in}px ${toString styles.gaps_in}px;
  }

  #tray widget > image {
    color: @fg;
    background: transparent;
    min-width: ${toString app_width}px;
    padding: 0px ${toString styles.gaps_in}px;
    border-radius: ${toString app_border_radius}px;
  }

  #tray widget.pasive > image {
    color: @fg;
    background: @bg;
    border: ${toString styles.border_size}px solid @bg;
    opacity: ${toString styles.opacity_mid};
  }

  #tray widget.active > image {
    color: @muted_fg;
    background: @muted;
    border: ${toString styles.border_size}px solid @border;
  }

  #tray widget.needs-attention > image {
    color: @info_fg;
    background: alpha(@info, ${toString styles.opacity_mid});
    border: ${toString styles.border_size}px solid @info;
  }

  #tray widget.active:hover > image,
  #tray widget.needs-attention:hover > image {
    background: alpha(@muted, ${toString styles.opacity_mid});
    border: ${toString styles.border_size}px solid alpha(@border, ${toString styles.opacity_low});
  }

  #tray menu {
    margin-top: 2px;
  }

  #tray menu > menuitem {
    color: @fg;
    background: transparent;
  }

  #tray menu > menuitem:hover {
    color: @muted_fg;
    background: alpha(@muted, ${toString styles.opacity_low});
  }

  #tray separator {
    background: @muted;
  }
''
