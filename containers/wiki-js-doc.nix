{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ../vars.nix;
  in
{
  containers.wiki-js-doc = {
    localAddress = "10.0.10.101";
    localAddress6 = "fa10::101";
    hostAddress = "10.0.10.1";
    hostAddress6 = "fa10::1";
    privateNetwork = true; # ve-wiki-js-doc
    forwardPorts = {
      containerPort = 3444;
      hostPort = 3444; 
      protocol = "tcp";
    };
    bindMounts = {

    };
    config = {

    };
  };
}