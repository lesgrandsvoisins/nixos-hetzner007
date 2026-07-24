{
  description = "OxiCloud Nix flake with module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
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
    packages = forAllSystems (pkgs: rec {
      # {
      oxicloud = pkgs.callPackage ./package.nix {};
      default = oxicloud;
    });

    nixosModules.oxicloud = import ./module.nix;

    # # optional default
    # defaultPackage.x86_64-linux = self.packages.x86_64-linux.oxicloud;
  };
}
