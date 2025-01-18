{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.git;
in

{
  options.myHome.git.enable = lib.mkEnableOption "Git configuration";

  config = lib.mkIf cfg.enable {

    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      # Set my identity.
      userName = "Alex Epelde";
      userEmail = "alex@epelde.net";

      # Set some basic options.
      extraConfig = {
        init.defaultBranch = "master"; pull.ff = "only";
        credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
      };
    };
  };
}
