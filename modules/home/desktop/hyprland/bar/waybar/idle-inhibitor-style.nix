{ styles, ... }:

let
  padding_right = styles.padding_x - (styles.gaps_in + 1);
  padding_left = (styles.padding_x + 1) - styles.gaps_in;
in
''
  #idle_inhibitor {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString padding_right}px 0px ${toString padding_left}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #idle_inhibitor:hover {
    border: ${toString styles.border_size}px solid @primary;
  }

  #idle_inhibitor.activated {
    border: ${toString styles.border_size}px solid @primary;
  }
''
