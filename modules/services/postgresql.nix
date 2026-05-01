# postgres.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
  };
  services.postgresql = {
    # package = pkgs.postgresql_18;
    enable = true;
    enableTCPIP = true;
    settings = {
      ssl = true;
      ssl_cert_file = "/etc/postgres/postgres.crt";
      ssl_key_file = "/etc/postgres/postgres.key";
      port = vars.ports.postgresql;
    };
    ensureUsers = [
      {
        name = "vikunja";
        ensureDBOwnership = true;
      }
      {
        name = "keygvje";
        ensureDBOwnership = true;
      }
      {
        name = "sftpgo";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoisinscom";
        ensureDBOwnership = true;
      }
      {
        name = "wagtail";
        ensureDBOwnership = true;
        # ensurePermissions = {
        #   "DATABASE \"wagtail\"" = "ALL PRIVILEGES";
        #   "DATABASE \"previous\"" = "ALL PRIVILEGES";
        #   "DATABASE \"fairemain\"" = "ALL PRIVILEGES";
        #   "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        # };
      }
      {
        name = "key";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailgvcoop";
        ensureDBOwnership = true;
      }
      {
        name = "sftpgo";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoisins";
        ensureDBOwnership = true;
      }
      {
        name = "resdigitaorg";
        ensureDBOwnership = true;
      }
      {
        name = "cantine";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailvillage";
        ensureDBOwnership = true;
      }
      {
        name = "village";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoinsinsfacile";
        ensureDBOwnership = true;
      }
      {
        name = "resdigitafastoche";
        ensureDBOwnership = true;
      }
      {
        name = "wwwfastoche";
        ensureDBOwnership = true;
      }
      {
        name = "francemalifacile";
        ensureDBOwnership = true;
      }
      {
        name = "crabfit";
        ensureDBOwnership = true;
      }
      {
        name = "wwwcfran";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailcfran";
        ensureDBOwnership = true;
      }
      {
        name = "djangocfran";
        ensureDBOwnership = true;
      }
      {
        name = "ffdncoin";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "keygvje"
      "sftpgo"
      "vikunja"
      "cantine"
      "crabfit"
      "djangocfran"
      "fairemain"
      "ffdncoin"
      "francemalifacile"
      "key"
      "lesgrandsvoinsinsfacile"
      "lesgrandsvoisins"
      "lesgrandsvoisinscom"
      "previous"
      "resdigitafastoche"
      "resdigitaorg"
      "sftpgo"
      "village"
      "wagtail"
      "wagtailcfran"
      "wagtailgvcoop"
      "wagtailvillage"
      "wwwcfran"
      "wwwfastoche"
      "coopgv" # h5
      "desgv" # h5
      "gdvox" # h5
      "keycloak" # h5
      "lesgrandsvoisins20241026" # h5
      "lesgv" # h5
      "mydb" # h5
      "odoo" # h5
      "odoofor" # h5
      "odoothree" # h5
      "odootoo" # h5
      "resdigita" # h5
      "roundcube" # h5
      "sogo" # h5
      "villagengo" # h5
      "wagtailfastoche" # h5
      "gitea" # h7
      "homarr" # h7
      "immich" # h7
      "lemmy" # h7
      "memos" # h7
      "memos2" # h7
      "memos3" # h7
      "miniflux" # h7
      "oxicloud" # h7
      "vaultwarden" # h7
      "vikunja" # h7
      "wiki-js" # h7
    ];
  };
}
