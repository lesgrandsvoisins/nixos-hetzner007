{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ../vars.nix;
in {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    ensureDatabases = [
      "cantine"
      "coopgv"
      "crabfit"
      "desgv"
      "fairemain"
      "francemalifacile"
      "gdvox"
      "key"
      "keycloak"
      "lesgrandsvoinsinsfacile"
      "lesgrandsvoisins"
      "lesgrandsvoisins20241026"
      "lesgrandsvoisinscom"
      "lesgrandsvoisinsfacile"
      "lesgv"
      "mydb"
      "oxicloud"
      "postgres"
      "previous"
      "resdigita"
      "resdigitafastoche"
      "resdigitaorg"
      "roundcube"
      "sftpgo"
      "sogo"
      "village"
      "villagengo"
      "wagtail"
      "wagtailcfran"
      "wagtailfastoche"
      "wagtailgvcoop"
      "wagtailvillage"
      "wwwcfran"
      "wwwfastoche"
    ];
    ensureUsers = [
      {
        name = "cantine";
        ensureDBOwnership = true;
      }
      {
        name = "coopgv";
        ensureDBOwnership = true;
      }
      {
        name = "crabfit";
        ensureDBOwnership = true;
      }
      {
        name = "desgv";
        ensureDBOwnership = true;
      }
      {
        name = "fairemain";
        ensureDBOwnership = true;
      }
      {
        name = "francemalifacile";
        ensureDBOwnership = true;
      }
      {
        name = "gdvox";
        ensureDBOwnership = true;
      }
      {
        name = "key";
        ensureDBOwnership = true;
      }
      {
        name = "keycloak";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoinsinsfacile";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoisins";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoisins20241026";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoisinscom";
        ensureDBOwnership = true;
      }
      {
        name = "lesgrandsvoisinsfacile";
        ensureDBOwnership = true;
      }
      {
        name = "lesgv";
        ensureDBOwnership = true;
      }
      {
        name = "mydb";
        ensureDBOwnership = true;
      }
      {
        name = "oxicloud";
        ensureDBOwnership = true;
      }
      {
        name = "postgres";
        ensureDBOwnership = true;
      }
      {
        name = "previous";
        ensureDBOwnership = true;
      }
      {
        name = "resdigita";
        ensureDBOwnership = true;
      }
      {
        name = "resdigitafastoche";
        ensureDBOwnership = true;
      }
      {
        name = "resdigitaorg";
        ensureDBOwnership = true;
      }
      {
        name = "roundcube";
        ensureDBOwnership = true;
      }
      {
        name = "sftpgo";
        ensureDBOwnership = true;
      }
      {
        name = "sogo";
        ensureDBOwnership = true;
      }
      {
        name = "village";
        ensureDBOwnership = true;
      }
      {
        name = "villagengo";
        ensureDBOwnership = true;
      }
      {
        name = "wagtail";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailcfran";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailfastoche";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailgvcoop";
        ensureDBOwnership = true;
      }
      {
        name = "wagtailvillage";
        ensureDBOwnership = true;
      }
      {
        name = "wwwcfran";
        ensureDBOwnership = true;
      }
      {
        name = "wwwfastoche";
        ensureDBOwnership = true;
      }
    ];
  };
}
