{ styles, ... }:

''
  #submap {
    color: @fg;
    background: @bg;
    padding: ${toString styles.gaps_in}px ${toString styles.gaps_in}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;

    animation-name: submap-rise;
    animation-duration: ${toString styles.animation_ms}ms;
    animation-timing-function: ease-out;
    animation-fill-mode: forwards;
  }

  #submap:hover {
   border: ${toString styles.border_size}px solid @primary;
  }

  #submap.monitor,
  #submap.resize {
    color: @primary_fg;
    background: @primary;
  }

  @keyframes submap-rise {
    0% {
      min-width: 0;
      margin-top: -4px;
      opacity: 0;
    }

    15% {
      min-width: ${toString (styles.min_width * 0.8)}px;
      margin-top: -3px;
      opacity: 0.4;
    }

    35% {
      min-width: ${toString (styles.min_width * 1.4)}px;
      margin-top: -1px;
      opacity: 0.8;
    }

    60% {
      min-width: ${toString (styles.min_width * 2.0)}px;
      margin-top: 0;
      opacity: 1;
    }

    80% {
      min-width: ${toString (styles.min_width * 2.8)}px;
      margin-top: 0;
      opacity: 1;
    }

    100% {
      min-width: ${toString (styles.min_width * 2.5)}px;
      margin-top: 0;
      opacity: 1;
    }
  }
''
