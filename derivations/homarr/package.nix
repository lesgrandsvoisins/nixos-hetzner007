{
  pkgs ? import <nixpkgs> {},
  unstable ? import <nixpkgs-unstable> {config = {allowUnfree = true;};},
  ...
}: let
  nodejs = unstable.nodejs_25;
  pnpm = unstable.pnpm.override {inherit nodejs;};
  homarrAssets = ./assets;
  # defaultSettings = {
  auth_secret = "";
  secret_encryption_key = "";
  cron_job_api_key = "";
  log_level = "info";
  db_driver = "better-sqlite3";
  db_url = "";
  local_certificate_path = "";
  enable_kubernetes = "false";
  unsafe_enable_mock_integration = "false";
  homarr_user = "";
  homarr_group = "services";
  # };
in
  pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "homarr";
    version = "1.56.1";

    outputs = ["out"];

    # auth_secret = defaultSettings.auth_secret;
    # secret_encryption_key = defaultSettings.secret_encryption_key;
    # cron_job_api_key = defaultSettings.cron_job_api_key;
    # log_level = defaultSettings.log_level;
    # db_driver = defaultSettings.db_driver;
    # db_url = defaultSettings.db_url;
    # local_certificate_path = defaultSettings.local_certificate_path;
    # enable_kubernetes = defaultSettings.enable_kubernetes;
    # unsafe_enable_mock_integration = defaultSettings.unsafe_enable_mock_integration;
    # # user = defaultSettings.user;
    # # group = defaultSettings.group;

    noAuditTmpdir = true;

    src = pkgs.fetchFromGitHub {
      owner = "homarr-labs";
      repo = "homarr";
      tag = "v${finalAttrs.version}";
      hash = "sha256-hUWE689K/HMhDc48Ft+HiaP2O1xe7QGQjiN602wrNK8=";
    };

    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm nodejs;
      fetcherVersion = 3;
      hash = "sha256-KLKQ0EmyMbpPq4tAHmPVciCXQKU0hMFmMqROPaLyfhM=";
    };

    nativeBuildInputs =
      [
        pkgs.makeWrapper
        nodejs
        unstable.pnpmConfigHook
        pnpm
        pkgs.esbuild
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.cctools];

    buildInputs = [
      # pkgs.gnused
      pkgs.openssl
      pkgs.gawk
    ];

    preBuild = ''
      echo "HOMARR Install"
    '';

    buildPhase = ''
      runHook preBuild
      # pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{,node_modules/.cache,etc/homarr,var/cache/homarr,var/lib/homarr/db,var/lib/homarr/ssl,.next/cache,.output,.vercel/output}
      mkdir -p $out/apps/nextjs/.next/cache
      mkdir -p $out/apps/nextjs/.next/types
      mkdir -p $out/apps/nextjs/.next/standalone/apps/nextjs/.next
      mkdir -p $out/apps/nextjs/node_modules/.cache
      mkdir -p $out/apps/nextjs/standalone



      export DIR_CONFIG=$out/etc/homarr
      export DIR_LIB=$out/var/lib/homarr
      export DIR_CACHE=$out/var/lib/homarr

      cp ${homarrAssets}/homarr.env $DIR_CONFIG/homarr.env

      cp -a . $out


      if [ -z "${auth_secret}" ]; then
        substituteInPlace $out/etc/homarr/homarr.env \
         --subst-var-by auth_secret $(openssl rand -base64 32)
      fi
      if [ -z "${secret_encryption_key}" ]; then
        substituteInPlace $out/etc/homarr/homarr.env \
         --subst-var-by secret_encryption_key $(openssl rand -base64 32)
      fi
      if [ -z "${cron_job_api_key}" ]; then
        substituteInPlace $out/etc/homarr/homarr.env \
         --subst-var-by cron_job_api_key $(openssl rand -base64 32)
      fi
      if [ -z "${local_certificate_path}" ]; then
        substituteInPlace $out/etc/homarr/homarr.env \
         --subst-var-by local_certificate_path "$DIR_LIB/ssl"
      fi
      if [ -z "${db_url}" ]; then
        substituteInPlace $out/etc/homarr/homarr.env \
         --subst-var-by db_url "$DIR_LIB/db/homarr.sqlite3"
      fi


      substituteInPlace $out/etc/homarr/homarr.env \
        --subst-var-by auth_secret "${auth_secret}" \
        --subst-var-by secret_encryption_key "${secret_encryption_key}" \
        --subst-var-by cron_job_api_key "${cron_job_api_key}"  \
        --subst-var-by log_level "${log_level}"  \
        --subst-var-by db_driver "${db_driver}"  \
        --subst-var-by db_url "${db_url}"  \
        --subst-var-by local_certificate_path "${local_certificate_path}" \
        --subst-var-by enable_kubernetes "${enable_kubernetes}" \
        --subst-var-by unsafe_enable_mock_integration "${unsafe_enable_mock_integration}"

      # cp $out/etc/homarr/homarr.env $out/.env
      ln -s $DIR_CONFIG/homarr.env $out/.env

      touch $DIR_LIB/db/homarr.sqlite3

      # substituteInPlace "$out/apps/nextjs/src/app/\\[local\\]/layout.tsx" \
      #   --replace-warn "import { Inter } from "next/font/google";" "" \
      #   --replace-warn "const fontSans = Inter({\n  subsets: [\"latin\"],\n  variable: \"--font-sans\",\n});" ""

      # echo $(ls $out/apps/nextjs/src/app/)

      # awk -i inplace '
      # /import \{ Inter \} from "next\/font\/google";/ { next }

      # /const fontSans = Inter\(/ { skip=1; next }

      # skip && /\}\);/ { skip=0; next }

      # skip { next }

      # { print }
      # ' "$out/apps/nextjs/src/app/\[local\]/layout.tsx"

      # ${pnpm}/bin/pnpm -C $out install -w next/font/google
      ${pnpm}/bin/pnpm -C $out run build

      runHook postInstall
    '';

    doDist = false;

    meta = with pkgs.lib; {
      description = "Homarr Dashboard";
      changelog = "https://github.com/homarr-labs/homarr/releases/tag/v${finalAttrs.version}";
      mainProgram = "homarr";
      homepage = "https://homarr.dev";
      platforms = platforms.all;
    };
  })
