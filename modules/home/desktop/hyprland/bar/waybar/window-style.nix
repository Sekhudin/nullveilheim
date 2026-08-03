{ styles, ... }:

''
  #window {
    color: @fg;
    background-color: @bg;
    min-width: ${toString styles.min_width}px;
    padding: ${toString styles.padding_y}px ${toString styles.padding_x}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: 999px;

    animation-name: window-rise;
    animation-duration: 300ms;
    animation-timing-function: ease-in-out;
    animation-fill-mode: forwards;
  }

  window#waybar.empty #window {
    padding: 0;
    border-width: 0;
    animation-name: window-hide;
  }

  #window:hover {
    border: ${toString styles.border_size}px solid @active_border;
  }

  @keyframes window-rise {
    0% {
      min-width: 0;
      margin-top: -8px;
      opacity: 0;
    }

    10% {
      min-width: ${toString styles.min_width}px;
      margin-top: -6px;
      opacity: 0.3;
    }

    25% {
      min-width: ${toString (styles.min_width * 3)}px;
      margin-top: -3px;
      opacity: 0.7;
    }

    45% {
      min-width: ${toString (styles.min_width * 6)}px;
      margin-top: -1px;
      opacity: 0.9;
    }

    70% {
      min-width: ${toString (styles.min_width * 10)}px;
      margin-top: 0;
      opacity: 1;
    }

    100% {
      min-width: ${toString (styles.min_width * 12)}px;
      margin-top: 0;
      opacity: 1;
    }
  }

  @keyframes window-hide {
    0% {
      min-width: ${toString (styles.min_width * 12)}px;
      margin-top: 0;
      opacity: 1;
    }

    30% {
      min-width: ${toString (styles.min_width * 10)}px;
      margin-top: 0;
      opacity: 1;
    }

    55% {
      min-width: ${toString (styles.min_width * 6)}px;
      margin-top: -1px;
      opacity: 0.9;
    }

    75% {
      min-width: ${toString (styles.min_width * 3)}px;
      margin-top: -3px;
      opacity: 0.7;
    }

    90% {
      min-width: ${toString styles.min_width}px;
      margin-top: -6px;
      opacity: 0.3;
    }

    100% {
      min-width: 0;
      margin-top: -8px;
      opacity: 0;
    }
  }
''
