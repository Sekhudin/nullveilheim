{
  mkExtraLib =
    { pkgs, lib }:

    {
      getHomeDir =
        {
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
