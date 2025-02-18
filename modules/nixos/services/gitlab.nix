{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.gitlab;
in

{
  options.myNixOS.gitlab.enable = lib.mkEnableOption "GitLab Community Edition";

  config = lib.mkIf cfg.enable {

    # Set up a reverse proxy.
    myNixOS.nginx.enable = true;

    services = {
      gitlab = {
        enable = true; https = true;
        host = "git.patchoulihq.cc";

        puma.workers = 0;
        sidekiq.concurrency = 10;
        backup.keepTime = 72;

        secrets = {
          dbFile = config.sops.secrets."gitlab/db-key".path;
          otpFile = config.sops.secrets."gitlab/otp-key".path;
          jwsFile = config.sops.secrets."gitlab/session-key".path;
          secretFile = config.sops.secrets."gitlab/secret-key".path;
        };

        extraConfig = {
          gitlab = { default_theme = 2; };
          gitlab_kas = { enabled = false; };
        };
      };

      nginx.virtualHosts."git.patchoulihq.cc" = {

      };
    };

    sops.secrets = {
      "gitlab/db-key" = { owner = "gitlab"; };
      "gitlab/otp-key" = { owner = "gitlab"; };
      "gitlab/session-key" = { owner = "gitlab"; };
      "gitlab/secret-key" = { owner = "gitlab"; };
    };
  };
}
