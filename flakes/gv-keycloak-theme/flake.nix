{
  description = "Keycloak with GV provider from source";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {inherit system;};

    # 1️⃣ Unpack the ZIP
    # gvSrc = pkgs.runCommand "gv-keycloak-src" { } ''
    #   mkdir -p $out
    #   cd $out
    #   ${pkgs.unzip}/bin/unzip ${../gv-keycloak-theme.zip}
    # '';
    srcJava = ./gv-keycloak-theme/src;

    # 2️⃣ Build the Maven proj/gv-keycloak-theme/src"ect
    gvPlugin = pkgs.maven.buildMavenPackage {
      pname = "gv-keycloak-plugin";
      version = "1.0.0";
      src = srcJava;

      # src = gvSrc;

      mvnHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      # ↑ replace after first build failure
      # Optional but often helpful if the build writes into HOME
      mvnParameters = "-DskipTests";

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp target/*.jar $out/gv-keycloak.jar
        runHook postInstall
      '';
    };

    # 3️⃣ Inject into Keycloak
    keycloakWithPlugin = pkgs.keycloak.override {
      plugins =
        pkgs.keycloak.enabledPlugins
        ++ [gvPlugin];
    };
  in {
    packages.${system}.gvKeycloakPlugin = gvPlugin;

    nixosModules.default = {config, ...}: {
      options.services.keycloak-gv.enable =
        nixpkgs.lib.mkEnableOption "Enable GV Keycloak plugin";

      config = nixpkgs.lib.mkIf config.services.keycloak-gv.enable {
        services.keycloak.package = keycloakWithPlugin;
      };
    };
    nixosConfigurations.example = lib.nixosSystem {
      inherit system;
      modules = [
        self.nixosModules.default
        ({...}: {
          services.keycloak-gv.enable = true;

          services.keycloak = {
            enable = true;

            settings = {
              hostname = "sso.example.org";
              http-enabled = true;
              proxy-headers = "xforwarded";
            };

            database = {
              type = "postgresql";
              createLocally = true;
            };
          };
        })
      ];
    };
  };
}
