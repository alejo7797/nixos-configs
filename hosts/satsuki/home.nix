{ pkgs, ... }: {

  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Install packages to our user profile.
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixos-generators
    nixgl.auto.nixGLDefault
  ];

}
