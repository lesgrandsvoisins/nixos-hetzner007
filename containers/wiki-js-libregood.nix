{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  # vars = import ../vars.nix;
in
{
  networking.hosts = {
    "10.0.12.102" = [ "wiki-js-libregood.local" ];
    # "fa12::102" = [ "wiki-js-libregood.local" ];
  };
  # networking.macvlans = {
  #   vlan-wiki = {
  #     interface = "enp0s31f6";

  #   };
  # };
  # networking.bridges = {
  #   br-wiki-js-lg = {
  #     interfaces = [
  #       "enp0s31f6"
  #     ];
  #     ipv4.adresses = [
  #       {
  #         address = "10.10.10.11";
  #         prefixLength = 24;
  #       }
  #     ];
  #   };
  # };

  systemd.tmpfiles.rules = [
    "d /etc/wiki-js-libregood/ 0755 wiki-js services"
    "d /etc/wiki-js-libregood/certs/ 0755 wiki-js services"
    "d /etc/wiki-js-libregood/certs/postgresql/ 0755 postgres services"
    # "d /etc/wiki-js-libregood/certs/ 0755 wiki-js services"
  ];
  users.users.postgres.extraGroups = [ "services" ];
  containers.wiki-js-libregood = {
    localAddress = "10.0.12.102";
    localAddress6 = "fa12::102";
    hostAddress = "10.0.12.1";
    hostAddress6 = "fa12::1";
    # privateNetwork = true; # ve-wiki-js-libregood
    # hostBridge = "br0";
    # forwardPorts = [
    #   {
    #     containerPort = vars.ports.wiki-js-libregood-https;
    #     hostPort = vars.ports.wiki-js-libregood-https;
    #     protocol = "tcp";
    #   }
    #   {
    #     containerPort = vars.ports.wiki-js-libregood-http;
    #     hostPort = vars.ports.wiki-js-libregood-http;
    #     protocol = "tcp";
    #   }
    # ];
    bindMounts = {
      "/etc/wiki-js-libregood/" = {
        hostPath = "/etc/wiki-js-libregood/";
        isReadOnly = true;
      };
    };
    autoStart = true;
    config = {
      system.stateVersion = "25.11";

      networking.hosts = {
        "10.0.12.102" = [ "wiki-js-libregood.local" ];
        # "fa12::102" = [ "wiki-js-libregood.local" ];
      };
      # networking.interfaces."enp0s31f6".ipv6.routes = [
      #   {
      #     address = "fe80::4438:1aff:fea3:c2fd";
      #     prefixLength = 64;
      #     via = "fa12::1";{
      #   }
      # ];

      environment.systemPackages = with pkgs; [
        net-tools
        lynx
      ];

      users.users.wiki-js = {
        isSystemUser = true;
        uid = vars.uid.wiki-js;
        group = "services";
      };
      users.groups.services.gid = vars.gid.services;

      systemd.services.wiki-js.serviceConfig.User = "wiki-js";
      systemd.services.wiki-js.serviceConfig.Group = "services";
      systemd.tmpfiles.rules = [
        "d /etc/wiki-js-libregood 0750 wiki-js services"
        "f /etc/wiki-js-libregood/.env 0640 wiki-js services"
        # "L /run/postgresql/.s.PGSQL.5432 /run/postgresql/.s.PGSQL.5434" # Strange fix
      ];
      services.cron.systemCronJobs = [ "0 0 1 * *  root systemctl restart wiki-js" ];

      systemd.services."postgresql".serviceConfig.EnvironmentFile = "/etc/wiki-js-libregood/.env";

      services.wiki-js = {
        enable = true;
        environmentFile = "/etc/wiki-js-libregood/.env";
        settings = {
          port = vars.ports.wiki-js-libregood-http;
          # bindIP = "fe80::94f6:edff:fe4f:9624";
          bindIP = "127.0.0.1";
          # bindIP = "10.0.12.102";
          db = {
            # host = "2a01:4f8:241:4faa::10";
            # port = vars.ports.postgresql;
            # host = "localhost";
            # port = 5432;
            # host = "wiki-js-libregood.local";
            host = "/run/postgresql";
            # host = "127.0.0.1";
            # host = "/run/postgresql/";
            # db = "wiki-js-libregood";
            db = "wiki-js";
            user = "wiki-js";
            # ssl = true;
            # sslOptions = {
            #   auto = false;
            #   cert = "/etc/wiki-js-libregood/certs/postgresql/wiki-js-libregood.local.pem";
            # };
          };
          loglevel = "info";
          ssl = {
            enabled = true;
            port = vars.ports.wiki-js-libregood-https;
            provider = "custom";
            format = "pem";
            cert = "/etc/wiki-js-libregood/certs/wiki-js-libregood.local.pem";
            key = "/etc/wiki-js-libregood/certs/wiki-js-libregood.local-key.pem";
            passphrase = null;
            dhparam = null;
          };
        };
      };
      services.postgresql = {
        enable = true;
        # enableTCPIP = true;
        # initialScript = pkgs.writeText "init-sql-script" ''
        #   GRANT ALL PRIVILEGES ON SCHEMA public to "wiki-js";
        #   GRANT ALL PRIVILEGES ON DATABASE "wiki-js-libregood" to "wiki-js";
        #   ALTER ROLE "wiki-js" WITH ENCRYPTED PASSWORD '@DB_PASS@';
        # '';
        # settings = {
        #   listen_addresses = lib.mkForce "wiki-js-libregood.local" ;
        #   # ssl = true;
        #   # ssl_cert_file = "/etc/wiki-js-libregood/certs/postgresql/wiki-js-libregood.local.pem";
        #   # ssl_key_file = "/etc/wiki-js-libregood/certs/postgresql/wiki-js-libregood.local-key.pem";
        # };
        ensureUsers = [
          {
            name = "wiki-js";
            ensureDBOwnership = true;
            # ensureClauses.login = true;
          }
        ];
        ensureDatabases = [
          "wiki-js-libregood"
          "wiki-js"
        ];
      };
    };
  };
}
