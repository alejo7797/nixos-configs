{ pkgs, ... }: {

  services.mysql = {

    package = pkgs.mariadb; # See https://mariadb.org/.

  };

}
