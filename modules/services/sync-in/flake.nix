{
  description = "Sync-in NixOS module + package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.${system}.sync-in = pkgs.callPackage ./package.nix {};
    packages.${system}.default = self.packages.${system}.sync-in;

    nixosModules.sync-in = import ./module.nix;

    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        self.nixosModules.sync-in
        {
          services.sync-in = {
            enable = true;
            package = self.packages.${system}.sync-in;

            admin.passwordFile = "/run/secrets/admin";
            database.passwordFile = "/run/secrets/db";
          };
        }
      ];
    };
  };
}
