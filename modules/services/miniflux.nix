{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/miniflux 0755 miniflux services"
    "f /etc/miniflux/.secret 0600 miniflux services"
  ];
  # users.users.miniflux = {
  #   uid = vars.uid.miniflux;
  #   group = "services";
  # };
  services.caddy.virtualHosts."miniflux.gv.je" = {
    extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString vars.ports.miniflux}
    '';
  };
  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/etc/miniflux/.secret";
    config = {
      LISTEN_ADDR = "localhost:${builtins.toString vars.ports.miniflux}";
      BASE_URL = "https://miniflux.gv.je";
      CREATE_SDMIN = 1;
    };
  };
}
