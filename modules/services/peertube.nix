{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/peertube/ 0770 sftpgo root"
    "f /etc/peertube/smtp.password 0660 peertube root"
    "f /etc/peertube/secrets.secrets 0660 peertube root"
    "f /etc/peertube/database.password 0660 peertube root"
  ];
  services.caddy.virtualHosts = {
    "peertube.gv.je".extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString vars.ports.peertube}
    '';
  };
  services.postgresql = {
    ensureUsers = [
      {
        name = "peertube";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "peertube"
    ];
  };
  users.users.peertube.uid = vars.uid.peertube;
  services.peertube = {
    enable = true;
    listenHttp = vars.ports.peertube;
    dataDirs = [
      "/srv/peertube/"
    ];
    listenWeb = 443;
    group = "services";
    enableWebHttps = true;
    localDomain = "peertub.gv.je";
    database.passwordFile = "/etc/peertube/database.password";
    secrets.secretsFile = "/etc/peertube/secrets.secrets";
    smtp.passwordFile = "/etc/peertub/smtp.password";
    # redis.enableUnixSocket = true;
  };
}
