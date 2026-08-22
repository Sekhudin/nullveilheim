{ styles, ... }:

let
  padding_x = styles.padding_x - styles.gaps_in;
in
''
  #submap {
    color: @fg;
    background: @bg;
    min-width: ${toString styles.min_width}px;
    padding: 0px ${toString padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #submap:hover {
   border: ${toString styles.border_size}px solid @primary;
  }

  #submap.M,
  #submap.R,
  #submap.S {
    border: ${toString styles.border_size}px solid @info;
  }
''
