{
  inputs = {
#   robotnix.url = "github:mraethel/robotnix";
    robotnix.url = "git+file:/home/sbmr/robotnix";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = {
    self,
    robotnix,
    nixpkgs,
    flake-utils,
    ...
  }: rec {
    robotnixModules.grapheneos = import robotnixModules/grapheneos { inherit robotnix; };
    robotnixConfigurations.grapheneos = robotnix.robotnixConfigurations.base.extendModules {
      modules = [ robotnixModules.grapheneos ];
    };
#   robotnixConfigurations.grapheneos = import robotnixModules/grapheneos { inherit robotnix; };
  } // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.grapheneos = self.robotnixConfigurations.grapheneos.img;
    devShells.remote = pkgs.callPackage devShells/remote { };
  });

  nixConfig = {
    builders = "ssh://linux@164.30.24.90 x86_64-linux /run/secrets/sbmr 32 1 - - -";
#   builders = "ssh://linux@164.30.24.90 x86_64-linux ${ config.sops.secrets.pem.path } 32 1 - - -";
    builders-use-substitutes = true;
    extra-substituters = [ "ssh://linux@164.30.24.90?ssh-key=/run/secrets/sbmr" ];
#   extra-substituters = [ "ssh://linux@164.30.24.90?ssh-key=${ config.sops.secrets.pem.path }" ];
    extra-trusted-public-keys = [ "cache@sbmr:O4oHBIJmgxgDRtc3+qunGSZ1LSKGgMoLlGP+AnRMrxo=" ];
  };
}
