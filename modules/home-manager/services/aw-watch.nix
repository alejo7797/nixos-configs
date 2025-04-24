{ pkgs, ... }: {

  services.activitywatch = {

    settings = {

    };

    watchers = {

      aw-awatcher = {
        package = pkgs.awatcher;
        executable = "awatcher";
      };

    };
  };
}
