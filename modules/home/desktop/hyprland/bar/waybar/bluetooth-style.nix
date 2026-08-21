{ font, styles, ... }:

''
  #bluetooth {
    color: @fg;
    background: @bg;
    font-size: ${toString (font.sizes.bar + 2)}px;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString (styles.padding_x - styles.gaps_in)}px;
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
