{
  description = "Sync-in NixOS package + module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        sync-in = import ./package.nix {inherit pkgs;};
      in {
        packages.sync-in = sync-in;

        packages.default = sync-in;
      }
    )
    // {
      nixosModules.sync-in = import ./module.nix;
    };
}
