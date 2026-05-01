{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  age.secrets = {
    "keylesgrandsvoisins.vikunja" = {
      file = ./secrets/keylesgrandsvoisins.vikunja.age;
      owner = "vikunja";
    };
    # "keycloakgdvoisins.vikunja" = {
    #   file = ./secrets/keycloakgdvoisins.vikunja.age;
    #   owner = "vikunja";
    # };
    "key.sftpgo" = {
      file = ./secrets/key.sftpgo.age;
      owner = "sftpgo";
    };
    "keycloak.vikunja" = {file = ./secrets/keycloak.vikunja.age;};
    # "writefreely.mysql" = { file = ./secrets/writefreely.mysql.age; };
    # "email.list" = {
    #   file = ./secrets/email.list.age;
    #   user = "wwwrun";
    #   group = "services";
    #   mode = "640";
    # };
    # "bind.slappasswd" = { file = ./secrets/bind.slappasswd.age;};
    "vikunja.env" = {
      file = ./secrets/vikunja.env.age;
      owner = "vikunja";
    };
  };
}
