{
  description = "Flake that installs one static image file into the Nix store for SFTPGO templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    # pkgs = import nixpkgs {};
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "sftpgo"
        ];
    };
  in {
    packages."x86_64-linux".default = pkgs.stdenv.mkDerivation {
      pname = "sftpgo-ui-gv";
      version = "1.0.2";

      buildInputs = with pkgs; [
        sftpgo
      ];

      src = ./.;

      installPhase = pkgs.lib.strings.concatStrings [
        ''
          mkdir -p $out/templates
          mkdir -p $out/templates/common
          mkdir -p $out/images
        ''
        ''
          cp -a ${pkgs.sftpgo}/share/sftpgo/templates/common/base.html $out/templates/common/base.html
          cp -a ${pkgs.sftpgo}/share/sftpgo/templates/common/base.html $out/templates/common/baselogin.html
        ''
        (pkgs.lib.strings.concatMapStrings (x: ''
            sed -i 's/<\/head>/<link type="text\/css" rel="stylesheet" href="https:\/\/public.gv.je\/static\/web\/gvbtn\/gvbtn.css">\n<\/head>/' ${x}
            sed -i 's/<\/body>/<a href="https:\/\/www.gv.je" class="site-action-button" aria-label="Open action">\n<img src="https:\/\/public.gv.je\/static\/web\/gvbtn\/gv-logo-512x512.png" class="site-action-button-img">\n<\/a>\n<\/body>/' ${x}

          '') [
            "$out/templates/common/base.html"
            "$out/templates/common/baselogin.html"
          ])
        (pkgs.lib.strings.concatMapStrings (x: "ln -s ${pkgs.sftpgo}/share/sftpgo/templates/${x} $out/templates/${x}\n") [
          "email"
          "webadmin"
          "webclient"
          "common/changepassword.html"
          "common/forgot-password.html"
          "common/login.html"
          "common/message.html"
          "common/reset-password.html"
          "common/twofactor.html"
          "common/twofactor-recovery.html"
        ])
        # (pkgs.lib.strings.concatMapStrings (x: "install -Dm644 ./${x} out/${x}\n") [
        #   "portal/templates/lesgrandsvoisins/login.template"
        #   "images/logo-lesgrandsvoisins-800-400-white.png"
        # ])
      ];
    };
  };
}
