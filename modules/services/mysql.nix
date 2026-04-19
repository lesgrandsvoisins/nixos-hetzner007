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
    group = "services";
    user = "mysql";
  };
}
