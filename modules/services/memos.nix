# home.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/memos 0755 memos services"
    "f /etc/memos/memos.env 0600 memos services"
  ];
  users.users.memos.uid = vars.uid.memos;
  imports = [
    ./memos/caddy-memos.nix
  ];
  services.memos = {
    enable = true;
    environmentFile = "/etc/memos/memos.env";
    # https://usememos.com/docs/configuration
    # https://search.nixos.org/options?channel=unstable&query=memos
    # CLI flag “–unix-sock” converts to MEMOS_UNIX_SOCK.
    # These settings are command-line arguments and take precedence over .env file
    settings = {
      MEMOS_MODE = "prod";
      MEMOS_ADDR = "127.0.0.1";
      MEMOS_PORT = "5230";
      MEMOS_DATA = config.services.memos.dataDir;
      # Better to configure MEMOS_DRIVER and MEMOS_DSN in /etc/memos/memos.env
      MEMOS_DRIVER = "sqlite"; # sqlite, mysql, postgresql
      # MEMOS_DSN = config.services.memos.dataDir + "/memos_prod.db";
      # MEMOS_UNIX_SOCK=/var/run/memos.sock
      MEMOS_INSTANCE_URL = "https://${vars.domains.memos}";
      MEMOS_DEMO = true;
    };
    user = "memos";
    group = "services";
    openFirewall = false;
    dataDir = "/var/lib/memos/";
  };
}
