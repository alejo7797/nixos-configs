{ pkgs, lib, config, ... }: {

  options.myHome.git.enable = lib.mkEnableOption "Git configuration";

  config.programs.git = lib.mkIf config.myHome.git.enable {

    # Configure Git.
    enable = true;

    # Configure my Git identity.
    userName = "Alex Epelde";
    userEmail = "alex@epelde.net";

    # And set some basic options.
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
      credential = {
        helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
      };
    };
  };
}
