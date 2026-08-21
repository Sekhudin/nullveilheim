{ styles, ... }:

let
  padding_x = styles.padding_x - styles.gaps_in;
in
''
  #bluetooth {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #bluetooth:hover {
    border: ${toString styles.border_size}px solid @primary;
  }

  #bluetooth.on {
    border: ${toString styles.border_size}px solid @primary;
  }

  #bluetooth.off {
    border: ${toString styles.border_size}px solid @border;
  }
''
