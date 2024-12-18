{ inputs, pkgs, ... }: {

  imports = [

    # External modules.
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix
  ] ++ [

    # My personal modules.
    ./style.nix ./users.nix
  ];

  # Enable Nix flakes support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages.
  nixpkgs.config = { allowUnfree = true; };

  # Access ilya-fedin's repository.
  nixpkgs.overlays = [
    (self: super: { ilya-fedin = import inputs.ilya-fedin { pkgs = super; }; })
  ];

  # Enable and configure zsh.
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Install vim.
  programs.vim = {
    enable = true;
    package = pkgs.vim-full;
  };

  # And set it as default.
  environment.variables = {
    DIFFPROG = "vimdiff";
    EDITOR = "vim";
  };

  # Enable plocate.
  services.locate = {
    enable = true;
    localuser = null;
    package = pkgs.plocate;
  };

}
