{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.gitlab-runner;
in

{
  options.myNixOS.gitlab-runner.enable = lib.mkEnableOption "GitLab Runner";

  config = lib.mkIf cfg.enable {

    services.gitlab-runner = {
      enable = true;

      services = {
        nix-updater = {
          executor = "shell";

          authenticationTokenConfigFile =
            # File containing the authentication token.
            config.sops.secrets."gitlab-runner/nix".path;
        };
      };
    };

    # Use a dedicated system user for the service.
    systemd.services.gitlab-runner.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "gitlab-runner";
      Group = "gitlab-runner";
    };

    users.users.gitlab-runner = {
      isSystemUser = true;
      home = "/var/lib/gitlab-runner";
      group = "gitlab-runner";
    };

    sops.secrets = {
      "gitlab-runner/nix" = { owner = "gitlab-runner"; };
    };
  };
}
