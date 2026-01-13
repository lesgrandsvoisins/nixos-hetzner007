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
      environment = {
        PATH = "/run/wrappers/bin:/home/homarr/.nix-profile/bin:/nix/profile/bin:/home/homarr/.local/state/nix/profile/bin:/etc/profiles/per-user/homarr/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
      };

      serviceConfig = {
        WorkingDirectory = "/home/homarr/homarr/";
        User = "homarr";
        Group = "users";
        Restart = "always";
        # Type = "simple";
      };
    };
  };
}
