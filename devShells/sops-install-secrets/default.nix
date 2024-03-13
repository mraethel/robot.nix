{
  sops-nix-manifest,
  sops-install-secrets,
  mkShell
}: mkShell {
  name = "sops-setup";
  packages = [ sops-install-secrets ];
  shellHook = "sops-install-secrets ${ sops-nix-manifest }; exit";
}
