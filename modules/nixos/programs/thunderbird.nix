{ pkgs, lib, config, ... }: {

  # Install Thunderbird extensions.
  programs.thunderbird.policies = {
    Extensions = {
      "Install" =
        map (a: "https://addons.thunderbird.net/thunderbird/downloads/latest/${a}/latest.xpi") [
          "darkreader"
        ];

    };
  };
}
