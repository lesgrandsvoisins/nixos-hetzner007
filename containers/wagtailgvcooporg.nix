{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  users = {
    users.wagtailgvcooporg = {
      group = "services";
      uid = vars.uid.wagtailgvcooporg;
      isSystemUser = true;
    };
  };
  networking.hosts = {
    "${vars.hosts.wagtailgvcooporg.ipv4}" = ["wagtailgvcooporg.containers"];
  };
  systemd.tmpfiles.rules = [
    "d /etc/wagtailgvcooporg 0775 wagtailgvcooporg services"
    "d /var/www/wagtailgvcooporg 0775 wagtailgvcooporg services"
  ];
  containers.wagtail = {
    hostAddress = vars.containers.wagtailgvcooporg.hostAddress;
    localAddress = vars.containers.wagtailgvcooporg.localAddress;
    hostAddress6 = vars.containers.wagtailgvcooporg.hostAddress6;
    localAddress6 = vars.containers.wagtailgvcooporg.localAddress6;
    bindMounts = vars.containers.wagtailgvcooporg.bindMounts;
    privateNetwork = true;
    autoStart = true;

    config = {
      config,
      pkgs,
      lib,
      vars,
      ...
    }: let
      vars = import ../vars.nix;
    in {
      system.stateVersion = "26.05";
      nix.settings.experimental-features = "nix-command flakes";
      networking.useHostResolvConf = lib.mkForce false;
      services.resolved.enable = true;

      imports = [
        ../modules/packages/common.nix
        ../modules/packages/vim.nix
      ];

      systemd.tmpfiles.rules = [
        "d /etc/wagtailgvcooporg 0775 wagtailgvcooporg services"
        "d /var/www/wagtailgvcooporg 0775 wagtailgvcooporg services"
      ];
    };
  };
}
