{ styles, ... }:

let
  padding_x = styles.padding_x - styles.gaps_in;
in
''
  #clock {
    color: @fg;
    background: @bg;
    padding: 0px ${toString padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #clock:hover {
  }
''
