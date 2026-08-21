{ styles, ... }:

let
  padding_right = styles.padding_x - (styles.gaps_in + 4);
  padding_left = (styles.padding_x + 2) - styles.gaps_in;
in
''
  #power-profiles-daemon {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString padding_right}px 0px ${toString padding_left}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #power-profiles-daemon.power-saver {
    border: ${toString styles.border_size}px solid @secondary;
  }

  #power-profiles-daemon.balanced {
    border: ${toString styles.border_size}px solid @border;
  }

  #power-profiles-daemon.performance {
    border: ${toString styles.border_size}px solid @primary;
  }

  #power-profiles-daemon:hover,
  #power-profiles-daemon.power-saver:hover,
  #power-profiles-daemon.balanced:hover {
    border: ${toString styles.border_size}px solid @primary;
  }
''
