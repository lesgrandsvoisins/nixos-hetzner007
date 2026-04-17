{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.collabora-online = {
    enable = true;
  };
}
