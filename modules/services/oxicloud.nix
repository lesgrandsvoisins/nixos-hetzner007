{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  users.users.oxicloud.uid = vars.uid.oxicloud;
  services.oxicloud = {
    enable = true;
    databaseUrl = "postgres://user:pass@localhost/oxicloud";
    user = "oxicloud";
    group = "services";
    dataDir = "/srv/oxicloud";
  };
}
