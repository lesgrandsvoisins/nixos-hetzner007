# /etc/nixos/flake.nix
{
  inputs = {
    # self.submodules = true; # See ./vendor

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    # nixos-unified.url = "github:srid/nixos-unified";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs = {
      darwin.follows = "nix-darwin";
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    # nuenv.url = "github:hallettj/nuenv/writeShellApplication";

    # Software inputs
    # caddy-ui-whowhatetc.url = "path:./flakes/caddy-ui";
    # homarr.url = "path:./flakes/homarr";
    # flake-utils.url = "github:numtide/flake-utils";
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-25.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    agenix,
    ...
  }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      imports = (with builtins;
        map
          (fn: ./modules/flake-parts/${fn})
          (attrNames (readDir ./modules/flake-parts)));

    }
    # flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      vars = import ./vars.nix;
    in {
      nixosConfigurations = {
        whowhatetc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # system = "${system}";
          modules = [
            ./overlays.nix
            ./configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {inherit vars inputs;};
        };
      };
    });

  # flake-utils.lib.eachDefaultSystem (system:
  #  let
  #    # pkgs = import nixpkgs { inherit system; };
  #  in {
  #  }
  #) //
  # let
  #   vars = import ./vars.nix;
  # in {

  # };
}
