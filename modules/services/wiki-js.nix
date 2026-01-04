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
    # "L /run/postgresql/.s.PGSQL.5434 /run/postgresql/.s.PGSQL.5432"
  ];
  services.cron.systemCronJobs = ["0 0 1 * *  root systemctl restart wiki-js"];

  services.wiki-js = {
    enable = true;
    environmentFile = "/etc/wiki-js/.env";
    settings = {
      port = vars.ports.wiki-js-http;
      bindIP = vars.ips.wiki-js;
      db = {
        # host = "2a01:4f8:241:4faa::10";
        port = vars.ports.postgresql;
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
        port = vars.ports.wiki-js-https;
        provider = "custom";
        format = "pem";
        cert = "/var/lib/acme/whowhatetc.com/fullchain.pem";
        key = "/var/lib/acme/whowhatetc.com/key.pem";
        passphrase = null;
        dhparam = null;
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
