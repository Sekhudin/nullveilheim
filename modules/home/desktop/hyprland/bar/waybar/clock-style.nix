{ styles, ... }:

''
  #clock {
    color: @fg;
    background: @bg;
    padding: ${toString styles.padding_y}px ${toString styles.padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #clock:hover {
    border: ${toString styles.border_size}px solid @primary;
  }
''
