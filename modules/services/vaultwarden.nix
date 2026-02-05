{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/vaultwarden 0755 vaultwarden services"
    "f /etc/vaultwarden/vaultwarden.env 0600 vaultwarden services"
  ];
  users.users.vaultwarden.extragrousp = ["services"];
  services.vaultwarden = {
    domain = "https://vw.gv.je";
    enable = true;
    configurePostgres = true;
    environmentFile = "/etc/vaultwarden/vaultwarden.env";
    # backupDir = "/var/backup/vaultwarden"; # Only works with SQLite
    configureNginx = false;
    dbBackend = "postgresql";
    config = {
      SIGNUPS_ALLOWED = true;
      SMTP_HOST="mail.lesgrandsvoisins.com";
      SMTP_FROM="list@lesgrandsvoisins.com";
      SMTP_FROM_NAME="Les Grands Voisins (List / Vaultwarden)";
      # SMTP_USERNAME="";
      # SMTP_PASSWORD="";
      SMTP_TIMEOUT=15;
      ROCKET_PORT=8222;
      # ROCKET_ADDRESS = "127.0.0.1";
      # ROCKET_LOG = "critical";  
      SMTP_PORT = 465;
      SMTP_SSL = true;
    };
  };
}