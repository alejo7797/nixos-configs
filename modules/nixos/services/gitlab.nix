{ config, lib, pkgs,... }:

let
  cfg = config.services.gitlab;
in

lib.mkIf cfg.enable {

  services = {

    gitlab = {
      port = 443; https = true;
      host = "git.patchoulihq.cc";

      puma.workers = 0;
      sidekiq.concurrency = 10;
      backup.keepTime = 72;

      initialRootPasswordFile = config.sops.secrets."gitlab/root-password".path;

      secrets = {
        dbFile = config.sops.secrets."gitlab/db-key".path;
        jwsFile = config.sops.secrets."gitlab/session-key".path;
        secretFile = config.sops.secrets."gitlab/secret-key".path;
        otpFile = config.sops.secrets."gitlab/otp-key".path;
      };

      extraConfig = {
        gitlab = { default_theme = 2; };
        gitlab_kas = { enabled = false; };
      };
    };

    nginx.virtualHosts.${cfg.host} = {

      extraConfig = ''
        # Increased values.
        proxy_read_timeout 5m;
        proxy_send_timeout 5m;

        # Let GitLab know it's behind SSL.
        proxy_set_header X-Forwarded-Ssl on;

        # Error redirection.
        error_page 404 /404.html;
        error_page 422 /422.html;
        error_page 500 /500.html;
        error_page 502 /502.html;
        error_page 503 /503.html;
      '';

      locations."/" = {
        # Proxy to the gitlab-workhorse UNIX socket present locally.
        proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };

      locations."~ ^/(404|422|500|502|503)\.html$" = {
        # Path to the public directory.
        root = "${pkgs.gitlab}/gitlab/public";
        extraConfig = "internal;";
      };

    };
  };

  sops.secrets = {
    "gitlab/db-key" = { owner = cfg.user; };
    "gitlab/root-password" = { owner =  cfg.user; };
    "gitlab/session-key" = { owner = cfg.user; };
    "gitlab/secret-key" = { owner = cfg.user; };
    "gitlab/otp-key" = { owner = cfg.user; };
  };
}
