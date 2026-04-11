{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "f /etc/immich/.secrets 0600 immich services"
    "d /etc/immich/ 0750 immich services"
  ];
  users.users.immich = {
    uid = vars.uid.immich;
    # group = "services";
  };
  services.postgresql.ensureUsers = [
    {
      name = "immich";
      ensureDBOwnership = true;
    }
  ];
  services.postgresql.ensureDatabases = ["immich"];
  services.caddy.virtualHosts."immich.gv.je" = {
    extraConfig = "reverse_proxy http://localhost:${builtins.toString vars.ports.immich}";
  };
  services.immich = {
    enable = true;
    port = vars.ports.immich;
    host = "localhost";
    database = {
      user = "immich";
      name = "immich";
    };
    mediaLocation = "/srv/immich";
    group = "services";
    secretsFile = "/etc/immich/.secrets";
    settings = {
      server = {
        externalDomain = "immich.gv.je";
      };
    };
  };
}
