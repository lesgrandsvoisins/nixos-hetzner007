# keycloak.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/lemmy 0750 lemmy services"
    "f /etc/lemmy/.secret.smtp 0600 lemmy services"
    "f /etc/lemmy/.secret.database 0600 lemmy services"
    "f /etc/lemmy/.secret.admin 0600 lemmy services"
  ];
  users.users.lemmy = {
    uid = vars.uid.lemmy;
    group = "services";
    isSystemUser = true;
  };
  systemd.services.lemmy.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "lemmy";
    Group = "services";
  };
  systemd.services.lemmy-ui.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "lemmy";
    Group = "services";
  };
  services.postgresql = {
    ensureUsers = [
      {
        name = "lemmy";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = ["lemmy"];
  };
  # Initialize passwords
  # systemd.services.lemmy-pwdinit = {
  #   wantedBy = ["multi-user.target"];
  #   before = ["lemmy.service" "lemmy-ui.service"];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.openssl}/bin/openssl rand -base64 32 > /etc/lemmy/.secret.admin";
  #     User = "lemmy";
  #     Group = "services";
  #   };
  # };
  services.lemmy = {
    enable = true;
    caddy.enable = true;
    smtpPasswordFile = "/etc/lemmy/.secret.smtp";
    adminPasswordFile = "/etc/lemmy/.secret.admin";
    database = {
      # uriFile = "/etc/lemmy/.secret.database";
      uri = "postgresql:///lemmy?user=lemmy&host=/var/run/postgresql";
      createLocally = false;
    };
    settings = {
      hostname = vars.domains.lemmy;
      port = vars.ports.lemmy-server;
      tls_enabled = true;
      email = {
        smtp_server = "mail.lesgrandsvoisins.com:465";
        smtp_login = "list@lesgrandsvoisins.com";
        tls_type = "tls";
        smtp_from_address = "list@lesgrandsvoisins.com";
      };
    };
    ui = {
      port = vars.ports.lemmy-ui;
    };
  };
}
