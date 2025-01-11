{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.arch-linux;
in

{
  options.myHome.arch-linux.enable = lib.mkEnableOption "Arch-Linux quirks";

  config = lib.mkIf cfg.enable {

    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [ "nixpkgs=flake:nixpkgs" ];
    };

    nixpkgs.overlays = [
      inputs.my-scripts.overlays.default
      inputs.nixgl.overlays.default
    ];

    # Wrap Home Manager-insttalled programs with NixGL.
    nixGL.packages = pkgs.nixgl;
    programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;

    # Load Hyprland plugins using hyprpm.
    wayland.windowManager.hyprland = {
      plugins = lib.mkForce [ ];
      importantPrefixes = lib.mkOptionDefault [ "exec-once" ];
      settings.exec-once = [ "hyprpm reload -n" ];
    };

    # Recover hyprlock functionality.
    myHome.wayland = {
      loginctl = "/usr/bin/loginctl";
      lock = "/usr/bin/hyprlock";
    };

    programs.zsh = {
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
          src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
          file = "zsh-autosuggestions.zsh";
        }
      ];
    };
  };
}
