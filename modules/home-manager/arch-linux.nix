{ inputs, pkgs, lib, config, ... }: let

  cfg = config.myHome.arch-linux;

in {

  options.myHome = {

    arch-linux.enable = lib.mkEnableOption "Arch-Linux quirks";

    hostName = lib.mkOption {
      description = "System hostname";
      type = lib.types.str;
    };

  };

  config = lib.mkIf cfg.enable {

    # Manage a user-level flake registry.
    nix.registry.nixpkgs.flake = inputs.nixpkgs;

    # And set NIX_PATH as desired.
    nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

    nixpkgs.overlays = [

      # Overlay to specify NixGLIntel's main program.
      (self: super: {
        nixgl.nixGLIntel = super.nixgl.nixGLIntel // {
          meta.mainProgram = "nixGLIntel";
        };
      })

      # Overlay to wrap user packages.
      (self: super:
        builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = config.lib.nixGL.wrap super.${name};
            })
            [ "yubioath-flutter" ]
        )
      )

    ];

    # Access NixGL in Home Manager.
    nixGL.packages = pkgs.nixgl;

    # Wrap programs with NixGL.
    programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;

    # Load Hyprland plugins using hyprpm.
    wayland.windowManager.hyprland = {
      plugins = lib.mkForce [ ];
      settings.exec-once = [ "hyprpm reload -n" ];
    };

    programs.zsh = {

      # Host specific plugins.
      oh-my-zsh.plugins = [ "archlinux" ];

      # We need to pull these manually from the Nix store.
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
