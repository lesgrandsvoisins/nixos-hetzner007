# home.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  services.caddy.virtualHosts."${vars.domains.memos}" = {
    extraConfig = ''
      reverse_proxy http://${config.services.memos.settings.MEMOS_ADDR}:${builtins.toString config.services.memos.settings.MEMOS_PORT}
    '';
  };
}
