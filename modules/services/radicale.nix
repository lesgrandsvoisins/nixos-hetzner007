{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/radicale 0755 radicale services"
    "d /etc/radicale/certs 0755 radicale services"
  ];
  networking.hosts = {
    "fa01::2" = [ "keycloak.local" ];
  };
  users.users.radicale = {
    extraGroups = ["services"];
    uid = vars.uid.radicale;
  };
  users.groups.radicale.gid = vars.gid.radicale;
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "0.0.0.0:5232" "[::]:5232" ];
        ssl = true;
        certificate = "";
        key = "";
      };
      auth = {
        type = "http_x_remote_user";
      };
      # storage = {
      #   filesystem_folder = "/var/lib/radicale/collections";
      # };
    };
  };
}