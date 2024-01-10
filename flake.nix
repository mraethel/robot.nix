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
  }: {
    robotnixConfigurations.grapheneos = import ./robotnixConfigurations/grapheneos.nix { inherit robotnix; };
  } // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    packages = {
      grapheneos = self.robotnixConfigurations.grapheneos.img;
    };
  });
}
