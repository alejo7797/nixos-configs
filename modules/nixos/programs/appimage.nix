{ pkgs, ... }: {

  programs.appimage = {

    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [ pkgs.icu ];
    };

  };

}
