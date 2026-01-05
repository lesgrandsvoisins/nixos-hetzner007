{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ../vars.nix;
  in
{
  containers.wiki-js-www = {
    localAddress = "10.0.11.101";
    localAddress6 = "fa11::101";
    hostAddress = "10.0.11.1";
    hostAddress6 = "fa11::1";
    privateNetwork = true; # ve-wiki-js-www
    forwardPorts = [{
      containerPort = 3443;
      hostPort = 3443; 
      protocol = "tcp";
    }];
    bindMounts = {
      
    };
    config = {

    };
  };
}