# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    oxicloud.url = "path:./modules/services/oxicloud";
    sync-in.url = "path:./modules/services/sync-in";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # caddy-ui-grandsvoisins.url = "path:./flakes/caddy-ui";
    # homarr.url = "path:./flakes/homarr";
    agenix.url = "github:ryantm/agenix";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    agenix,
    oxicloud,
    sync-in,
    ...
  } @ inputs:
  # flake-utils.lib.eachDefaultSystem (system:
  #  let
  #    # pkgs = import nixpkgs { inherit system; };
  #  in {
  #  }
  #) //
  let
    vars = import ./vars.nix;
    secrets = import ./secrets.nix;
  in {
    nixosConfigurations = {
      hetzner007 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./overlays.nix
          ./configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          oxicloud.nixosModules.oxicloud
          sync-in.nixosModules.sync-in
        ];
        specialArgs = {inherit vars secrets inputs oxicloud sync-in;};
      };
    };
  };
}
