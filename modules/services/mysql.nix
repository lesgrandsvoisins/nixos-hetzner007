{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # package = pkgs.mysql82;
    group = "services";
    user = "mysql";
  };
  # users.users.mysql.uid = vars.uid.mysql;
}
