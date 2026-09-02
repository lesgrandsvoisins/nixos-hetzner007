{
  description = "memos package";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.${system}.memos = pkgs.callPackage ./package.nix {inherit pkgs;};

    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.memos}/bin/memos";
    };
  };
}
