{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  # vars = import ../vars.nix;
in {
  # imports = [
  #   (import "${home-manager}/nixos")
  # ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mannchri = {
    isNormalUser = true;
    description = "mannchri";
    extraGroups = ["networkmanager" "wheel" "acme" "caddy" "services"];
    packages = with pkgs; [];
    uid = vars.uid.mannchri;
  };

  users.users.mael = {
    isNormalUser = true;
    description = "mael";
    extraGroups = ["acme" "caddy"];
    packages = with pkgs; [];
    uid = vars.uid.mael;
  };

  # # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.homarr = {
  #   isNormalUser = true;
  #   description = "homarr";
  #   extraGroups = ["caddy" "services"];
  #   packages = with pkgs.unstable; [
  #     nodejs_25
  #     (pnpm_10.override {nodejs = nodejs_25;})
  #     pnpmConfigHook
  #     # fetchPnpmDeps
  #   ];
  #   uid = vars.uid.homarr;
  # };

  users.users.caddy = {
    uid = vars.uid.caddy;
    group = "caddy";
    isSystemUser = true;
  };
  users.users.keycloak = {
    uid = vars.uid.keycloak;
    group = "services";
    isSystemUser = true;
  };
  users.users.lldap = {
    uid = vars.uid.lldap;
    group = "services";
    isSystemUser = true;
  };
  users.users.lldap.extraGroups = ["caddy"];
  users.groups.caddy.gid = vars.gid.caddy;
  users.groups.services.gid = vars.gid.services;
  users.groups.users.gid = vars.gid.users;

  # home-manager.users.homarr = {
  #   /* The home.stateVersion option does not have a default and must be set */
  #   home.stateVersion = "25.11";
  #   /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  # };
}
