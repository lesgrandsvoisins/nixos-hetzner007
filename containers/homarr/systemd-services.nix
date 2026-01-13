{
  pkgs,
  lib,
  config,
  # unstable,
  # vars,
  ...
}: let
  # unstable = import <nixpkgs-unstable>;
  vars = import ../../vars.nix;
in {
  systemd.services = {
    homarr = {
      enable = true;
      unitConfig = {
        Type = "simple";
        # ...
      };
      wantedBy = ["multi-user.target"];
      description = "Système de tableaux de bords Homarr";
      # script = "/home/homarr/homarr/start.sh";
      # script = ''
      #   /run/current-system/sw/bin/node --env-file=/etc/homarr/homarr.env apps/tasks/tasks.cjs &
      #   /run/current-system/sw/bin/node --env-file=/etc/homarr/homarr.env apps/websocket/wssServer.cjs &
      #   /run/current-system/sw/bin/pnpm dotenv -e /etc/homarr/homarr.env -- next start /home/homarr/homarr/apps/nextjs/
      # '';
      # alias node=/run/current-system/sw/bin/node
      # alias pnpm=/run/current-system/sw/bin/pnpm
      script = ''
        /run/current-system/sw/bin/node apps/tasks/tasks.cjs &
        /run/current-system/sw/bin/node apps/websocket/wssServer.cjs &
        /run/current-system/sw/bin/pnpm next start /home/homarr/homarr/apps/nextjs/
      '';
      # environment = "/etc/homarr/homarr.env";
      # script = "/home/homarr/homarr/start.sh";
      path = with pkgs; [
        nodejs_25
        (pnpm_10.override {nodejs = nodejs_25;})
        pnpmConfigHook
      ];

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
