# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    caddy-ui-whowhatetc.url = "path:./flakes/caddy-ui";
    agenix.url = "github:ryantm/agenix";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, agenix, caddy-ui-whowhatetc, ... }@inputs: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
      }
    ) // {
      nixosConfigurations = {
        whowhatetc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [   
            ./configuration.nix
            agenix.nixosModules.default
          ];
          specialArgs = { inherit caddy-ui-whowhatetc; };
        };
      };
    };
}
