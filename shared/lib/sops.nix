{
  mkExtraLib =
    { lib }:

    let
      mkSecretAttrs =
        { path, fields }:

        let
          mkName = a: builtins.replaceStrings [ "." "/" ] [ "_" "_" ] a;
          mkKey = a: builtins.replaceStrings [ "." ] [ "/" ] a;

          namePrefix = mkName path;
          keyPrefix = mkKey path;
        in
        builtins.listToAttrs (
          map (fd: {
            name = "${namePrefix}_${mkName fd}";
            value = {
              key = "${keyPrefix}/${mkKey fd}";
            };
          }) fields
        );
    in
    {
      inherit mkSecretAttrs;

      mkGPGKeySecrets =
        profiles:

        lib.mkMerge (
          map (
            profile:
            mkSecretAttrs {
              path = "gpg_keys.${profile}";
              fields = [
                "email"
                "private_key"
                "owner_trust"
              ];
            }
          ) profiles
        );

      mkSSHKeySecrets =
        profiles:

        lib.mkMerge (
          map (
            profile:
            mkSecretAttrs {
              path = "ssh_keys.${profile}";
              fields = [
                "path"
                "private_key"
              ];
            }
          ) profiles
        );

      mkGitIdentitySecrets =
        profiles:

        lib.mkMerge (
          map (
            profile:
            mkSecretAttrs {
              path = "git_identities.${profile}";
              fields = [
                "name"
                "email"
                "signing_key"
                "ssh_key"
                "gitdirs/w1"
                "gitdirs/w2"
                "gitdirs/w3"
              ];
            }
          ) profiles
        );
    };
}
