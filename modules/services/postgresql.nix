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
    ];
  };
}
