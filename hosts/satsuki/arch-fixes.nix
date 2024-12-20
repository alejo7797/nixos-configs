{ pkgs, lib, config, ... }: let

  kdeconnect-cfg = config.services.kdeconnect;

in {

  # Temporary stopgap.
  services.gammastep.settings.general = {
    adjustment-method = "wayland";
  };

  programs.zsh = {

    # Host specific plugins.
    oh-my-zsh.plugins = [ "archlinux" ];
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
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.1";
          sha256 = "vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
        };
      }
    ];
  };

  systemd.user.services.kdeconnect = {
    Service.ExecStart = lib.concatStringsSep " " [
      "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL"
      "${kdeconnect-cfg.package}/bin/kdeconnectd"
    ];
  };

}
