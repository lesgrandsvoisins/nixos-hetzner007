{pkgs ? import <nixpkgs> {}}: let
in
  pkgs.stdenv.mkDerivation {
    pname = "sftpgo-ui-gv";
    version = "1.0.3";
    src = ./.;
    nativeBuildInputs = [pkgs.sftpgo];
    preInstall = ''
      mkdir -p $out/templates
      mkdir -p $out/images
    '';
    installPhase = pkgs.lib.strings.concatStrings [
      ''
        runHook preInstall
        mkdir -p $out/templates/common/
        mkdir -p $out/templates/webadmin/
      ''
      # (pkgs.lib.strings.concatMapStrings (x: "ln -s ${pkgs.sftpgo}/share/sftpgo/templates/common/${x} $out/templates/common/${x}\n") builtins.attrNames (builtins.readDir ${pkgs.sftpgo}/share/sftpgo/templates/common) )
      #     (pkgs.lib.strings.concatMapStrings(x: "ln -s ${pkgs.sftpgo}/share/sftpgo/templates/webadmin/${x} $out/templates/webadmin/${x}\n") [(builtins.attrNames (builtins.readDir ${pkgs.sftpgo}/share/sftpgo/templates/webadmin))])
      ''
        #     rm $out/share/sftpgo/templates/common/base.html
        #     rm $out/share/sftpgo/templates/webadmin/base.html
            cp -a ${pkgs.sftpgo}/share/sftpgo/templates/common/base.html $out/templates/common/base.html
            cp -a ${pkgs.sftpgo}/share/sftpgo/templates/common/baselogin.html $out/templates/common/baselogin.html
            cp -a ${pkgs.sftpgo}/share/sftpgo/templates/webadmin/base.html $out/templates/webadmin/base.html
            cp -a ${pkgs.sftpgo}/share/sftpgo/templates/webadmin/base.html $out/templates/webadmin/baselogin.html
      ''
      (pkgs.lib.strings.concatMapStrings (x: ''
          sed -i 's/<\/head>/<link type="text\/css" rel="stylesheet" href="https:\/\/public.gv.je\/static\/web\/gvbtn\/gvbtn.css">\n<\/head>/' ${x}
          sed -i 's/<\/body>/<a href="https:\/\/www.gv.je" class="site-action-button" aria-label="Open action">\n<img src="https:\/\/public.gv.je\/static\/web\/gvbtn\/gv-logo-512x512.png" class="site-action-button-img">\n<\/a>\n<\/body>/' ${x}
        '') [
          "$out/templates/common/base.html"
          "$out/templates/common/baselogin.html"
          "$out/templates/webadmin/base.html"
          "$out/templates/webadmin/baselogin.html"
        ])

      (pkgs.lib.strings.concatMapStrings (x: "ln -s ${pkgs.sftpgo}/share/sftpgo/templates/${x} $out/templates/${x}\n") [
        "email"
        "webclient"
        # "common/base.html"
        # "common/baselogin.html"
        "common/changepassword.html"
        "common/forgot-password.html"
        "common/login.html"
        "common/message.html"
        "common/reset-password.html"
        "common/twofactor.html"
        "common/twofactor-recovery.html"
        "webadmin/admin.html"
        "webadmin/adminsetup.html"
        "webadmin/admins.html"
        # "webadmin/base.html"
        "webadmin/configs.html"
        "webadmin/connections.html"
        "webadmin/defender.html"
        "webadmin/eventaction.html"
        "webadmin/eventactions.html"
        "webadmin/eventrule.html"
        "webadmin/eventrules.html"
        "webadmin/events.html"
        "webadmin/folder.html"
        "webadmin/folders.html"
        "webadmin/fsconfig.html"
        "webadmin/group.html"
        "webadmin/groups.html"
        "webadmin/iplist.html"
        "webadmin/iplists.html"
        "webadmin/maintenance.html"
        "webadmin/mfa.html"
        "webadmin/profile.html"
        "webadmin/role.html"
        "webadmin/roles.html"
        "webadmin/status.html"
        "webadmin/user.html"
        "webadmin/users.html"
      ])
      ''
        runHook postInstall
      ''
    ];
  }
