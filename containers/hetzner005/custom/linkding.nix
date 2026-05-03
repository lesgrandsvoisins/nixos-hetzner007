{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  systemd.services = {
    linkding = {
      enable = true;
      description = "Bookmarking system Linkding on linkding.lesgrandsvoisins.com";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      # requires = [ "linkding.socket" ];
      serviceConfig = {
        WorkingDirectory = "/home/python/live/linkding/";
        ExecStart = ''/home/python/live/linkding/venv/bin/gunicorn --access-logfile /var/log/linkding/linkding-access.log --error-logfile /var/log/linkding/linkding-error.log --chdir /home/python/live/linkding/ --workers 12 --bind localhost:8901 siteroot.wsgi:application'';
        # ExecStart = ''/home/wagtail/venv/bin/gunicorn --env WAGTAIL_ENV='production' --access-logfile /var/log/wagtail/access.log --error-logfile /var/log/wagtail/error.log --chdir /home/wagtail/wagtail-lesgv --workers 12 --bind unix:/run/wagtail-sockets/wagtail.sock lesgv.wsgi:application'';
        Restart = "always";
        RestartSec = "10s";
        User = "python";
        Group = "users";
      };
      unitConfig = {
        StartLimitInterval = "1min";
      };
    };
  };
}
