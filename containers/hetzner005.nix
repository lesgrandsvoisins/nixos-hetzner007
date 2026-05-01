{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  containers.hetzner005.localAddress = vars.containers.hetzner005.localAddress;
  containers.hetzner005.hostAddress = vars.containers.hetzner005.hostAddress;
  containers.hetzner005.localAddress6 = vars.containers.hetzner005.localAddress6;
  containers.hetzner005.hostAddress6 = vars.containers.hetzner005.hostAddress6;
  containers.hetzner005.bindMounts = vars.containers.hetzner005.bindMounts;

  containers.cherryldap = {
    autoStart = false;
    privateNetwork = true;
    config = {
      config,
      pkgs,
      lib,
      ...
    }: let
      vars = import ./hetzner005/vars.nix;
    in {
      imports = [
        ./hetzner005/configuration.nix
      ];
    };
  };
}
