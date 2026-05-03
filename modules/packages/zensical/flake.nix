{
  description = "Zensical Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f (import nixpkgs {inherit system;})
      );
  in {
    packages = forAllSystems (pkgs: {
      zensical = pkgs.callPackage ./package.nix {};
    });

    nixosModules.zensical = import ./module.nix;

    # optional default
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.zensical;
  };
}
