let
  activation = import ./activation.nix;
  devshell = import ./devshell.nix;
  nixvim = import ./nixvim.nix;
  sops = import ./sops.nix;
  tmux = import ./tmux.nix;
in
{
  mkExtraLib =
    { lib }:

    {
      activation = activation.mkExtraLib { };

      devshell = devshell.mkExtraLib { inherit lib; };

      nixvim = nixvim.mkExtraLib { inherit lib; };

      sops = sops.mkExtraLib { inherit lib; };

      tmux = tmux.mkExtraLib { inherit lib; };

      isStandalone = cfg: cfg == null || builtins.attrNames cfg == [ ];

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
