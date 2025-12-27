
{ config, pkgs, ... }:
let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
in
{
  # imports = [
  #   (import "${home-manager}/nixos")
  # ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mannchri = {
    isNormalUser = true;
    description = "mannchri";
    extraGroups = [ "networkmanager" "wheel" "acme" "caddy" ];
    packages = with pkgs; [];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.homarr = {
    isNormalUser = true;
    description = "homarr";
    extraGroups = [ "caddy" ];
    packages = with pkgs.unstable; [
      nodejs_25
      (pnpm_10.override { nodejs = nodejs_25; })
      pnpmConfigHook
      fetchPnpmDeps
      stdenv
    ];
  };

  # home-manager.users.homarr = {
  #   /* The home.stateVersion option does not have a default and must be set */
  #   home.stateVersion = "25.11";
  #   /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  # };

}