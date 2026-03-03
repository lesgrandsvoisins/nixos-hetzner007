{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  users.users.gitea.uid = vars.uid.gitea;
  systemd.tmpfiles.rules = [
    "d /etc/gitea 0755 gitea services"
    "f /etc/gitea/oauth2_jwt_secret 0640 gitea services"
  ];
  services.gitea = {
    enable = true;
    group = "services";
    database = {
      type = "postgres";
      socket = "/var/run/postgresql/.s.PGSQL.5434";
    };
    settings = {
      DISABLE_REGISTRATION = true;
      PROTOCOL = "https";
      HTTP_PORT = vars.ports.gitea-https;
      SSH_PORT = vars.ports.gitea-ssh;
      oauth2 = {
        ENABLED = true;
        JWT_SECRET_URI = "file:/etc/gitea/oauth2_jwt_secret";
      };
      server = {
        ROOT_URL = "https://gitea.gv.je";
      };
      "cron.sync_external_users" = {
        RUN_AT_START = true;
        SCHEDULE = "@every 24h";
        UPDATE_EXISTING = true;
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "smtps";
        SMTP_ADDR = "mail.ldesgrandsvoisins.com";
        SMTP_PORT = "465";
        FROM = "Gitea Service <list@lesgrandsvoisins.com>";
        USER = "list@lesgrandsvoisins.com";
      };
      other = {
        SHOW_FOOTER_VERSION = false;
      };
    };
  };
}
