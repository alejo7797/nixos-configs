{
  nixpkgs.overlays = [
    (_: prev: {

      steam = prev.steam.override {
        extraPreBwrapCmds = ''
          mkdir -p $XDG_DATA_HOME/Steam/home
        '';

        extraBwrapArgs = [
          "--bind $XDG_DATA_HOME/Steam/home $HOME"
          "--bind $XDG_DATA_HOME $HOME/.local/share"
          "--bind $XDG_CONFIG_HOME $HOME/.config"
          "--bind-try $HOME/Games $HOME/Games"
        ];
      };

    })
  ];
}
