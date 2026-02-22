{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  sftpgo-prelogin-hook = pkgs.callPackage ../../derivations/sftpgo-hook/default.nix {};
  # sftpgo_host = builtins.toString (builtins.elemAt vars.hetzner.ipv4 0).addr;
  sftpgo_host = "127.0.0.1";
in {
  environment.systemPackages = [sftpgo-prelogin-hook];
  users.users.sftpgo.uid = vars.uid.sftpgo;
  users.users.sftpgo.group = "sftpgo";
  users.groups.sftpgo.gid = vars.gid.sftpgo;
  # systemd.services.sftpgo.environment = {"SFTPGO_DATA_PROVIDER__PASSWORD" = "$(cat /etc/sftpgo/.secret.postgresqlpassword)";};
  # systemd.services.sftpgo.environment = {"SFTPGO_SMTP__PASSWORD" = "$(cat /etc/sftpgo/.secret.smtppassword)";};
  systemd.services.sftpgo.environment = {"SFTPGO_DEFAULT_ADMIN_USERNAME" = "adminsftpgo";};
  # systemd.services.sftpgo.environment = {"SFTPGO_DEFAULT_ADMIN_PASSWORD" = "$(cat /etc/sftpgo/.secret.adminpassword)";};
  systemd.tmpfiles.rules = [
    "f /etc/sftpgo/.secret.smtppassword 0660 sftpgo root"
    "f /etc/sftpgo/.secret.postgresqlpassword 0660 sftpgo root"
    "f /etc/sftpgo/.secret.oidcpassword 0660 sftpgo root"
    "d /etc/sftpgo/env.d 0770 sftpgo root"
    "d ${vars.dirs.sftpgo-users} 0770 sftpgo root"
  ];
  systemd.services.sftpgo.serviceConfig.Environment = [
    "SFTPGO_HOME_BASE=${vars.dirs.sftpgo-users}"
    # If SFTPGo runs as root (or has CAP_CHOWN), you can set ownership:
    # "SFTPGO_HOME_UID=1001"
    # "SFTPGO_HOME_GID=1001"
    "SFTPGO_HOME_MODE=2770"
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
      data_provider = {
        driver = "postgresql";
        name = "sftpgo";
        host = "${sftpgo_host}";
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
        pre_login_hook = "${sftpgo-prelogin-hook}/bin/sftpgo-prelogin-hook";
      };
      webdavd.bindings = [
        {
          address = "${sftpgo_host}";
          port = vars.ports.sfptgo-webdav;
          # enable_https = true;
          # # certificate_file = "/etc/sftpgo/127.0.0.1.pem";
          # # certificate_key_file = "/etc/sftpgo/127.0.0.1-key.pem";
          # certificate_file = "/var/lib/acme/sftpgo.gv.je/fullchain.pem";
          # certificate_key_file = "/var/lib/acme/sftpgo.gv.je/key.pem";
          # client_ip_proxy_header = "X-Forwarded-Host";
        }
      ];
      sftp.bindings = [
        {
          address = "${sftpgo_host}";
          port = vars.ports.sfptgo-sftp;
        }
      ];
      httpd.bindings = [
        {
          address = "${sftpgo_host}";
          port = vars.ports.sfptgo-httpd;
          enable_web_client = true;
          enable_web_admin = true;
          enabled_login_methods = 0;
          disabled_login_methods = 0;
          enable_https = true;
          # certificate_file = "/etc/sftpgo/127.0.0.1.pem";
          # certificate_key_file = "/etc/sftpgo/127.0.0.1-key.pem";
          certificate_file = "/var/lib/acme/sftpgo.gv.je/fullchain.pem";
          certificate_key_file = "/var/lib/acme/sftpgo.gv.je/key.pem";
          # proxy_mode = 1;
          # proxy_allowed = ["${sftpgo_host}"];
          client_ip_proxy_header = "X-Forwarded-Host";
          languages = ["fr" "en" "es"];
          oidc = {
            config_url = "https://key.gv.je/realms/master";
            client_id = "sftpgo";
            client_secret_file = "/etc/sftpgo/.secret.oidcpassword";
            username_field = "preferred_username";
            redirect_base_url = "https://sftpgo.gv.je";
            implicit_roles = true;
            # scopes = [
            #   "openid"
            #   "profile"
            #   "email"
            #   "username"
            # ];
            # security = {
            #   https_proxy_headers = [
            #     {
            #       "key" = "X-Forwarded-Proto";
            #       "value" = "https";
            #     }
            #   ];
            #   hosts_proxy_headers = ["X-Forwarded-Host"];
            #   enabled = true;
            #   allowed_hosts = ["sftpgo.gv.je"];
            # };
            # custom_fields = ["sftpgo_home_dir"];
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
