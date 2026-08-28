{
  pkgs,
  actions,
  ...
}:

let
  name = actions.screenrec;

  runtimeInputs = with pkgs; [
    wf-recorder
    libnotify
  ];

  text = ''
    output_dir="''${HOME}/Videos/Recordings"
    state_file="''${XDG_RUNTIME_DIR}/wf-recorder"

    notify() {
      notify-send \
        --urgency="$1" \
        "Screen Recording" \
        "$2"
    }

    start_recording() {
      mkdir -p "$output_dir"

      output="$output_dir/record-$(date '+%Y-%m-%d_%H-%M-%S').mp4"
      tmp_state="''${state_file}.tmp"

      wf-recorder \
        -c libx264 \
        -p crf=18 \
        -p preset=medium \
        -f "$output" &
      pid="$!"

      sleep 0.1

      if ! kill -0 "$pid" 2>/dev/null; then
        wait "$pid" 2>/dev/null || true

        notify \
          critical \
          "Failed to start recording"

        return 1
      fi

      {
        printf '%s\n' "$pid"
        printf '%s\n' "$output"
      } > "$tmp_state"

      mv "$tmp_state" "$state_file"

      notify \
        normal \
        "Recording started"
    }

    stop_recording() {
      if [ ! -f "$state_file" ]; then
        start_recording
        return
      fi

      mapfile -t state < "$state_file"

      pid="''${state[0]:-}"
      output="''${state[1]:-}"

      if [ -z "$pid" ] ||
         [ -z "$output" ] ||
         ! [[ "$pid" =~ ^[0-9]+$ ]]
      then
        rm -f "$state_file"

        notify \
          critical \
          "Invalid recording state"

        return 1
      fi

      if ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$state_file"

        notify \
          critical \
          "Recording process is no longer running"

        return 1
      fi

      kill -INT "$pid"

      while kill -0 "$pid" 2>/dev/null; do
        sleep 0.1
      done

      rm -f "$state_file"

      if [ -f "$output" ]; then
        notify \
          normal \
          "Recording saved\n$output"
      else
        notify \
          critical \
          "Recording stopped, but output file was not found"
      fi
    }

    if [ -f "$state_file" ]; then
      mapfile -t state < "$state_file"
      pid="''${state[0]:-}"

      if [ -n "$pid" ] &&
         [[ "$pid" =~ ^[0-9]+$ ]] &&
         kill -0 "$pid" 2>/dev/null
      then
        stop_recording
      else
        rm -f "$state_file"
        start_recording
      fi
    else
      start_recording
    fi
  '';
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
