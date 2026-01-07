{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  systemd.services = {
    homarr = {
      enable = true;
      wantedBy = ["default.target"];
      description = "Système de tableaux de bords Homarr";
      script = "/home/homarr/homarr/start.sh";
      serviceConfig = {
        WorkingDirectory = "/home/homarr/homarr";
        User = "homarr";
        Group = "users";
        Restart = "always";
        # Type = "simple";
      };
    };
  };
}
