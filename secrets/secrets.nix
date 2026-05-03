let
  vpsfree = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCO4erKWHAGx075rA9VZAWBJ660j0QFwIm+lY1SbxukN81ul6VFYktmp1iI6CPZgWuIuWz4sgz0LagwJHp12eRHVyX02DewMyOIfL5pL1EHksVCLMuMpmJiGwPOxPT2PPwFwqYLGx6RL26mhV58F0eJeqJVlQLfxnoiICezXsRgB/0tVI78pik6muhvRaMKENAvin8PiGSDl26KU2PgP/5DJEPWVs+ipy0Ka0/ATchby8ySw/XWEBKFt6ziWDIt69Mu8YzYiPZ8QAVQ/ahSF/kuqHgvVKp9LZzRlPevIHnUMwt8PNJl+yx2DVHkz9xqauTTHPBJXevkzY5Qu+Ic/FmUcXOSJYa8GQLlA78M8xStr+Zgip9YWDlTMmTIQd3M/qeY2ZiuuUfw78pDwdPRsTZ5kTy057orRQOtVb1OdGHjNf4QeOXBGBas/SfNBHA6BceigkUgZbOekPtDt/a/YrDqc1esXGpyuUH7pR5wzF6YDc13kJszgZK+DvoT/LxcNtrXEl88cmaIRXYf0ZXEr2Ns2fffdHKpzl5IujH4QObuvIBLhFIejFPY44y1iIfGB4ZIvFWtv88MSs3rPhF8FdLunSEetiO5kUuLwZadJL/R+K0P/JDz0bDG0iMmsugEil/YwMnFI79fhqFD1SLl61WtroekV36wCUKFcPkD2Ax6Bw== root@nixos";
  hetzner005 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+pcl1dOr8crSsr0zGlTwIv3hrfT0Of3w+JLhg7P6OWrUekUUobfH1NnoadbxVC3e10Y8pbAwc8oHbsfaTVHzgL5sEzBk+eSKVghMKH0z1xzKfugurf2MIhZuAGLYqhLYNcZv5Oss4OAr20rX+jqTiE2Fjyez+odDvTs4U9Nd6Gf/vudGQpQzsKGbuezXkUECce1Uu+I+z+VP9B4qmrk1ZOCuDkmwHZ/yOZBPBXXklLjcGozC9mfpnXGs0pfqhkbvrHGrq+YHuRjarf/Kq1UNyUzoYLUIjFFMbPi+FNGqmNje8tE8rfw2AUUda2J2hhIOIIqirCDiGipBqQoKC+dknHh2wZaEdvTaDJN33R9LGrrhqBL/XNd8sbwRTZ4nvcw3QAW8mfRTJLx0X7Q6O4omF73VMHS0ST5KET3MKswRQIzrFP5Casg66Ry6bcTp/2s8DHZMkfUvrl6hfJ6ldUuyGw9Nza0Kjo9A3JUtlQADbFtELGUOfPMsr1H6D2sx0qFP8MHjf3nvckQgNBgqlipgMh1Au67VMQi/wEd9W2jJ4ayruOEK7LS6bnaRHf1KyA5VF2WhB4de1wINcBsJN/2VI0bxoTN8zDwfMzYZRX1yvwvPcWqkMRrnpczjKHydpXF7tAlYAUl+LbZHJW5cIpTplbH3Uck/re0sLV+7rCUcc4w== root@lesgrandsvoisins";
  mannchri-lenovo = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFhMZvVw9XmqlqsN7OkxQwmick74uPEwPFE3221SbShBnjq4uPqtKWzKQkV06gABvpyMEUHkM4ZaboAwKA8BR5jrO848MdDtkVVUjTAEcXndjB5eigotSeygsa3Ym+1Bt2OVornEJlN0C09UdwOQv9Jc1KgAt/mQIySi9hNF28Z0h1DA5NhECX0jyPaRVtApx1DkP8pqFx4UqOtiXPXi1XiJxcbWKmj9Z54+grf708bOXe5qYa1Ls3wYwIkgWsvyfNPEtCTiBqEyheXu5AkFz/b6jhoUM0cZATx4r1N9s47fhiu8dLrvsfe1Ujis98s8kb231lkUbf+MQnAvtzIch83OLylOmKQmGt1+jrLHnxcXJc9qsc4TyzCF/hfaASZbYjX3XGs4PG9HzVt/wD8bkWionO49rrnC09NlwujTfoALqHN2oQX5O5RTfiPwgYd+QoILFVjdE7eWVA/TA4csHTAOxZ/I6pzWPT3ZgHFcWgA+pzmfedOKeIqLRNmoSKuhE= mannchri@mannchri";
  secretgroup = [hetzner005 mannchri-lenovo];
in
{
  "secret1.age".publicKeys = secretgroup;
  "alice.age".publicKeys = secretgroup;
  "bind.age".publicKeys = secretgroup;
  "bind.slappasswd.age".publicKeys = secretgroup;
  "bob.age".publicKeys = secretgroup;
  "chris.age".publicKeys = secretgroup;
  "db.sftpgo.age".publicKeys = secretgroup;
  "email.list.age".publicKeys = secretgroup;
  "email.vikunja.age".publicKeys = secretgroup;
  "etebase.age".publicKeys = secretgroup;
  "filebrowser.age".publicKeys = secretgroup;
  "filebrowser.28240704.age".publicKeys = secretgroup;
  "fossil.age".publicKeys = secretgroup;
  "httpd.dav.oidcclientsecret.age".publicKeys = secretgroup;
  "httpd.dav.oidcclientsecret.20240701.age".publicKeys = secretgroup;
  "httpd.dav.oidcclientsecret.keycloak.age".publicKeys = secretgroup;
  "httpd.radicale.oidcclientsecret.age".publicKeys = secretgroup;
  "keepassweb.age".publicKeys = secretgroup;
  "keepassweb.passphrase.age".publicKeys = secretgroup;
  "keeweb.age".publicKeys = secretgroup;
  "keeweb.passphrase.age".publicKeys = secretgroup;
  "keycloakdata.age".publicKeys = secretgroup;
  "keycloak.vikunja.age".publicKeys = secretgroup;
  "keycloak.vikunja.20240628.age".publicKeys = secretgroup;
  "keygvcoop.vikunja.age".publicKeys = secretgroup;
  "keygvcoop.vikunja.old.age".publicKeys = secretgroup;
  "keylesgrandsvoisins.vikunja.age".publicKeys = secretgroup;
  "key.sftpgo.age".publicKeys = secretgroup;
  "kopia.silverbullet.age".publicKeys = secretgroup;
  "newuser.age".publicKeys = secretgroup;
  "httpd.newuser.conf.age".publicKeys = secretgroup;
  "httpd.filebrowser.conf.age".publicKeys = secretgroup;
  "oauthpassword.age".publicKeys = secretgroup;
  "vikunja.env.age".publicKeys = secretgroup;
  "seafile.age".publicKeys = secretgroup;
  "sogo.age".publicKeys = secretgroup;
  "zitadel.age".publicKeys = secretgroup;
}
