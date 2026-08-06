{ styles, ... }:

''
  #network {
    color: @fg;
    background: @bg;
    min-width: ${toString (styles.min_width * 4)}px;
    padding: ${toString styles.padding_y}px ${toString styles.padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #network:hover {
    border: ${toString styles.border_size}px solid @primary;
  }
''
