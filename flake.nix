{
  inputs = {
#   robotnix.url = "github:mraethel/robotnix";
    robotnix.url = "git+file:/home/sbmr/robotnix";

    sops.url = "github:Mic92/sops-nix";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: rec {
    robotnixModules.grapheneos = import robotnixModules/grapheneos { inherit (inputs) robotnix; };
#   robotnixConfigurations.grapheneos = inputs.robotnix.robotnixConfigurations.base.extendModules {
#     modules = [ robotnixModules.grapheneos ];
#   };
    robotnixConfigurations.grapheneos = robotnixModules.grapheneos;
    nixosModules = {
#     git = import nixosModules/git;
      sbmr = import nixosModules/sbmr;
#     sops = import nixosModules/sops;
    };
    nixosConfigurations.sbmr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = (with nixosModules; [
        sbmr
#       sops
      ]) ++ (with inputs.sops.nixosModules; [
        sops
      ]);
    };
  } // flake-utils.lib.eachDefaultSystem (system: let
    inherit (pkgs) callPackage;
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.grapheneos = self.robotnixConfigurations.grapheneos.img;
    devShells.remote = callPackage devShells/remote { pem = self.nixosConfigurations.sbmr.config.sops.secrets."sbmr/pem"; };
  });

  nixConfig = {
    builders = "ssh://linux@164.30.24.90 x86_64-linux /run/secrets/sbmr/pem 32 1 - - -";
    builders-use-substitutes = true;
    extra-substituters = [ "ssh://linux@164.30.24.90?ssh-key=/run/secrets/sbmr/pem" ];
    extra-trusted-public-keys = [ "cache@sbmr:O4oHBIJmgxgDRtc3+qunGSZ1LSKGgMoLlGP+AnRMrxo=" ];
  };
}
