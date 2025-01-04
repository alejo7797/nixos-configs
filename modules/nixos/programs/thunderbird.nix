{ pkgs, lib, config, ... }: {

  # Install Thunderbird extensions.
  programs.thunderbird.policies.Extensions.Install = [
    "https://addons.thunderbird.net/thunderbird/downloads/latest/darkreader/latest.xpi"
  ];

}
