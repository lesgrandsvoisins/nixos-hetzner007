{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # vars = import ../vars.nix;
in {
  containers.wiki-js-www = {
    localAddress = "10.0.11.101";
    localAddress6 = "fa11::101";
    hostAddress = "10.0.11.1";
    hostAddress6 = "fa11::1";
    privateNetwork = true; # ve-wiki-js-www
    forwardPorts = [
      {
        containerPort = vars.ports.wiki-js-www-https;
        hostPort = vars.ports.wiki-js-www-https;
        protocol = "tcp";
      }
    ];
    bindMounts = {
    };
    config = {
      system.stateVersion = "25.11";
    };
  };
}
