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
    group = ["services"];
  };
  systemd.services.lemmy.serviceConfig = {
    DynamicUser = pkgs.mkForce false;
    User = lemmy;
    Group = services;
  };
  systemd.services.lemmy-ui.serviceConfig = {
    DynamicUser = pkgs.mkForce false;
    User = lemmy;
    Group = services;
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
  Initialize passwords
  systemd.service.lemmy-pwdinit = {
    User = lemmy;
    Group = services;
    wantedBy = [ "multi-user.target" ];
    before = ["lemmy.service" "lemmy-ui.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "for i in admin database; do ${pkgs.openssl}/bin/openssl rand -base64 32 > /etc/lemmy/.secret.$i;done;";
    };
  };
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
    hostname = vars.domains.lemmy;
    settings = {
      port = vars.ports.lemmy-server;
    };
    ui = {
      port = vars.ports.lemmy-ui;
    };
  };
}
