{ pkgs, lib, config, ... }: let

  kdeconnect-cfg = config.services.kdeconnect;

in {

  # These services get managed natively.
  services.gammastep.enable = lib.mkForce false;
  services.xsettingsd.enable = lib.mkForce false;
  services.kdeconnect.enable = lib.mkForce false;
  programs.waybar.enable = lib.mkForce false;
  services.swaync.enable = lib.mkForce false;

  programs.zsh = {
    # Host specific plugins.
    oh-my-zsh.plugins = [ "archlinux" ];

    # We need to pull these plugins manually from the Nix store.
    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "nix-zsh-completions";
        src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
      }
      {
        name = "zsh-autosuggestions";
        src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
        file = "zsh-autosuggestions.zsh";
      }
    ];
  };

}
