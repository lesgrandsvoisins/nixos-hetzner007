{
  pkgs,
  lib,
  config,
  ...
}: let
  vars = import ../../vars.nix;
in {
  users.users.wiki-js = {
    isSystemUser = true;
    uid = vars.uid.wiki-js;
    group = "services";
  };
  systemd.services.wiki-js.serviceConfig.User = "wiki-js";
  systemd.services.wiki-js.serviceConfig.Group = "services";
  systemd.tmpfiles.rules = [
    "d /etc/wiki-js 0750 wiki-js services"
    "f /etc/wiki-js/.env 0640 wiki-js services"
  ];
  services.wiki-js = {
    enable = true;
    environmentFile = "/etc/wiki-js/.env";
    settings = {
      db = {
        # host = "2a01:4f8:241:4faa::10";
        port = 5434;
        # host = "localhost";
        host = "/run/postgresql/";
        # host = "/run/postgresql/";
        db = "wiki-js";
        user = "wiki-js";
        # ssl = true;
      };
      loglevel = "info";
      ssl = {
        enabled = true;
        port = 3443;
        provider = "custom";
        format = "pem";
        cert = "/var/lib/acme/wiki-js.whowhatetc.com/fullchain.pem";
        key = "/var/lib/acme/wiki-js.whowhatetc.com/key.pem";
      };
    };
  };
  services.postgresql = {
    ensureUsers = [
      {
        name = "wiki-js";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = ["wiki-js"];
  };
}
