{pkgs ? import <nixpkgs>}:
pkgs.stdenv.mkDerivation {
  pname = "sftpgo-ui-gv";
  version = "1.0.2";
  src = ./.;
  nativeBuildInputs = [pkgs.sftpgo];
  installPhase = pkgs.lib.strings.concatStrings [
    ''
      mkdir -p $out/templates
      mkdir -p $out/templates/common
      mkdir -p $out/images
    ''
    ''
      cp -a ${pkgs.sftpgo}/share/sftpgo/templates/common/base.html $out/templates/common/base.html
      cp -a ${pkgs.sftpgo}/share/sftpgo/templates/common/base.html $out/templates/common/baselogin.html
      # cp -a ${pkgs.sftpgo}/share/sftpgo/templates/webadmin/base.html $out/templates/webadmin/base.html
      # cp -a ${pkgs.sftpgo}/share/sftpgo/templates/webadmin/base.html $out/templates/webadmin/baselogin.html
      # cp -a ${pkgs.sftpgo}/share/sftpgo/templates/webadmin/*.html $out/templates/webadmin/
    ''
    (pkgs.lib.strings.concatMapStrings (x: ''
        sed -i 's/<\/head>/<link type="text\/css" rel="stylesheet" href="https:\/\/public.gv.je\/static\/web\/gvbtn\/gvbtn.css">\n<\/head>/' ${x}
        sed -i 's/<\/body>/<a href="https:\/\/www.gv.je" class="site-action-button" aria-label="Open action">\n<img src="https:\/\/public.gv.je\/static\/web\/gvbtn\/gv-logo-512x512.png" class="site-action-button-img">\n<\/a>\n<\/body>/' ${x}

      '') [
        "$out/templates/common/base.html"
        "$out/templates/common/baselogin.html"
        # "$out/templates/webadmin/base.html"
        # "$out/templates/webadmin/baselogin.html"
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
  ];
}
