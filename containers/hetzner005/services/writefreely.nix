{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  services.writefreely = {
    acme.enable = true;
    admin.name = "lesgrandsvoisins";
    # database.createLocally = true;
    # database.passwordFile = "/etc/.secret.writefreely.mysql";
    # database.type = "mysql";
    enable = true;
    host = "writefreely.lesgrandsvoisins.com";
    # nginx.enable = true;
    # nginx.forceSSL = true;
    settings = {
      server = {
        port = 9090;
      };
      app = {
        site_name = "Les Grands Voisins";
        min_username_len = 3;
        site_description = "WriteFreely for Les Grands Voisins";
        editor = "classic";
        single_user = false;
        federation = true;
        monetization = true;
        open_registration = true;
        private = false;
        user_invites = true;
      };
    };
  };
}
