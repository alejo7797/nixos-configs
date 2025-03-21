{ pkgs, ... }: {

  programs.appimage = {

    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [ icu libpng ];
    };

  };

}
