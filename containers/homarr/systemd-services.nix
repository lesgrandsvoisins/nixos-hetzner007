{pkgs, ...}: let
in {
  systemd.services = {
    homarr = {
      enable = true;
      wantedBy = ["default.target"];
      description = "Système de tableaux de bords Homarr";
      serviceConfig = {
        WorkingDirectory = "/home/homarr/homarr/";
        User = "homarr";
        Group = "users";
        Restart = "always";
        Type = "simple";
        ExecStart = "/run/current-system/sw/bin/pnpm start";
      };
    };
  };
}
