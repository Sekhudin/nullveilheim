{ styles, ... }:

''
  #network {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString (styles.padding_x - styles.gaps_in)}px;
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
