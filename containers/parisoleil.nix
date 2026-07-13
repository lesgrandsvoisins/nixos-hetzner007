{
  config,
  pkgs,
  lib,
  vars,
  ...
}: {
  services.caddy.virtualHosts."www.parisoleil.com" = {
    extraConfig = ''
      reverse_proxy http://${vars.containers.parisoleil.localAddress}:8082
    '';
  };

  containers.parisoleil = {
    hostAddress = vars.containers.parisoleil.hostAddress;
    localAddress = vars.containers.parisoleil.localAddress;
    hostAddress6 = vars.containers.parisoleil.hostAddress6;
    localAddress6 = vars.containers.parisoleil.localAddress6;
    bindMounts = vars.containers.parisoleil.bindMounts;
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
      system.stateVersion = "25.11";
      nix.settings.experimental-features = "nix-command flakes";
      networking.useHostResolvConf = lib.mkForce false;
      services.resolved.enable = true;

      services.homepage-dashboard = {
        enable = true;
        openFirewall = true;
        allowedHosts = "localhost:8082,localhost,www.parisoleil.com,www.parisoleil.com:8082";
        settings = {
          title = "Paris Soleil Tableau de bord";
          useEqualHeights = true;
          language = "fr";
          startUrl = "https://www.parisoleil.com";
          baseUrl = "https://www.parisoleil.com";
          color = "zinc";
          target = "_blank";
          instanceName = "www.parisoleil.com";
        };
        widgets = [
          {
            greeting = {
              text_size = "xl";
              text = "Tableau de bord de Paris Soleil.";
            };
          }
          {
            datetime = {
              text_size = "md";
              format = {
                timeStyle = "short";
                hour12 = false;
                dateStyle = "short";
                hourCycle = "h23";
              };
            };
          }
        ];
        # TODO: ajouter les services réels de Paris Soleil ici.
        services = [
          (import ./parisoleil/homepage-dashboard/compte-unifie.nix)
          (import ./parisoleil/homepage-dashboard/ouverts-all.nix)
          (import ./parisoleil/homepage-dashboard/new-services.nix)
          (import ./parisoleil/homepage-dashboard/sites-publics.nix)
          (import ./parisoleil/homepage-dashboard/nouvelles-memos.nix)
          (import ./parisoleil/homepage-dashboard/admin-compte.nix)
          (import ./parisoleil/homepage-dashboard/agenda-gv.nix)
          (import ./parisoleil/homepage-dashboard/medias-sociaux.nix)
          (import ./parisoleil/homepage-dashboard/dons-gv.nix)
          (import ./parisoleil/homepage-dashboard/comptes-admin.nix)
          (import ./parisoleil/homepage-dashboard/anciens-services1.nix)
          (import ./parisoleil/homepage-dashboard/anciens-services2.nix)
          (import ./parisoleil/homepage-dashboard/anciens-services3.nix)
          (import ./parisoleil/homepage-dashboard/admin-sys.nix)
          (import ./parisoleil/homepage-dashboard/projets-alpha.nix)
          (import ./parisoleil/homepage-dashboard/chez-marjan.nix)
        ];
      };
    };
  };
}
