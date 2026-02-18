# postgres.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  services.postgresql = {
    # package = pkgs.postgresql_18;
    enable = true;
    # enableTCPIP = true;
    settings = {
      ssl = true;
      ssl_cert_file = "/etc/postgres/postgres.crt";
      ssl_key_file = "/etc/postgres/postgres.key";
      port = vars.ports.postgresql;
    };
    ensureUsers = [
      {
        name = "keygvje";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = ["keygvje"];
  };
}
