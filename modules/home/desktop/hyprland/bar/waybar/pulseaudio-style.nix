{ styles, ... }:

let
  padding_right = styles.padding_x - styles.gaps_in;
  padding_left = styles.padding_x - (styles.gaps_in + 1);
in
''
  #pulseaudio {
    color: @fg;
    background: @bg;
    min-width: ${toString (styles.min_width)}px;
    padding: 0px ${toString padding_right}px 0px ${toString padding_left}px;
    border: ${toString styles.border_size}px solid @primary;
    border-radius: ${toString styles.rounding}px;
  }

  #pulseaudio:hover {
    border: ${toString styles.border_size}px solid @primary;
  }

  #pulseaudio.muted {
    border: ${toString styles.border_size}px solid @border;
  }
''
