{
  config,
  ...
}: let
  sshKey = rec {
    path = "/etc/ssh/ssh_${ name }_${ type }_key";
    type = "ed25519";
  };
  name = config.users.users.sbmr.name;
in {
  sops = {
    age.sshKeyPaths = [ sshKey.path ];
    secrets."${ name }/pem" = {
      sopsFile = ../../secrets/secrets.yaml;
      owner = name;
    };
    secrets."${ name }/pat" = {
      sopsFile = ../../secrets/secrets.yaml;
      owner = name;
    };
  };
  services.openssh.hostKeys = [{ inherit (sshKey) path type; }];
}
