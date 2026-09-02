{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  users = {
    users.wagtailgvcoop = {
      group = "services";
      uid = vars.uid.wagtailgvcoop;
      isSystemUser = true;
    };
  };
  networking.hosts = {
    "${vars.hosts.wagtailgvcoop.ipv4}" = ["wagtailgvcoop.containers"];
  };
  systemd.tmpfiles.rules = [
    "d /etc/wagtailgvcoop 0775 wagtailgvcoop services"
    "d /var/www/wagtailgvcoop 0775 wagtailgvcoop services"
  ];
  containers.wagtail = {
    hostAddress = vars.containers.wagtailgvcoop.hostAddress;
    localAddress = vars.containers.wagtailgvcoop.localAddress;
    hostAddress6 = vars.containers.wagtailgvcoop.hostAddress6;
    localAddress6 = vars.containers.wagtailgvcoop.localAddress6;
    bindMounts = vars.containers.wagtailgvcoop.bindMounts;
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
        "d /etc/wagtailgvcoop 0775 wagtailgvcoop services"
        "d /var/www/wagtailgvcoop 0775 wagtailgvcoop services"
      ];
    };
  };
}
