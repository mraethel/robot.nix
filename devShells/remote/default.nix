{
  config,
  mkShell
}: mkShell {
  name = "Open Telekom Cloud";
  shellHook = "ssh -i ${ config.sops.secrets.pem.path } linux@164.30.24.90; exit";
}
