{ styles, ... }:

let
  padding_right = styles.padding_x - (styles.gaps_in + 2);
  padding_left = styles.padding_x - styles.gaps_in;
in
''
  #network {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString padding_right}px 0px ${toString padding_left}px;
    border: ${toString styles.border_size}px solid @primary;
    border-radius: ${toString styles.rounding}px;
  }

  #network:hover {
    border: ${toString styles.border_size}px solid @primary;
  }

  #network.disabled {
    border: ${toString styles.border_size}px solid @border;
  }
''
