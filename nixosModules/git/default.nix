{
  config,
  ...
}: { home-manager.users.sbmr.programs.git.extraConfig.credential.helper = "store --file ${ config.sops.secrets."sbmr/pat".path }"; }
