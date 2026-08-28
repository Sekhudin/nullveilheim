{ styles, ... }:

let
  width = (styles.min_width + 2) - styles.gaps_in;
  border_radius = styles.rounding - styles.gaps_in;
in
''
  #screen-recorder {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: ${toString styles.gaps_in}px ${toString styles.gaps_in}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #screen-recorder:hover {
  }

  #custom-screen-recorder-icon {
    min-width: ${toString width}px;
    margin-right: ${toString styles.gaps_in}px;
    padding: 0px ${toString (styles.gaps_in * 1.0)}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString border_radius}px;
  }

  #custom-screen-recorder-icon.idle {
    color: @muted_fg;
    background: @muted;
  }

  #custom-screen-recorder-icon.recording {
    color: @primary_fg;
    background: alpha(@primary, ${toString styles.opacity_mid});
    border: ${toString styles.border_size}px solid @primary;
  }

  #custom-screen-recorder-text {
    margin-right: ${toString styles.gaps_in}px;
  }
''
