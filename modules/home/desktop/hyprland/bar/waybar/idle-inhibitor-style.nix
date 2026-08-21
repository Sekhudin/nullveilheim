{ styles, ... }:

''
  #idle_inhibitor {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString (styles.padding_x - styles.gaps_in)}px;
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
