{
  imports = [ ./sops ];

  users.users.sbmr = {
    isNormalUser = true;
    extraGroups = [ "keys" ];
  };
}
