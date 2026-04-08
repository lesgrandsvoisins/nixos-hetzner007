{pkgs ? import <nixpkgs> {}}: let
  homepageGvBtn = pkgs.stdenv.mkDerivation {
    pname = "homepage-dashboard-custom";
    version = "v0.8.0";

    src = pkgs.fetchFromGitHub {
      owner = "gethomepage";
      repo = "homepage";
      rev = "v0.8.0"; # adjust to latest
      sha256 = "sha256-70NpDQZD3jkYDbv4fhs9/Nm4WhmrOFIJ4JR4ZhAtSfs=";
    };

    nativeBuildInputs = [pkgs.nodejs pkgs.pnpm_9];

    buildPhase = ''
      export HOME=$TMPDIR
      pnpm install --frozen-lockfile
      pnpm build
    '';

    installPhase = ''
      mkdir -p $out

      # Copy built app
      cp -r .next $out/
      cp -r public $out/
      cp -r package.json $out/

      # ✅ Inject your static widget
      mkdir -p $out/public/widgets

      cat > $out/public/widgets/gvbtn.html <<EOF
        <a href="https://www.gv.je"
          class="site-action-button"
          aria-label="Open action">
          <img src="https://public.gv.je/static/web/gvbtn/gv-logo-512x512.png" class="site-action-button-img">
        </a>
      EOF
    '';
  };
in
  homepageGvBtn
