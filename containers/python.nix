{
  config,
  pkgs,
  lib,
  vars,
  zensical,
  ...
}: let
  vars = import ../vars.nix;
in {
  users = {
    users.monty = {
      group = "services";
      uid = vars.uid.monty;
      isNormalUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d /etc/monty monty services 0750 -"
  ];
  # networking.hosts = {
  #   "${vars.hosts.python.ipv4}" = ["python.containers"];
  # };
  containers.python = {
    localAddress = vars.containers.python.localAddress;
    hostAddress = vars.containers.python.hostAddress;
    localAddress6 = vars.containers.python.localAddress6;
    hostAddress6 = vars.containers.python.hostAddress6;
    bindMounts = vars.containers.python.bindMounts;

    autoStart = true;
    privateNetwork = true;
    config = {
      config,
      pkgs,
      lib,
      vars,
      ...
    }: let
      vars = import ../vars.nix;
    in {
      systemd.tmpfiles.rules = [
        "d /etc/monty 0775 monty services"
      ];
      system.stateVersion = "25.11";
      nix.settings.experimental-features = "nix-command flakes";
      networking = {
        # hosts = {
        #   "${vars.hosts.node-red.ipv4}" = ["node-red.cont"];
        # };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
      services.resolved.enable = true;
      users.users.monty = {
        uid = vars.uid.monty;
        isNormalUser = true;
        group = "services";
      };
      users.groups.services.gid = vars.gid.services;
      programs.nix-ld.enable = true;
      environment.systemPackages = [
        zensical.packages.${pkgs.stdenv.hostPlatform.system}.zensical
      ];
    };
  };
}
