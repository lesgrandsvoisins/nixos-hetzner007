{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  users.users.sftpgo.uid = vars.uid.sftpgo;
  users.users.sftpgo.group = "sftpgo";
  users.groups.sftpgo.gid = vars.gid.sftpgo;
  systemd.services.sftpgo.environment = {"SFTPGO_DATA_PROVIDER__PASSWORD" = "$(cat /etc/sftpgo/.secret.postgresqlpassword)";};
  systemd.services.sftpgo.environment = {"SFTPGO_SMTP__PASSWORD" = "$(cat /etc/sftpgo/.secret.smtppassword)";};
  systemd.services.sftpgo.environment = {"SFTPGO_DEFAULT_ADMIN_USERNAME" = "adminsftpgo";};
  systemd.services.sftpgo.environment = {"SFTPGO_DEFAULT_ADMIN_PASSWORD" = "$(cat /etc/sftpgo/.secret.adminpassword)";};
  systemd.tmpfiles.rules = [
    "f /etc/sftpgo/.secret.smtppassword 0660 sftpgo root"
    "f /etc/sftpgo/.secret.postgresqlpassword 0660 sftpgo root"
    "f /etc/sftpgo/.secret.oidcpassword 0660 sftpgo root"
    "d /etc/sftpgo/env.d 0770 sftpgo root"
  ];
  services.sftpgo = {
    enable = true;
    extraArgs = [
      # "--config-dir"
      # "/etc/sftpgo"
    ];
    dataDir = "/var/lib/sftpgo";
    loadDataFile = null;
    settings = {
      # templates_path = "${pkgs.sftpgo}/share/sftpgo/templates";
      data_provider = {
        driver = "postgresql";
        name = "sftpgo";
        host = "127.0.0.1";
        port = builtins.toString vars.ports.postgresql;
        username = "sftpgo";
        connection_string = "postgresql://:5434/sftpgo";
        # password = "$(cat /etc/sftpgo/.secret.postgresqlpassword)";
        # ssl-mode = 1;
        # root_cert = "/etc/postgres/root.crt";
        # disable_sni = true;
        # track_quota = 2;
        # users_base_dir = "/tmp";
        # pre_login_hook
        # post_login_hook
        create_default_admin = true;
      };
      webdavd.bindings = [
        {
          address = "127.0.0.1";
          port = vars.ports.sfptgo-webdav;
        }
      ];
      sftp.bindings = [
        {
          address = "127.0.0.1";
          port = vars.ports.sfptgo-sftp;
        }
      ];
      httpd.bindings = [
        {
          address = "127.0.0.1";
          port = vars.ports.sfptgo-httpd;
          enable_web_client = true;
          enable_web_admin = true;
          enabled_login_methods = 0;
          disabled_login_methods = 0;
          enable_https = true;
          certificate_file = "/etc/sftpgo/127.0.0.1.pem";
          certificate_key_file = "/etc/sftpgo/127.0.0.1-key.pem";
          oidc = {
            config_url = "https://key.gv.je/realms/master";
            client_id = "sftpgo";
            client_secret_file = "/etc/sftpgo/.secret.oidcpassword";
            username_field = "preferred_username";
          };
        }
      ];
      smtp = {
        user = "list@lesgrandsvoisins.com";
        port = 465;
        host = "mail.lesgrandsvoisins.com";
        from = "list@lesgrandsvoisins.com";
        password = "$(cat /etc/sftpgo/.secret.smtppassword)";
        encryption = 1; # 1 TLS 2 STARTTLS
        auth_type = 1; # 1 Login 0 Plain 2 CRAM-MD5
        templates_path = "${pkgs.sftpgo}/share/sftpgo/templates";
      };
    };
  };
}
