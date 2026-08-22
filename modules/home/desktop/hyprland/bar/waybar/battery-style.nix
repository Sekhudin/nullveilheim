{ styles, ... }:

''
  #battery {
    color: @fg;
    background: @bg;
    padding: 0px ${toString styles.padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #battery:hover {
  }

  #battery.charging {
    border: ${toString styles.border_size}px solid @secondary;
  }

  #battery.discharging {
    border: ${toString styles.border_size}px solid @border;
  }
''
