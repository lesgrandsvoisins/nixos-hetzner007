{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/freshrss 0755 freshrss services"
    "f /etc/freshrss/.secret 0600 freshrss services"
  ];
  users.users.freshrss = {
    uid = vars.uid.freshrss;
    # group = "services";
  };
  services.freshrss = {
    enable = true;
    language = "fr";
    webserver = "caddy";
    virtualHost = "freshrss.gv.je";
    baseUrl = "https://freshrss.gv.je";
    passwordFile = "/etc/freshrss/.secret";
  };
}
