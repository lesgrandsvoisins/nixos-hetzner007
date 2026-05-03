{
  description = "Zensical Nix flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }: let
    systems = ["x86_64-linux"];
    forAllSystems = f:
      nixpkgs-unstable.lib.genAttrs systems (
        system:
          f (import nixpkgs-unstable {inherit system;})
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
