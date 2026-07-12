let
  devshell = import ./devshell.nix;
  tmux = import ./tmux.nix;
in
{
  mkExtraLib =
    { lib }:

    let
      isStandalone = osConfig: osConfig == null;
    in
    {
      inherit isStandalone;

      devshell = devshell.mkExtraLib { inherit lib; };

      tmux = tmux.mkExtraLib { inherit lib; };

      getHomeDir =
        {
          pkgs,
          username,
          osConfig ? { },
        }:
        let
          nixosHome = lib.attrByPath [ "users" "users" username "home" ] null osConfig;
          defaultHome = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
        in
        if nixosHome != null then nixosHome else defaultHome;
    };
}
