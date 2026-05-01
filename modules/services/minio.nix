{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.minio = {
    enable = true;
  };
}
