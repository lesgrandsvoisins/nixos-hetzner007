{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # vars = import ../vars.nix;
in {
  networking.hosts = {
    "10.0.12.102" = [ "wiki-js-libregood.local" ];
    "fa12::102" = [ "wiki-js-libregood.local" ];
  };
  systemd.tmpfiles.rules = [
    "d /etc/wiki-js-libregood/ 0755 wiki-js services"
    # "d /etc/wiki-js-libregood/certs/ 0755 wiki-js services"
  ];
  containers.wiki-js-libregood = {
    localAddress = "10.0.12.102";
    localAddress6 = "fa12::102";
    hostAddress = "10.0.12.1";
    hostAddress6 = "fa12::1";
    privateNetwork = true; # ve-wiki-js-libregood
    forwardPorts = [
      {
        containerPort = vars.ports.wiki-js-libregood-https;
        hostPort = vars.ports.wiki-js-libregood-https;
        protocol = "tcp";
      }
    ];

    bindMounts = {
      "/etc/wiki-js-libregood/" = {
        hostPath = "/etc/wiki-js-libregood/";
        isReadOnly = true;
      };
    };
    autoStart = true;
    config = {
      system.stateVersion = "25.11";

  users.users.wiki-js = {
    isSystemUser = true;
    uid = vars.uid.wiki-js;
    group = "services";
  };
  users.groups.services.gid = vars.gid.services;

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
      port = vars.ports.wiki-js-libregood-http;
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
        port = vars.ports.wiki-js-libregood-https;
        provider = "custom";
        format = "pem";
        cert = "/etc/wiki-js-libregood/wiki-js-libregood.local.pem";
        key = "/etc/wiki-js-libregood/wiki-js-libregood.local-key.pem";
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
    };
  };
}
