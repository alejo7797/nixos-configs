{ pkgs, lib, config, ... }: {

  options.myHome.git.enable = lib.mkEnableOption "Git configuration";

  config.programs.git = lib.mkIf config.myHome.git.enable {

    # Configure my Git profile.
    enable = true;
    package = pkgs.gitFull;

    # Set my identity.
    userName = "Alex Epelde";
    userEmail = "alex@epelde.net";

    # And set some basic options.
    extraConfig = {
      init.defaultBranch = "master";
      pull.ff = "only";
      credential = {
        helper = "git-credential-libsecret";
        interactive = true;
      };
    };
  };
}
