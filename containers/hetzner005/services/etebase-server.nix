{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  services.etebase-server = {
    enable = true;
    unixSocket = "/var/lib/etebase-server/etebase-server.sock";
    user = "etebase-server";
    settings = {
      global.debug = false;
      global.secret_file = "/var/lib/etebase-server/.secrets.etebase"; # mind permissions
      allowed_hosts.allowed_host1 = "ete.village.ngo";
    };
  };
}
