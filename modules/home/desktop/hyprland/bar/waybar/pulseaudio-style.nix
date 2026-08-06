{ styles, ... }:

''
  #pulseaudio {
    color: @fg;
    background: @bg;
    min-width: ${toString (styles.min_width)}px;
    padding: ${toString styles.padding_y}px ${toString (styles.padding_x - styles.gaps_in)}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #pulseaudio:hover {
    border: ${toString styles.border_size}px solid @primary;
  }

''
