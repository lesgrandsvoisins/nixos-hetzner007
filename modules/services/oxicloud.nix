{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  users.users.oxicloud.uid = vars.uid.oxicloud;
  services.caddy = {
    virtualHosts."oxicloud.gv.je".extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString vars.ports.oxicloud}
    '';
  };
  services.oxicloud = {
    enable = true;
    databaseUrl = "postgres://user:pass@localhost/oxicloud";
    user = "oxicloud";
    group = "services";
    dataDir = "/srv/oxicloud";
    port = vars.ports.oxicloud;
  };
}
