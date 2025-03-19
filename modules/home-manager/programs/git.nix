{ lib, pkgs, ... }: {

  programs.git = {

    extraConfig = {
      init.defaultBranch = "master"; pull.ff = "only";
      credential.helper = lib.getExe' pkgs.gitFull "git-credential-libsecret";
    };

  };
}
