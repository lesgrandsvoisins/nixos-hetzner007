{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  users.users.oxicloud.uid = vars.uid.oxicloud;
  services.postgresql.ensureUsers = [
    {
      name = "oxicloud";
      ensureDBOwnership = true;
    }
  ];
  services.postgresql.ensureDatabases = ["oxicloud"];
  services.caddy = {
    virtualHosts."oxicloud.gv.je".extraConfig = ''
      reverse_proxy http://${vars.hosts.oxicloud.addr}:${builtins.toString vars.ports.oxicloud}
    '';
  };
  systemd.tmpfiles.rules = [
    "d /srv/oxicloud/storage"
  ];
  services.oxicloud = {
    enable = true;
    # database.url = "postgres://user:pass@localhost/oxicloud";
    user = "oxicloud";
    host = vars.hosts.oxicloud.addr;
    group = "services";
    dataDir = "/srv/oxicloud";
    port = vars.ports.oxicloud;
  };
}
