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
          text_size = "l";
          text = "GV.je. Ce tableau de bord fournit des liens vers toutes les ressources nyumériques des GV.";
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
      {
        "Votre compte @gv.je unifié" = [
          {
            "CREER & GERER votre compte unifié @GV.je" = {
              href = "https://key.gv.je/realms/master/account";
              description = "Keycloak pour la connexion unifiée : Serveur de connexion et déconnexion unifiées (SSO en OAuth2) pour plusieurs services GV.";
              icon = "si-keycloak";
            };
          }
          {
            "STOCKER vos fichiers dans votre casier électronique SFTP" = {
              href = "https://sftpgo.gv.je/";
              icon = "mdi-folder-key-network";
              noticon = "sh-sftpgo";
              description = "Un espace pour ses fichiers et pour les partager.";
            };
          }
          {
            "MARQUEZ les pages webs et les retrouver" = {
              description = "Partager des fichiers et des dossiers";
              href = "https://linkding.lesgrandsvoisins.com/";
              icon = "mdi-paperclip";
            };
          }
          {
            "EDITEZ des carnets collaboratifs en markdown" = {
              href = "https://mark.lesgrandsvoisins.com/auth/oauth2";
              noticon = "https://mark.lesgrandsvoisins.com/banner/banner_vertical_color.svg";
              icon = "si-hedgedoc";
              description = "Notre serveur Hedgedoc fournit documents en format Markdown pouvant être modifiés par plusieurs personnes en même temps.";
            };
          }
        ];
      }
      {
        "Accès ouverts" = [
          {
            "VISIO : Passez nous voir en virtual" = {
              href = "https://meet.lesgrandsvoisins.com/";
              description = " Notre serveur Jitsi offre un espace de visioconférences qui tient vraiment la route. ";
              icon = "si-jitsi";
            };
          }
          {
            "DOCUMENTER-VOUS sur les Grands Voisins (Civisme, Arts plastiques, Numérique)" = {
              href = "https://wiki.grandsvoisins.org";
              description = "Voici toute la documentation sur Les Grands Voisins (voir numérique pour l'usage de nos services auto-hébergés)";
              icon = "si-wikidotjs";
            };
          }
          # {
          #   "TABLEAU DE BORD @GV.je, votre tableau de bord" = {
          #     href = "https://www.gv.je";
          #     description = "Tableau de bord des Grands Voisins";
          #     icon = "si-homepage";
          #     # widget = {
          #     #   type = "custom";
          #     #   component = "wigets/gvbtn/component.jsx";
          #     #   css = "wigets/gvbtn/gvbtn.css";
          #     # };
          #   };
          # }
        ];
      }
      {
        "VISITEZ nos sites webs publics" = [
          {
            "LesGrandsVoisins.fr est notre portail" = {
              href = "https://www.lesgrandsvoisins.com/";
              description = "Le site internet des GV.";
              icon = "https://www.lesgrandsvoisins.com/medias/img/lesgv/logo-lesgrandsvoisins-800-400-white.png";
            };
          }
          {
            Annuaire = {
              description = "Annuaire des Grands Voisins";
              href = "https://www.gdvoisins.com";
              icon = "https://public.gv.je/static/web/fr.gv.je/etrevoisin1.svg";
            };
          }
          {
            "Blog.LesGrandsVoisisns.com pour les nouvelles" = {
              href = "https://blog.lesgrandsvoisins.com";
              icon = "si-ghost";
            };
          }
          {
            "Liste de diffusion (ListMonk)" = {
              description = "Inscription sur nos lettres d'information ListMonk";
              href = "https://list.lesgrandsvoisins.com/subscription/form";
              icon = "si-listmonk";
            };
          }
        ];
      }
      {
        "VOIR les nouvelles" = [
          {
            "Memos, le Twitter des Grands Voisins" = {
              href = "https://memos.gv.je/explore";
              description = "Permet le fait de noter des memos privés, protégés (pour tous les utilisateurs identifiés) et publics";
              noticon = "sh-memos";
              icon = "mdi-bird";
              widget = {
                type = "customapi";
                url = "https://miniflux.gv.je/v1/feeds/2/entries?limit=5&order=published_at&direction=desc";
                display = "dynamic-list";
                headers = {
                  X-AUTH-TOKEN = "3421d3702a8784ea19d7d94f5ef40f6e86b4af02cb6a8362f5492a4ad7203efb";
                };
                mappings = {
                  items = "entries";
                  name = "title";
                  label = "published_at";
                  limit = "6";
                  format = "date";
                  target = "{url}";
                };
              };
            };
          }
        ];
      }
      {
        "GERER vos services unifiés @gv.je" = [
          {
            "ENVOYER ET RECEVOIR vos emails @gv.je" = {
              href = "https://mail.lesgrandsvoisins.com";
              description = "Roundcube Webmail : Consulter vos courriels des comptes des GV avec pour login le courriel du compte GV et le mot de passe de votre compte des GV.";
              icon = "si-roundcube";
            };
          }
          {
            "EDITER votre fiche annuaire sur le web avec Wagtail" = {
              description = "Administration du portail Wagtail";
              href = "https://www.lesgrandsvoisins.com/cms-admin/";
              icon = "si-wagtail";
            };
          }
          {
            "GERE Votre compte avec Guichet " = {
              href = "https://guichet.resdigita.com/user";
              icon = "https://guichet.resdigita.com/static/image/outilsinformatiques.svg";
              description = "Depuis Guichet du profil et du mot de passe, vous pouvez ajouter et supprimer des boîtes-aux-lettres de courriel.";
            };
          }
        ];
      }
      {
        "Nouveaux services des GV" = [
          {
            "CONSOLIDER vos flux RSS" = {
              href = "https://miniflux.gv.je";
              icon = "mdi-alpha-m";
              description = "Vous pouvez consolider vos flux rss";
            };
          }
          {
            "GERER des tâches avec Vikunja" = {
              href = "https://vikunja.gv.je";
              icon = "si-vikunja";
              description = "Vikunja nous permet de gérer les tâches à faire dans nos équipes.";
            };
          }
          {
            "GERER du code source avec Forgejo" = {
              description = "Serveur de développement et de codes sources";
              href = "https://forgejo.roses.gv.je/user/login";
              icon = "si-forgejo";
            };
          }
        ];
      }
      {
        "Agenda des GV" = [
          {
            Agenda = {
              icon = "mdi-calendar-month";
              href = "https://www.lesgrandsvoisins.com/fr/";
              description = "Calendrier Radicale par pcal.gv.je (public) et par rcal.gv.je";
              widget = {
                type = "calendar";
                firstDayInWeek = "monday";
                view = "monthly";
                maxEvents = 25;
                showTime = true;
                timezone = "Europe/Paris";
                integrations = [
                  {
                    type = "ical";
                    url = "https://pcal.gv.je/public/public";
                    name = "Agenda Les Grands Voisins par Radicale";
                    params = {showName = true;};
                  }
                  {
                    type = "ical";
                    url = "https://openagenda.com/agendas/17490527/events.v2.ics?relative%5B0%5D=current&relative%5B1%5D=upcoming&displayExportModal=embed";
                    name = "OpenAgenda LesGrandsVoisins.com";
                  }
                ];
              };
            };
          }
        ];
      }
      {
        "Média sociaux des GV" = [
          {
            "DEV Github" = {
              description = "lesgrandsvoisins sur GitHub";
              href = "https://github.com/lesgrandsvoisins";
              icon = "si-github";
            };
          }
          {
            "social-media Instagram" = {
              description = "les_grands_voisins sur Instagram";
              href = "https://www.instagram.com/les_grands_voisins";
              icon = "si-instagram";
            };
          }
          {
            "social-media Youtube" = {
              description = "@LesGrandsVoisinsCom sur Youtube";
              href = "https://www.youtube.com/@LesGrandsVoisinsCom";
              icon = "si-youtube";
            };
          }
        ];
      }
      {
        "Dons et souscriptions aux Grands Voisins" = [
          {
            "Dons via HelloAsso" = {
              description = "Dons HelloAsso pour Les Grands Voisins";
              href = "https://www.helloasso.com/associations/les-grands-voisins/adhesions/souscription-annuelle";
              icon = "mdi-hand-coin";
            };
          }
          {
            "Dons via Paypal" = {
              description = "Dons Paypal pour Les Grands Voisins";
              href = "https://www.paypal.com/donate/?hosted_button_id=BPUUS6H6TP62Y";
              icon = "si-paypal";
            };
          }
          {
            "Dons via Stripe" = {
              description = "Dons Stripe pour Les Grands Voisins";
              href = "https://donate.stripe.com/fZe7uD07z9hAg0w288";
              icon = "si-stripe";
            };
          }
        ];
      }
      {
        "Comptes indépendants et administration" = [
          {
            "Ghost pour la gestion du blog.lesgrandsvoisins.com" = {
              href = "https://blog.lesgrandsvoisins.com/ghost/";
              description = "Gestion du contenu du site blog";
              icon = "si-ghost";
            };
          }
          {
            "ListMonk pour les listes de diffusion" = {
              href = "https://list.lesgrandsvoisins.com";
              description = "Le serveur de listes de diffusion des GV.";
              noticon = "https://listmonk.app/static/images/logo.svg";
              icon = "si-listmonk";
            };
          }
        ];
      }
      {
        "Anciens services GV.je (1/3)" = [
          {
            "Tableau de bord Homarr anciennement sur www.gv.je" = {
              href = "https://homarr.gv.je";
              icon = "si-homarr";
              description = "Notre tableau de bord perosnalisé pour chacun.e";
            };
          }
          {
            "Vikunja (Ancien) gestionnaire des tâches à faire en équipe" = {
              href = "https://task.lesgrandsvoisins.com";
              icon = "si-vikunja";
              description = "Vikunja nous permet de gérer les tâches à faire dans nos équipes.";
            };
          }
          {
            "Drive  CopyParty" = {
              description = "Partager des fichiers et des dossiers";
              href = "https://cp.roses.gdvoisins.com/";
              icon = "mdi-cassette";
            };
          }
          {
            "Maux de passe (Vaultwarden)" = {
              description = "Vaultwarden pour gérer nos mots de passe";
              href = "https://vw.lgv.info/";
              icon = "si-vaultwarden";
            };
          }
        ];
      }
      {
        "Anciens services GV.je (2/3)" = [
          {
            "KeeWeb pour la geston des mots de passe" = {
              href = "https://keeweb.resdigita.com/";
              description = "Ce dispostif enregistre les bases de mots de passe dans un dossier secret, permet la syncronisation en plus de l'accès web.";
              icon = "si-keeweb";
            };
          }
          {
            "Outils info. @GV.je" = {
              description = "Ces services sont disponible après un parametrage par nos administrateurs.";
              href = "https://www.gv.je/boards/Plus";
              icon = "si-homarr";
            };
          }
          {
            "Crabfit pour trouver un moment de rendez-vous" = {
              href = "https://crabfit.resdigita.com/";
              noticon = "https://crab.fit/_next/static/media/logo.b29ef579.svg";
              icon = "mdi-jellyfish";
              description = "Indiquer d'abord votre nom, puis choisir les moments où vous êtes possiblement disponibles et c'est tout.";
            };
          }
          {
            "Quartz pour la doc technique" = {
              href = "https://quartz.resdigita.com/";
              icon = "mdi-crystal-ball";
              description = "Documentation de Resdigita des GV sur l'ensemble de nos services autonomes de par et pour les GV";
            };
          }
        ];
      }
      {
        "Anciens services GV.je (3/3)" = [
          {
            Login = {
              description = "Identifiez-vous pour avoir votre propre tableau de bord personalisé.";
              href = "https:homarr.gv.je/auth/login";
              icon = "si-wagtail";
            };
          }
          {
            "Wagtail pour la gestion du contenu des sites webs" = {
              href = "https://wagtail.resdigita.com/admin/";
              description = "Gestion du contenu du site web";
              icon = "si-wagtail";
            };
          }
          {
            "Wiki « Configmagic » (Wikijs)" = {
              description = "Wikijs de configuration Config Magic";
              href = "https://www.configmagic.com/";
              icon = "si-wikidotjs";
            };
          }
          {
            "Admin des GV" = {
              description = "Accès pour les administrateurs des GV";
              href = "https://homarr.gv.je/boards/Admin";
              icon = "si-homarr";
            };
          }
          {
            "Applications des GV.je" = {
              description = "Tous les comptes GV.je disposent de ces services";
              href = "https://homarr.gv.je/boards/Compte";
              icon = "mdi-account";
            };
          }
        ];
      }
      {
        "Coin des administrateurs système" = [
          {
            "Admin Keycloak" = {
              icon = "si-keycloak";
              description = "Espace d'administation de Keycloak";
              href = "https://key.gv.je/admin";
            };
          }
          {
            "Admin ListMonk" = {
              icon = "si-listmonk";
              description = "Espace d'administation de ListMonk";
              href = "https://list.lesgrandsvoisins.com/";
            };
          }
          {
            "Admin SFTPgo - rive des gv sur sftpgo.gv.je" = {
              description = "Interface d'adiminstration pour SFTPGo";
              href = "https://sftpgo.gv.je/web/admin/login";
              icon = "mdi-folder-key-network";
            };
          }
          {
            "admin Uptime Kuma (monitoring)" = {
              description = "Admin monitoring par notre Uptime Kuma";
              href = "https://up.lesgrandsvoisins.com";
              icon = "si-uptimekuma";
            };
          }
        ];
      }
      {
        "Projets Alpha" = [
          {
            "alpha forum (Discourse)" = {
              description = "Forum Discourse";
              href = "https://discourse.lesgrandsvoisins.com/";
              icon = "si-discourse";
            };
          }
          {
            "alpha MatterMost (discussions)" = {
              description = "Fils de discussion Matter Most";
              href = "https://mm.lgv.info/";
              icon = "si-mattermost";
            };
          }
          {
            "alpha WriteFreely (Blog)" = {
              description = "Blog Write Freely";
              href = "https://writefreely.lesgrandsvoisins.com/";
              icon = "si-writefreely";
            };
          }
          {
            "CASIERS Eléctroniques PHYLUM" = {
              description = "Phylum vous permet de garder en sécurité vos fichiers et vos dossiers, puis de les partager aussi !";
              href = "https://phylum.roses.gdvoisins.com";
              icon = "mdi-folder";
            };
          }
        ];
      }
      {
        "Chez Marjan Janjic" = [
          {
            "Max Auth" = {
              description = "Serveur d'authentification sur le serveur de max";
              href = "https://auth.max.gdvoisins.com";
              icon = "si-maxplanckgesellschaft";
            };
          }
          {
            "Max Dashy" = {
              description = "Tableau de bord Dash sur le serveur de Max";
              href = "https://dashy.max.gdvoisins.com";
              icon = "mdi-betamax";
            };
          }
        ];
      }
    ];
  };
}
