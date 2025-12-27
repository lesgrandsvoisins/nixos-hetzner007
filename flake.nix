# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    caddy-ui-whowhatetc.url = "path:./flakes/caddy-ui";
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
    caddy-ui-whowhatetc, 
    ... 
    }@inputs: 
    # flake-utils.lib.eachDefaultSystem (system:
    #  let
    #    # pkgs = import nixpkgs { inherit system; };
    #  in {
    #  }
    #) // 
    {
      nixosConfigurations = {
        whowhatetc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [   
            ./overlays.nix
            ./configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
