{
  pkgs,
  lib,
  config,
  # vars,
  ...
}: let
  vars = import ../../vars.nix;
in {
  systemd.services = {
    homarr = {
      enable = true;
      wantedBy = ["default.target"];
      description = "Système de tableaux de bords Homarr";
      # script = "/home/homarr/homarr/start.sh";
      # script = ''
      #   /run/current-system/sw/bin/node --env-file=/etc/homarr/homarr.env apps/tasks/tasks.cjs &
      #   /run/current-system/sw/bin/node --env-file=/etc/homarr/homarr.env apps/websocket/wssServer.cjs &
      #   /run/current-system/sw/bin/pnpm dotenv -e /etc/homarr/homarr.env -- next start /home/homarr/homarr/apps/nextjs/
      # '';
      script = ''
        alias node=/run/current-system/sw/bin/node
        alias pnpm=/run/current-system/sw/bin/pnpm
        /run/current-system/sw/bin/node apps/tasks/tasks.cjs &
        /run/current-system/sw/bin/node apps/websocket/wssServer.cjs &
        /run/current-system/sw/bin/pnpm next start /home/homarr/homarr/apps/nextjs/
      '';
      # environment = "/etc/homarr/homarr.env";

      serviceConfig = {
        WorkingDirectory = "/home/homarr/homarr/";
        User = "homarr";
        Group = "users";
        Restart = "always";
        # Type = "simple";
        EnvironmentFile = "/etc/homarr/homarr.env";
      };
    };
  };
}
