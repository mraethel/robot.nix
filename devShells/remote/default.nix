{
  pem,
  mkShell,
  openssh
}: mkShell {
  name = "ssh-otc";
  packages = [ openssh ];
  shellHook = "ssh -i ${ pem.path } linux@164.30.24.90; exit";
}
