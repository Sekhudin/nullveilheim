{ styles, ... }:

''
  #battery {
    color: @fg;
    background: @bg;
    padding: ${toString styles.padding_y}px ${toString styles.padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #battery:hover {
    border: ${toString styles.border_size}px solid @primary;
  }

  #battery.charging {
    border: ${toString styles.border_size}px solid @primary;
  }

  #battery.discharging {
    border: ${toString styles.border_size}px solid @border;
  }
''
