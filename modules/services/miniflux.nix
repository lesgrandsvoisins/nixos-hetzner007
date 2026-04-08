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
    "f /etc/miniflux/.oidc.secret 0600 miniflux services"
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
  systemd.services.miniflux.serviceConfig.EnvironmentFile = "/etc/miniflux/.env";
  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/etc/miniflux/.secret";
    config = {
      LISTEN_ADDR = "localhost:${builtins.toString vars.ports.miniflux}";
      BASE_URL = "https://miniflux.gv.je";
      CREATE_ADMIN = 1;
      OAUTH2_USER_CREATION = 1;
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_OIDC_PROVIDER_NAME = "key@gv.je";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://key.gv.je/realms/master";
      OAUTH2_CLIENT_SECRET_FILE = "/etc/miniflux/.oidc.secret";
      OAUTH2_CLIENT_ID = "miniflux";
      OAUTH2_REDIRECT_URL = "https://miniflux.gv.je/oauth2/google/callback";
    };
  };
}
