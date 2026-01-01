{pkgs, ...}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/lldap 0775 lldap services"
    "f /etc/lldap/lldap.env 0664 lldap services"
    "f /etc/lldap/.lldap_user_pass 0664 lldap services"
  ];
  # security.acme.certs."lldap.whowhatetc.com".group = "caddy";
  services.lldap = {
    enable = true;
    environmentFile = "/etc/lldap/lldap.env";
    package = pkgs.lldap;
    silenceForceUserPassResetWarning = false;
    environment = {}; # PREFIX LLDAP_ take precedence
    settings = {
      database_url = "sqlite://./users.db?mode=rwc"; # Exemple "postgres://postgres-user:password@postgres-server/my-database"
      smtp_options = {
        smtp_encryption = "TLS";
        user = "list@lesgrandsvoisins.com";
        enable_password_reset = true;
      };
      ldaps_options = {
        enabled = true;
        port = 3636;
        cert_file = "/var/lib/caddy/ssl/cert.pem";
        key_file = "/var/lib/caddy/ssl/key.pem";
      };
      force_ldap_user_pass_reset = "always";
      http_host = "0.0.0.0";
      http_port = 17170;
      http_url = "http://0.0.0.0:17170";
      jwt_secret_file = null;
      ldap_base_dn = "dc=whowhatetc,dc=com";
      ldap_host = "0.0.0.0";
      ldap_port = 3890;
      ldap_user_dn = "admin";
      ldap_user_email = "admin@lesgrandsvoisins.com";
      ldap_user_pass = null;
      ldap_user_pass_file = "/etc/lldap/.lldap_user_pass";
    };
  };
}
