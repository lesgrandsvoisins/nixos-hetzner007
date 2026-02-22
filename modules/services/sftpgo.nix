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
  services.sftpgo = {
    enable = true;
    extraArgs = [
      ""
    ];
    dataDir = "/var/lib/sftpgo";
    loadDataFile = null;
    settings = {
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
        }
      ];
      smtp = {
        user = "";
        port = 456;
        host = "mail.lesgrandsvoisins.com";
        from = "list@lesgrandsvoisins.com";
        encryption = 1; # 1 TLS 2 STARTTLS
        auth_type = 1; # 1 Login 0 Plain 2 CRAM-MD5
      };
    };
  };
}
