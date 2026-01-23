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
    "::1" = [ "radicale.local" ];
    "127.0.0.1" = [ "radicale.local" ];
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
        hosts = [ "127.0.0.1:${builtins.toString vars.ports.radicale}" "[::1]:${builtins.toString vars.ports.radicale}" ];
        ssl = true;
        certificate = "/etc/radicale/certs/radicale.local.pem";
        key = "/etc/radicale/certs/radicale.local-key.pem";
      };
      auth = {
        type = "remote_user";
        htpasswd_filename = "/etc/radicale/users";
        htpasswd_encryption = "autodetect";
      };
      # storage = {
      #   filesystem_folder = "/var/lib/radicale/collections";
      # };
    };
  };
}