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

  config.programs.git = lib.mkIf cfg.enable {

    # Configure my Git profile.
    enable = true;
    package = pkgs.gitFull;

    # Set my identity.
    userName = "Alex Epelde";
    userEmail = "alex@epelde.net";

    # And set some basic options.
    extraConfig = {
      init.defaultBranch = "master"; pull.ff = "only";
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
  };
}
