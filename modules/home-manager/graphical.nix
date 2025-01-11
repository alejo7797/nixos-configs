{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myHome.graphical;
in
{
  imports = [
    ./style
    ./wayland

    ./autostart.nix
    ./i3-wm.nix
    ./mime.nix
  ];

  options.myHome = {

    graphical.enable = lib.mkEnableOption "basic graphical utilities";
    laptop.enable = lib.mkEnableOption "laptop-specific configuration";

    workspaces = lib.mkOption {
      description = "Workspace output assignments.";
      type = with lib.types; attrsOf ( listOf (oneOf [ int str ]) );
      default = { };
      example = {
        "DP-1" = [ "web" "dev" ];
        "eDP-1" = [ "chat" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {

    myHome = {
      kitty.enable = true;
      mimeApps.enable = true;
      style.enable = true;
      zathura.enable = true;
    };

    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
      xsettingsd.enable = true;

      kdeconnect = {
        enable = true;
        indicator = true;
      };
    };

    xdg.configFile = {
      "fcitx5" = {
        source = ./programs/fcitx5/config;
        force = true;
        recursive = true;
      };

      "chktexrc".source = ./programs/latex/chktexrc;
      "latexmk/latexmkrc".source = ./programs/latex/latexmkrc;

      "baloofilerc".text = ''
        [Basic Settings]
        Indexing-Enabled=false
      '';
    };

    xdg.dataFile = {
      "fcitx5" = {
        source = ./programs/fcitx5/data;
        recursive = true;
      };
    };

    systemd.user.services =

      lib.mapAttrs
        (_: value: {
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
          Unit = {
            inherit (value.Unit) Description;
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          inherit (value) Service;
        })

        {
          polkit-gnome-agent = {
            Unit.Description = "GNOME PolicyKit authentication daemon";
            Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          };

          keepassxc = {
            Unit.Description = "KeepassXC password manager";
            # Prevent quirks with KeepassXC when it starts too early.
            Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
            Service.ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
          };

          variety = {
            Unit.Description = "Variety wallpaper changer";
            Service.ExecStart = "${pkgs.variety}/bin/variety";
          };
        };

    programs.zsh.shellAliases =
      let
        variety = "${pkgs.variety}/bin/variety";
      in
      {
        bgnext = "${variety} --next";
        bgprev = "${variety} --previous";
        bgtrash = "${variety} --trash";
        bgfav = "${variety} --favorite";
      };

    # The script cannot be read-only, otherwise Variety won't run.
    home.activation.variety = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cp ${./programs/variety/set_wallpaper} ${config.xdg.configHome}/variety/scripts/set_wallpaper
    '';
  };
}
