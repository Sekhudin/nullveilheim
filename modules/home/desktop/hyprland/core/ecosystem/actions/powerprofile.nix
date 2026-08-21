{
  pkgs,
  actions,
  ...
}:

let
  name = actions.powerprofile;

  runtimeInputs = [ ];

  text = ''
    current=$(powerprofilesctl get)

    case "$current" in
      power-saver)
        powerprofilesctl set balanced
        ;;
      balanced)
        powerprofilesctl set performance
        ;;
      performance)
        powerprofilesctl set power-saver
        ;;
      *)
        echo "Unknown power profile: $current" >&2
        exit 1
        ;;
    esac
  '';
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
