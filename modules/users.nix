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
    # group = "caddy";
    # group = "services";
    isSystemUser = true;
    extraGroups = ["services"];
  };
  users.users.keycloak = {
    uid = vars.uid.keycloak;
    group = "services";
    isSystemUser = true;
    extraGroups = ["caddy"];
  };
  users.users.lldap = {
    uid = vars.uid.lldap;
    group = "services";
    isSystemUser = true;
    extraGroups = ["caddy"];
  };
  users.groups.caddy.gid = vars.gid.caddy;
  users.groups.services.gid = vars.gid.services;
  users.groups.users.gid = vars.gid.users;

  # home-manager.users.homarr = {
  #   /* The home.stateVersion option does not have a default and must be set */
  #   home.stateVersion = "25.11";
  #   /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  # };
  users = {
    # groups.sftpgo = {
    #   gid = 979;
    # };
    # groups.services = {
    #   gid = vars.gid.services;
    # };
    groups = {
      aaa.gid = vars.gid.aaa;
      appflowycloud.gid = vars.gid.appflowycloud;
      haproxy.gid = vars.gid.haproxy;
      filebrowser.gid = vars.gid.filebrowser;
      crabfit.gid = vars.gid.crabfit;
      fossil.gid = vars.gid.fossil;
      wagtail.gid = vars.gid.wagtail;
      python.gid = vars.gid.python;
      wwwrun.gid = vars.gid.wwwrun;
      mailserver = {
        gid = vars.gid.mailserver;
        members = ["dovecot2" "postfix" "openldap"];
      };
    };
    users = {
      appflowycloud = {
        isNormalUser = true;
        uid = vars.uid.appflowycloud;
      };
      filebrowser = {
        isNormalUser = true;
        group = "wwwrun";
        uid = vars.uid.filebrowser;
      };
      # sftpgo = {
      #   isSystemUser = true;
      #   extraGroups = ["wwwrun" "acme"];
      #   # group = lib.mkDefault  "wwwrun";
      #   # group = "sftpgo";
      #   # uid = 1020;
      #   # uid = vars.uid.sftpgo;
      # };
      haproxy = {
        extraGroups = ["wwwrun" "acme"];
        uid = vars.uid.haproxy;
        group = "services";
        isSystemUser = true;
      };
      # mannchri = {
      #   #   isNormalUser = true;
      #   #   openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
      #   #   extraGroups = ["wheel" "syncthing" "libvirtd" "wwwrun" "acme" "nginx-sso"];
      #   #   uid = vars.uid.mannchri;
      # };
      crabfit = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
        group = "services";
        extraGroups = ["docker"];
        uid = vars.uid.crabfit;
      };
      fossil = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
        group = "services";
        uid = vars.uid.fossil;
      };
      wagtail = {
        isNormalUser = true;
        group = "services";
        uid = vars.uid.wagtail;
      };
      python = {
        isNormalUser = true;
        group = "services";
        uid = vars.uid.python;
      };
      # radicale = {
      #   isNormalUser = true;
      #   openssh.authorizedKeys.keys = [ vars.keys.public.mannchri ];
      # };
    };
  };
}
