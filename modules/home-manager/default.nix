{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nur.modules.homeManager.default
    inputs.sops-nix.homeManagerModules.sops

    ./arch-linux.nix
    ./graphical.nix
    ./programs
  ];

  config = {
    nix.gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };

    sops = {
      defaultSopsFile = ../../secrets/${config.home.username}.yaml;
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    myHome = {
      git.enable = true;
      gpg.enable = true;
      neovim.enable = true;
      zsh.enable = true;
    };

    programs = {
      home-manager.enable = true;
    };

    # My personal shell scripts.
    home.packages = with pkgs; [
      audio-switch
      favicon-generator
      lockbg-cache
      round-corners
      sleep-deprived
    ];
  };
}
