{ styles, font, ... }:

''
  #custom-nixosicon {
    color: @fg;
    background: @bg;
    font-size: ${toString (font.sizes.bar + 4)}px;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString (styles.padding_x - styles.gaps_in)}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #custom-nixosicon:hover {
    border: ${toString styles.border_size}px solid @primary;
  }
''
