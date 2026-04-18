{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # homepage = pkgs.homepage-dashboard.overrideAttrs (oldAttrs: rec {
  #   pname = "homepage-dashboard-with-gv-widget";
  #   version = "v0.8.0";
  #   # Include your custom widget files in the source
  #   src = pkgs.lib.cleanSource ./homepage-dashboard;
  #   # Add post-install step to copy widget into Homepage static widgets folder
  #   installPhase = ''
  #     mkdir -p $out/widgets/custom
  #     cp -r ${src}/component.jsx $out/widgets/gvbtn/
  #     cp -r ${src}/widget.js $out/widgets/gvbtn/
  #     cp -r ${src}/gvbtn.css $out/widgets/gvbtn/
  #     # mkdir -p $out/config
  #     # SERVICES_YAML=$out/config/services.yaml
  #     # if [ ! -f "$SERVICES_YAML" ]; then
  #     #   echo "# Auto-generated services.yaml" > $SERVICES_YAML
  #     #   echo "services:" >> $SERVICES_YAML
  #     # fi
  #     # # Append the GV.je widget if not already present
  #     # if ! grep -q "GV.je" $SERVICES_YAML; then
  #     #   cat <<EOF >> $SERVICES_YAML
  #     #   - My Services:
  #     #     - GV.je:
  #     #         icon: https://public.gv.je/static/web/gvbtn/gv-logo-512x512.png
  #     #         href: https://www.gv.je
  #     #         description: GV.je
  #     #         widget:
  #     #           type: custom
  #     #           component: widgets/custom/component.jsx
  #     #           css: widgets/custom/custom.css
  #     #   EOF
  #     # fi
  #   '';
  #   meta = with pkgs.lib; {
  #     description = "Homepage Dashboard with a custom GV.je static widget";
  #     homepage = "https://github.com/gethomepage/homepage";
  #     license = licenses.mit;
  #     maintainers = with maintainers; [];
  #   };
  # });
in {
  services.caddy.virtualHosts."www.gv.je" = {
    # "xcal.grandsvoisins.org" = {
    extraConfig = ''
      # authorize with identifiedpolicy
      reverse_proxy http://localhost:8082
    '';
  };
  services.homepage-dashboard = {
    enable = true;
    # package = homepage;
    allowedHosts = "localhost:8082,localhost,fr.gv.je,fr.gv.je:8082,www.gv.je,www.gv.je:8082,homepage-dashboard.gv.je,homepage-dashboard.gv.je:8082,gv.je,gv.je:8082";

    settings = {
      title = "GV.je Tableau de bord !";
      useEqualHeights = true;
      language = "fr";
      startUrl = "https://www.gv.je";
      baseUrl = "https://www.gv.je";
      color = "zinc";
      favicon = "https://public.gv.je/static/web/fr.gv.je/favicon/favicon.ico";
      target = "_blank";
      instanceName = "www.gv.je";
      providers = {
        openweathermap = "openweathermapapikey";
        weatherapi = "weatherapiapikey";
      };
    };
    widgets = [
      {
        logo = {
          icon = "https://public.gv.je/static/web/fr.gv.je/gv1.png";
          href = "https://www.gv.je";
        };
      }
      # {
      #   gvbtn = {};
      # }
      {
        greeting = {
          text_size = "xl";
          text = "Ce tableau de bord fournit des liens vers toutes les ressources numériques des GV.";
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
      {
        openmeteo = {
          label = "Paris";
          latitude = 48.8575;
          longitude = 2.3514;
          timezone = "Europe/Paris";
          units = "metric";
          cache = 15;
          format = {maximumFractionDigits = 0;};
        };
      }
      {
        search = {
          provider = "custom";
          url = "https://www.lesgrandsvoisins.com/fr/search/?query=";
          target = "_blank";
        };
      }
    ];
    services = [
      (import ./homepage-dashboard/compte-unifie.nix)
      (import ./homepage-dashboard/ouverts-all.nix)
      (import ./homepage-dashboard/new-services.nix)
      (import ./homepage-dashboard/sites-publics.nix)
      (import ./homepage-dashboard/nouvelles-memos.nix)
      (import ./homepage-dashboard/admin-compte.nix)
      (import ./homepage-dashboard/agenda-gv.nix)
      (import ./homepage-dashboard/medias-sociaux.nix)
      (import ./homepage-dashboard/dons-gv.nix)
      (import ./homepage-dashboard/comptes-admin.nix)
      (import ./homepage-dashboard/anciens-services1.nix)
      (import ./homepage-dashboard/anciens-services2.nix)
      (import ./homepage-dashboard/anciens-services3.nix)
      (import ./homepage-dashboard/admin-sys.nix)
      (import ./homepage-dashboard/projets-alpha.nix)
      (import ./homepage-dashboard/chez-marjan.nix)
    ];
  };
}
