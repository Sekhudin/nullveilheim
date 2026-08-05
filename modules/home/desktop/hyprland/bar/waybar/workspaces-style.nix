{ styles, ... }:

"
  #workspaces {
    color: @fg;
    background: @bg;
    padding: ${toString styles.gaps_in}px ${toString styles.gaps_in}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${toString styles.rounding}px;
  }

  #workspaces button {
    animation-duration: ${toString styles.animation_ms}ms;
    animation-timing-function: ease-out;
    animation-fill-mode: forwards;
  }

  #workspaces button.active,
  #workspaces button:not(.active),
  #workspaces button.empty,
  #workspaces button:not(.empty),
  #workspaces button.visible {
    color: @muted_fg;
    background: @muted;
    min-width: ${
      toString (styles.min_width - styles.gaps_in)
    }px;
    padding: ${toString (styles.padding_y - styles.gaps_in)}px ${
      toString (styles.padding_x - styles.gaps_in)
    }px;
    margin-left: ${toString styles.gaps_in}px;
    border: ${toString styles.border_size}px solid @border;
    border-radius: ${
      toString (styles.rounding - styles.gaps_in)
    }px;
  }

  #workspaces button.active:first-child,
  #workspaces button:not(.active):first-child,
  #workspaces button.empty:first-child,
  #workspaces button:not(.empty):first-child,
  #workspaces button.visible:first-child {
    margin-left: 0px;
  }

  #workspaces button:not(.empty):not(.active) {
    color: @primary;
    border: ${toString styles.border_size}px solid @primary;
  }

  #workspaces button.active {
    color: @primary_fg;
    background: @primary;
    border: ${toString styles.border_size}px solid @primary;
    animation-name: workspace-rise;
  }

  @keyframes workspace-rise {
    0% {
      min-width: 0;
      margin-top: -4px;
      opacity: 0;
    }
  
    15% {
      min-width: ${
        toString (styles.min_width * 0.5)
      }px;
      margin-top: -3px;
      opacity: 0.4;
    }
  
    35% {
      min-width: ${
        toString (styles.min_width * 1)
      }px;
      margin-top: -1px;
      opacity: 0.8;
    }
  
    60% {
      min-width: ${
        toString (styles.min_width * 1.8)
      }px;
      margin-top: 0;
      opacity: 1;
    }
  
    80% {
      min-width: ${
        toString (styles.min_width * 2.1)
      }px;
      margin-top: 0;
      opacity: 1;
    }
  
    100% {
      min-width: ${
        toString (styles.min_width * 2)
      }px;
      margin-top: 0;
      opacity: 1;
    }
  }
"
