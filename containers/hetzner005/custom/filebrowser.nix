{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  systemd.services = {
    "filebrowser@" = {
      enable = true;
      wantedBy = ["default.target"];
      scriptArgs = "filebrowser %i";
      # preStart = "mkdir -p /opt/filebrowser/dbs/%u/%i; touch /opt/filebrowser/dbs/%u/%i/temoin.txt";
      script = "/opt/filebrowser/dbs/filebrowser.sh $filebrowser_user $filebrowser_database";
      description = "File Browser, un interface web à un système de fichiers pour %u on %i";
      environment = {
        filebrowser_user = "filebrowser";
        filebrowser_database = "%i";
        FB_BASEURL = "";
      };
      serviceConfig = {
        WorkingDirectory = "/var/www/dav/data/%i";
        User = "filebrowser";
        Group = "wwwrun";
        UMask = "0002";
      };
    };
  };
}
