{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  containers.postgresql = {
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    config = {
      config,
      pkgs,
      ...
    }: {
      #      nix.settings.experimental-features = "nix-command flakes";
      #      imports = [
      #        ./vpsadminos.nix
      #      ];
      #      environment.systemPackages = with pkgs; [
      #        vim
      #      ];
      services.postgresql.enable = true;
      services.postgresql.package = pkgs.postgresql_14;
      time.timeZone = "Europe/Amsterdam";
      system.stateVersion = "25.11";
    };
  };
}
